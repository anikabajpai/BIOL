import 'package:BIOL/Teacher%20View/TeacherDashboard.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:BIOL/MongoConnect.dart';
import '../Collection Classes/Teacher.dart';
import '../src/models/teacherUser.dart';

// padding values for individual pages
const double afterButtonPadding = 20.0;
const double afterImagePadding = 20.0;

// text sizes
const double titleSize = 32.0;
const double bodySize = 20.0;

// container heights for fixed sizing
const double titleHeight = 120.0;
const double bodyHeight = 200.0;

// button width
const double buttonWidth = 200.0;

// profile image size (both width and height)
const double profileImgSize = 75.0;

// other variables needed across pages
List<String> takenUsernames = [];
final List<Map<String, List<int>>> gradeInitializer = [];
String accessCode = "";
String profilePic = 'images/profile/white.png';
String passsword = "";

class TeacherWelcome extends StatelessWidget {
  final Teacher teacher;
  final String password;
  TeacherWelcome({Key key, @required this.teacher, this.password}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    passsword = password;
    return MaterialApp(
      title: "Welcome!",
      home: Scaffold(
        appBar: AppBar(title: Text(""), backgroundColor: clr.color_2,),
        body: TeacherWelcome1(teacher: teacher),
      ),
    );
  }
}

class TeacherWelcome1 extends StatelessWidget {
  final Teacher teacher;
  const TeacherWelcome1({Key key, @required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: [
          new Container(
              height: titleHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Welcome to BIOL,\n" + teacher.username + "!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: titleSize),
              )
          ),

          new Image.asset(
            'images/BIOL_LOGO.png', width: 256, height: 124, fit: BoxFit.cover,),

          new Padding(padding: EdgeInsets.all(afterImagePadding)),

          new Container(
              height: bodyHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("We're so excited you're here! Before you dive into the app, let's get you set up...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: bodySize),
              )
          ),

          new Container(
            width: buttonWidth,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(pageRouter(teacher, 2));
              },
              style: ElevatedButton.styleFrom(
                primary: clr.color_1,
              ),
              child: const Text('Sounds good!'),
            ),
          ),

          new Padding(padding: EdgeInsets.all(afterButtonPadding)),

        ],
      ),
    );
  }
}

class WelcomeAc extends StatefulWidget {
  final Teacher teacher;
  WelcomeAc(this.teacher);

  @override
  _WelcomeAcState createState() => _WelcomeAcState(this.teacher);
}

class _WelcomeAcState extends State<WelcomeAc> {
  final Teacher teacher;
  _WelcomeAcState(this.teacher);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Access Code'),
            backgroundColor: clr.color_2,
        ),
        body: Center(
            child: UpdateText(teacher)
        )
    );
  }
}

class DisplayCode extends StatefulWidget {
  final Teacher teacher;
  DisplayCode(this.teacher);

  @override
  UpdateCode createState() => UpdateCode(teacher);
}

class UpdateCode extends State<DisplayCode> {
  final Teacher teacher;
  UpdateCode(this.teacher);
  bool acNotEmpty = false;


  checkAc(){
    setState(() {
      if (teacher.accessCode == "") {
        acNotEmpty = false;
      } else {
        acNotEmpty = true;
      }
    });
  }

  Widget build(BuildContext context) {
    checkAc();
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Align(
          alignment: Alignment.topCenter,
          child: Text(acNotEmpty? teacher.accessCode :"Please generate an access code",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15),
          )),);
  }
}

class UpdateText extends StatefulWidget {
  final Teacher teacher;
  UpdateText(this.teacher);

  UpdateTextState createState() => UpdateTextState(teacher);
}

class UpdateTextState extends State {
  final Teacher teacher;
  UpdateTextState(this.teacher);

  String textHolder = 'Code Display';

  changeText() {

    setState(() {
      var rng = new Random();
      var code = rng.nextInt(900000) + 100000;
      teacher.accessCode = code.toString();
      textHolder = code.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(125)),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: teacher.accessCode==""?Text('$textHolder',
                          style: TextStyle(fontSize: 25)):Text('${teacher.accessCode}',
                          style: TextStyle(fontSize: 25))
                  ),
                  MaterialButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      if(teacher.accessCode == ""){
                        changeText();
                        accessCode = teacher.accessCode;
                        if (teacher != null){
                          Navigator.of(context).push(pageRouter(teacher, 5));
                        }
                      }
                      else
                        {
                          Navigator.of(context).push(pageRouter(teacher, 5));
                        }
                    },
                    child: Text('Click Here to Generate New Access Code'),
                    textColor: Colors.white,
                    color: clr.color_2,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),

                ]))
    );
  }
}

class WelcomePage2 extends StatelessWidget {
  final Teacher teacher;
  const WelcomePage2({Key key, @required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: clr.color_2,),
      body: new Column(
        children: [
          new Container(
              height: titleHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Great, your access code is $accessCode!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: titleSize),
              )
          ),

          new Image.asset(
            'images/BIOL_LOGO.png', width: 256, height: 124, fit: BoxFit.cover,),

          new Padding(padding: EdgeInsets.all(afterImagePadding)),

          new Container(
              height: bodyHeight,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("This access code will be used by your students to enroll in your class, though you can always enroll them manually!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: bodySize),
              )
          ),

          new Container(
            width: buttonWidth,
            child: ElevatedButton(
              onPressed: () {
                // time to push everything to the database
                insertTeacher(teacher.username, teacher.emailId,
                    passsword, accessCode);
                teacher.accessCode = accessCode;
                teacher.password = passsword;

                // pop until we get to the main page...then push to dashboard
                /*Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);*/
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherDashboard(
                          teacher: teacher,)),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: clr.color_1,
              ),
              child: const Text("Get Started!"),
            ),
          ),

          new Padding(padding: EdgeInsets.all(afterButtonPadding)),
        ],
      ),
    );
  }
}

Route pageRouter(Teacher teacher, int destination) {
  // Enables right to left animation - like turning a page
  // Destination is the next page (e.g. if destination is 2, the page to be
  // loaded is WelomePage2
  if(destination == 2) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomeAc(teacher),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  else {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomePage2(teacher: teacher),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
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
