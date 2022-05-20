import 'package:cloud_firestore/cloud_firestore.dart';

class CostData {
  double cost;
  DateTime dateTime;
  String id;
  String groupId;

  CostData({
    required this.cost,
    required this.dateTime,
    required this.id,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'cost': cost,
      'dateTime': Timestamp.fromDate(dateTime),
      'groupId': groupId,
    };
  }

  factory CostData.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CostData(
      id: snapshot.id,
      cost: data['cost'],
      dateTime: data['dateTime'].toDate(),
      groupId: data['groupId'],
    );
  }

  @override
  String toString() {
    return 'CostData{cost: $cost, dateTime: $dateTime, id: $id}';
  }
}
