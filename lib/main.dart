import 'dart:async';
import 'dart:io' as io;

import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: RecorderExample(),
        ),
      ),
    );
  }
}

class RecorderExample extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  const RecorderExample({super.key, localFileSystem})
      : localFileSystem = localFileSystem ?? const LocalFileSystem();

  @override
  State<RecorderExample> createState() => RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;
  double score = 0.0;
  final double minimumScore = 10000.0;
  final int stopInSeconds = 30;

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    final double userDecibel = noiseReading.maxDecibel - 60;

    if (userDecibel > 0) {
      setState(() {
        score += userDecibel;
      });
    }
  }

  void onError(Object error) {
    print(error);
    stop();
  }

  /// Stop sampling.
  void stop() {
    _noiseSubscription?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Status : $_currentStatus"),
            Text("Score: ${score.toStringAsFixed(2)}/$minimumScore"),
            Text("Audio recording duration : ${_current?.duration.toString()}"),
            Text("maximum duration : $stopInSeconds seconds"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      switch (_currentStatus) {
                        case RecordingStatus.Initialized:
                          {
                            _start();
                            break;
                          }
                        case RecordingStatus.Recording:
                          {
                            _pause();
                            break;
                          }
                        case RecordingStatus.Paused:
                          {
                            _resume();
                            break;
                          }
                        case RecordingStatus.Stopped:
                          {
                            _init();
                            break;
                          }
                        default:
                          break;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                    ),
                    child: _buildText(_currentStatus),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _currentStatus != RecordingStatus.Unset ? _stop : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  child:
                      const Text("Stop", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onPlayAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  child:
                      const Text("Play", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/another_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        // after initialization
        var current = await _recorder?.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
      } else {
        return const SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });

      noiseMeter ??= NoiseMeter();

      // Listen to the noise stream.
      _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });

      Future.delayed(
          Duration(seconds: stopInSeconds, milliseconds: 500), _stop);
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder?.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder?.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder?.stop();
    _noiseSubscription?.cancel();
    print("Stop recording: ${result?.path}");
    print("Stop recording: ${result?.duration}");
    File file = widget.localFileSystem.file(result?.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: const TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    if (audioPlayer.state != PlayerState.playing) {
      Source source = DeviceFileSource(_current!.path!);
      await audioPlayer.play(source);
    }
  }
}
