import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scream_app/data/local_hive.dart';
import 'package:scream_app/pages/start.dart';
import 'package:scream_app/widgets/loading_overlay.dart';

import '../style.dart';
import '../widgets/layout.dart';

class FailedPage extends StatefulWidget {
  final int score;
  const FailedPage({super.key, required this.score});

  @override
  State<FailedPage> createState() => _FailedPageState();
}

class _FailedPageState extends State<FailedPage> {
  final Dio _dio = Dio();
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    _loadUserFromHive();
    _submitScore();
  }

  Future<void> _loadUserFromHive() async {
    final hive = HiveService();
    final user = hive.getUser();
    setState(() {
      _userData = user;
    });
  }

  void showLoadingDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.4),
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _submitScore() async {
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
          "score": widget.score,
        },
      );

      if (!mounted) return; // ✅ stop jika sudah keluar dari halaman

      if (mounted) setState(() => _isLoading = false);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final msg = response.data['message'] ?? 'Score Berhasil disimpan';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      } else {
        final msg = response.data['message'] ?? 'Gagal mengirim score';
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

  // Future<void> _submitScore() async {
  //   if (_userData == null || _userData?['uniq_id'] == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('User tidak ditemukan di local storage')),
  //     );
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   final uniqId = _userData!['uniq_id'];

  //   try {
  //     final response = await _dio.post(
  //       'https://scream-apps-api.on-forge.com/save-score.php',
  //       data: {
  //         "uniq_id": uniqId,
  //         "score": widget.score,
  //       },
  //     );

  //     setState(() => _isLoading = false);

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Score berhasil dikirim!')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'Gagal: ${response.data['message'] ?? 'Unknown error'}',
  //           ),
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     setState(() => _isLoading = false);

  //     String message = 'Terjadi kesalahan';
  //     if (e.response != null) {
  //       message = e.response?.data['error'] ?? e.message ?? message;
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(message)),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Layout(backgroundColorFilter: lGred, lightLogo: true, children: [
          Image.asset(
            'assets/images/logo-clw.png',
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Image.asset(
            'assets/images/on-no-clw.png',
            width: 70,
            height: 70,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Image.asset(
            'assets/images/not-hear-clw.png',
            width: 170,
            height: 170,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
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
        ]),
        if (_isLoading) const ShowLoadingOverlay(),
      ],
    );
  }
}
