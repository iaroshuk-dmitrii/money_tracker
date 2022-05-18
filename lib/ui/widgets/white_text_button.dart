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
      child: Center(
        child: loading ? const CircularProgressIndicator(color: Colors.white) : Text(buttonTitle),
      ),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 50.0)),
        backgroundColor:
            loading ? MaterialStateProperty.all<Color>(kLightGray) : MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
      ),
      onPressed: onPressed,
    );
  }
}
