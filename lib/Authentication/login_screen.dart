import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task/Home/home_screen.dart';
import 'package:todo_task/Authentication/signup_screen.dart';

import '../Utils/app_const.dart';
import '../Utils/theme_manager.dart';
import '../Utils/validators.dart';
import '../Widget/custom_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeManager themeManager = ThemeManager();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _validatorKey = GlobalKey<FormState>();


  ///==== Firebase methods
  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('isLogin', "true");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeManager.getWhiteColor,
        body: Container(
          margin: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Form(
              key: _validatorKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.2,
                        width: height * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.3),
                            image: DecorationImage(
                                image: AssetImage("assets/images/logo.png"),
                                fit: BoxFit.fill)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Text("Login",
                      style: TextStyle(
                          fontSize: width * 0.1,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: height * 0.04,
                  ),


                  /// ==== Login details
                  CustomTextFormField(
                    readOnly: false,
                    obscureText: false,
                    controller: emailController,
                    title: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icon(Icons.email),
                    fillColor: themeManager.getLightThemeColor,
                    validator: (value) {
                      if (Validators().EmailValidate(emailController.text)
                          is String) {
                        return Validators().EmailValidate(emailController.text);
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: height * 0.03,
                  ),
                  CustomTextFormField(
                    readOnly: false,
                    obscureText: true,
                    maxLine: 1,
                    controller: passwordController,
                    title: "Password",
                    hintText: "Enter password",
                    prefixIcon: Icon(Icons.key),
                    fillColor: themeManager.getLightThemeColor,
                    validator: (value) {
                      if (Validators().passwordValidate(passwordController.text)
                          is String) {
                        return Validators()
                            .passwordValidate(passwordController.text);
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),

                  SizedBox(
                    height: height * 0.05,
                  ),

                  /// ==== Login Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_validatorKey.currentState!.validate()) {
                            signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * 0.02),
                              color: themeManager.getThemeColor),
                          alignment: Alignment.center,
                          child: Text("Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.02,
                                  color: themeManager.getWhiteColor)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),

                  /// ==== Create new Account status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingUpScreen(),
                              ));
                        },
                        child: Text("Create new Account? ",
                            style: TextStyle(
                                fontSize: width * 0.035,
                                color: themeManager.getLightBlackColor,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
