import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task/Authentication/login_screen.dart';
import 'package:todo_task/Home/home_screen.dart';

import '../Utils/app_const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkStatus();

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.2,
              width: height * 0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.3),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.fill)),
            ),
          ],
        ),
      ),
    );
  }

  void checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
String? isLogin = prefs.getString('isLogin');
    if(isLogin != null && isLogin == 'true')  {
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
