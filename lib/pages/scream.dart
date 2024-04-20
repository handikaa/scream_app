import 'dart:async';
import 'dart:io' as io;

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scream_app/style.dart';
import 'package:scream_app/widgets/layout.dart';
// ignore: unused_import
import 'package:scream_app/widgets/start_button.dart';

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
  final minimumScore = 8000.0;
  final int stopInSeconds = 15;
  final CountDownController _controller = CountDownController();
  final int _duration = 5;
  bool isStarted = false;
  bool isReached = false;
  late Timer timer;
  int ms = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
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
      CircularCountDownTimer(
        duration: _duration,
        initialDuration: 0,
        controller: _controller,
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 2.5,
        ringColor: Colors.transparent,
        fillColor: Colors.black,
        backgroundColor: Colors.transparent,
        strokeWidth: 10.0,
        strokeCap: StrokeCap.round,
        textStyle: pathwayGothicOne48,
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        onComplete: () {
          setState(() {
            isStarted = true;
          });
          _start();
        },
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (duration.inSeconds == 0) return 'BERSIAP!';
          return Function.apply(defaultFormatterFunction, [duration]);
        },
      ),
      const Text(
        'SEKUAT APA SUARAMU',
        style: passionOne32,
      ),
      const Text(
        'UNTUK NYALAKAN TV!',
        style: passionOne32,
      ),

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
    ];
  }

  List<Widget> get afterStart {
    return [
      const Column(
        children: [
          Text(
            'MULAI TERIAK',
            style: passionOne32,
          ),
          Text(
            'UNTUK MENYALAKAN TV!',
            style: passionOne32,
          ),
        ],
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.1),
      Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.238,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tv_new.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          LimitedBox(
            maxHeight: isReached
                ? 0
                : (MediaQuery.of(context).size.height * 0.238) -
                    ((MediaQuery.of(context).size.height * 0.238) *
                        (score == 0.0
                            ? 0
                            : score > minimumScore
                                ? 1
                                : score / minimumScore)),
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.238,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/tv_new.png'),
                    fit: BoxFit.fitWidth,
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.srcATop)),
              ),
            ),
          ),
        ],
      ),
      Text(
        '${(_current?.duration?.inMinutes ?? 0) % 60}:${(_current?.duration?.inSeconds ?? 0) % 60}.${ms.toString().padLeft(3, '0')}',
        style: pathwayGothicOne48,
      ),
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

  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/another_audio_recorder_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        var current = await _recorder?.current(channel: 0);

        setState(() {
          isReached = false;
          _current = current;
          _currentStatus = current!.status!;
        });

        _controller.start();
      } else {
        return const SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  _start() async {
    try {
      await _recorder?.start();
      score = 0.0;
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });
      const tick = Duration(milliseconds: 24);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        final peak = current!.metering!.peakPower!;
        // print(current.status);
        ms += tick.inMilliseconds;
        setState(() {
          ms = ms % 1000;
          if (score >= minimumScore) {
            isReached = true;
          }
          if (peak > -20) {
            double temp = (peak.abs() - 20);
            score += temp.abs();
          }
          _currentStatus = _current!.status!;
        });

        if (isReached) {
          t.cancel();
          _stop();
        }
      });

      timer = Timer(Duration(seconds: stopInSeconds, milliseconds: 500), _stop);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  _stop() async {
    debugPrint('stop called');
    if (_currentStatus == RecordingStatus.Recording) {
      var result = await _recorder?.stop();
      timer.cancel();

      File file = widget.localFileSystem.file(result?.path);
      file.deleteSync();
      setState(() {
        _current = result;
        _currentStatus = _current!.status!;
      });
    }
    if (isReached && mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/select-prize');
    }
    if (!isReached && mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/failed');
    }
  }

  void onPlayAudio() async {
    if (audioPlayer.state != PlayerState.playing) {
      Source source = DeviceFileSource(_current!.path!);
      await audioPlayer.play(source);
    }
  }
}
