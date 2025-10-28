import 'dart:async';
import 'dart:io' as io;
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:scream_app/style.dart';
import 'package:scream_app/widgets/layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: unused_import
import 'package:scream_app/widgets/start_button.dart';

import '../data/local_shared.dart';

class ScreamPage extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  const ScreamPage({super.key, localFileSystem})
      : localFileSystem = localFileSystem ?? const LocalFileSystem();

  @override
  State<ScreamPage> createState() => ScreamPageState();
}

class ScreamPageState extends State<ScreamPage> {
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  AudioPlayer audioPlayer = AudioPlayer();
  double score = 0.0;

  int minimumScore = 1800;
  int stopInSeconds = 15;
  final CountDownController _controller = CountDownController();

  bool isStarted = false;
  bool isReached = false;
  bool isFinished = false;

  late Timer timer;
  int ms = 0;

  int countdown = 5;
  Timer? _tickTimer;
  Timer? _autoStopTimer;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _loadLevelFromLocal();
    _init();
    _loadTimerFromLocal();
    _startCountdown();
  }

  /// 🔹 Ambil data timer dari SharedPreferences
  Future<void> _loadTimerFromLocal() async {
    try {
      int? localTimer = await LocalStorageHelper.getTimer();

      setState(() {
        stopInSeconds = localTimer ?? 15;
      });

      debugPrint('⏱ Timer loaded from local: $stopInSeconds seconds');
    } catch (e) {
      debugPrint('❌ Gagal memuat timer: $e');
      setState(() {
        stopInSeconds = 15; // fallback default
      });
    }
  }

  Future<void> _loadLevelFromLocal() async {
    try {
      final level = await LocalStorageHelper.getLevel();

      final levelBox = Hive.box<Map>('levelBox');
      final data = levelBox.get('levels');

      int defaultEasy = 2800;
      int defaultMed = 3800;
      int defaultHard = 4800;
      int newScore = defaultEasy;

      if (data == null || data.isEmpty) {
        if (level == 'easy') {
          newScore = defaultEasy;
        } else if (level == 'med') {
          newScore = defaultMed;
        } else if (level == 'hard') {
          newScore = defaultHard;
        }
      } else {
        if (data.containsKey(level)) {
          newScore = data[level] is int
              ? data[level]
              : int.tryParse('${data[level]}') ?? defaultEasy;
        } else {
          if (level == 'easy') newScore = defaultEasy;
          if (level == 'med') newScore = defaultMed;
          if (level == 'hard') newScore = defaultHard;
        }
      }

      if (mounted) {
        setState(() {
          minimumScore = newScore;
        });
      }

      debugPrint('🎯 Level aktif: $level | Minimum score: $newScore');
    } catch (e, s) {
      debugPrint('❌ Gagal memuat level dari local: $e\n$s');
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (countdown == 1) {
        timer.cancel();
        setState(() {
          isStarted = true;
        });
        await _start(); // 🔥 otomatis mulai merekam saat countdown habis
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  Future<void> _disposeRecorder() async {
    try {
      // Hentikan semua timer aktif
      _tickTimer?.cancel();
      _autoStopTimer?.cancel();

      // Stop recorder jika masih merekam
      if (_currentStatus == RecordingStatus.Recording) {
        await _recorder?.stop();
      }

      _recorder = null;
      debugPrint('🛑 Recorder & timer disposed.');
    } catch (e) {
      debugPrint('⚠️ Error saat dispose recorder: $e');
    }
  }

  Future<void> _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/another_audio_recorder_';
        io.Directory appDocDirectory = io.Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : (await getExternalStorageDirectory())!;

        customPath =
            '${appDocDirectory.path}$customPath${DateTime.now().millisecondsSinceEpoch}';
        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        var current = await _recorder?.current(channel: 0);
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          isReached = false;
        });
        _controller.start();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must accept permissions")),
        );
      }
    } catch (e) {
      debugPrint('Error init recorder: $e');
    }
  }

  // Future<void> _start() async {
  //   try {
  //     await _recorder?.start();
  //     var recording = await _recorder?.current(channel: 0);
  //     setState(() => _current = recording);

  //     const tick = Duration(milliseconds: 50);

  //     // Timer pembacaan audio
  //     _tickTimer = Timer.periodic(tick, (Timer t) async {
  //       if (_currentStatus == RecordingStatus.Stopped) {
  //         t.cancel();
  //         return;
  //       }

  //       var current = await _recorder?.current(channel: 0);
  //       final peak = current?.metering?.peakPower ?? -60;
  //       ms += tick.inMilliseconds;

  //       setState(() {
  //         if (peak > -20) {
  //           double temp = (peak.abs() - 20);
  //           score += temp.abs() * 2;
  //         }
  //         if (score >= minimumScore) {
  //           isReached = true;
  //           _stop(success: true);
  //         }
  //         _current = current;
  //         _currentStatus = current?.status ?? RecordingStatus.Unset;
  //       });
  //     });

  //     // Auto stop setelah durasi tertentu
  //     _autoStopTimer = Timer(Duration(seconds: stopInSeconds), () {
  //       _stop(success: score >= minimumScore);
  //     });
  //   } catch (e) {
  //     debugPrint('Error start recording: $e');
  //   }
  // }

  Future<void> _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() => _current = recording);

      const tick = Duration(milliseconds: 50);

      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
          return;
        }

        var current = await _recorder?.current(channel: 0);
        final peak = current?.metering?.peakPower ?? -60;
        ms += tick.inMilliseconds;

        // 🔊 Hitung skor berdasarkan volume
        setState(() {
          if (peak > -20) {
            double temp = (peak.abs() - 20);
            score += temp.abs() * 2; // tambah multiplier biar terasa naik cepat
          }
          if (score >= minimumScore) {
            isReached = true;
            _stop(success: true);
          }
          _current = current;
          _currentStatus = current?.status ?? RecordingStatus.Unset;
        });
      });

      // timer = Timer(Duration(seconds: stopInSeconds),
      //     () => _stop(success: score >= minimumScore));
      timer = Timer(Duration(seconds: stopInSeconds), () async {
        final double percent = (score / minimumScore).clamp(0.0, 1.0);
        final int displayedScore = (percent * 100).round();

        final bool success = displayedScore >= 0;
        await _stop(success: success);
      });
    } catch (e) {
      debugPrint('Error start recording: $e');
    }
  }

  // Future<void> _stop({required bool success}) async {
  //   final double percent = (score / minimumScore).clamp(0.0, 1.0);
  //   final int displayedScore = (percent * 100).round();

  //   try {
  //     await _recorder?.stop();
  //     _tickTimer?.cancel();
  //     _autoStopTimer?.cancel();
  //     setState(() => isFinished = true);

  //     // ✅ Tidak langsung dispose di sini agar animasi bisa selesai
  //     Future.delayed(const Duration(milliseconds: 800), () {
  //       if (!mounted) return;
  //       Navigator.pushReplacementNamed(
  //         context,
  //         success ? '/result' : '/failed',
  //         arguments: displayedScore,
  //       );
  //     });
  //   } catch (e) {
  //     debugPrint('Error stop recording: $e');
  //   }
  // }

  Future<void> _stop({required bool success}) async {
    final double percent = (score / minimumScore).clamp(0.0, 1.0);
    final int displayedScore = (percent * 100).round();

    try {
      await _recorder?.stop();
      timer.cancel();
      setState(() => isFinished = true);

      Future.delayed(const Duration(milliseconds: 800), () {
        if (success) {
          Navigator.pushReplacementNamed(context, '/result',
              arguments: displayedScore);
        } else {
          Navigator.pushReplacementNamed(context, '/failed',
              arguments: displayedScore);
        }
      });
    } catch (e) {
      debugPrint('Error stop recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(children: [
      if (!isStarted) ...beforeStart,
      if (isStarted) ...afterStart
    ]);
  }

  List<Widget> get beforeStart {
    return [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.03,
      ),
      Image.asset(
        'assets/images/logo-clw.png',
        width: 90,
        height: 90,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Column(
        children: [
          Text(
            'WAIT...',
            style: TextStyle(
                color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
      ),
      Container(
          padding: EdgeInsets.only(top: 70),
          width: 250,
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/paw.png',
                ),
                fit: BoxFit.contain),
          ),
          child: Center(
            child: Text(
              '$countdown',
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              // Stack(
              //   children: [
              //     Text(
              //       '$countdown',
              //       style: TextStyle(
              //           fontFamily: 'Cookie Crumble',
              //           fontSize: 60,
              //           fontWeight: FontWeight.w700,
              //           foreground: Paint()
              //             ..style = PaintingStyle.stroke
              //             ..strokeWidth = 5
              //             ..color = Colors.white),
              //     ),
              //     Text(
              //       '$countdown',
              //       style: const TextStyle(
              //         fontFamily: 'Cookie Crumble',
              //         fontSize: 60,
              //         fontWeight: FontWeight.w700,
              //         color: Color(
              //           0xff9956A3,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          )
          // CircularCountDownTimer(
          //   duration: _duration,
          //   initialDuration: 0,
          //   controller: _controller,
          //   width: MediaQuery.of(context).size.width / 2.5,
          //   height: MediaQuery.of(context).size.height / 2.5,
          //   ringColor: Colors.transparent,
          //   fillColor: Colors.black,
          //   backgroundColor: Colors.transparent,
          //   strokeWidth: 10.0,
          //   strokeCap: StrokeCap.round,
          //   textStyle: pathwayGothicOne48,
          //   textFormat: CountdownTextFormat.S,
          //   isReverse: true,
          //   isReverseAnimation: true,
          //   isTimerTextShown: true,
          //   onComplete: () {
          //     setState(() {
          //       isStarted = true;
          //     });
          //     _start();
          //   },
          //   timeFormatterFunction: (defaultFormatterFunction, duration) {
          //     if (duration.inSeconds == 0) return 'BERSIAP!';
          //     return Function.apply(defaultFormatterFunction, [duration]);
          //   },
          // ),
          // const Text(
          //   'SEKUAT APA SUARAMU',
          //   style: passionOne32,
          // ),
          // const Text(
          //   'UNTUK NYALAKAN TV!',
          //   style: passionOne32,
          // ),

          // Debug Buttons
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     StartButton(
          //       onPressed: () {
          //         _controller.start();
          //       },
          //       child: const Text('Start', style: TextStyle(color: Colors.white)),
          //     ),
          //     StartButton(
          //       onPressed: () {
          //         _controller.reset();
          //         setState(() {
          //           isStarted = false;
          //         });
          //       },
          //       child: const Text('Reset', style: TextStyle(color: Colors.white)),
          //     ),
          //   ],
          // )
          ),
    ];
  }

  List<Widget> get afterStart {
    final itemHeight = MediaQuery.of(context).size.height * 0.238;

    final double percent = (score / minimumScore).clamp(0.0, 1.0);
    final int displayedScore = (percent * 100).round();
    return [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.03,
      ),
      Image.asset(
        'assets/images/logo-clw.png',
        width: 90,
        height: 90,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
      ),
      Column(
        children: [
          Text(
            'SCREAAAM!!!',
            style: TextStyle(
                color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
      ),

      SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/paw.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: (score / minimumScore).clamp(0.0, 1.0),
                child: Image.asset(
                  'assets/images/paw.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),

      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      Column(
        children: [
          Text('$displayedScore/100',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ],
      ),
      // Column(
      //   children: [
      //     Stack(
      //       children: [
      //         Text(
      //           '$displayedScore/100',
      //           style: TextStyle(
      //               fontFamily: 'Cookie Crumble',
      //               fontSize: 40,
      //               fontWeight: FontWeight.w700,
      //               foreground: Paint()
      //                 ..style = PaintingStyle.stroke
      //                 ..strokeWidth = 3
      //                 ..color = Colors.white),
      //         ),
      //         Text(
      //           '$displayedScore/100',
      //           style: const TextStyle(
      //             fontFamily: 'Cookie Crumble',
      //             fontSize: 40,
      //             fontWeight: FontWeight.w700,
      //             color: Color(
      //               0xff9956A3,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
      ),
      // Column(
      //   children: [
      //     Text(
      //       '${((_current?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((_current?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}',
      //       style: const TextStyle(
      //           fontSize: 50, fontWeight: FontWeight.w700, color: Colors.white),
      //     ),
      //   ],
      // ),
      // Column(
      //   children: [
      //     Stack(
      //       children: [
      //         Text(
      //           '${((_current?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((_current?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}',
      //           style: TextStyle(
      //               fontFamily: 'Cookie Crumble',
      //               fontSize: 60,
      //               fontWeight: FontWeight.w700,
      //               foreground: Paint()
      //                 ..style = PaintingStyle.stroke
      //                 ..strokeWidth = 5
      //                 ..color = Colors.white),
      //         ),
      //         Text(
      //           '${((_current?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((_current?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}',
      //           style: const TextStyle(
      //             fontFamily: 'Cookie Crumble',
      //             fontSize: 60,
      //             fontWeight: FontWeight.w700,
      //             color: Color(
      //               0xff9956A3,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),

      // const Column(
      //   children: [
      //     Text(
      //       'MULAI TERIAK',
      //       style: passionOne32,
      //     ),
      //     Text(
      //       'UNTUK MENYALAKAN TV!',
      //       style: passionOne32,
      //     ),
      //   ],
      // ),
      // SizedBox(height: MediaQuery.of(context).size.height * 0.1),

      // SizedBox(
      //   height: itemHeight,
      //   child: SfRadialGauge(
      //     enableLoadingAnimation: true,
      //     animationDuration: 500,
      //     axes: <RadialAxis>[
      //       RadialAxis(
      //         minimum: 0,
      //         maximum: minimumScore.toDouble(),
      //         showTicks: false,
      //         showLabels: false,
      //         axisLineStyle: const AxisLineStyle(
      //           thickness: 20,
      //         ),
      //         ranges: <GaugeRange>[
      //           /// Level 0
      //           GaugeRange(
      //             startValue: 0,
      //             endValue: minimumScore * 0.01,
      //             color: Colors.grey,
      //             // label: 'Level 0',
      //             sizeUnit: GaugeSizeUnit.factor,
      //             startWidth: 0.5,
      //             endWidth: 0.5,
      //             labelStyle: const GaugeTextStyle(
      //               fontSize: 12,
      //               color: Colors.white,
      //             ),
      //           ),

      //           /// Level 1
      //           GaugeRange(
      //             startValue: minimumScore * 0.01,
      //             endValue: minimumScore * 0.35,
      //             color: Colors.green,
      //             label: 'Level 1',
      //             sizeUnit: GaugeSizeUnit.factor,
      //             startWidth: 0.5,
      //             endWidth: 0.5,
      //             labelStyle: const GaugeTextStyle(
      //               fontSize: 12,
      //               color: Colors.white,
      //             ),
      //           ),

      //           /// Level 2
      //           GaugeRange(
      //             startValue: minimumScore * 0.35,
      //             endValue: minimumScore * 0.7,
      //             color: Colors.orange,
      //             label: 'Level 2',
      //             sizeUnit: GaugeSizeUnit.factor,
      //             startWidth: 0.5,
      //             endWidth: 0.5,
      //             labelStyle: const GaugeTextStyle(
      //               fontSize: 12,
      //               color: Colors.white,
      //             ),
      //           ),

      //           /// Level 3
      //           GaugeRange(
      //             startValue: minimumScore * 0.7,
      //             endValue: minimumScore.toDouble(),
      //             color: Colors.red,
      //             label: 'Level 3',
      //             sizeUnit: GaugeSizeUnit.factor,
      //             startWidth: 0.5,
      //             endWidth: 0.5,
      //             labelStyle: const GaugeTextStyle(
      //               fontSize: 12,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ],
      //         pointers: <GaugePointer>[
      //           NeedlePointer(
      //             value: score > minimumScore ? minimumScore.toDouble() : score,
      //             needleColor: Colors.black,
      //             knobStyle: const KnobStyle(
      //               color: Colors.black,
      //               knobRadius: 0.06,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // )

      // SizedBox(
      //   height: itemHeight,
      //   child: Stack(
      //     children: [
      //       Container(
      //         height: itemHeight,
      //         width: MediaQuery.of(context).size.width * 0.8,
      //         decoration: const BoxDecoration(
      //           image: DecorationImage(
      //             image: AssetImage('assets/images/tv_footer.png'),
      //             fit: BoxFit.fitWidth,
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         top: 0,
      //         left: 0,
      //         right: 0,
      //         child: Center(
      //           child: Container(
      //             color: Colors.black,
      //             width: MediaQuery.of(context).size.width * 0.8 - 22,
      //             height: isReached || score > minimumScore
      //                 ? 0
      //                 : (itemHeight - 26) -
      //                     ((itemHeight - 26) * (score / minimumScore)),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      // Text(
      //   '${((_current?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((_current?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}',
      //   style: pathwayGothicOne48,
      // ),
      // Debug Buttons
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     if (_currentStatus == RecordingStatus.Stopped)
      //       StartButton(
      //         onPressed: _init,
      //         child: const Text('Init', style: TextStyle(color: Colors.white)),
      //       ),
      //     if (_currentStatus == RecordingStatus.Initialized)
      //       StartButton(
      //         onPressed: _start,
      //         child: const Text('Start', style: TextStyle(color: Colors.white)),
      //       ),
      //     StartButton(
      //       onPressed:
      //           _currentStatus == RecordingStatus.Recording ? _stop : null,
      //       child: const Text('Stop', style: TextStyle(color: Colors.white)),
      //     ),
      //     StartButton(
      //       onPressed: onPlayAudio,
      //       child: const Text('Play', style: TextStyle(color: Colors.white)),
      //     ),
      //   ],
      // )
    ];
  }

  // _init() async {
  //   try {
  //     if (await AnotherAudioRecorder.hasPermissions) {
  //       String customPath = '/another_audio_recorder_';
  //       io.Directory appDocDirectory;
  //       if (io.Platform.isIOS) {
  //         appDocDirectory = await getApplicationDocumentsDirectory();
  //       } else {
  //         appDocDirectory = (await getExternalStorageDirectory())!;
  //       }

  //       customPath = appDocDirectory.path +
  //           customPath +
  //           DateTime.now().millisecondsSinceEpoch.toString();

  //       _recorder =
  //           AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

  //       await _recorder?.initialized;
  //       var current = await _recorder?.current(channel: 0);

  //       setState(() {
  //         isReached = false;
  //         _current = current;
  //         _currentStatus = current!.status!;
  //       });

  //       _controller.start();
  //     } else {
  //       return const SnackBar(content: Text("You must accept permissions"));
  //     }
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }

  // int _getLevel(double score, int minimumScore) {
  //   const epsilon = 100.1;

  //   if (score >= 0 && score < minimumScore * 0.01) {
  //     return 0; // Level 0
  //   } else if (score >= minimumScore * 0.01 && score < minimumScore * 0.35) {
  //     return 1; // Level 1
  //   } else if (score >= minimumScore * 0.35 && score < minimumScore * 0.7) {
  //     return 2; // Level 2
  //   } else if (score >= minimumScore * 0.7 && score <= minimumScore + epsilon) {
  //     return 3; // Level 3
  //   } else {
  //     return -1; // di luar range (opsional untuk handle error)
  //   }
  // }

  // _start() async {
  //   try {
  //     await _recorder?.start();
  //     // score = 0.0;
  //     var recording = await _recorder?.current(channel: 0);
  //     setState(() {
  //       _current = recording;
  //     });
  //     const tick = Duration(milliseconds: 24);
  //     Timer.periodic(tick, (Timer t) async {
  //       if (_currentStatus == RecordingStatus.Stopped) {
  //         t.cancel();
  //       }

  //       var current = await _recorder?.current(channel: 0);
  //       final peak = current!.metering!.peakPower!;
  //       // print(current.status);
  //       ms += tick.inMilliseconds;
  //       setState(() {
  //         ms = ms % 1000;
  //         if (score >= minimumScore) {
  //           isReached = true;
  //         }
  //         if (peak > -20) {
  //           double temp = (peak.abs() - 20);
  //           score += temp.abs();
  //         }
  //         _currentStatus = _current!.status!;
  //       });

  //       if (isReached) {
  //         t.cancel();
  //         _stop();
  //       }
  //     });

  //     timer = Timer(Duration(seconds: stopInSeconds), _stop);
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }

  // _stop() async {
  //   debugPrint('stop called');
  //   if (_currentStatus == RecordingStatus.Recording) {
  //     var result = await _recorder?.stop();
  //     timer.cancel();

  //     File file = widget.localFileSystem.file(result?.path);
  //     file.deleteSync();
  //     setState(() {
  //       _current = result;
  //       _currentStatus = _current!.status!;
  //     });
  //   }

  //   // ✅ Hitung level berdasarkan score
  //   int level = _getLevel(score, minimumScore);

  //   if (mounted) {
  //     if (level == 3) {
  //       // ✅ Level akhir → langsung ke halaman result
  //       Navigator.pushNamed(context, '/failed', arguments: level.toString());
  //     } else {
  //       // ✅ Level tertentu → tetap lewat tapi bukan gagal
  //       Navigator.pushNamed(context, '/failed', arguments: level.toString());
  //     }
  //   }
  // }

  // _stop() async {
  //   debugPrint('stop called');
  //   if (_currentStatus == RecordingStatus.Recording) {
  //     var result = await _recorder?.stop();
  //     timer.cancel();

  //     File file = widget.localFileSystem.file(result?.path);
  //     file.deleteSync();
  //     setState(() {
  //       _current = result;
  //       _currentStatus = _current!.status!;
  //     });
  //   }
  //   if (isReached && mounted) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushNamed(context, '/select-prize');
  //   }
  //   if (!isReached && mounted) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushNamed(context, '/failed', arguments: '0');
  //   }
  // }

  void onPlayAudio() async {
    if (audioPlayer.state != PlayerState.playing) {
      Source source = DeviceFileSource(_current!.path!);
      await audioPlayer.play(source);
    }
  }
}
