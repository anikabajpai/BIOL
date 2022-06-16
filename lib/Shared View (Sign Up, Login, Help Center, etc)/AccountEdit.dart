import 'package:BIOL/src/models/colortheme.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as K;
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/ForgotPasswordScreen.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/LoginScreen.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
var clr = AppColors();
class AccountEdit extends StatefulWidget{
  final Student student;
  final Teacher teacher;
  final String feature;

  AccountEdit({Key key, @required this.student, @required this.teacher, @required this.feature}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new AccountEditState(student: this.student, teacher: this.teacher, feature:this.feature);
  }
}

class AccountEditState extends State<AccountEdit> {

  // local variables - filled in build()
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Student student;
  Teacher teacher;
  String feature;

  AccountEditState({Key key, @required this.student, @required this.teacher, @required this.feature});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Change $feature'),
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
                      'Edit Information',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New $feature',
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
                  onPressed: (){
                    //forgot password screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                  },
                  textColor: clr.color_1,
                  child: Text('Forgot Password?'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: clr.color_2,
                      child: Text('Confirm Change'),
                      onPressed: () {
                        final key = K.Key.fromLength(32);
                        final iv = K.IV.fromLength(16);
                        final encrypter = K.Encrypter(K.AES(key));
                        final encrypted = encrypter.encrypt(passwordController.text, iv: iv);
                        String passE = encrypted.base64;

                        if (student == null) {  //teacher
                          if(passE == teacher.password)
                            {
                              print(nameController.text + " "  + teacher.emailId);
                              if(feature == "Name"){
                                updateTeacher(teacher.emailId, nameController.text, teacher.emailId);
                                print(nameController.text + " "  + teacher.emailId);
                              }
                              else{
                                updateTeacher(teacher.emailId, teacher.username,  nameController.text);
                                print(nameController.text + " "  + teacher.username);
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                            }
                          else{
                            print("Failed");
                            passwordAlert(context);
                          }
                        }
                        else {
                          if(passE == student.password)
                          {
                            if(feature == "Name"){
                              updateStud(student.emailId, nameController.text, student.emailId);
                              print(nameController.text + " " + student.emailId);
                            }
                            else{
                              updateStud(student.emailId, student.username, nameController.text);
                              print(nameController.text + " "  + student.username);
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                          }
                          else{
                            passwordAlert(context);
                          }
                        }
                      },
                    )),
              ],
            )));
  }

  updateStud(String prevEmail, String Name, String Email) async{
    await MongoDatabase.updateStud(prevEmail, Name, Email);
  }

  updateTeacher(String prevEmail, String Name, String Email) async{
    await MongoDatabase.updateTeacher(prevEmail, Name, Email);
  }
}

passwordAlert(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("Incorrect Password. Please try again."),
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