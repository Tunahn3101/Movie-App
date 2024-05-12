import 'package:flutter/material.dart';
import 'package:movieapp/settings/ui/ui_setting_list.dart';
import 'package:movieapp/settings/ui_info_user_setting.dart';
import 'package:movieapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import '../login_and_register/login_screen.dart';
import '../provider/sign_in_provider.dart';
import '../utils/button_action.dart';
import '../utils/next_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchValue = true;
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

    final selectedColor = isDarkMode ? Colors.white : Colors.black54;
    final sp = context.watch<SignInProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 68),
                const UIInfoUserSetting(),
                const SizedBox(height: 20),
                Container(
                  height: 51,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: selectedColor)),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-darkMode.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Expanded(
                        child: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Switch(
                        value:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .isDarkMode,
                        onChanged: (value) =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const UISettingList(),
                const SizedBox(height: 20),
                ActionButton(
                  onPressed: () {
                    sp.userSignOut();
                    nextScreen(context, const LoginScreen());
                  },
                  text: 'Logout',
                  backgroundColor: const Color(0xFFDB515E),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
