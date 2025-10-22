import 'package:flutter/material.dart';

import '../style.dart';
import '../widgets/layout.dart';

class FailedPage extends StatelessWidget {
  // const FailedPage({super.key, required this.level});

  // final String level;

  String getMessageByLevel(String level) {
    switch (level) {
      case "0":
        return "Masih terlalu sopan teriakannya, ibarat kura-kura jalan santai di catwalk 🐢✨ ayo coba lebih kenceng!";
      case "1":
        return "Selamat! Teriakanmu di Level 1 berhasil bikin hamster yang lagi ngemil langsung nengok 🤭🐹";

      case "2":
        return "Gokil! Suaramu di Level 2 udah cukup buat bangunin si Oyen yang lagi tidures 🐱😹";
      case "3":
        return "Luar biasa! Level 3, teriakanmu bikin kucing-kucing yang lagi mager langsung sprint maraton! 🐱💨";
      default:
        return "Terjadi kesalahan yang tidak diketahui.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(backgroundColorFilter: lGred, lightLogo: true, children: [
      Image.asset(
        'assets/images/logo-clw.png',
        width: 150,
        height: 150,
      ),

      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
      ),
      Image.asset(
        'assets/images/failed-clw.png',
        width: 150,
        height: 150,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
      ),
      InkWell(
        onTap: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        child: Image.asset(
          'assets/images/back-clw.png',
          width: 100,
          height: 100,
        ),
      ),

      // Text(
      //   getMessageByLevel(level),
      //   style: passionOne28.copyWith(color: Colors.black),
      //   textAlign: TextAlign.center,
      // ),
      // Column(
      //   children: [
      //     Text(
      //       'YAHHHH!',
      //       style: passionOne32.copyWith(color: Colors.white),
      //     ),
      //     Text(
      //       'SUARAMU SUDAH KUAT, TAPI BELUM',
      //       style: passionOne24.copyWith(color: Colors.white, height: 0.0),
      //     ),
      //     Text(5554321123
      //       'BISA MENYALAKAN TVNYA',
      //       style: passionOne24.copyWith(color: Colors.white, height: 0.0),
      //     )
      //   ],
      // ),
      // SizedBox(
      //   height: MediaQuery.of(context).size.height * 0.1,
      // ),
      // Column(
      //   children: [
      //     Text(
      //       'Kasih giliran yang lain yah buat teriak dan dapetin hadiahnya',
      //       style: passionOne24.copyWith(color: Colors.black),
      //       textAlign: TextAlign.center,
      //     ),

      //     SizedBox(
      //       height: MediaQuery.of(context).size.height * 0.05,
      //     ),
      //     // Text(
      //     //   'UNTUK MENYALAKAN TVNYA',
      //     //   style: passionOne32.copyWith(color: Colors.white),
      //     // ),
      //     StartButton(
      //       bgColor: Colors.white,
      //       onPressed: () {
      //         Navigator.popUntil(context, (route) => route.isFirst);
      //       },
      //       textStyle: passionOne24.copyWith(color: Colors.black),
      //       child: Text(
      //         'KEMBALI',
      //         style: passionOne24.copyWith(color: Colors.black),
      //       ),
      //     ),
      //   ],
      // ),
    ]);
  }
}
