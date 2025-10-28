import 'package:flutter/material.dart';

import '../data/local_shared.dart';
import '../widgets/layout.dart';
import '../widgets/shake_widget.dart';

class SelectLevelPage extends StatefulWidget {
  const SelectLevelPage({super.key});

  @override
  State<SelectLevelPage> createState() => _SelectLevelPageState();
}

class _SelectLevelPageState extends State<SelectLevelPage> {
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _loadSelectedLevel();
  }

  Future<void> _loadSelectedLevel() async {
    final savedLevel = await LocalStorageHelper.getLevel();
    setState(() {
      _selectedLevel = savedLevel;
    });
  }

  Future<void> _saveLevel() async {
    if (_selectedLevel != null) {
      await LocalStorageHelper.saveLevel(_selectedLevel!);
    }
  }

  void _onLevelSelect(String level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(children: [
      Image.asset('assets/images/logo-clw.png', width: 100, height: 100),

      SizedBox(height: MediaQuery.of(context).size.height * 0.04),

      const Column(
        children: [
          Text(
            'Select Level',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),

      // Column(
      //   children: [
      //     Stack(
      //       children: [
      //         Text(
      //           'Select Level',
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
      //           'Select Level',
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

      SizedBox(height: MediaQuery.of(context).size.height * 0.04),

      // EASY Button
      GestureDetector(
        onTap: () => _onLevelSelect('easy'),
        child: ShakeWidget(
          shake: _selectedLevel == 'easy',
          child: Image.asset(
            'assets/images/easy-btn-clw.png',
            width: 80,
            height: 80,
          ),
        ),
      ),

      SizedBox(height: 20),

      // MED Button
      GestureDetector(
        onTap: () => _onLevelSelect('med'),
        child: ShakeWidget(
          shake: _selectedLevel == 'med',
          child: Image.asset(
            'assets/images/med-btn-clw.png',
            width: 80,
            height: 80,
          ),
        ),
      ),

      SizedBox(height: 20),

      // HARD Button
      GestureDetector(
        onTap: () => _onLevelSelect('hard'),
        child: ShakeWidget(
          shake: _selectedLevel == 'hard',
          child: Image.asset(
            'assets/images/hard-btn-clw.png',
            width: 80,
            height: 80,
          ),
        ),
      ),

      SizedBox(height: MediaQuery.of(context).size.height * 0.1),

      // BACK BUTTON
      InkWell(
        onTap: () async {
          await _saveLevel();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        child:
            Image.asset('assets/images/back-clw.png', width: 100, height: 100),
      ),
    ]);
  }
}
