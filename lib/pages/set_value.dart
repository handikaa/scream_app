import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
  final _medController = TextEditingController();
  final _hardController = TextEditingController();

  late Box<Map> levelBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    levelBox = await Hive.openBox<Map>('levelBox');

    final data = levelBox.get('levels');
    if (data != null) {
      _easyController.text = (data['easy'] ?? '').toString();
      _medController.text = (data['med'] ?? '').toString();
      _hardController.text = (data['hard'] ?? '').toString();
      setState(() => isValid = true);
    }
  }

  void _isValid() {
    setState(() {
      isValid = _easyController.text.isNotEmpty &&
          _medController.text.isNotEmpty &&
          _hardController.text.isNotEmpty;
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
      'med': int.tryParse(_medController.text) ?? 0,
      'hard': int.tryParse(_hardController.text) ?? 0,
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
    _medController.dispose();
    _hardController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        // 🔹 Title
        Column(
          children: [
            Stack(
              children: [
                Text(
                  'Set Value Level',
                  style: TextStyle(
                    fontFamily: 'Cookie Crumble',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Colors.white,
                  ),
                ),
                const Text(
                  'Set Value Level',
                  style: TextStyle(
                    fontFamily: 'Cookie Crumble',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffD19C3C),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        // 🔹 Input EASY
        _buildLevelInput('EASY', _easyController),

        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // 🔹 Input MEDIUM
        _buildLevelInput('MEDIUM', _medController),

        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // 🔹 Input HARD
        _buildLevelInput('HARD', _hardController),

        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        // 🔹 Tombol Submit
        InkWell(
          onTap: _saveValueLocal,
          child: Image.asset(
            'assets/images/btn-submit-clw.png',
            height: 80,
          ),
        ),
      ],
    );
  }

  // 🔹 Widget input field custom
  Widget _buildLevelInput(String label, TextEditingController controller) {
    return Column(
      children: [
        Stack(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cookie Crumble',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cookie Crumble',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xffD19C3C),
              ),
            ),
          ],
        ),
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
