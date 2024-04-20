import 'package:flutter/material.dart';
import 'package:scream_app/widgets/layout.dart';

import '../style.dart';

class ResultPage extends StatelessWidget {
  final String seletedPrize;
  final String participantId;

  const ResultPage(
      {super.key, required this.seletedPrize, required this.participantId});

  @override
  Widget build(BuildContext context) {
    return  Layout(
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
      ],
    );
  }
}
