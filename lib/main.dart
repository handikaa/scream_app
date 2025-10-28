import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scream_app/pages/select_level.dart';
import 'package:scream_app/pages/set_value.dart';

import 'pages/failed.dart';
import 'pages/login.dart';
import 'pages/result.dart';
import 'pages/scream.dart';
import 'pages/select_prize.dart';
import 'pages/start.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await Hive.initFlutter();

  await Hive.openBox('usersBox');
  await Hive.openBox<Map>('levelBox');

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6909962655742a3c10b5fe409b4f6d85@o4505861416419328.ingest.us.sentry.io/4510263965057024';
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      options.enableLogs = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      // Configure Session Replay
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: const MyApp())),
  );
  // TODO: Remove this line after sending the first sample event to sentry.
  await Sentry.captureException(StateError('This is a sample exception.'));
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
            final arg = settings.arguments as int;
            return MaterialPageRoute(builder: (context) {
              return FailedPage(
                score: arg,
              );
            });

          case '/select-prize':
            return MaterialPageRoute(
              builder: (context) => const SelectPrizePage(),
            );
          case '/select-level':
            return MaterialPageRoute(
              builder: (context) => const SelectLevelPage(),
            );
          case '/set-value':
            return MaterialPageRoute(
              builder: (context) => const SetValuePage(),
            );

          case '/result':
            // final args = settings.arguments as ResultArgs;
            final score = settings.arguments as int;

            return MaterialPageRoute(
              builder: (context) => ResultPage(
                score: score,
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
