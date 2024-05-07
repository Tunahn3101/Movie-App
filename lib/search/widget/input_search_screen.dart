import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_provider.dart';

class InputSearchScreen extends StatelessWidget {
  const InputSearchScreen(
      {super.key, required this.controller, required this.onSearch});
  final TextEditingController controller;
  final void Function(String) onSearch; // Thêm function callback onSearch

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onSearch,
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Type Something',
                  hintStyle: GoogleFonts.roboto(),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
