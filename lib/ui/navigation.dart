import 'package:flutter/material.dart';
import 'package:money_tracker/ui/screens/loader_screen.dart';
import 'package:money_tracker/ui/screens/login_screen.dart';
import 'package:money_tracker/ui/screens/profile_screen.dart';
import 'package:money_tracker/ui/screens/test_screen.dart';

abstract class Screens {
  static const loader = '/LoaderScreen';
  static const login = '/LoginScreen';
  static const profile = '/ProfileScreen';
  static const costAccounting = '/CostAccountingScreen';
  static const test = '/TestScreen';
}

class MainNavigation {
  final initialRoute = Screens.loader;

  final routes = <String, Widget Function(BuildContext)>{
    Screens.loader: (context) {
      print('Create LoaderScreen');
      return const LoaderScreen();
    },
    Screens.login: (context) {
      print('Create LoginScreen');
      return const LoginScreen();
    },
    Screens.profile: (context) {
      print('Create ProfileScreen');
      return const ProfileScreen();
    },
    Screens.costAccounting: (context) {
      print('Create CostAccountingScreen');
      return const ProfileScreen();
    },
    Screens.test: (context) {
      print('Create TestScreen');
      return const TestScreen();
    },
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const Text('Navigation Error!!'));
  }

  // Route<Object> _customAnimateRoute(Widget page, {RouteSettings? settings}) => PageRouteBuilder(
  //       settings: settings,
  //       pageBuilder: (
  //         BuildContext context,
  //         Animation<double> animation,
  //         Animation<double> secondaryAnimation,
  //       ) =>
  //           page,
  //       transitionDuration: const Duration(milliseconds: 500),
  //       reverseTransitionDuration: const Duration(milliseconds: 500),
  //       transitionsBuilder: (
  //         BuildContext context,
  //         Animation<double> animation,
  //         Animation<double> secondaryAnimation,
  //         Widget child,
  //       ) =>
  //           FadeTransition(opacity: animation, child: child),
  //     );
}
