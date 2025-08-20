import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
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

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

String remoteName = "Guest";
int remoteAge = 18;
bool remoteIsAdmin = false;

Future<void> setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 18),
    minimumFetchInterval: const Duration(seconds: 10),
  ));

  await remoteConfig.setDefaults({
    "name": "Guest",
    "age": 18,
    "isAdmin": false,
  });

  try {
    final bool updated = await remoteConfig.fetchAndActivate();
    print("🔄 Remote Config updated: $updated");
  } catch (e) {
    print("❌ Remote Config fetch error: $e");
  }

  remoteConfig.onConfigUpdated.listen((event) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await remoteConfig.activate();

      remoteName = remoteConfig.getString("name");
      remoteAge = remoteConfig.getInt("age");
      remoteIsAdmin = remoteConfig.getBool("isAdmin");

      print("♻️ Config updated -> $remoteName / $remoteAge / $remoteIsAdmin");
    });
  });

  remoteName = remoteConfig.getString("name");
  remoteAge = remoteConfig.getInt("age");
  remoteIsAdmin = remoteConfig.getBool("isAdmin");

  print("🔥 Remote Config values:");
  print("Name: $remoteName");
  print("Age: $remoteAge");
  print("isAdmin: $remoteIsAdmin");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseApi().initNotifications();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  LocalNotificationService.initialize();

  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      print(message.notification!.title);
      print('Message: ${message.notification!.body}');
    }

    LocalNotificationService.display(message);
  });

  await setupRemoteConfig();

  FlutterError.onError = (errorDetails) {
    try {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      if (kDebugMode) {
        FlutterError.presentError(errorDetails);
        debugPrint("flutter_error_crash: $errorDetails");
      }
    } catch (_) {}
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

      if (kDebugMode) {
        debugPrint("platform_dispatcher_error: $error");
        debugPrint("platform_dispatcher_stack_trace: \n$stack");
      }
    } catch (_) {}
    return true;
  };

  runApp(
    MultiProvider(
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
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}
