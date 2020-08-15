import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class AuthUser {
  const AuthUser({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

abstract class Auth {
  Future<AuthUser> currentUser();

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    void Function(AuthException) onVerificationFailed,
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
