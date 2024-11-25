import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart'
    as another_splash;
import 'package:wallpaper_app/home/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return another_splash.FlutterSplashScreen.fadeIn(
      duration: const Duration(seconds: 2),
      childWidget: SizedBox(
        height: 150,
        width: 150,
        child: Image.asset("assets/logo_coloured.png"),
      ),
      nextScreen: const HomeScreen(),
    );
  }
}
