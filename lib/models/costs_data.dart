class CostData {
  double cost;
  DateTime dateTime;
  String id;

  CostData({required this.cost, required this.dateTime, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'cost': cost,
      'dateTime': dateTime,
    };
  }

  @override
  String toString() {
    return 'CostData{cost: $cost, dateTime: $dateTime, id: $id}';
  }
}
