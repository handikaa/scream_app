import 'package:flutter/material.dart';
import 'package:scream_app/route_args.dart';
import 'package:scream_app/widgets/layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';

class SelectPrizePage extends StatefulWidget {
  const SelectPrizePage({super.key});

  @override
  State<SelectPrizePage> createState() => _SelectPrizePageState();
}

class _SelectPrizePageState extends State<SelectPrizePage> {
  int currentCode = 1;

  @override
  void initState() {
    super.initState();
    loadCode();
  }

  Future<void> loadCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentCode = prefs.getInt('current_code') ?? 1;
    });
  }

  Future<void> saveCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_code', currentCode);
  }

  String getFormattedCode() {
    return currentCode.toString().padLeft(7, '0');
  }

  void goToResult(String type) {
    final code = getFormattedCode();
    Navigator.pushNamed(
      context,
      '/result',
      arguments: ResultArgs(type, code),
    );
    setState(() {
      currentCode++;
    });
    saveCode();
  }

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
            // Text(
            //   'ANDA SUDAH MENYALAKAN TVNYA!!',
            //   style: passionOne24,
            // ),
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
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 16.0,
          runSpacing: 16.0,
          children: [
            InkWell(
              onTap: () => goToResult('assets/images/rinso.png'),
              child: Image.asset(
                'assets/images/rinso.png',
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.fitHeight,
              ),
            ),
            // InkWell(
            //   onTap: () => goToResult('assets/images/tshirt-white.png'),
            //   child: Image.asset(
            //     'assets/images/tshirt-white.png',
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     fit: BoxFit.fitHeight,
            //   ),
            // ),
            // InkWell(
            //   onTap: () => goToResult('assets/images/bag-red.png'),
            //   child: Image.asset(
            //     'assets/images/bag-red.png',
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     fit: BoxFit.fitHeight,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
