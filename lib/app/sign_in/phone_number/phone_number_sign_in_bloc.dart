import 'package:firebase_auth/firebase_auth.dart';
import 'package:kwexpress/app/sign_in/validator.dart';
import 'package:kwexpress/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

enum SignInFormType { input, confirmation }

class PhoneNumberSignInBloc with PhoneNumberValidators {
  PhoneNumberSignInBloc({
    @required this.auth,
  });
  final Auth auth;
  String _verificationId;
  BehaviorSubject<bool> isSmsSentController = BehaviorSubject<bool>();
  Stream<bool> get smsSentStream => isSmsSentController.stream;

  Future<void> submitPhoneNumber(String phoneNumber) async {
    try {
      phoneNumber = '+213' + phoneNumber.substring(1);
      await auth.verifyPhoneNumber(
        phoneNumber,
        _onVerificationFailed,
        _onCodeSent,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _onVerificationFailed(FirebaseAuthException e) => throw e;

  void _onCodeSent(String verificationId, [int forceResendingToken]) {
    this._verificationId = verificationId;
    print('oncodesent called');
    if (!isSmsSentController.isClosed) {
      print('sinking...');
      isSmsSentController.sink.add(true);
    }
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
    isSmsSentController.close();
  }
}
