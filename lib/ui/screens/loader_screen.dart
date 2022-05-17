import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/business_logic/auth_bloc.dart';
import 'package:money_tracker/ui/navigation.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.mainTabs, (Route<dynamic> route) => false);
        }
        if (state is AuthUnauthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.login, (Route<dynamic> route) => false);
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
