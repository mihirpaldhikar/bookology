import 'dart:async';

import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/notification.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final apiService = ApiService();
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
      final result = await apiService.createUser(
        uuid: _firebaseAuth.currentUser?.uid,
        email: _firebaseAuth.currentUser?.email,
        password: '',
        profilePhotoUrl: profilePictureURL,
        firstName: firstName,
        lastName: lastName,
        authProvider: 'email-password',
      );

      return result;
    } on FirebaseAuthException catch (error) {
      print(error.message);
      return error.message;
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
      final result = await apiService.createUser(
        uuid: _firebaseAuth.currentUser?.uid,
        email: _firebaseAuth.currentUser?.email,
        password: '',
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
          'lastSeen': null,
          'role': types.Role.user.toShortString(),
          'metadata': {
            'userName':
                _firebaseAuth.currentUser?.email.toString().split('@')[0],
            'isVerified': false,
          },
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
    } on FirebaseAuthException catch (error) {
      print(error);
      return error;
    }
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
    } on FirebaseAuthException catch (error) {
      print(error.message);
      return error.message;
    }
  }

  Future<dynamic> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await CacheService().clearCacheStorage();
      return true;
    } on FirebaseAuthException catch (error) {
      return error;
    }
  }

  dynamic isEmailVerified() {
    try {
      _firebaseAuth.currentUser?.reload();
      if (_firebaseAuth.currentUser?.emailVerified == true) {
        FirebaseFirestore.instance
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
            'role': types.Role.user.toShortString(),
            'metadata': {
              'userName':
                  _firebaseAuth.currentUser?.email.toString().split('@')[0],
              'isVerified': false,
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
    } catch (error) {
      print(error);
      return error;
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
