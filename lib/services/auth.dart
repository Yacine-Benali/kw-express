import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class AuthUser {
  const AuthUser({
    @required this.uid,
    @required this.phoneNumber,
  });

  final String uid;
  final String phoneNumber;
}

abstract class Auth {
  Future<AuthUser> currentUser();

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    void Function(FirebaseAuthException) onVerificationFailed,
    void Function(String, [int]) onCodeSent,
  );
  Future<void> signInWithPhoneNumber(
    String verificationId,
    String smsCode,
  );

  Future<void> signOut();
  Stream<AuthUser> get onAuthStateChanged;
  void dispose();
}
