import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 156,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFFFFFFF)),
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Enter email to receive new password',
                  style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xFF303C41)),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: 260,
                  height: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: const Color(0xFFECEEED), width: 1)),
                  child: const TextField(
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF192024),
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                        hintText: 'abc123@gmail.com',
                        hintStyle: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Color(0xFFB8B8B8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        contentPadding:
                            EdgeInsets.only(left: 16, top: 13, bottom: 13),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Color(0xFFD3D3D3),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                      const VerticalDivider(color: Colors.grey),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
