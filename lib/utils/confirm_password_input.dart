import 'package:flutter/material.dart';

class ConfirmPasswordInput extends StatefulWidget {
  final String hintText;
  final String textTitle;
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordInput(
      {super.key,
      required this.hintText,
      required this.textTitle,
      required this.controller,
      required this.passwordController});

  @override
  State<ConfirmPasswordInput> createState() {
    return _ConfirmPasswordInputState();
  }
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {
  bool _passwordVisible = true;

  String? _validateConfirmPassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return "Length of password's characters must be 8 or greater";
    } else if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.textTitle,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            color: Color(0xFF303C41),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: widget.controller,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w500,
            color: Color(0xFF192024),
            fontSize: 15,
          ),
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _passwordVisible,
          validator: _validateConfirmPassword,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xFFD3D3D3)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD3D3D3)),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  _passwordVisible
                      ? 'assets/images/ic-hide.png'
                      : 'assets/images/ic-show.png',
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
