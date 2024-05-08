import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 68),
              Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: selectedColor, width: 1)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('${sp.imageUrl}'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${sp.name}",
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${sp.email}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: 105,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: selectedColor)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 51,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-profile.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Personal information',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Image.asset('assets/images/ic-more.png')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1, // Độ dày của đường kẻ
                        color: selectedColor, // Màu sắc của đường kẻ
                      ),
                      Container(
                        height: 51,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(16)),
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
                              value: Provider.of<ThemeProvider>(context,
                                      listen: false)
                                  .isDarkMode,
                              onChanged: (value) => Provider.of<ThemeProvider>(
                                      context,
                                      listen: false)
                                  .toggleTheme(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 16,
              ),
              Container(
                  height: 158,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: selectedColor)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 51,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-share.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Share app',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1, // Độ dày của đường kẻ
                        color: selectedColor, // Màu sắc của đường kẻ
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 51,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-rate.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'App reviews',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1, // Độ dày của đường kẻ
                        color: selectedColor, // Màu sắc của đường kẻ
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 52,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-help.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Help',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 16,
              ),
              Container(
                  height: 158,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: selectedColor)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 51,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-aboutUs.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'About us',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Image.asset('assets/images/ic-more.png')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1, // Độ dày của đường kẻ
                        color: selectedColor, // Màu sắc của đường kẻ
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 51,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-privacyPolicy.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Privacy policy',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Image.asset('assets/images/ic-more.png')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1, // Độ dày của đường kẻ
                        color: selectedColor, // Màu sắc của đường kẻ
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          height: 52,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic-termsOfService.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Terms of service',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Image.asset('assets/images/ic-more.png')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              ActionButton(
                onPressed: () {
                  sp.userSignOut();
                  nextScreen(context, const LoginScreen());
                },
                text: 'Logout',
                backgroundColor: const Color(0xFFDB515E),
              ),
              const SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }
}
