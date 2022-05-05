import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        labelStyle: TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
      ),
      style: TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
    );
  }
}
