import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scream_app/pages/failed.dart';
import 'package:scream_app/pages/result.dart';
import 'package:scream_app/pages/scream.dart';
import 'package:scream_app/pages/select_prize.dart';
import 'package:scream_app/pages/start.dart';
import 'package:scream_app/route_args.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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

          case '/failed':
            return MaterialPageRoute(
              builder: (context) => const FailedPage(),
            );

          case '/select-prize':
            return MaterialPageRoute(
              builder: (context) => const SelectPrizePage(),
            );

          case '/result':
            final args = settings.arguments as ResultArgs;

            return MaterialPageRoute(
              builder: (context) => ResultPage(
                participantId: args.participantId,
                seletedPrize: args.seletedPrize,
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
