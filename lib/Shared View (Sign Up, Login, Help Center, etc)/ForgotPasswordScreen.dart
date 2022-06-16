import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as K;
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/LoginScreen.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen();

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  String role = "Student";
  TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    emailController = new TextEditingController();

    return Scaffold(
        appBar: AppBar(
        title: Text("Change Password"),
          backgroundColor: clr.color_1,
        ),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text('Select Your role (Student/Teacher)',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      )),),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child:  Align(
                    alignment: Alignment.center,
                    child: DropdownButton(
                      value: role,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        //color: Colors.deepPurpleAccent,
                        color: clr.color_1,
                      ),
                      onChanged: (String newRole) {
                        setState(() {
                          role = newRole;
                        });
                      },
                      items: <String>['Student', 'Teacher']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              textAlign: TextAlign.center),
                        );
                      }).toList(),
                    ),
                  ),

                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text('Enter your email that you used to create account:',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      )),),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: TextField(
                        obscureText: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),),),
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: clr.color_1,
                      child: Text('Submit'),
                      onPressed: () async {

                        //check if email exists
                        await MongoDatabase.searchMail(emailController.text, role).then((user) async {

                          if (user != null) {
                            //user exists
                            //generate temp password code
                            var rng = new Random();
                            var code = (rng.nextInt(900000) + 100000).toString();

                            //send email
                            String usernameC = 'cHVyZHVlLmVwaWNzLmJsYWNrQGdtYWlsLmNvbQ==';
                            String passwordC = 'YmxhY2tAZXBpY3M=';
                            Codec<String, String> stringToBase64 = utf8.fuse(base64);
                            usernameC = stringToBase64.decode(usernameC);
                            passwordC = stringToBase64.decode(passwordC);

                            String userN = user['name'];

                            final smtpServer = SmtpServer('smtp.gmail.com',
                                username: usernameC, password: passwordC);

                            final message = Message()
                              ..from = Address(usernameC, usernameC)
                              ..recipients.add(emailController.text)
                              ..subject = 'Temporary Password Code'
                              ..text = 'Your username is: $userN.\n'
                                  'Please enter the following code in order to reset your password.\n'
                                  'DO NOT share this code with anyone else.\n'
                                  '$code\n';

                            try {
                              final sendReport = await send(message, smtpServer);
                              print('Message sent: ' + sendReport.toString());

                              //go to next screen; enter temp password code

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TempACScreen(code, user, role)));

                            } on MailerException catch (e) {
                              print('Message not sent.');
                              for (var p in e.problems) {
                                print('Problem: ${p.code}: ${p.msg}');
                              }
                            }
                          } else {
                            //no such user
                            print("no such user");
                            failedAlert(context, "No such email. Create a new user first.");
                          }

                        });


                      },
                    ),),)
              ]
          )
       )
    );
  }
}

class TempACScreen extends StatefulWidget {
  String tempAC;
  dynamic user;
  String role;
  TempACScreen(this.tempAC, this.user, this.role);

  @override
  State<TempACScreen> createState() => _TempACScreen(tempAC, user, role);
}

class _TempACScreen extends State<TempACScreen> {
  String tempAC;
  dynamic user;
  String role;
  TextEditingController ACController;
  TextEditingController NPController;
  TextEditingController NPController2;
  _TempACScreen(this.tempAC, this.user, this.role);
  bool proceed = false;

  @override
  Widget build(BuildContext context) {
    ACController = new TextEditingController();
    NPController = new TextEditingController();
    NPController2 = new TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: Padding(
        padding: EdgeInsets.all(0),
        child: ListView(
        children: proceed == false? <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('Enter the temporary password code:-',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextField(
                controller: ACController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Temporary Password Code',
                ),
              ),),),
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: MaterialButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Submit'),
                onPressed: () {
                  //make extra fields
                  if (ACController.text == tempAC) {
                    setState(() {
                      proceed = !proceed;
                    });
                  } else {
                    print("Not same code\n");
                    failedAlert(context, "Wrong passcode.");
                  }

                },
              ),),)] :
        <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('Enter your new password:-',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextField(
                obscureText: true,
                controller: NPController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter New Password',
                ),
              ),),),
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextField(
                obscureText: true,
                controller: NPController2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter New Password Again',
                ),
              ),),),
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: MaterialButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Submit'),
                onPressed: () async {

                  //push to database
                  if (NPController.text == NPController2.text) {
                    //checked; can update password

                    final key = K.Key.fromLength(32);
                    final iv = K.IV.fromLength(16);
                    final encrypter = K.Encrypter(K.AES(key));
                    final encrypted = encrypter.encrypt(NPController.text, iv: iv);
                    String passE = encrypted.base64;

                    await MongoDatabase.updatePassword(passE, user, role);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          LoginScreen()),
                    );
                  } else {
                    print("Wrong password match");
                    failedAlert(context, "Wrong Password match.");
                  }
                },
              ),),)
        ]
        ))
    );
  }
}

failedAlert(BuildContext context, String message) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Login Failed"),
    content: Text("$message\nPlease try again."),
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