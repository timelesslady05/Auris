import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Update user profile data
  Future<void> updateUserData({
    required String name,
    required String ageRange,
    required String language,
  }) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'ageRange': ageRange,
      'language': language,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Save vocabulary board
  Future<void> saveVocabulary(Map<String, dynamic> vocabulary) async {
    return await usersCollection.doc(uid).update({
      'vocabulary': vocabulary,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Get user profile stream
  Stream<DocumentSnapshot> get userData {
    return usersCollection.doc(uid).snapshots();
  }

  // Get user profile once
  Future<DocumentSnapshot> getUserDoc() async {
    return await usersCollection.doc(uid).get();
  }
}
