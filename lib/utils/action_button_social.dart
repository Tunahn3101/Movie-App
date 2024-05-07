import 'package:flutter/material.dart';

class ActionButtonSocial extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;

  const ActionButtonSocial({
    required this.imagePath,
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          fixedSize: const Size(175, 48), // Kích thước của nút
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Độ cong của góc
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 21,
              height: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xFF202A2E),
              ),
            )
          ],
        ),
      ),
    );
  }
}
