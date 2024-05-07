import 'package:flutter/material.dart';

class LoginRegisterDivider extends StatelessWidget {
  final String text;

  const LoginRegisterDivider({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 1.0,
            color: Color(0xFFD3D3D3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              color: Color(0xFF6C6C6C),
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 1.0,
            color: Color(0xFFD3D3D3),
          ),
        ),
      ],
    );
  }
}
