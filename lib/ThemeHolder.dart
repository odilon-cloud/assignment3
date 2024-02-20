

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeHolder{

  static final ThemeHolder instance = ThemeHolder.internal();

  StreamController<bool> controller = StreamController.broadcast();

  factory ThemeHolder() => instance;

  ThemeHolder.internal();

  bool?  isDarkTheme;

  bool get getTheme => isDarkTheme ?? false;
  Stream<bool> getThemeBroadcast() => controller.stream;

  void changeState(bool state) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', state);
    isDarkTheme = state;
    controller.add(getTheme);
  }

}