import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';
import 'personal_model.dart';

class UIInformation extends StatelessWidget {
  const UIInformation({super.key, required this.list});

  final PersonalModel list;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          list.titleText,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: list.hintText,
              hintStyle: TextStyle(
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFECEEED)),
              ),
              filled: true,
              fillColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
        )
      ],
    );
  }
}
