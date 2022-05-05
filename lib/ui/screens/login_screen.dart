import 'package:flutter/material.dart';
import 'package:money_tracker/ui/constants.dart';
import 'package:money_tracker/ui/widgets/email_input.dart';
import 'package:money_tracker/ui/widgets/password_input.dart';
import 'package:money_tracker/ui/widgets/purple_text_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerEmail = TextEditingController();
    TextEditingController _controllerPassword = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 47, horizontal: 25),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: [
                const Expanded(flex: 2, child: SizedBox.shrink()),
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 13),
                const Text(
                  'Учёт расходов',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'SanFrancisco',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ваша история расходов',
                  style: TextStyle(fontSize: 15, fontFamily: 'SanFrancisco'),
                ),
                const Text(
                  'всегда под рукой',
                  style: TextStyle(fontSize: 15, fontFamily: 'SanFrancisco'),
                ),
                const SizedBox(height: 40),
                EmailInput(controller: _controllerEmail),
                PasswordInput(controller: _controllerPassword),
                const SizedBox(height: 40),
                _LoginButton(controllerEmail: _controllerEmail, controllerPassword: _controllerPassword),
                const Expanded(flex: 7, child: SizedBox.shrink()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ещё нет аккаунта? ',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      child: const Text(
                        'Регистрация',
                        style: TextStyle(color: kPurpleColor, fontSize: 15),
                      ),
                      onPressed: () {}, //TODO
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
    required TextEditingController controllerEmail,
    required TextEditingController controllerPassword,
  })  : _controllerEmail = controllerEmail,
        _controllerPassword = controllerPassword,
        super(key: key);

  final TextEditingController _controllerEmail;
  final TextEditingController _controllerPassword;

  @override
  Widget build(BuildContext context) {
    return PurpleTextButton(
      buttonTitle: 'Войти',
      onPressed: () {}, //TODO
    );
  }
}
