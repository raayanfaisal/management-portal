import 'package:firebase_auth/firebase_auth.dart';

import '../building_blocks/application_service.dart';

class AuthenticationService implements ApplicationService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<UserAuthCredential> createAccountWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserAuthCredential(
        userCredential.user!.uid,
        userCredential.user!.email!,
        userCredential.user!.emailVerified,
        userCredential.user!.getIdToken,
      );
    } on FirebaseAuthException catch (err) {
      throw AuthException._fromFirebaseError(err);
    }
  }

  Future<UserAuthCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserAuthCredential(
        userCredential.user!.uid,
        userCredential.user!.email!,
        userCredential.user!.emailVerified,
        userCredential.user!.getIdToken,
      );
    } on FirebaseAuthException catch (err) {
      throw AuthException._fromFirebaseError(err);
    }
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .catchError((err) => throw AuthException._fromFirebaseError(err));
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  UserAuthCredential? get currentUser {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      return UserAuthCredential(
        currentUser.uid,
        currentUser.email!,
        currentUser.emailVerified,
        currentUser.getIdToken,
      );
    }
  }

  Stream<bool> get userIsAuthenticated {
    return _firebaseAuth.userChanges().map((user) => user != null);
  }
}

class AuthException implements Exception {
  final String message;

  AuthException._fromFirebaseError(FirebaseAuthException error)
      : message = _parseMessage(error);

  static String _parseMessage(FirebaseAuthException error) {
    switch (error.code) {
      case r'user-not-found':
        return 'No user exists for the given email address';
      case r'wrong-password':
        return 'Password is wrong';
      case r'email-already-in-use':
        return 'There already exists a user for the given email address';
      default:
        return 'Something went wrong';
    }
  }
}

class UserAuthCredential {
  final String id;
  final String email;
  final bool isEmailVerified;
  final Future<String> Function([bool forceRefresh]) getIdToken;

  UserAuthCredential(
    this.id,
    this.email,
    this.isEmailVerified,
    this.getIdToken,
  );
}
