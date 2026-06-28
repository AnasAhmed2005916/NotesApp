import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;

  ThemeCubit(this.prefs)
    : super(
        prefs.getBool('isDark') ?? false ? ThemeMode.dark : ThemeMode.light,
      );

  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
      await prefs.setBool('isDark', false);
    } else {
      emit(ThemeMode.dark);
      await prefs.setBool('isDark', true);
    }
  }
}
