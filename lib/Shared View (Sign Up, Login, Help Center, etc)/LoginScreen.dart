import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as K;
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/ForgotPasswordScreen.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/SignUpScreen.dart';
import 'package:BIOL/Student View/StudentDashboard.dart';
import 'package:BIOL/Teacher View/TeacherDashboard.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

class LoginScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'BIOL',
                      style: TextStyle(
                          color: clr.color_1,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
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
                MaterialButton(
                  onPressed: () {
                    //forgot password screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()));
                  },
                  textColor: clr.color_1,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: MaterialButton(
                      textColor: clr.text_white,
                      color: clr.color_1,
                      child: Text('Login as Student'),
                      onPressed: () {
                        final key = K.Key.fromLength(32);
                        final iv = K.IV.fromLength(16);
                        final encrypter = K.Encrypter(K.AES(key));
                        final encrypted =
                            encrypter.encrypt(passwordController.text, iv: iv);
                        String passE = encrypted.base64;

                        MongoDatabase.loginStudent(nameController.text, passE)
                            .then((student) {
                          if (student != null) {
                            Student s = new Student(
                                id: student["_id"],
                                username: student["name"],
                                emailId: student['email'],
                                password: student["password"],
                                grade: student["grade"],
                                extraGrade: student["extraGrade"],
                                accessCode: student["accessCode"],
                                alias: student["alias"],
                                image: student["image"],
                                recentQuiz: student["recentQuiz"],
                                completedQuizzes: null,
                                viewedQuizzes: null,
                                percentageCorrect: 0.0,
                                percentageWrong: 0.0);

                            s.password = passE;

                            MongoDatabase.getCustomQuizzes(s.accessCode)
                                .then((quizL) {
                              String recentQuestion;
                              String recentAnswer;
                              MongoDatabase.getDocumentsHelp(s.accessCode)
                                  .then((queries) {
                                for (int i = queries.length - 1; i >= 0; i--) {
                                  if (queries[i]['question'] != "" &&
                                      queries[i]['answer'] != "" &&
                                      queries[i]['userEmail'] ==
                                          student['email']) {
                                    recentAnswer = queries[i]['answer'];
                                    recentQuestion = queries[i]['question'];
                                    print(recentAnswer);
                                    print(recentQuestion);
                                  }
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentDashboard(
                                          student: s,
                                          ql: quizL,
                                          recentquestion: recentQuestion,
                                          recentanswer: recentAnswer)),
                                );
                              });
                            });
                          } else {
                            print("Sign in failed");
                            loginFailedAlert(context);
                          }
                        });
                      },
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: MaterialButton(
                      textColor: clr.text_white,
                      color: clr.color_2,
                      child: Text('Login as Teacher'),
                      onPressed: () {
                        final key = K.Key.fromLength(32);
                        final iv = K.IV.fromLength(16);
                        final encrypter = K.Encrypter(K.AES(key));
                        final encrypted =
                            encrypter.encrypt(passwordController.text, iv: iv);
                        String passE = encrypted.base64;

                        MongoDatabase.loginTeacher(nameController.text, passE)
                            .then((teacher) {
                          if (teacher != null) {
                            Teacher t = new Teacher(
                                username: teacher["name"],
                                emailId: teacher['email'],
                                password: teacher["password"],
                                accessCode: teacher["accessCode"],
                                createdQuizzes: null,
                                studentActivity: null,
                                assignedClasses: null);

                            t.password = passE;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TeacherDashboard(teacher: t)),
                            );
                          } else {
                            print("Sign in failed");
                            loginFailedAlert(context);
                          }
                        });
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text("Don't have an account?"),
                        MaterialButton(
                          textColor: clr.color_1,
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}

loginFailedAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Login Failed"),
    content: Text("Wrong username or password. Please try again."),
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
