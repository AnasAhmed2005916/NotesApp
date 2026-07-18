import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/core/dependency_injuction/dependency_injuction.dart';
import 'package:last_version/core/helpers/cubits/theme_cubit/theme_cubit.dart';
import 'package:last_version/core/helpers/storage_helper.dart';
import 'package:last_version/core/services/notification_service.dart';
import 'package:last_version/features/auth/screens/login_screen.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/screens/home_page_screen.dart';
import 'package:last_version/features/onboarding/screens/on_boarding_screen.dart';
import 'package:last_version/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isOnBoardingFinished = await StorageHelper.isOnBoardingFinished();
  setupGetIt();
  await getIt<NotificationService>().init();
  runApp(
    EasyLocalization(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit(prefs)),
          BlocProvider(create: (context) => getIt<NoteCubit>()),
        ],
        child: MyApp(isOnBoardingFinished: isOnBoardingFinished),
      ),
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnBoardingFinished;
  const MyApp({super.key, required this.isOnBoardingFinished});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          debugShowCheckedModeBanner: false,
          home: !isOnBoardingFinished
              ? const OnBoardingScreen()
              : (FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified)
              ? const HomePageScreen()
              : LoginScreen(),
        );
      },
    );
  }
}
