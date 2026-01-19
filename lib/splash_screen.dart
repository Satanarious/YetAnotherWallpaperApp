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
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("assets/logo.gif"),
          ),
          const Text(
            "YAWA",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(131, 184, 243, 0.8),
            ),
          )
        ],
      ),
      nextScreen: const HomeScreen(),
    );
  }
}
