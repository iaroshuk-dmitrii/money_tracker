import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_tracker/models/costs_data.dart';

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
      final WriteBatch batch = _firebaseFirestore.batch();
      var groupReference = _firebaseFirestore.collection('users').doc(userId).collection('groups').doc(group.id);
      batch.delete(groupReference);
      var collection =
          _firebaseFirestore.collection('users').doc(userId).collection('costs').where('groupId', isEqualTo: group.id);
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<void> addCost({required String userId, required CostData costData}) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).collection('costs').add(costData.toMap());
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<void> deleteCost({required String userId, required CostData costData}) async {
    try {
      await _firebaseFirestore.collection('users').doc(userId).collection('costs').doc(costData.id).delete();
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
