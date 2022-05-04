import 'package:flutter/material.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mainNavigation = MainNavigation();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      initialRoute: mainNavigation.initialRoute,
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
