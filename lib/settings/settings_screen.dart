import 'package:flutter/material.dart';
import 'package:movieapp/settings/ui/ui_setting_list.dart';
import 'package:movieapp/settings/ui_info_user_setting.dart';
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
    final sp = context.watch<SignInProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 68),
              const UIInfoUserSetting(),
              const SizedBox(height: 24),
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
    );
  }
}
