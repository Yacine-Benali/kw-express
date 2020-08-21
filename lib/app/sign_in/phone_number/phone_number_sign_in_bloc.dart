import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwexpress/app/sign_in/validator.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:flutter/foundation.dart';

enum SignInFormType { input, confirmation }

class PhoneNumberSignInBloc with PhoneNumberValidators {
  PhoneNumberSignInBloc({
    @required this.auth,
  });
  final Auth auth;
  String _verificationId;

  Future<bool> submitPhoneNumber(String phoneNumber) async {
    try {
      phoneNumber = '+213' + phoneNumber.substring(1);
      await auth.verifyPhoneNumber(
        phoneNumber,
        _onVerificationFailed,
        _onCodeSent,
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  void _onVerificationFailed(AuthException e) => throw e;

  void _onCodeSent(String verificationId, [int forceResendingToken]) =>
      this._verificationId = verificationId;

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
}
