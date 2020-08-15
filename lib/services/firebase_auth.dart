import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kwexpress/services/auth.dart';

class FirebaseAuthService implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<List<String>> fetchSignInMethodsForEmail({String email}) =>
      _firebaseAuth.fetchSignInMethodsForEmail(email: email);

  AuthUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Stream<AuthUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future verifyPhoneNumber(
    String mobile,
    void Function(AuthException) onVerificationFailed,
    void Function(String, [int]) onCodeSent,
  ) async {
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) =>
          _onVerificationCompleted(authCredential),
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, [int forceResendingToken]) =>
          onCodeSent(verificationId, forceResendingToken),
      codeAutoRetrievalTimeout: null,
    );
  }

  @override
  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    await _firebaseAuth.signInWithCredential(authCredential);
  }

  _onVerificationCompleted(AuthCredential authCredential) async {
    await _firebaseAuth.signInWithCredential(authCredential);
  }

  @override
  Future<AuthUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
