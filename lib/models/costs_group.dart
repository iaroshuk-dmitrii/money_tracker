import 'package:money_tracker/models/costs_data.dart';

class CostsGroup {
  String name;
  late double totalCosts;
  int color;
  List<CostData> costs;

  CostsGroup({
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
      'totalCosts': totalCosts,
    };
  }

  @override
  String toString() {
    return 'CostsGroup{name: $name, totalCosts: $totalCosts, color: $color, costs: $costs}';
  }
}
