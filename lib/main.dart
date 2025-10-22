import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/failed.dart';
import 'pages/login.dart';
import 'pages/result.dart';
import 'pages/scream.dart';
import 'pages/select_prize.dart';
import 'pages/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await Hive.initFlutter();

  // buka box untuk menyimpan user
  await Hive.openBox('usersBox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const StartPage(),
            );

          case '/scream':
            return MaterialPageRoute(
              builder: (context) => const ScreamPage(),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );

          case '/failed':
            // final arg = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => FailedPage(
                  // level: arg,
                  ),
            );

          case '/select-prize':
            return MaterialPageRoute(
              builder: (context) => const SelectPrizePage(),
            );

          case '/result':
            // final args = settings.arguments as ResultArgs;

            return MaterialPageRoute(
              builder: (context) => ResultPage(
                  // participantId: args.participantId,
                  // seletedPrize: args.seletedPrize,
                  ),
            );

          default:
            return null;
        }
      },
    );
  }
}
