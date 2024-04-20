import 'package:flutter/material.dart';
import 'package:scream_app/style.dart';
import 'package:scream_app/widgets/layout.dart';
import 'package:scream_app/widgets/start_button.dart';

import 'package:permission_handler/permission_handler.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      decorations: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            width: 546,
            'assets/images/screaming_woman.png',
          ),
        )
      ],
      children: [
        const Text(
          'SEKUAT APA SUARAMU',
          style: passionOne32,
        ),
        const Text(
          'UNTUK NYALAKAN TV!',
          style: passionOne32,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        StartButton(
            onPressed: () async {
              final permission = await Permission.microphone.request();
              if (permission.isGranted) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/scream');
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Akses microphone tidak diberikan!'),
                  ),
                );
              }
            },
            child: Text(
              'MULAI TERIAK!',
              style: passionOne24.copyWith(fontSize: 20, color: Colors.white),
            )),
      ],
    );
  }
}
