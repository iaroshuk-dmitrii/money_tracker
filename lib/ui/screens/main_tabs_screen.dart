import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/business_logic/auth_bloc.dart';
import 'package:money_tracker/business_logic/main_tabs_bloc.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/screens/cost_accounting_screen.dart';
import 'package:money_tracker/ui/screens/profile_screen.dart';

class MainTabsScreen extends StatelessWidget {
  const MainTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = context.select((MainTabsBloc bloc) => bloc.state);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.login, (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: const [
            CostAccountingScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              label: "Рсходы",
              icon: Icon(Icons.credit_card),
              tooltip: "Рсходы",
            ),
            BottomNavigationBarItem(
              label: "Профиль",
              icon: Icon(Icons.person),
              tooltip: "Профиль",
            ),
          ],
          onTap: (index) {
            context.read<MainTabsBloc>().add(ChangeTabEvent(index));
          },
        ),
      ),
    );
  }
}
