import 'package:flutter/material.dart';
import 'package:scream_app/route_args.dart';
import 'package:scream_app/widgets/layout.dart';

import '../style.dart';

class SelectPrizePage extends StatelessWidget {
  const SelectPrizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      children: [
        const Column(
          children: [
            Text(
              'SELAMAT!',
              style: passionOne32,
            ),
            Text(
              'ANDA SUDAH MENYALAKAN TVNYA!!',
              style: passionOne24,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
        ),
        const Text(
          'PILIH HADIAH DIBAWAH!',
          style: passionOne32,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/result',
                    arguments: ResultArgs('shirt', '0000001'));
              },
              child: Image.asset(
                'assets/images/shirt.png',
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.fitHeight,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/result',
                    arguments: ResultArgs('tumbler', '0000001'));
              },
              child: Image.asset(
                'assets/images/tumbler.png',
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        )
      ],
    );
  }
}
