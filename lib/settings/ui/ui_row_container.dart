import 'package:flutter/material.dart';
import 'package:movieapp/common/app_images.dart';
import 'package:movieapp/settings/action_model.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class UIRowContainer extends StatelessWidget {
  const UIRowContainer({
    super.key,
    required this.action,
  });

  final ActionModel action;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final selectedColor = isDarkMode ? Colors.white : Colors.black54;
    return GestureDetector(
      onTap: action.ontap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: selectedColor)),
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                action.icon,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  action.title,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              if (action.isMore) Image.asset(AppImage.icMore),
              if (action.darkMode)
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
