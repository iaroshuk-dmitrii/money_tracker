import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_tracker/models/costs_data.dart';

class CostsGroup {
  String? id;
  String name;
  late double totalCosts;
  int color;
  List<CostData> costs;

  CostsGroup({
    this.id,
    required this.name,
    required this.color,
    required this.costs,
  }) : totalCosts = getTotalCosts(costs);

  static double getTotalCosts(List<CostData> costs) {
    double totalCosts = 0.0;
    for (var element in costs) {
      totalCosts += element.cost;
    }
    return totalCosts;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color,
    };
  }

  factory CostsGroup.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CostsGroup(
      id: snapshot.id,
      name: data['name'],
      color: data['color'],
      costs: [],
    );
  }

  @override
  String toString() {
    return 'CostsGroup{name: $name, totalCosts: $totalCosts, color: $color, costs: $costs}';
  }
}
