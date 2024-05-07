import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import '../utils/snack_bar.dart';
import 'after_sign_in.dart';

void handleGoogleSignIn(BuildContext context) async {
  final sp = context.read<SignInProvider>();
  final ip = context.read<InternetProvider>();
  await ip.checkInternetConnection();

  if (ip.hasInternet == false) {
    // ignore: use_build_context_synchronously
    openSnackbar(context, "Check your Internet connection", Colors.red);
  } else {
    await sp.signInWithGoogle().then((value) {
      if (sp.hasError == true) {
        openSnackbar(context, sp.errorCode.toString(), Colors.red);
      } else {
        // checking whether user exists or not
        sp.checkUserExists().then((value) async {
          if (value == true) {
            // user exists
            await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                .saveDataToSharedPreferences()
                .then((value) => sp.setSignIn().then((value) {
                      handleAfterSignIn(context);
                    })));
          } else {
            // user does not exist
            sp.saveDataToFirestore().then((value) => sp
                .saveDataToSharedPreferences()
                .then((value) => sp.setSignIn().then((value) {
                      handleAfterSignIn(context);
                    })));
          }
        });
      }
    });
  }
}
