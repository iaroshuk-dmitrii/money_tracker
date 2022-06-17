import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_tracker/ui/screens/cost_data_screen.dart';
import 'package:money_tracker/ui/screens/loader_screen.dart';
import 'package:money_tracker/ui/screens/login_screen.dart';
import 'package:money_tracker/ui/screens/main_tabs_screen.dart';

abstract class Screens {
  static const loader = '/LoaderScreen';
  static const login = '/LoginScreen';
  static const mainTabs = '/MainTabsScreen';
  static const costData = '/CostDataScreen';
  static const test = '/TestScreen';
}

class MainNavigation {
  final initialRoute = Screens.loader;

  final routes = <String, Widget Function(BuildContext)>{
    Screens.loader: (context) {
      log('Create LoaderScreen');
      return const LoaderScreen();
    },
    Screens.login: (context) {
      log('Create LoginScreen');
      return const LoginScreen();
    },
    Screens.mainTabs: (context) {
      log('Create MainTabsScreen');
      return const MainTabsScreen();
    },
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Screens.costData:
        final groupId = settings.arguments as String;
        return _customAnimateRoute(CostDataScreen(groupId: groupId), settings: settings);
      default:
        return MaterialPageRoute(builder: (context) => const Text('Navigation Error!!'));
    }
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
