import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task/Authentication/login_screen.dart';
import 'package:todo_task/Utils/theme_manager.dart';
import '../Utils/app_const.dart';
import '../Home/home_screen.dart';
import '../Utils/validators.dart';
import '../Widget/custom_textformfield.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  ThemeManager themeManager = ThemeManager();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _validatorKey = GlobalKey<FormState>();

  ///==== Firebase methods
  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('isLogin', "true");

      userDataSet(userController.text.toString(),
          emailController.text.toString(), passwordController.text.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  ///==== Firebase User methods
  void userDataSet(String userName, String email, String password) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "userName": userName,
        "email": email,
        "uid": FirebaseAuth.instance.currentUser!.uid,
      },
    );
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
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _validatorKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ==== App Logo & Title
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
                    height: height * 0.02,
                  ),
                  Text("SignUp",
                      style: TextStyle(
                          fontSize: width * 0.1,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: height * 0.04,
                  ),

                  /// ==== Signup Details List
                  CustomTextFormField(
                    readOnly: false,
                    obscureText: false,
                    controller: userController,
                    title: "User Name",
                    hintText: "Enter user name",
                    prefixIcon: Icon(Icons.account_circle_sharp),
                    fillColor: themeManager.getLightThemeColor,
                    validator: (value) {
                      if (Validators().NonEmptyValidate(userController.text)
                          is String) {
                        return Validators()
                            .NonEmptyValidate(userController.text);
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
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
                    height: height * 0.04,
                  ),

                  /// ==== SingUp Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_validatorKey.currentState!.validate()) {
                            await signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false);
                          }
                        },
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * 0.02),
                              color: themeManager.getThemeColor),
                          alignment: Alignment.center,
                          child: Text("SignUp",
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

                  ///==== Back To Login Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text("Back to login? ",
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
