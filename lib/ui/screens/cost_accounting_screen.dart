import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/business_logic/cost_cubit.dart';
import 'package:money_tracker/business_logic/firestore_bloc.dart';
import 'package:money_tracker/business_logic/group_cubit.dart';
import 'package:money_tracker/models/costs_group.dart';
import 'package:money_tracker/ui/constants.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/widgets/cost_accounting_list_title.dart';
import 'package:money_tracker/ui/widgets/custom_alert_dialog.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CostAccountingScreen extends StatelessWidget {
  const CostAccountingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _monthPickerAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(
            flex: 2,
            child: _PieChartDiagram(),
          ),
          Expanded(
            flex: 3,
            child: _CostsGroupsList(),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget _monthPickerAppBar(BuildContext context) {
  return AppBar(
      centerTitle: true,
      title: TextButton(
        child: BlocBuilder<FirestoreBloc, FirestoreState>(builder: (context, state) {
          return Text(
            '${StringUtils.capitalize(DateFormat('MMMM').format(state.month))} ${DateFormat('yyyy').format(state.month)}',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          );
        }),
        onPressed: () async {
          DateTime? pickedMonth = await _selectMonth(context);
          if (pickedMonth != null) {
            BlocProvider.of<FirestoreBloc>(context).add(MonthChangedEvent(pickedMonth));
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _createCostsGroupDialog(context);
          },
        )
      ]);
}

Future<DateTime?> _selectMonth(BuildContext context) async {
  final DateTime? pickedData = await showMonthPicker(
    context: context,
    firstDate: DateTime(2001),
    lastDate: DateTime(2101),
    initialDate: DateTime.now(),
    locale: Locale(Intl.getCurrentLocale()),
  );
  return pickedData;
}

class _PieChartDiagram extends StatelessWidget {
  const _PieChartDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirestoreBloc, FirestoreState>(builder: (context, state) {
      List<CostsGroup> notEmptyCostsGroups = [];
      for (CostsGroup costsGroup in state.costsGroups) {
        if (costsGroup.totalCosts != 0) {
          notEmptyCostsGroups.add(costsGroup);
        }
      }
      return ColoredBox(
        color: kLightGray,
        child: Center(
          child: notEmptyCostsGroups.isNotEmpty
              ? SfCircularChart(
                  series: [
                    DoughnutSeries<CostsGroup, String>(
                        dataSource: notEmptyCostsGroups,
                        xValueMapper: (CostsGroup data, _) => data.name,
                        yValueMapper: (CostsGroup data, _) => data.totalCosts,
                        dataLabelMapper: (CostsGroup data, _) => data.name,
                        pointColorMapper: (CostsGroup data, _) => Color(0XFF000000 + data.color),
                        dataLabelSettings: const DataLabelSettings(isVisible: true))
                  ],
                )
              : Text('За ${DateFormat('MMMM').format(state.month)} нет расходов'),
        ),
      );
    });
  }
}

Future<dynamic> _createCostsGroupDialog(BuildContext context) async {
  context.read<GroupCubit>().resetState();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocListener<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state.status == GroupStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == GroupStatus.error) {
            Navigator.of(context).pop(); //TODO
          }
        },
        child: CustomAlertDialog(
          title: Column(
            children: [
              const Text('Добавить категорию'),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Название'),
                onChanged: (value) => context.read<GroupCubit>().nameChanged(value),
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  labelText: 'Цвет',
                  suffixIcon: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
                    return Icon(
                      Icons.palette_outlined,
                      color: Color(0xFF000000 + state.intColor),
                      size: 30,
                    );
                  }),
                ),
                onChanged: (value) => context.read<GroupCubit>().colorChanged(value),
                maxLength: 6,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-fA-F]")),
                ],
              )
            ],
          ),
          onConfirm: () => context.read<GroupCubit>().createGroup(),
        ),
      );
    },
  );
}

Future<dynamic> _deleteCostGroupDialog({required BuildContext context, required CostsGroup costsGroup}) async {
  context.read<GroupCubit>().resetState();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocListener<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state.status == GroupStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == GroupStatus.error) {
            Navigator.of(context).pop(); //TODO
          }
        },
        child: CustomAlertDialog(
          title: Center(
            child: RichText(
              text: TextSpan(
                text: 'Удалить категорию ',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: costsGroup.name, style: kPurpleTextStyle),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
          ),
          onConfirm: () => context.read<GroupCubit>().deleteGroup(costsGroup),
        ),
      );
    },
  );
}

class _CostsGroupsList extends StatelessWidget {
  const _CostsGroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: BlocBuilder<FirestoreBloc, FirestoreState>(builder: (context, state) {
        return ListView.builder(
          itemCount: state.costsGroups.length,
          itemBuilder: (context, index) => CAListTitle(
            title: state.costsGroups[index].name,
            subtitle: state.costsGroups[index].totalCosts != 0.0
                ? 'Всего: ${state.costsGroups[index].totalCosts}'
                : 'Добавить расход',
            iconColor: Color(0xFF000000 + state.costsGroups[index].color),
            onTap: () {
              _createCostsDialog(context: context, costsGroup: state.costsGroups[index]);
            },
            onLongPress: () {
              _deleteCostGroupDialog(context: context, costsGroup: state.costsGroups[index]);
            },
            onIconTap: () {
              Navigator.of(context).pushNamed(Screens.costData, arguments: state.costsGroups[index].id);
            },
          ),
        );
      }),
    );
  }
}

Future<dynamic> _createCostsDialog({required BuildContext context, required CostsGroup costsGroup}) async {
  context.read<CostCubit>().resetState();
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
          title: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Добавить расход'),
                  TextButton(
                    onPressed: () async {
                      DateTime? newData = await selectDate(context);
                      if (newData != null) {
                        context.read<CostCubit>().dateChanged(newData);
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                      alignment: Alignment.bottomRight,
                    ),
                    child: BlocBuilder<CostCubit, CostState>(builder: (context, state) {
                      return Text(
                        DateFormat('dd MMM yyyy').format(state.dateTime),
                        style: const TextStyle(fontSize: 10.0),
                      );
                    }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  autofocus: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    isDense: true,
                    labelText: 'Введите сумму',
                    labelStyle: TextStyle(color: kPurpleColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPurpleColor),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        gapPadding: 1.0),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9.,]")),
                  ],
                  onChanged: (value) => context.read<CostCubit>().costChanged(value),
                ),
              ),
            ],
          ),
          onConfirm: () => context.read<CostCubit>().createCost(groupId: costsGroup.id!),
        ),
      );
    },
  );
}

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? pickedData = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    initialEntryMode: DatePickerEntryMode.input,
    firstDate: DateTime(2001),
    lastDate: DateTime(2101),
    locale: Locale(Intl.getCurrentLocale()),
  );
  return pickedData;
}
