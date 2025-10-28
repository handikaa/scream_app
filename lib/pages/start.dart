import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scream_app/widgets/loading_overlay.dart';

import '../widgets/layout.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _tapCount = 0;
  int _tapTeks = 0;
  Timer? _resetTimer;

  void _onLogoTap() {
    _tapCount++;

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 1), () {
      _tapCount = 0;
    });

    if (_tapCount == 3) {
      _resetTimer?.cancel();
      _tapCount = 0;

      Navigator.pushNamed(context, '/set-value');
    }
  }

  void _onTeksTap() {
    _tapTeks++;

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 1), () {
      _tapTeks = 0;
    });

    if (_tapTeks == 3) {
      _resetTimer?.cancel();
      _tapTeks = 0;

      Navigator.pushNamed(context, '/select-level');
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      bg: 'assets/images/bg-clw-1.png',
      // decorations: [
      //   // Positioned(
      //   //   bottom: 0,
      //   //   left: 0,
      //   //   right: 0,
      //   //   child: Image.asset(
      //   //     width: 546,
      //   //     'assets/images/screaming_woman.png',
      //   //   ),
      //   // )
      // ],
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        GestureDetector(
          onTap: () => _onLogoTap(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo-clw.png',
                width: 90,
                height: 90,
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        GestureDetector(
          onTap: () => _onTeksTap(),
          child: Image.asset(
            'assets/images/come-clw.png',
            width: 140,
            height: 140,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Image.asset(
          'assets/images/bark-clw.png',
          width: 40,
          height: 40,
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        // const Text(
        //   'SEKUAT APA SUARAMU',
        //   style: passionOne32,
        // ),
        // const Text(
        //   'UNTUK NYALAKAN TV!',
        //   style: passionOne32,
        // ),

        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/login');
            // final permission = await Permission.microphone.request();

            // if (permission.isGranted) {
            //   // ignore: use_build_context_synchronously
            //   Navigator.pushNamed(context, '/scream');
            //   // Navigator.pushNamed(context, '/select-prize');
            // } else {
            //   // ignore: use_build_context_synchronously
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       content: Text('Akses microphone tidak diberikan!'),
            //     ),
            //   );
            // }
          },
          child: Image.asset(
            'assets/images/btn-start-clw.png',
            width: 100,
            height: 100,
          ),
        ),

        // StartButton(
        //     onPressed: () async {
        //       final permission = await Permission.microphone.request();
        //       // Navigator.pushNamed(context, '/select-prize');
        //       if (permission.isGranted) {
        //         // ignore: use_build_context_synchronously
        //         Navigator.pushNamed(context, '/scream');
        //       } else {
        //         // ignore: use_build_context_synchronously
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(
        //             content: Text('Akses microphone tidak diberikan!'),
        //           ),
        //         );
        //       }
        //     },
        //     child: Text(
        //       'MULAI TERIAK!',
        //       style: passionOne24.copyWith(fontSize: 20, color: Colors.white),
        //     )),
      ],
    );
  }
}
