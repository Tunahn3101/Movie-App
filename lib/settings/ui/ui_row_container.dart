import 'package:flutter/material.dart';
import 'package:movieapp/common/app_images.dart';
import 'package:movieapp/settings/action_model.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class UIRowContainer extends StatefulWidget {
  const UIRowContainer({
    super.key,
    required this.action,
  });

  final ActionModel action;

  @override
  State<UIRowContainer> createState() => _UIRowContainerState();
}

class _UIRowContainerState extends State<UIRowContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action.ontap,
      child: SizedBox(
        height: 51,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                widget.action.icon,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.action.title,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              if (widget.action.isMore) Image.asset(AppImage.icMore),
              if (widget.action.darkMode)
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
