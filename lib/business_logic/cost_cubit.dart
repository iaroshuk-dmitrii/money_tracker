import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/models/costs_data.dart';

class CostCubit extends Cubit<CostState> {
  CostCubit()
      : super(CostState(
          id: '',
          cost: 0.0,
          dateTime: DateTime.now(),
          status: CostStatus.initial,
          error: '',
        ));

  void costChanged(String value) {
    print('costChanged $value');
    emit(state.copyWith(cost: double.tryParse(value.replaceAll(',', '.')), status: CostStatus.initial));
  }

  void dateChanged(DateTime value) {
    print('dateChanged $value');
    emit(state.copyWith(dateTime: value, status: CostStatus.initial));
  }

  void resetState() {
    print('resetState');
    emit(state.copyWith(
      id: '',
      cost: 0.0,
      dateTime: DateTime.now(),
      status: CostStatus.initial,
      error: '',
    ));
  }

  Future<void> createCost() async {
    print('createCost');
    emit(state.copyWith(status: CostStatus.inProgress));
    try {
      //TODO
      CostData costData = CostData(id: state.id, cost: state.cost, dateTime: state.dateTime);
      print(costData.toString());
      emit(state.copyWith(status: CostStatus.success, costData: costData));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: CostStatus.error, error: e.toString()));
    }
  }

  Future<void> deleteCost(CostData costData) async {
    print('deleteCost');
    emit(state.copyWith(status: CostStatus.inProgress));
    try {
      //TODO
      emit(state.copyWith(status: CostStatus.success));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: CostStatus.error, error: e.toString()));
    }
  }
}

//------------------------------
enum CostStatus { initial, inProgress, success, error }

//------------------------------
class CostState {
  final String id;
  final double cost;
  final DateTime dateTime;
  final CostStatus status;
  final String error;
  final CostData? costData;

  const CostState({
    required this.id,
    required this.cost,
    required this.dateTime,
    required this.status,
    required this.error,
    this.costData,
  });

  CostState copyWith({
    String? id,
    double? cost,
    DateTime? dateTime,
    CostStatus? status,
    String? error,
    CostData? costData,
  }) {
    return CostState(
      id: id ?? this.id,
      cost: cost ?? this.cost,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      error: error ?? this.error,
      costData: costData ?? this.costData,
    );
  }
}
