import 'package:flutter/material.dart';
import 'package:movieapp/extension/extension_core.dart';
import 'package:movieapp/settings/ui/ui_row_container.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';
import '../action_model.dart';

class UISectionContainer extends StatelessWidget {
  const UISectionContainer({
    super.key,
    required this.data,
  });

  final List<ActionModel> data;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final selectedColor = isDarkMode ? Colors.white : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selectedColor,
          width: 1,
        ),
      ),
      child: Column(
        children: data.mapIndexed((element, index) {
          if (index == 0) {
            return UIRowContainer(action: element);
          } else {
            return Column(
              children: [
                Divider(height: 1, color: selectedColor),
                UIRowContainer(action: element)
              ],
            );
          }
        }).toList(),
      ),
    );
  }
}
