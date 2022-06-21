import 'package:flutter/material.dart';
import 'package:money_tracker/ui/widgets/purple_text_button.dart';
import 'package:money_tracker/ui/widgets/white_text_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget? title;
  final void Function()? onConfirm;

  const CustomAlertDialog({
    Key? key,
    this.title,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      actions: <Widget>[
        Column(
          children: [
            PurpleTextButton(
              buttonTitle: 'Подтвердить',
              onPressed: onConfirm,
            ),
            WhiteTextButton(
              buttonTitle: 'Отмена',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      titlePadding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 10.0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 25.0),
    );
  }
}
