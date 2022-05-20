import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/business_logic/auth_bloc.dart';
import 'package:money_tracker/business_logic/cost_cubit.dart';
import 'package:money_tracker/business_logic/firestore_bloc.dart';
import 'package:money_tracker/business_logic/group_cubit.dart';
import 'package:money_tracker/business_logic/image_picker_bloc.dart';
import 'package:money_tracker/business_logic/login_cubit.dart';
import 'package:money_tracker/business_logic/main_tabs_bloc.dart';
import 'package:money_tracker/business_logic/profile_bloc.dart';
import 'package:money_tracker/repositories/auth_repository.dart';
import 'package:money_tracker/repositories/firestore_repository.dart';
import 'package:money_tracker/repositories/storage_repository.dart';
import 'package:money_tracker/ui/navigation.dart';
import 'package:money_tracker/ui/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    Intl.defaultLocale = 'ru';
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (BuildContext context) => AuthRepository()),
        RepositoryProvider(create: (BuildContext context) => StorageRepository()),
        RepositoryProvider(create: (BuildContext context) => FirestoreRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider<LoginCubit>(create: (context) => LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider<MainTabsBloc>(create: (context) => MainTabsBloc()),
          BlocProvider<ImagePickerBloc>(create: (context) => ImagePickerBloc()),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authRepository: context.read<AuthRepository>(),
              storageRepository: context.read<StorageRepository>(),
            ),
            lazy: false,
          ),
          BlocProvider<GroupCubit>(
              create: (context) => GroupCubit(
                  authRepository: context.read<AuthRepository>(),
                  firestoreRepository: context.read<FirestoreRepository>())),
          BlocProvider<CostCubit>(create: (context) => CostCubit()),
          BlocProvider<FirestoreBloc>(
            create: (context) => FirestoreBloc(
                authRepository: context.read<AuthRepository>(),
                firestoreRepository: context.read<FirestoreRepository>()),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          initialRoute: mainNavigation.initialRoute,
          routes: mainNavigation.routes,
          onGenerateRoute: mainNavigation.onGenerateRoute,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
