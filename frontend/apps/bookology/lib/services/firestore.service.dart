import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirestoreService(this._firestore);

  Future<dynamic> getAccessToken() async {
    try {
      SharedPreferences userPrefs = await SharedPreferences.getInstance();

      final data = await _firestore
          .collection('Secrets')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();

      final userKey = data.data()?['authorizeToken'];
      if (userPrefs.getString('userAccessKey') == null) {
        userPrefs.setString('userAccessKey', userKey);
      }

      return userPrefs.getString('userAccessKey');
    } catch (error) {
      print(error);
      return error;
    }
  }
}
