import 'package:flutter/material.dart';
import 'package:movieapp/utils/app_utils.dart';
import 'package:provider/provider.dart';

import '../provider/internet_provider.dart';
import '../provider/sign_in_provider.dart';
import '../utils/snack_bar.dart';
import 'after_sign_in.dart';

void handleAppleSignIn(BuildContext context) async {
  final sp = context.read<SignInProvider>();
  final ip = context.read<InternetProvider>();

  await ip.checkInternetConnection();

  if (!context.mounted) return;

  AppUtils.showLoadingDialog(context);

  if (ip.hasInternet == false) {
    if (!context.mounted) return;
    AppUtils.hideLoadingDialog(context);
    openSnackbar(context, "Check your Internet connection", Colors.red);
    return;
  }

  bool result = await sp.signInWithApple();

  if (!context.mounted) return;

  if (!result || sp.hasError) {
    AppUtils.hideLoadingDialog(context);
    openSnackbar(context, sp.errorCode.toString(), Colors.red);
    return;
  }

  bool userExists = await sp.checkUserExists();

  if (!context.mounted) return;

  if (userExists) {
    await sp.getUserDataFromFirestore(sp.uid);
  } else {
    await sp.saveDataToFirestore();
  }

  await sp.saveDataToSharedPreferences();
  await sp.setSignIn();

  if (!context.mounted) return;

  AppUtils.hideLoadingDialog(context);
  handleAfterSignIn(context);
}
