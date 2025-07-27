import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_provider.dart';

class InputSearchScreen extends StatefulWidget {
  const InputSearchScreen({
    super.key,
    required this.controller,
    required this.onSearch,
  });
  final TextEditingController controller;
  final void Function(String) onSearch;

  @override
  State<InputSearchScreen> createState() => _InputSearchScreenState();
}

class _InputSearchScreenState extends State<InputSearchScreen> {
  bool isShowClearText = false;

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
                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                controller: widget.controller,
                onChanged: (value) {
                  setState(() {
                    isShowClearText = value.isNotEmpty;
                  });
                  widget.onSearch(value);
                },
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
            ),
            const SizedBox(width: 3),
            if (isShowClearText)
              InkWell(
                onTap: () {
                  widget.controller.clear();
                  setState(() {
                    isShowClearText = false;
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Icon(
                  IconlyLight.close_square,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              )
          ],
        ),
      ),
    );
  }
}
