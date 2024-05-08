import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/login_and_register/login_screen.dart';
import 'package:movieapp/ui/ui_bottom_navigation.dart';
import 'package:provider/provider.dart';

import 'provider/sign_in_provider.dart';
import 'utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();

    Timer(const Duration(seconds: 4), () {
      sp.isSignedIn == false
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const UiBottomNavigation());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splashScreen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Moviemoz',
                  style: GoogleFonts.germaniaOne(
                    textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(
                  'assets/images/video_player.png',
                  width: 40,
                  height: 39,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Text(
            'Enjoy the gathering of all movies.',
            maxLines: 2,
            style: GoogleFonts.andika(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
