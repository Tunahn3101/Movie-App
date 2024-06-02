import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/home/notification_screen.dart';
import 'package:movieapp/provider/sign_in_provider.dart';
import 'package:movieapp/settings/personal_information/personal_information.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class UIInforUser extends StatefulWidget {
  const UIInforUser({super.key});

  @override
  State<UIInforUser> createState() => _UIInforUserState();
}

class _UIInforUserState extends State<UIInforUser> {
  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 19) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final sp = context.watch<SignInProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👋 Hi ${sp.name},',
                  maxLines: 1,
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(fontSize: 16)),
                ),
                Text(
                  getGreeting(),
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              nextScreen(context, const NotificationScreen());
            },
            icon: Icon(isDarkMode
                ? IconlyBold.notification
                : IconlyLight.notification),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              nextScreen(context, const PersonalInformationScreen());
            },
            child: CircleAvatar(
                radius: 30, backgroundImage: NetworkImage('${sp.imageUrl}')),
          ),
        ],
      ),
    );
  }
}
