/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:async';

import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/notification.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _apiService = ApiService();
  final User? user = FirebaseAuth.instance.currentUser;

  AuthService(this._firebaseAuth);

  Stream<User?> get onAuthStateChanges => _firebaseAuth.authStateChanges();

  Future<dynamic> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String profilePictureURL,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final result = await _apiService.createUser(
        uuid: _firebaseAuth.currentUser?.uid,
        email: _firebaseAuth.currentUser?.email,
        profilePhotoUrl: profilePictureURL,
        firstName: firstName,
        lastName: lastName,
        authProvider: 'email-password',
      );

      return result;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      final result = await _apiService.createUser(
        uuid: _firebaseAuth.currentUser?.uid,
        email: _firebaseAuth.currentUser?.email,
        profilePhotoUrl: _firebaseAuth.currentUser?.photoURL,
        firstName:
            _firebaseAuth.currentUser?.displayName.toString().split(' ')[0],
        lastName:
            _firebaseAuth.currentUser?.displayName.toString().split(' ')[1],
        authProvider: 'google',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .set(
        {
          'firstName':
              _firebaseAuth.currentUser?.displayName.toString().split(' ')[0],
          'imageUrl': _firebaseAuth.currentUser?.photoURL.toString(),
          'lastName':
              _firebaseAuth.currentUser?.displayName.toString().split(' ')[1],
          'lastSeen': FieldValue.serverTimestamp(),
          'role': 'user',
          'metadata': {'isNewUser': false},
          'secrets': {
            'fcmToken': await NotificationService(FirebaseMessaging.instance)
                .getMessagingToken(),
          },
        },
        SetOptions(
          merge: true,
        ),
      );

      return result;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<bool> sendResetPasswordEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
    return true;
  }

  Future<dynamic> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<dynamic> signOut() async {
    try {
      await _firebaseAuth.signOut();
      //await SecretsManager().removeAllSecrets();
      await PreferencesManager().clearCacheStorage();
      return true;
    } on FirebaseAuthException catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> updateProfile(
      {required String name, required String profilePictureUrl}) async {
    try {
      await _firebaseAuth.currentUser!.updateDisplayName(name);
      await _firebaseAuth.currentUser!.updatePhotoURL(profilePictureUrl);
      return true;
    } on FirebaseAuthException catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  dynamic isEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      if (_firebaseAuth.currentUser?.emailVerified == true) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_firebaseAuth.currentUser?.uid)
            .set(
          {
            'firstName':
                _firebaseAuth.currentUser?.displayName.toString().split(' ')[0],
            'imageUrl': _firebaseAuth.currentUser?.photoURL.toString(),
            'lastName':
                _firebaseAuth.currentUser?.displayName.toString().split(' ')[1],
            'lastSeen': null,
            'role': 'user',
            'metadata': {
              'userName':
                  _firebaseAuth.currentUser?.email.toString().split('@')[0],
              'isVerified': false,
              'isNewUser': true,
            },
            'secrets': {
              'fcmToken': FirebaseMessaging.instance.getToken(),
            },
          },
          SetOptions(
            merge: true,
          ),
        ).then((value) {});
        return true;
      }

      return false;
    } on FirebaseAuthException catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  bool isUserSignedIn() {
    if (_firebaseAuth.currentUser?.uid != null) {
      return true;
    }
    return false;
  }
}
