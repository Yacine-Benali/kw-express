import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kwexpress/app/sign_in/validator.dart';
import 'package:kwexpress/services/auth.dart';

enum SignInFormType { input, confirmation }

class PhoneNumberSignInBloc with PhoneNumberValidators {
  PhoneNumberSignInBloc({
    @required this.auth,
  });
  final Auth auth;
  String _verificationId;
  StreamController<bool> controller;

  Future<void> submitPhoneNumber(
      String phoneNumber, StreamController<bool> controller2) async {
    // if (this.controller == null) print('no controller has been set');
    this.controller = controller2;
    try {
      phoneNumber = '+213' + phoneNumber.substring(1);
      await auth.verifyPhoneNumber(
        phoneNumber,
        _onVerificationFailed,
        onCodeSent,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _onVerificationFailed(FirebaseAuthException e) => throw e;

  void onCodeSent(String verificationId, [int forceResendingToken]) async {
    this._verificationId = verificationId;
    print('oncodeSent');
    controller.add(true);
  }

  Future<void> submitSmsCode(String smsCode) async {
    try {
      await auth.signInWithPhoneNumber(this._verificationId, smsCode);
    } catch (e) {
      rethrow;
    }
  }

  String validatePhoneNumber(String phoneNuber) {
    if (!phoneNumberSubmitValidator.isValid(phoneNuber)) {
      return 'please enter valid phone number';
    }
    return null;
  }

  void dispose() {
    // print('bloc stream diposed called');
  }
}
