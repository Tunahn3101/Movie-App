import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
