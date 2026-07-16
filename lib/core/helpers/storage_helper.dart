import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String onBoardingKey = 'onBoardingFinished';
  static Future<void> saveOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onBoardingKey, true);
  }

  static Future<bool> isOnBoardingFinished() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(onBoardingKey) ?? false;
  }
}
