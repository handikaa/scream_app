import 'package:flutter/material.dart';

import '../widgets/layout.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-clw.png',
              width: 200,
              height: 200,
            ),
          ],
        ),

        // const Text(
        //   'SEKUAT APA SUARAMU',
        //   style: passionOne32,
        // ),
        // const Text(
        //   'UNTUK NYALAKAN TV!',
        //   style: passionOne32,
        // ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),

        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELCOME TO',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Image.asset(
          'assets/images/teks-clw.png',
          width: 50,
          height: 50,
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),

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
