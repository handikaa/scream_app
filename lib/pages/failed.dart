import 'package:flutter/material.dart';
import 'package:scream_app/style.dart';
import 'package:scream_app/widgets/layout.dart';

class FailedPage extends StatelessWidget {
  const FailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(backgroundColorFilter: lGred, lightLogo: true, children: [
      Column(
        children: [
          Text(
            'YAHHHH!',
            style: passionOne32.copyWith(color: Colors.white),
          ),
          Text(
            'SUARAMU SUDAH KUAT, TAPI BELUM',
            style: passionOne24.copyWith(color: Colors.white, height: 0.0),
          ),
          Text(
            'BISA MENYALAKAN TVNYA',
            style: passionOne24.copyWith(color: Colors.white, height: 0.0),
          )
        ],
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
      ),
      Column(
        children: [
          Text(
            'KASIH GILIRAN YANG LAIN',
            style: passionOne32.copyWith(color: Colors.white),
          ),
          Text(
            'UNTUK MENYALAKAN TVNYA',
            style: passionOne32.copyWith(color: Colors.white),
          ),
        ],
      ),
    ]);
  }
}
