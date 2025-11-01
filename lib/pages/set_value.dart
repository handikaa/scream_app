import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../data/local_shared.dart';
import '../widgets/form.dart';
import '../widgets/layout.dart';

class SetValuePage extends StatefulWidget {
  const SetValuePage({super.key});

  @override
  State<SetValuePage> createState() => _SetValuePageState();
}

class _SetValuePageState extends State<SetValuePage> {
  bool isValid = false;
  final _easyController = TextEditingController();
  // final _medController = TextEditingController();
  // final _hardController = TextEditingController();
  final _timerController = TextEditingController();
  int? savedTimer;

  late Box<Map> levelBox;

  @override
  void initState() {
    super.initState();
    _initHive();
    _loadLocalTimer();
  }

  Future<void> _loadLocalTimer() async {
    final timer = await LocalStorageHelper.getTimer();
    if (timer != null) {
      setState(() {
        savedTimer = timer;
        _timerController.text = timer.toString();
      });
      debugPrint('⏱ Timer ditemukan di local: $timer');
    } else {
      debugPrint('⚠️ Belum ada timer tersimpan');
    }
  }

  Future<void> _saveValueLocalTimer() async {
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan timer yang valid!')),
      );
      return;
    }

    final timerValue = int.parse(_timerController.text);
    await LocalStorageHelper.saveTimer(timerValue);

    if (mounted) {
      setState(() {
        savedTimer = timerValue;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Timer $timerValue second succesfully saved')),
    );
  }

  Future<void> _initHive() async {
    levelBox = await Hive.openBox<Map>('levelBox');

    final data = levelBox.get('levels');
    if (data != null) {
      _easyController.text = (data['easy'] ?? '').toString();
      // _medController.text = (data['med'] ?? '').toString();
      // _hardController.text = (data['hard'] ?? '').toString();
      setState(() => isValid = true);
    }
  }

  void _isValid() {
    setState(() {
      isValid = _easyController.text.isNotEmpty;
      // _medController.text.isNotEmpty &&
      // _hardController.text.isNotEmpty;
    });
  }

  Future<void> _saveValueLocal() async {
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua nilai level')),
      );
      return;
    }

    final newData = {
      'easy': int.tryParse(_easyController.text) ?? 0,
      // 'med': int.tryParse(_medController.text) ?? 0,
      // 'hard': int.tryParse(_hardController.text) ?? 0,
    };

    await levelBox.put('levels', newData);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Value Succesfully Saved')),
    );
  }

  @override
  void dispose() {
    _easyController.dispose();
    // _medController.dispose();
    // _hardController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Image.asset(
        //       'assets/images/logo-clw.png',
        //       width: 100,
        //       height: 100,
        //     ),
        //   ],
        // ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        // 🔹 Title
        const Column(
          children: [
            Text(
              'Set Value Level',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // Column(
        //   children: [
        //     Stack(
        //       children: [
        //         Text(
        //           'Set Value Level',
        //           style: TextStyle(
        //             fontFamily: 'Cookie Crumble',
        //             fontSize: 40,
        //             fontWeight: FontWeight.w700,
        //             foreground: Paint()
        //               ..style = PaintingStyle.stroke
        //               ..strokeWidth = 5
        //               ..color = Colors.white,
        //           ),
        //         ),
        //         const Text(
        //           'Set Value Level',
        //           style: TextStyle(
        //             fontFamily: 'Cookie Crumble',
        //             fontSize: 40,
        //             fontWeight: FontWeight.w700,
        //             color: Color(0xffD19C3C),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        _buildLevelInput('Set Value', _easyController),

        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // _buildLevelInput('MEDIUM', _medController),

        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // _buildLevelInput('HARD', _hardController),

        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        _buildLevelInput('Set Timer (in seconds)', _timerController),

        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        ElevatedButton(
          onPressed: () {
            _saveValueLocalTimer();
            _saveValueLocal();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // sudut melengkung
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ), // opsional untuk ukuran tombol
          ),
          child: const Text(
            "Simpan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // InkWell(
        //   onTap: () {
        //     _saveValueLocalTimer();
        //     _saveValueLocal();
        //   },
        //   child: Image.asset(
        //     'assets/images/btn-submit-clw.png',
        //     height: 80,
        //   ),
        // ),
      ],
    );
  }

  // 🔹 Widget input field custom
  Widget _buildLevelInput(String label, TextEditingController controller) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // Stack(
        //   children: [
        //     Text(
        //       label,
        //       style: TextStyle(
        //         fontFamily: 'Cookie Crumble',
        //         fontSize: 30,
        //         fontWeight: FontWeight.w700,
        //         foreground: Paint()
        //           ..style = PaintingStyle.stroke
        //           ..strokeWidth = 5
        //           ..color = Colors.white,
        //       ),
        //     ),
        //     Text(
        //       label,
        //       style: const TextStyle(
        //         fontFamily: 'Cookie Crumble',
        //         fontSize: 30,
        //         fontWeight: FontWeight.w700,
        //         color: Color(0xffD19C3C),
        //       ),
        //     ),
        //   ],
        // ),
        AppTextFormField(
          hintText: label,
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) => _isValid(),
        ),
      ],
    );
  }
}
