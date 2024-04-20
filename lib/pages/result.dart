import 'package:flutter/material.dart';
import 'package:scream_app/widgets/layout.dart';
import 'package:scream_app/widgets/start_button.dart';

import '../style.dart';

class ResultPage extends StatelessWidget {
  final String seletedPrize;
  final String participantId;

  const ResultPage(
      {super.key, required this.seletedPrize, required this.participantId});

  @override
  Widget build(BuildContext context) {
    return Layout(
      children: [
        Text(
          participantId,
          style: passionOne32,
        ),
        Text(
          'SILAHKAN FOTO DAN TUNJUKAN',
          style: passionOne24.copyWith(height: 0.0),
        ),
        Text(
          'KEPADA KASIR',
          style: passionOne24.copyWith(height: 0.0),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
        ),
        StartButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          textStyle: passionOne24.copyWith(color: Colors.white),
          child: Text(
            'KEMBALI',
            style: passionOne24.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
