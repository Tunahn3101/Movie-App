import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/action_button_social.dart';
import '../utils/button_action.dart';
import '../utils/confirm_password_input.dart';
import '../utils/email_input.dart';
import '../utils/login_register_divider.dart';
import '../utils/next_screen.dart';
import '../utils/password_input.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _agreeToTerms = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateEmailValidity);
    passwordController.addListener(_updatePasswordValidity);
    confirmPasswordController.addListener(_updateConfirmPasswordValidity);
  }

  void _updateEmailValidity() {
    setState(() {
      isEmailValid = _validateEmail(emailController.text);
    });
  }

  void _updatePasswordValidity() {
    setState(() {
      isPasswordValid = _validatePassword(passwordController.text);
      isConfirmPasswordValid =
          passwordController.text == confirmPasswordController.text &&
              isPasswordValid;
    });
  }

  void _updateConfirmPasswordValidity() {
    setState(() {
      isConfirmPasswordValid =
          passwordController.text == confirmPasswordController.text &&
              isPasswordValid;
    });
  }

  bool _validateEmail(String email) {
    return email.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 8;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? checkboxError = _validateCheckbox(_agreeToTerms);
      if (checkboxError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(checkboxError)),
        );
        return;
      } else {
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          if (credential.user != null) {
            // ignore: use_build_context_synchronously
            nextScreen(context, const LoginScreen());
          }
        } on FirebaseAuthException catch (e) {
          _showErrorDialog(e.code);
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? _validateCheckbox(bool value) {
    if (!value) {
      return 'Please agree to the terms and conditions';
    }
    return null;
  }

  void _toggleAgreeToTerms() {
    setState(() {
      _agreeToTerms = !_agreeToTerms;
    });
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
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF202A2E),
                            fontSize: 28),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Connect with your family today!',
                      style: GoogleFonts.sansitaSwashed(
                        textStyle: const TextStyle(
                          color: Color(0xFF202A2E),
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
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PasswordInput(
                      hintText: 'Enter your password',
                      textTitle: 'Password',
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConfirmPasswordInput(
                      hintText: 'Enter your password',
                      textTitle: 'Confirm password',
                      controller: confirmPasswordController,
                      passwordController: passwordController,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _toggleAgreeToTerms();
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFFB8B8B8),
                                width: 1,
                              ),
                            ),
                            child: _agreeToTerms
                                ? Center(
                                    child: Image.asset(
                                      'assets/images/Fill.png',
                                      width: 11,
                                      height: 7.97,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            _toggleAgreeToTerms();
                          },
                          child: const Text(
                            'I agree to the terms and conditions',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF303C41),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    ActionButton(
                      onPressed: _submitForm,
                      text: 'Register',
                      backgroundColor: isEmailValid &&
                              isPasswordValid &&
                              isConfirmPasswordValid &&
                              _agreeToTerms
                          ? const Color(0xFFFF8311)
                          : const Color(0xFFD3D3D3),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const LoginRegisterDivider(text: 'Or Register with'),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
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
                          onTap: () {},
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
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
                              nextScreen(context, const LoginScreen());
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFFFF8311),
                              ),
                            ),
                          ),
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
