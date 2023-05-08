import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task/Authentication/login_screen.dart';
import 'package:todo_task/Widget/custom_textformfield.dart';
import 'package:uuid/uuid.dart';
import '../Utils/app_const.dart';
import '../Utils/theme_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeManager themeManager = ThemeManager();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool isChecked = false;
  List tasks = [];

  @override
  void initState() {
    getAllTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return themeManager.getBlackColor;
      }
      return themeManager.getThemeColor;
    }

    return Scaffold(
      appBar: AppBar(
          title:
              Text("Home", style: TextStyle(color: themeManager.getWhiteColor)),
          backgroundColor: themeManager.getThemeColor,
          actions: [
            GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setString('isLogin', "false");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false);
                },
                child: Container(
                  margin: EdgeInsets.only(right: width * 0.05),
                  child: Icon(Icons.logout, color: themeManager.getWhiteColor),
                ))
          ],
          automaticallyImplyLeading: false),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(
                      left: width * 0.03,
                      right: width * 0.03,
                      top: height * 0.0,
                      bottom: height * 0.015),
                  margin: EdgeInsets.only(
                      left: width * 0.03,
                      right: width * 0.03,
                      top: height * 0.02),
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      color: themeManager.getLightThemeColor.withOpacity(0.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// === task Title & Description
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: tasks[index]['isComplete'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    tasks[index]['isComplete'] = value!;
                                  });
                                  updateTask(tasks[index]['id'],
                                      tasks[index]['isComplete']);
                                },
                              ),
                              Text(tasks[index]['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                deleteTask(tasks[index]['id']);
                              },
                              child:
                                  const Icon(Icons.close, color: Colors.red)),
                        ],
                      ),
                      Text(tasks[index]['description']),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),

      ///==== Add Task button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  clipBehavior: Clip.none,
                  // overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(Icons.close,
                              color: themeManager.getThemeColor),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomTextFormField(
                            readOnly: false,
                            obscureText: false,
                            hintText: "Title",
                            controller: title,
                          ),
                          CustomTextFormField(
                            readOnly: false,
                            obscureText: false,
                            hintText: "Description",
                            controller: description,
                          ),
                          GestureDetector(
                            onTap: () {
                              addTask(title, description);
                            },
                            child: Container(
                              height: height * 0.06,
                              width: width * 0.3,
                              margin: EdgeInsets.only(top: height * 0.02),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.02),
                                  color: themeManager.getThemeColor),
                              child: Text("Save",
                                  style: TextStyle(
                                      color: themeManager.getWhiteColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: themeManager.getThemeColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ///==== Add Task
  void addTask(
      TextEditingController title, TextEditingController description) async {
    Uuid uuid = const Uuid();
    String id = uuid.v4();
    await FirebaseFirestore.instance.collection('Tasks').doc(id).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "title": title.text,
      "description": description.text,
      "isComplete": false,
      "id": id,
    });
    title.clear();
    description.clear();
    getAllTask();
    Navigator.pop(context);
  }

  ///==== update Task Status
  void updateTask(id, status) async {
    await FirebaseFirestore.instance.collection('Tasks').doc(id).update({
      "isComplete": status,
    });
    getAllTask();
  }

  ///==== delete Task
  void deleteTask(id) async {
    await FirebaseFirestore.instance.collection('Tasks').doc(id).delete();
    getAllTask();
  }

  ///==== get Task List
  void getAllTask() async {
    tasks = [];
    var res = await FirebaseFirestore.instance
        .collection('Tasks')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    res.docs.forEach((element) {
      tasks.add(element.data());
      setState(() {});
    });
  }
}
