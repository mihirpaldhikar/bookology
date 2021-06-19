import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirestoreService(this._firestore);

  Future<dynamic> getAccessToken() async {
    try {
      final data = await _firestore
          .collection('Secrets')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();

      return data.data()?['authorizeToken'];
    } catch (error) {
      print(error);
      return error;
    }
  }
}
