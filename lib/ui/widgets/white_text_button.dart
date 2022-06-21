import 'package:flutter/material.dart';
import 'package:money_tracker/ui/constants.dart';

class WhiteTextButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onPressed;
  final bool loading;

  const WhiteTextButton({Key? key, required this.buttonTitle, this.onPressed, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.zero,
        primary: Colors.red,
        backgroundColor: loading ? kLightGray : null,
        alignment: Alignment.center,
        fixedSize: const Size(double.infinity, 50.0),
      ),
      onPressed: onPressed,
      child: Center(
        child: loading ? const CircularProgressIndicator(color: Colors.white) : Text(buttonTitle),
      ),
    );
  }
}
