import 'package:BIOL/Teacher%20View/TeacherWelcome.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as K;
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:BIOL/Student View/Welcome.dart';
import 'package:BIOL/src/models/teacherUser.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Teacher View/TeacherDashboard.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();
const int NUM_CLASSES = 1;
// List of possible classes to enroll in (for use in checkboxes)
List<String>allClasses = <String>[
  "Biology",
  "Math",
  "Social Studies",
  "English"
];

// List of boolean values corresponding to enrollment in classes
List<bool>enrolledClasses = <bool>[
  false,  // Biology        (index 0)
  false,  // Math           (index 1)
  false,  // Social Studies (index 2)
  false   // English        (index 3)
];

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController password2Controller = TextEditingController();
TextEditingController accessCodeController = TextEditingController();
final List<Map<String, List<int>>> gradeInitializer = [];

class SignUp extends StatefulWidget {
  @override
  SignUpScreen createState() => SignUpScreen();
}

class SignUpScreen extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Online Learning Platform'),
          backgroundColor: clr.color_1,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Image.asset('images/BIOL_LOGO.png',
                      width: 130,
                      height: 130,
                      scale: 1.0
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),

                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: password2Controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Re-enter Password',
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.fromLTRB(70, 10, 10, 0),
                    child: Text(
                      'Select the courses you want to enroll in',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    )
                ),

                Column(
                  children: [
                    for(var i = 0; i < NUM_CLASSES; i++)
                      Row(
                        children: [
                          Checkbox(
                              value: enrolledClasses[i],
                              onChanged: (value) {
                                setState(() {
                                  enrolledClasses[i] = !enrolledClasses[i];
                                });
                              }

                          ),
                          Text(allClasses[i])
                        ],

                      ),

                  ],
                ),

                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: Colors.blue,
                  child: Text('Already have an account?     Sign in'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: clr.color_1,
                      child: Text('Sign up as Student'),
                      onPressed: () {

                        //encrypt the password
                        final key = K.Key.fromLength(32);
                        final iv = K.IV.fromLength(16);
                        final encrypter = K.Encrypter(K.AES(key));
                        var encrypted = encrypter.encrypt(passwordController.text, iv: iv);

                        String passE = encrypted.base64;

                        MongoDatabase.searchAccount(emailController.text, "Student").then((student) {
                          if (student == null) {
                            Student student = new Student(
                                username: nameController.text,
                                emailId: emailController.text,
                                completedQuizzes: null,
                                viewedQuizzes: null,
                                accessCode: "",
                                percentageCorrect: 0.0,
                                percentageWrong: 0.0,
                                recentQuiz: "",
                                grade: null,
                                extraGrade: null
                            );
                            student.enrolledClasses = new List<String>();

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  Welcome(student: student, password: passE)),
                            );
                          }
                          else{
                            print("Sign up failed");
                            SignUpFailedAlert(context);
                          }
                        });
                      },
                    )),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: clr.color_2,
                      child: Text('Sign up as Teacher'),
                      onPressed: () {

                        //encrypt the password
                        final key = K.Key.fromLength(32);
                        final iv = K.IV.fromLength(16);
                        final encrypter = K.Encrypter(K.AES(key));
                        var encrypted = encrypter.encrypt(passwordController.text, iv: iv);

                        String passE = encrypted.base64;

                        MongoDatabase.searchAccount(emailController.text, "Teacher").then((teacher) {
                          if (teacher == null) {
                            Teacher teacher = new Teacher(
                                username: nameController.text,
                                emailId: emailController.text,
                                createdQuizzes: null,
                                studentActivity: null,
                                assignedClasses: null,
                                accessCode: "");

                            //sending data to Teacher class

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  TeacherWelcome(teacher: teacher, password: passE)),
                            );
                          }
                          else{
                            print("Sign in failed");
                            SignUpFailedAlert(context);
                          }
                        });
                      },
                    )),

              ],
            )));
  }

  insertTeacher(String nameA, String emailA, String passwordA, String accessCodeA) async {
    final teacher = TeacherUser(
      id: M.ObjectId(),
      name: nameA,
      email: emailA,
      password: passwordA,
      accessCode: accessCodeA,
    );
    await MongoDatabase.insertTeacher(teacher);
  }
}

SignUpFailedAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Sign up Failed"),
    content: Text("This Email is already in use."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
