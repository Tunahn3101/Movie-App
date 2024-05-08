import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import '../utils/snack_bar.dart';
import 'after_sign_in.dart';

void handleEmailSignIn(
    BuildContext context, String email, String password) async {
  final sp = context.read<SignInProvider>();
  final ip = context.read<InternetProvider>();

  await ip.checkInternetConnection();
  if (!ip.hasInternet) {
    openSnackbar(context, "Check your Internet connection", Colors.red);
    return;
  }

  sp.signInWithEmail(email, password).then((_) {
    if (sp.hasError) {
      openSnackbar(context, sp.errorCode ?? "Login failed", Colors.red);
    } else {
      sp.checkUserExists().then((userExists) async {
        if (userExists) {
          // user exists
          await sp.getUserDataFromFirestore(sp.uid!).then((_) async {
            await sp.saveDataToSharedPreferences();
            await sp.setSignIn();
            handleAfterSignIn(context);
          });
        } else {
          // user does not exist
          await sp.saveDataToFirestore();
          await sp.saveDataToSharedPreferences();
          await sp.setSignIn();
          handleAfterSignIn(context);
        }
      });
    }
  }).catchError((error) {
    openSnackbar(context, error.toString(), Colors.red);
  });
}
