import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/sign_in_provider.dart';
import '../themes/theme_provider.dart';

class UIInfoUserSetting extends StatefulWidget {
  const UIInfoUserSetting({super.key});

  @override
  State<UIInfoUserSetting> createState() => _UIInfoUserSettingState();
}

class _UIInfoUserSettingState extends State<UIInfoUserSetting> {
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
    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selectedColor, width: 1)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }
}
