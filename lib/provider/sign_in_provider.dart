import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  // instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  //hasError, errorCode, provider,uid, email, name, imageUrl
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  // set imageUrl(String? url) {
  //   _imageUrl = url;
  //   notifyListeners(); // Giúp cập nhật UI khi imageUrl thay đổi
  // }

  String? _gender;
  String? get gender => _gender;

  String? _dateOfBirth;
  String? get dateOfBirth => _dateOfBirth;

  String? _countries;
  String? get countries => _countries;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // sign in with email

  // sign in with email
  Future signInWithEmail(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? userDetails = credential.user;
      if (userDetails != null) {
        _name = userDetails.displayName ?? "New User";
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL ??
            "https://cdn1.iconfinder.com/data/icons/round2-set/25/Profile_ic-512.png";
        _provider = "EMAIL";
        _uid = userDetails.uid;
        _gender = "";
        _dateOfBirth = "";
        _countries = "";
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  // sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser!.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        _gender = "";
        _dateOfBirth = "";
        _countries = "";
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // // sign in with facebook
  // Future signInWithFacebook() async {
  //   final LoginResult result = await facebookAuth.login();
  //   // getting the profile
  //   final graphResponse = await http.get(Uri.parse(
  //       'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

  //   final profile = jsonDecode(graphResponse.body);

  //   if (result.status == LoginStatus.success) {
  //     try {
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);
  //       await firebaseAuth.signInWithCredential(credential);
  //       // saving the values
  //       _name = profile['name'];
  //       _email = profile['email'];
  //       _imageUrl = profile['picture']['data']['url'];
  //       _uid = profile['id'];
  //       _hasError = false;
  //       _provider = "FACEBOOK";
  //       notifyListeners();
  //     } on FirebaseAuthException catch (e) {
  //       switch (e.code) {
  //         case "account-exists-with-different-credential":
  //           _errorCode =
  //               "You already have an account with us. Use correct provider";
  //           _hasError = true;
  //           notifyListeners();
  //           break;

  //         case "null":
  //           _errorCode = "Some unexpected error while trying to sign in";
  //           _hasError = true;
  //           notifyListeners();
  //           break;
  //         default:
  //           _errorCode = e.toString();
  //           _hasError = true;
  //           notifyListeners();
  //       }
  //     }
  //   } else {
  //     _hasError = true;
  //     notifyListeners();
  //   }
  // }

  // ENTRY FOR CLOUDFIRESTORE
  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['image_url'],
              _provider = snapshot['provider'],
              _gender = snapshot['gender'],
              _dateOfBirth = snapshot['date_of_birth'],
              _countries = snapshot['countries'],
            });
  }

  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "provider": _provider,
      "gender": _gender,
      "date_of_birth": _dateOfBirth,
      "countries": _countries,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    await s.setString('gender', _gender!);
    await s.setString('date_of_birth', dateOfBirth!);
    await s.setString('countries', countries!);
    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _gender = s.getString('gender');
    _dateOfBirth = s.getString('date_of_birth');
    _countries = s.getString('countries');
    notifyListeners();
  }

  Future<void> updateUserData({
    required String name,
    required String gender,
    required String dateOfBirth,
    required String country,
    String? imageUrl,
  }) async {
    try {
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Cập nhật thông tin người dùng trong Firestore
      await userDoc.update({
        'name': name,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'countries': country,
        if (imageUrl != null) 'image_url': imageUrl,
      });

      // Cập nhật thông tin trong SharedPreferences
      final SharedPreferences s = await SharedPreferences.getInstance();
      await s.setString('name', name);
      await s.setString('gender', gender);
      await s.setString('date_of_birth', dateOfBirth);
      await s.setString('countries', country);
      if (imageUrl != null) await s.setString('image_url', imageUrl);

      // Cập nhật state của provider
      _name = name;
      _gender = gender;
      _dateOfBirth = dateOfBirth;
      _countries = country;
      if (imageUrl != null) _imageUrl = imageUrl;

      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  // checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      // ignore: avoid_print
      print("EXISTING USER");
      return true;
    } else {
      // ignore: avoid_print
      print("NEW USER");
      return false;
    }
  }

  // signout
  Future userSignOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // await facebookAuth.logOut();

    _isSignedIn = false;
    notifyListeners();
    // clear all storage information
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }
}
