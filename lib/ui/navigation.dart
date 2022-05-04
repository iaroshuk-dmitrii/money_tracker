import 'package:flutter/material.dart';
import 'package:money_tracker/ui/screens/login_screen.dart';
import 'package:money_tracker/ui/screens/profile_screen.dart';
import 'package:money_tracker/ui/screens/sign_up_screen.dart';
import 'package:money_tracker/ui/screens/test_screen.dart';

abstract class Screens {
  static const login = '/LoginScreen';
  static const signUp = '/SignUpScreen';
  static const profile = '/ProfileScreen';
  static const test = '/TestScreen';
}

class MainNavigation {
  final initialRoute = Screens.test;

  final routes = <String, Widget Function(BuildContext)>{
    Screens.login: (context) => const LoginScreen(),
    Screens.signUp: (context) => const SignUpScreen(),
    Screens.profile: (context) => const ProfileScreen(),
    Screens.test: (context) => const TestScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const Text('Navigation Error!!'));
  }

  Route<Object> _customAnimateRoute(Widget page, {RouteSettings? settings}) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            page,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) =>
            FadeTransition(opacity: animation, child: child),
      );
}
