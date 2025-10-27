import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scream_app/pages/scream.dart';
import 'package:scream_app/widgets/app_elevated_button.dart';
import 'package:scream_app/widgets/form.dart';
import 'package:scream_app/widgets/layout.dart';
import 'package:scream_app/widgets/snackbar.dart';

import '../data/local_hive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isValid = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _isValid() {
    setState(() {
      isValid = false;
    });
    if (_nameController.text.isEmpty) return;
    if (_nameController.text.length < 4) return;
    if (_phoneController.text.isEmpty) return;
    if (_phoneController.text.length < 4) return;
    setState(() {
      isValid = true;
    });
  }

  // void _onRegister() async {
  //   final name = _nameController.text.trim();
  //   final phone = _phoneController.text.trim();

  //   final found = listAccount.any(
  //     (account) =>
  //         account['name'].toString().toLowerCase() == name.toLowerCase() &&
  //         account['phone'] == phone,
  //   );

  //   if (found) {
  //     showAppSnackBar(context,
  //         message:
  //             "no telepon sudah terdaftar, silahkan beri kesempatan yang lain",
  //         type: SnackType.error);
  //   } else {
  //     final permission = await Permission.microphone.request();

  //     if (permission.isGranted) {
  //       // ignore: use_build_context_synchronously
  //       Navigator.pushNamed(context, '/scream');
  //       // Navigator.pushNamed(context, '/select-prize');
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Akses microphone tidak diberikan!'),
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> _registerUser(BuildContext context) async {
    final dio = Dio();
    final hive = HiveService();

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan No Telp tidak boleh kosong')),
      );
      return;
    }
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid phone number at least 10 karakter')),
      );
      return;
    }

    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await dio.post(
        'https://scream-apps-api.on-forge.com/save-data.php',
        data: {
          "name": name,
          "phone": phone,
        },
      );

      Navigator.pop(context); // Tutup loading

      if (response.statusCode == 201 && response.data['success'] == true) {
        await hive.clearUser();

        final userData = response.data['data'];

        await hive.saveUser(userData);

        final permission = await Permission.microphone.request();

        if (permission.isGranted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/scream', (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akses microphone tidak diberikan!'),
            ),
          );
        }

        // Navigator.pushReplacementNamed(
        //   context,
        //   '/scream',
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                response.data['error'] ?? 'Gagal register',
                style: TextStyle(color: Colors.white),
              )),
        );
      }
    } on DioException catch (e) {
      Navigator.pop(context); // Tutup loading

      String errorMessage = 'Terjadi kesalahan';
      if (e.response != null) {
        if (e.response?.statusCode == 409) {
          errorMessage =
              e.response?.data['error'] ?? 'Nomor sudah terdaftar hari ini';
        } else {
          errorMessage = e.response?.data['error'] ?? 'Gagal register';
        }
      } else {
        errorMessage = 'Tidak dapat terhubung ke server';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            )),
      );
    }
  }

  // Future<void> _registerUser(BuildContext ctx) async {
  //   if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Form tidak boleh kosong',
  //           style: TextStyle(fontSize: 15),
  //         ),
  //         backgroundColor: Colors.redAccent,
  //       ),
  //     );
  //     return;
  //   }

  //   final hive = HiveService();
  //   final name = _nameController.text.trim();
  //   final phone = _phoneController.text.trim();

  //   final exists = hive.isUserExist(name, phone);

  //   if (exists) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'no telp sudah terdaftar, silahkan beri kesempatan yang lain',
  //           style: TextStyle(fontSize: 15),
  //         ),
  //         backgroundColor: Colors.redAccent,
  //       ),
  //     );
  //     return;
  //   }

  //   await hive.addUser({'name': name, 'phone': phone});

  //   final permission = await Permission.microphone.request();

  //   if (permission.isGranted) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushNamed(context, '/scream');
  //     // Navigator.pushNamed(context, '/select-prize');
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Akses microphone tidak diberikan!'),
  //       ),
  //     );
  //   }

  //   // ScaffoldMessenger.of(ctx).showSnackBar(
  //   //   const SnackBar(
  //   //     content: Text('Registrasi berhasil! Silakan login.'),
  //   //     backgroundColor: Colors.green,
  //   //   ),
  //   // );

  //   // Navigator.pushNamed(ctx, '/login');
  // }

  @override
  Widget build(BuildContext context) {
    return Layout(
      bg: 'assets/images/bg-clw-2.png',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-clw.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        AppTextFormField(
          hintText: 'NAMA LENGKAP',
          controller: _nameController,
          onChanged: (value) => _isValid(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        AppTextFormField(
          hintText: 'NO TELP',
          keyboardType: TextInputType.number,
          controller: _phoneController,
          onChanged: (value) => _isValid(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        InkWell(
          onTap: () async {
            _registerUser(context);
          },
          child: Image.asset(
            'assets/images/btn-submit-clw.png',
            height: 80,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Follow Us On IG & Tiktok\n@clawset.id',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
