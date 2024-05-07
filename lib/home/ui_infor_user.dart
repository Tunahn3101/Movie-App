import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/provider/sign_in_provider.dart';
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
                  '👋 Hi ${sp.name ?? 'User'},',
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
            onPressed: () {},
            icon: Icon(isDarkMode
                ? IconlyBold.notification
                : IconlyLight.notification),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(sp.imageUrl ??
                'https://cdn1.iconfinder.com/data/icons/round2-set/25/Profile_ic-512.png'),
          ),
        ],
      ),
    );
  }
}
