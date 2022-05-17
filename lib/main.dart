import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/business_logic/auth_bloc.dart';
import 'package:money_tracker/business_logic/image_picker_bloc.dart';
import 'package:money_tracker/business_logic/login_cubit.dart';
import 'package:money_tracker/business_logic/main_tabs_bloc.dart';
import 'package:money_tracker/business_logic/profile_bloc.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/storage_repository.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mainNavigation = MainNavigation();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (BuildContext context) => AuthRepository()),
        RepositoryProvider(create: (BuildContext context) => StorageRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider<LoginCubit>(create: (context) => LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider<MainTabsBloc>(create: (context) => MainTabsBloc()),
          BlocProvider<ImagePickerBloc>(create: (context) => ImagePickerBloc()),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
                authRepository: context.read<AuthRepository>(), storageRepository: context.read<StorageRepository>()),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          initialRoute: mainNavigation.initialRoute,
          routes: mainNavigation.routes,
          onGenerateRoute: mainNavigation.onGenerateRoute,
        ),
      ),
    );
  }
}
