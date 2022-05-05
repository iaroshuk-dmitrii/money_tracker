import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        labelText: 'Пароль',
        labelStyle: TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
      ),
      style: TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
    );
  }
}
