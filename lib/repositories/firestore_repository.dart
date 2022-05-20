import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/costs_group.dart';

class FirestoreRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot?> groupSnapshot({required String userId}) {
    return _firebaseFirestore.collection('users').doc(userId).collection('groups').snapshots();
  }

  Stream<QuerySnapshot?> costsForPeriodSnapshot({
    required String userId,
    required DateTime startDateTime,
    required DateTime finalDateTime,
  }) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('costs')
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDateTime))
        .where('dateTime', isLessThan: Timestamp.fromDate(finalDateTime))
        .snapshots();
  }

  Future<void> addGroup({required String userId, required CostsGroup group}) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).collection('groups').add(group.toMap());
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<void> deleteGroup({required String userId, required CostsGroup group}) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).collection('groups').doc(group.id).delete();
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
