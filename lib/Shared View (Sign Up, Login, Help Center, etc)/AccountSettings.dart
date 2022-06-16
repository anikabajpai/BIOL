import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/AccountEdit.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/ForgotPasswordScreen.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/LoginScreen.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();
// padding constants - change as needed
const double topPadding = 15.0;
const double EnterQuizPadding = 30.0;
const double paddingBetweenAnswers = 5.0;

// answer choices height & width
const double buttonHeight = 60.0;
const double buttonWidth = 500.0;

class AccountSettings extends StatefulWidget{
  final Student student;
  final Teacher teacher;

  AccountSettings({Key key, @required this.student, @required this.teacher}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new AccountSettingsState(student: this.student, teacher: this.teacher);
  }
}

class AccountSettingsState extends State<AccountSettings> {

  // local variables - filled in build()
  Student student;
  Teacher teacher;

  AccountSettingsState({Key key, @required this.student, @required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Account Settings", style: new TextStyle( fontSize: 18.0, color: Colors.white),),
            backgroundColor: clr.color_1,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[

                  Image.asset(
                    student!=null?student.image:'images/profile/green.png', width: 600, height: 240,),
                  //Spacer(flex: 3),

                  const SizedBox(height: 30),
                  TextButton(
                      onPressed: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountEdit(student: student, teacher: teacher, feature: "Name")),
                        );
                      },
                      child: student!=null?Text('Name: ' + student.username,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),):
                      Text('Name: ' + teacher.username,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),) //want it to do nothing
                  ),

                  const SizedBox(height: 30),
                  TextButton(
                      onPressed: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountEdit(student: student, teacher: teacher, feature: "Email Address")),
                        );
                      },
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                      child: student!=null?Text('Email: ' + student.emailId,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),):
                      Text('Email: ' + teacher.emailId,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),)
                  ),

                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(5, 35, 5, 5),
                      child: student!=null?Text('Alias: '+student.alias,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),):
                      Text('Access Code: ' + teacher.accessCode,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),) //want it to do nothing
                  ),

                  new Padding(padding : EdgeInsets.all(15.0)),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: new Text("Change Password", style: new TextStyle( fontSize: 18.0, color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                        },
                      )),
                  SizedBox(height: 30),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: new Text("Delete Account", style: new TextStyle( fontSize: 18.0, color: Colors.white)),
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text("Delete Account?"),
                                content: Text("Are you sure you want to delete your account?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")
                                  ),

                                  TextButton(
                                      onPressed: ()
                                      {
                                        if (student == null) {  //teacher
                                          removeUser(teacher.emailId, "Teacher");
                                        }
                                        else {
                                          removeUser(student.emailId, "Student");
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginScreen()),
                                        );
                                      },
                                      child: Text("Delete Account")
                                  )
                                ]
                            )
                        ),
                      )),

                  new Padding(padding : EdgeInsets.all(35.0)),


                ])));
  }

  void exitQuiz() {
    setState(() {
      Navigator.pop(context);
    });
  }

  removeUser(String email, String role) async{
    await MongoDatabase.removeUser(email, role);
  }

}