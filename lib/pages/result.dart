import 'package:flutter/material.dart';

import '../widgets/generate_random_code.dart';
import '../widgets/layout.dart';

class ResultPage extends StatelessWidget {
  // final String seletedPrize;
  // final String participantId;

  // const ResultPage(
  //     {super.key, required this.seletedPrize, required this.participantId});
  final String uniqCode = generateUniqCode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Layout(
        children: [
          Image.asset(
            'assets/images/logo-clw.png',
            width: 150,
            height: 150,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),

          Container(
            color: const Color(0xff9956A3),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Text(
                      'SCORE',
                      style: TextStyle(
                          fontFamily: 'Cookie Crumble',
                          fontSize: 60,
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Colors.white),
                    ),
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        fontFamily: 'Cookie Crumble',
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: Color(
                          0xffD19C3C,
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Text(
                      '100/100',
                      style: TextStyle(
                          fontFamily: 'Cookie Crumble',
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.white),
                    ),
                    const Text(
                      '100/100',
                      style: TextStyle(
                        fontFamily: 'Cookie Crumble',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(
                          0xff9956A3,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Stack(
                  children: [
                    Text(
                      'UNIQ CODE',
                      style: TextStyle(
                          fontFamily: 'Cookie Crumble',
                          fontSize: 60,
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Colors.white),
                    ),
                    const Text(
                      'UNIQ CODE',
                      style: TextStyle(
                        fontFamily: 'Cookie Crumble',
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: Color(
                          0xffD19C3C,
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Text(
                      uniqCode,
                      style: TextStyle(
                          fontFamily: 'Cookie Crumble',
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.white),
                    ),
                    Text(
                      uniqCode,
                      style: TextStyle(
                        fontFamily: 'Cookie Crumble',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(
                          0xff9956A3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Image.asset(
            'assets/images/htc-clw.png',
            width: 40,
            height: 40,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Image.asset(
            'assets/images/step.png',
            width: 90,
            height: 90,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),

          InkWell(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false),
            child: Image.asset(
              'assets/images/back-clw.png',
              width: 50,
              height: 50,
            ),
          ),
          // Text(
          //   participantId,
          //   style: passionOne32,
          // ),
          // Text(
          //   'SILAHKAN FOTO DAN TUNJUKAN',
          //   style: passionOne24.copyWith(height: 0.0),
          // ),
          // Text(
          //   'KEPADA KASIR',
          //   style: passionOne24.copyWith(height: 0.0),
          // ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.1,
          // ),
          // Image.asset(
          //   seletedPrize,
          //   height: MediaQuery.of(context).size.height * 0.2,
          //   fit: BoxFit.fitHeight,
          // ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.05,
          // ),
          // StartButton(
          //   onPressed: () {
          //     Navigator.popUntil(context, (route) => route.isFirst);
          //   },
          //   textStyle: passionOne24.copyWith(color: Colors.white),
          //   child: Text(
          //     'KEMBALI',
          //     style: passionOne24.copyWith(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
