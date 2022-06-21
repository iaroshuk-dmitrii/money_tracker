import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/business_logic/cost_cubit.dart';
import 'package:money_tracker/business_logic/firestore_bloc.dart';
import 'package:money_tracker/models/costs_data.dart';
import 'package:money_tracker/models/costs_group.dart';
import 'package:money_tracker/ui/widgets/cost_accounting_list_title.dart';
import 'package:money_tracker/ui/widgets/custom_alert_dialog.dart';
import 'package:money_tracker/utils/text_color_for_background.dart';

class CostDataScreen extends StatelessWidget {
  final String groupId;

  const CostDataScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreBloc, FirestoreState>(builder: (context, state) {
      final CostsGroup costsGroup = state.costsGroups.firstWhere((element) => element.id == groupId);
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            costsGroup.name,
            style: TextStyle(color: getTextColorForBackground(Color(0XFF000000 + costsGroup.color))),
          ),
          backgroundColor: Color(0XFF000000 + costsGroup.color),
        ),
        body: ListView.builder(
          itemCount: costsGroup.costs.length,
          itemBuilder: (context, index) => CAListTitle(
            title: costsGroup.costs[index].cost.toString(),
            subtitle: DateFormat().format(costsGroup.costs[index].dateTime),
            showIcon: false,
            onLongPress: () => _deleteCostDialog(context: context, costData: costsGroup.costs[index]),
          ),
        ),
      );
    });
  }
}

Future<dynamic> _deleteCostDialog({required BuildContext context, required CostData costData}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocListener<CostCubit, CostState>(
        listener: (context, state) {
          if (state.status == CostStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == CostStatus.error) {
            Navigator.of(context).pop(); //TODO
          }
        },
        child: CustomAlertDialog(
          title: const Center(child: Text('Удалить данные о расходе?')),
          onConfirm: () => context.read<CostCubit>().deleteCost(costData),
        ),
      );
    },
  );
}
