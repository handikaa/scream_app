import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scream_app/data/local_hive.dart';
import 'package:scream_app/widgets/loading_overlay.dart';

import '../widgets/generate_random_code.dart';
import '../widgets/layout.dart';

class ResultPage extends StatefulWidget {
  final int score;
  const ResultPage({super.key, required this.score});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? uniqCode;

  final Dio _dio = Dio();
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadUserFromHive();

    _submitScore(widget.score);
  }

  Future<void> _loadUserFromHive() async {
    final hive = HiveService();
    final user = hive.getUser();
    setState(() {
      _userData = user;
      uniqCode = _userData!['uniq_id'];
    });
  }

  Future<void> _submitScore(int score) async {
    if (!mounted) return; // ✅ pastikan widget masih aktif

    if (_userData == null || _userData?['uniq_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User tidak ditemukan di local storage')),
      );
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    final uniqId = _userData!['uniq_id'];

    try {
      final response = await _dio.post(
        'https://scream-apps-api.on-forge.com/save-score.php',
        data: {
          "uniq_id": uniqId,
          "score": score,
        },
      );

      if (!mounted) return;

      if (mounted) setState(() => _isLoading = false);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final msg = response.data['message'] ?? 'Score Berhasil disimpan';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      } else {
        final msg = response.data['error'] ?? 'Gagal mengirim score';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $msg')),
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;
      if (mounted) setState(() => _isLoading = false);

      String message = 'Terjadi kesalahan';
      if (e.response != null) {
        message = e.response?.data['error'] ?? e.message ?? message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Layout(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Image.asset(
                'assets/images/logo-clw.png',
                width: 90,
                height: 90,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Image.asset(
                'assets/images/congrats.png',
                width: 60,
                height: 60,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SCORE',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${widget.score}/100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Stack(
                    //   children: [
                    //     Text(
                    //       'SCORE',
                    //       style: TextStyle(
                    //           fontFamily: 'Cookie Crumble',
                    //           fontSize: 60,
                    //           fontWeight: FontWeight.w700,
                    //           foreground: Paint()
                    //             ..style = PaintingStyle.stroke
                    //             ..strokeWidth = 5
                    //             ..color = Colors.white),
                    //     ),
                    //     const Text(
                    //       'SCORE',
                    //       style: TextStyle(
                    //         fontFamily: 'Cookie Crumble',
                    //         fontSize: 60,
                    //         fontWeight: FontWeight.w700,
                    //         color: Color(
                    //           0xffD19C3C,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Stack(
                    //   children: [
                    //     Text(
                    //       '100/100',
                    //       style: TextStyle(
                    //           fontFamily: 'Cookie Crumble',
                    //           fontSize: 40,
                    //           fontWeight: FontWeight.w700,
                    //           foreground: Paint()
                    //             ..style = PaintingStyle.stroke
                    //             ..strokeWidth = 3
                    //             ..color = Colors.white),
                    //     ),
                    //     const Text(
                    //       '100/100',
                    //       style: TextStyle(
                    //         fontFamily: 'Cookie Crumble',
                    //         fontSize: 40,
                    //         fontWeight: FontWeight.w700,
                    //         color: Color(
                    //           0xff9956A3,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    const Text(
                      'UNIQ CODE',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      uniqCode!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Stack(
                    //   children: [
                    //     Text(
                    //       'UNIQ CODE',
                    //       style: TextStyle(
                    //           fontFamily: 'Cookie Crumble',
                    //           fontSize: 60,
                    //           fontWeight: FontWeight.w700,
                    //           foreground: Paint()
                    //             ..style = PaintingStyle.stroke
                    //             ..strokeWidth = 5
                    //             ..color = Colors.white),
                    //     ),
                    //     const Text(
                    //       'UNIQ CODE',
                    //       style: TextStyle(
                    //         fontFamily: 'Cookie Crumble',
                    //         fontSize: 60,
                    //         fontWeight: FontWeight.w700,
                    //         color: Color(
                    //           0xffD19C3C,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Stack(
                    //   children: [
                    //     Text(
                    //       uniqCode ?? "0",
                    //       style: TextStyle(
                    //           fontFamily: 'Cookie Crumble',
                    //           fontSize: 40,
                    //           fontWeight: FontWeight.w700,
                    //           foreground: Paint()
                    //             ..style = PaintingStyle.stroke
                    //             ..strokeWidth = 3
                    //             ..color = Colors.white),
                    //     ),
                    //     Text(
                    //       uniqCode ?? "0",
                    //       style: const TextStyle(
                    //         fontFamily: 'Cookie Crumble',
                    //         fontSize: 40,
                    //         fontWeight: FontWeight.w700,
                    //         color: Color(
                    //           0xff9956A3,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.04,
              // ),
              // Image.asset(
              //   'assets/images/htc-clw.png',
              //   width: 40,
              //   height: 40,
              // ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.03,
              // ),
              // Image.asset(
              //   'assets/images/step.png',
              //   width: 90,
              //   height: 90,
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                "SHOW TO CASHIER\nTO CLAIM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
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
          if (_isLoading) const ShowLoadingOverlay(),
        ],
      ),
    );
  }
}
