import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/firebase_options.dart';
import 'package:movieapp/handlesignin/firebase_api.dart';
import 'package:movieapp/provider/library_provider.dart';
import 'package:movieapp/provider/internet_provider.dart';
import 'package:movieapp/provider/movie_details_provider.dart';
import 'package:movieapp/provider/movie_search_provider.dart';
import 'package:movieapp/provider/movies_provider.dart';
import 'package:movieapp/provider/sign_in_provider.dart';
import 'package:movieapp/provider/tab_provider.dart';
import 'package:movieapp/provider/version_app_provider.dart';
import 'package:movieapp/services/local_notification_service.dart';
import 'package:movieapp/splash_screen.dart';
import 'package:movieapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseApi().initNotifications();

  final remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setDefaults({
    'name': "PhamTuanAnh",
    "age": 20,
    "isDeveloper": true,
    "isAdmin": false,
  });

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  LocalNotificationService.initialize();

  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      print(message.notification!.title);
      print('Message: ${message.notification!.body}');
    }

    LocalNotificationService.display(message);
  });

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://5388c8056b3e927c320e2b47b94a6b37@o4509864085880832.ingest.us.sentry.io/4509978931167232';
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
    appRunner: () => runApp(SentryWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => MovieDetailsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => MovieSearchProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SignInProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => InternetProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => LibraryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => MoviesProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TabProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => VersionAppProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}
