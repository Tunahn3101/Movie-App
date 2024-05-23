import 'package:flutter/material.dart';

class PersonalInformationInput extends StatelessWidget {
  const PersonalInformationInput(
      {super.key,
      required this.titleText,
      required this.hintText,
      required this.enabled,
      required this.keyboardType});
  final String titleText;
  final String hintText;
  final bool enabled;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF909090)),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color(0xFF303C41)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFECEEED)),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
          ),
        ),
      ],
    );
  }
}
