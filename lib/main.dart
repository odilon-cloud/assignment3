import 'package:assignment3/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyHomePage.dart';
import 'ThemeHolder.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Future<bool> isDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
  ThemeHolder().isDarkTheme = await isDarkMode();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isDarkMode(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter App',
            debugShowCheckedModeBanner: false,
            theme: snapshot.data! ? ThemeData.dark() : ThemeData.light(),
            home: LoginPage(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<bool> _isDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}
