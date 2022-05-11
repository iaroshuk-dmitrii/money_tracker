import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/business_logic/login_cubit.dart';
import 'package:money_tracker/ui/constants.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/widgets/purple_text_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.costAccounting, (Route<dynamic> route) => false);
        }
        if (state.status == LoginStatus.error) {
          final String errorMessage = state.error;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(errorMessage),
                );
              });
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 47, horizontal: 25),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    // const Expanded(flex: 2, child: SizedBox.expand()),
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
                    const _EmailInput(),
                    const _PasswordInput(),
                    const SizedBox(height: 40),
                    const _LoginButton(),
                    // const Expanded(flex: 7, child: SizedBox.shrink()),
                    const _SwitchSign(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        labelStyle: TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
      ),
      style: const TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        labelText: 'Пароль',
        labelStyle: TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
      ),
      style: const TextStyle(fontSize: 17, fontFamily: 'SanFrancisco'),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      final String buttonTitle = state.loginType == LoginType.login ? 'Войти' : 'Регистрация';
      final bool loading = state.status == LoginStatus.inProgress;
      return PurpleTextButton(
        buttonTitle: buttonTitle,
        onPressed: () {
          state.loginType == LoginType.login ? context.read<LoginCubit>().login() : context.read<LoginCubit>().signUp();
        },
        loading: loading,
      );
    });
  }
}

class _SwitchSign extends StatelessWidget {
  const _SwitchSign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      final String text = state.loginType == LoginType.login ? 'Ещё нет аккаунта? ' : 'Уже есть аккаунт? ';
      final String buttonText = state.loginType == LoginType.login ? 'Регистрация' : 'Войти';
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
          TextButton(
            child: Text(
              buttonText,
              style: const TextStyle(color: kPurpleColor, fontSize: 15),
            ),
            onPressed: () {
              state.loginType == LoginType.login
                  ? context.read<LoginCubit>().switchToSignUp()
                  : context.read<LoginCubit>().switchToLogin();
            },
          ),
        ],
      );
    });
  }
}
