import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/handlesignin/email_sign_in.dart';

import '../handlesignin/google_sign_in.dart';
import '../utils/action_button_social.dart';
import '../utils/button_action.dart';
import '../utils/dialog.dart';
import '../utils/email_input.dart';
import '../utils/forgot_password_dialog.dart';
import '../utils/login_register_divider.dart';
import '../utils/next_screen.dart';
import '../utils/password_input.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateEmailValidity);
    passwordController.addListener(_updatePasswordValidity);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _updateEmailValidity() {
    setState(() {
      isEmailValid = _validateEmail(emailController.text);
    });
  }

  void _updatePasswordValidity() {
    setState(() {
      isPasswordValid = _validatePassword(passwordController.text);
    });
  }

  bool _validateEmail(String email) {
    // Thực hiện logic kiểm tra email hợp lệ ở đây
    return email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePassword(String password) {
    // Thực hiện logic kiểm tra password hợp lệ ở đây
    return password.isNotEmpty && password.length >= 8;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      handleEmailSignIn(context, emailController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 92),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back! 👋',
                      style: GoogleFonts.sansitaSwashed(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 28),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Hello , Nice to meet you again!',
                      style: GoogleFonts.sansitaSwashed(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmailInput(
                        hintText: 'Enter your email',
                        controller: emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    PasswordInput(
                      hintText: 'Enter your password',
                      textTitle: 'Password',
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pushDialog(context, const ForgotPasswordDialog());
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6C6C6C)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    ActionButton(
                      onPressed: _submitForm,
                      text: 'Login',
                      backgroundColor: isEmailValid && isPasswordValid
                          ? const Color(0xFFFF8311) // Khi cả hai trường hợp lệ
                          : const Color(0xFFD3D3D3),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const LoginRegisterDivider(text: 'Or Login with'),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ActionButtonSocial(
                          imagePath: 'assets/images/facebook.png',
                          text: 'Facebook',
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ActionButtonSocial(
                          imagePath: 'assets/images/google.png',
                          text: 'Google',
                          onTap: () {
                            handleGoogleSignIn(context);
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFF303C41),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: () {
                              nextScreen(context, const RegisterScreen());
                            },
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFFFF8311),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
