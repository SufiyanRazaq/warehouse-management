import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Splash.dart';
import 'BranchSelectionScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedBranch = prefs.getString('selectedBranch');

  runApp(MyApp(
      initialScreen:
          selectedBranch == null ? BranchSelectionScreen() : SplashScreen()));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: initialScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
