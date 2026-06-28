import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/auth/screens/login_screen.dart';
import 'package:last_version/core/helpers/cubits/theme_cubit/theme_cubit.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/screens/home_page_screen.dart';
import 'package:last_version/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit(prefs)),
        BlocProvider(create: (context) => NoteCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // void initState() {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state,

          debugShowCheckedModeBanner: false,
          home:
              (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified)
              ? HomePageScreen()
              : LoginScreen(),
        );
      },
    );
  }
}
