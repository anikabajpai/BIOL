import 'package:flutter/material.dart';
import 'dart:math';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/AccountSettings.dart';
import 'package:BIOL/Teacher View/TeacherGradeDisplay.dart';
import 'package:BIOL/Unused Files/Leaderboard.dart';
import 'package:BIOL/Teacher View/ClassManagement.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/leaderboardMenu.dart';
import 'package:BIOL/Teacher View/CreateQuiz.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/HelpCenter.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/Teacher View/BiologyQuizListTeachers.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Teacher View/QuizCSVImport.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();

// constants that may be changed later if needed
const double titleFont = 24;      // font size of title: 'Welcome [Teacher]!'
const double titleContainer = 26; // container height of home containers containing titles
const double bodyContainer = 110; // container height of home containers containing body text

class TeacherDashboard extends StatelessWidget {
  final Teacher teacher;
  TeacherDashboard({Key key, @required this.teacher}) : super(key : key);
  int classLength; //should be a constant
  List<String> customQuizList;
  Map<String, int> quizNSub;
  List<String> helpCenterList;

  Future<Map<String, int>> numSubmissions(ac) async { //number of submissions

    DateTime dt = DateTime.now();
    String dtStr = dt.toString();

    print("Am i here");
    var students = await MongoDatabase.getStudents(ac);
    var quizList = await MongoDatabase.getCustomQuizzes2(ac); //gets list of quizzes
    customQuizList = [];

    int actualCQ = 0;
    await MongoDatabase.getCustomQuizzes(ac).then((quizL) {
      for(int i = 0; i < quizL.length; i++){ //goes to each custom quiz
        //print("quiz: ${quizList[i]['quiz_name']}, accessCode: ${quizList[i]['accessCode']}");
        if(quizL[i]['accessCode'] == teacher.accessCode) {
          //print("quiz is access code");
          if(dtStr.compareTo(quizL[i]['dueDate'].toString()) < 0) {
            //print("This is active");
            actualCQ++; //ONLY FOR DISPLAY ATM
            customQuizList.add(quizL[i]['quiz_name']);
          }
        }
      }

      List<int> submissions = List.filled(actualCQ, 0); //class length of zeroes

      for(int i = 0; i < customQuizList.length; i++) { //goes to each custom quiz
        for (int j = 0; j < students.length; j++) { //iterate through all students
          print('hi');
          for (int k = 0; k < students[j]['grade'].length; k++) { //iterate through all quizzes student has taken
            var bool = students[j]['grade'][k].containsKey(customQuizList[i]);
            if(bool) {
              print(customQuizList[i]);
              submissions[i]++;
            }
          }
        }
      }

      for(int i = 0; i < actualCQ; i++){
        if(submissions[i] != 0){
          var element = customQuizList[i];
          var numSub = submissions[i];
          print('The number of submissions for $element is $numSub\n');
        }
      }

      quizNSub = new Map();
      for (int i = 0; i < customQuizList.length; i++) {
        quizNSub.putIfAbsent(customQuizList[i], () => submissions[i]);
      }
      print(quizNSub);
    });

    //get documents
    helpCenterList = [];
    await MongoDatabase.getDocumentsHelp(ac).then((tempHCList) {
      for (Map<String, dynamic> temp in tempHCList) {
        if (temp['answer'] == "" || temp['answer'] == null) {
          helpCenterList.add(temp['question']);
        }
      }
    });

    return quizNSub;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: numSubmissions(teacher.accessCode),
        builder: (context, quizNSubmissions) {

          Size size = MediaQuery.of(context).size;
          return Scaffold(
            appBar: AppBar(
                title: Text("BIOL - Teacher View"),
                backgroundColor: clr.header,
            ),
            backgroundColor: clr.background,
            body: Padding(
                padding: EdgeInsets.all(0),
                child: ListView(
                    children: <Widget>[
                      Container(
                        height: 60,
                        padding: EdgeInsets.only(top: 15),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              child: Text('Welcome ' + teacher.username + '!',
                                style: TextStyle(
                                    color: clr.text_black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24),
                              ),
                            ),
                            ),),

                      DisplayCode(teacher),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          height: 40,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: clr.color_1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )
                          ),
                          alignment: Alignment.center,
                          child: new Text(
                              'Active Quizzes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            height: quizNSub != null ? (quizNSub.length * 20 + 50).toDouble() : 50,
                            width: size.width * 0.8,
                            child: Container(
                                decoration: BoxDecoration( //did this need to stay const??
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: clr.color_1.withOpacity(0.5),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 5),
                                    ),
                                  ]
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: quizNSub != null && quizNSub.isNotEmpty ? Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                  "Quiz Name",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                                "No. of submissions",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            width: 180,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      for(String x in quizNSub.keys)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 3),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: Text(x),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              Container(
                                                width: 180,
                                                child: Text("  ${quizNSub['$x']}"),
                                                alignment: Alignment.center,
                                              ),
                                            ],
                                          ),
                                        )
                                    ],
                                  ) :
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No Active Quizzes.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                        color: clr.color_1,
                                      ),
                                    ),
                                  )
                                )
                            ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          height: 40,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: clr.color_1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )
                          ),
                          alignment: Alignment.center,
                          child: new Text(
                            'Help Center',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          height: (helpCenterList == null) ? 50 : (helpCenterList.length * 20 + 50).toDouble(),
                          width: size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration( //did this need to stay const??
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: clr.color_1.withOpacity(0.5),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 5),
                                ),
                              ]
                          ),
                            child: helpCenterList != null && helpCenterList.isNotEmpty ? Column(
                              children: <Widget>[
                                Text(
                                  'Unanswered Questions',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                for (String x in helpCenterList)
                                  Text(
                                    "$x",
                                    style: TextStyle(color: Colors.black),
                                  )
                              ],
                            ) :
                            Text("No upcoming assignment."),
                            ),
                      )
                    ])),

            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      child: Text(
                        'Main Menu\n Biology Online Learning',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 32),
                      )),
                  Center(
                    child: Image.asset('images/BIOL_LOGO.png',
                        width:130,
                        height:130,
                        scale:1.0
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.account_box),
                    title: Text('Account Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AccountSettings(student: null, teacher: teacher)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Class Management'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ClassManagement(teacher: teacher)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Access Code'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccessCode(teacher)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.border_color),
                    title: Text('Upload Quiz'),
                    onTap: () {
                      loadUploadQuizPage(context, teacher);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: Text('View Quiz Information'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionBankOrResults(teacher: teacher)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.show_chart),
                    title: Text('LeaderBoards'),
                    onTap: () {
                      loadLeaderboard(context, teacher);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.question_answer),
                    title: Text('Help Center'),
                    onTap: () {
                      loadHelpCenterPage(context, teacher);
                    },
                  ),
                  ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Log Out'),
                      onTap: ()
                      {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                  ),
                ],
              ),
            ),
          );
        }
    );}

  void loadLeaderboard(BuildContext context, Teacher teacher) {
    if(teacher.accessCode.compareTo("") != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChooseClassForViewingGrades(teacher: teacher, viewGrades: false)),
      );
    } else {
      // student is not able to access the help center - it will just
      // crash due to the necessity of an access code! give them an error
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: Text("Cannot Enter Help Center"),
              content: Text("Please generate an access code in the 'Access Code' section to use this feature."),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK")
                )
              ]
          )
      );
    }
  }

  void loadHelpCenterPage(BuildContext context, Teacher teacher) {
    if(teacher.accessCode.compareTo("") != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            TeacherHelpCenter(teacher: teacher, student: null)),
      );
    } else {
      // student is not able to access the help center - it will just
      // crash due to the necessity of an access code! give them an error
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: Text("Cannot Enter Help Center"),
              content: Text("Please generate an access code in the 'Access Code' section to use this feature."),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK")
                )
              ]
          )
      );
    }
  }

  void loadUploadQuizPage(BuildContext context, Teacher teacher) {
    if(teacher.accessCode.compareTo("") != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UploadQuizzes(teacher: teacher)),
      );
    } else {
      // student is not able to access the help center - it will just
      // crash due to the necessity of an access code! give them an error
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: Text("Cannot Enter Upload Quiz Page"),
              content: Text("Please generate an access code in the 'Access Code' section to use this feature."),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK")
                )
              ]
          )
      );
    }
  }
}

class AccessCode extends StatelessWidget {
  final Teacher teacher;
  AccessCode(this.teacher);

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
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 60,
            width: size.width * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: clr.color_1,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 10),
                  color: clr.color_1.withOpacity(0.5),
                )
              ]
            ),
            alignment: Alignment.center,
            child: acNotEmpty ? Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                          'Access Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12)
                      ),
                    ),
                  ),
                  Container(
                    width: 170,
                    child: Text(
                        teacher.accessCode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 25)
                    ),
                  ),
                ],
              )
            ) :
            Text("Please generate an access code",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25),
            ),
          ),
      ),);
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
                        MongoDatabase.updateAccessCode(teacher.accessCode, teacher.username, null);
                        if (teacher != null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherDashboard(teacher: teacher)),
                          );
                        }
                      }
                      else
                      {
                        acGenerated(context);
                      }
                    },
                    child: Text('Click Here to Generate New Access Code'),
                    textColor: Colors.white,
                    color: clr.color_1,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),

                ]))
    );
  }
}

acGenerated(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cannot generate Access Code"),
    content: Text("Access Code already generated."),
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

class UploadQuizzes extends StatelessWidget {
  final Teacher teacher;
  int numQuestions;

  UploadQuizzes({Key key, @required this.teacher}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Quizzes"),
        backgroundColor: clr.color_2,
      ),
      body: ListView(
        children: [
          Container(
          height: 70,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child:
          MaterialButton(
              shape: StadiumBorder(),
              textColor: Colors.white,
              color: clr.color_1,
              child: Text('Create In App'),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: Text("How many questions?"),
                    content: WheelChooser.integer(
                      horizontal: true,
                      onValueChanged: (i) => {
                        numQuestions = i
                      },
                      maxValue: 100,
                      minValue: 1,
                      step: 1,
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel")
                      ),

                      TextButton(
                          onPressed: () => { Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateQuiz(teacher: teacher, numQuestions: numQuestions)),
                          )
                          },
                          child: Text("OK")
                      )
                    ]
                ),
              )
          )
          ),

          Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child:
              MaterialButton(
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  color: clr.color_1,
                  child: Text('Import from CSV'),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QuizCSVImport(teacher: teacher)),
                    );
                  }
              )
          )
        ]
      )
    );
  }
}

class QuestionBankOrResults extends StatelessWidget {

  final Teacher teacher;
  QuestionBankOrResults({Key key, @required this.teacher}) : super(key : key);

  Future<List<Map<String, dynamic>>> loadQ() async {
    var quizList = await MongoDatabase.getCustomQuizzes(teacher.accessCode);
    return quizList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quiz Information/Grades"),
          backgroundColor: clr.color_2,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  //Spacer(flex: 3),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('Quizzes Available'),
                        onPressed: () {
                          loadQ().then((quizL) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BiologyQuizListTeachers(teacher: this.teacher, lq: quizL)),
                            );
                          });
                        },
                      )),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Student Performance by Quiz'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChooseClassForViewingGrades(teacher: this.teacher, viewGrades: true)),
                          );
                        },
                      )),
                ])));
  }
}

class ChooseClassForViewingGrades extends StatelessWidget {
  final bool viewGrades;
  final Teacher teacher;
  ChooseClassForViewingGrades({Key key, @required this.teacher, this.viewGrades}) : super(key : key);

  Future<List<Map<String, dynamic>>> loadQ() async {
    var quizList = await MongoDatabase.getCustomQuizzes(teacher.accessCode);
    return quizList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Classes"),
          backgroundColor: clr.color_2,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  //Spacer(flex: 3),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('Class 1\nAccess Code: ' + teacher.accessCode), //when multiple access codes are allowed this will probably need to be modified
                        onPressed: () {
                          loadQ().then((quizL) {
                            viewGrades ?
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeacherGradeDisplay(teacher: this.teacher, lq: quizL)),
                            ) : Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LeaderBoardMenu(quizL, teacher.accessCode, null, teacher)),
                            );
                          });
                        },
                      )
                  ),
                ])));
  }
}

class ChooseClassForLeaderboards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Classes"),
          backgroundColor: clr.color_2,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  //Spacer(flex: 3),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('Block 1 (8: 30) - Biology'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherLeaderboards()),
                          );
                        },
                      )),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Block 2 (10:10) - AP Biology'),
                        onPressed: () {{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherLeaderboards()),
                          );
                        }
                        },
                      )),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('Block 3 (12:30) - Biochemistry'),
                        onPressed: () {{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherLeaderboards()),
                          );
                        }
                        },
                      )),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Block 4 (2:05) - Anatomy'),
                        onPressed: () {{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherLeaderboards()),
                          );
                        }
                        },
                      )),

                ])));
  }
}

class TeacherLeaderboards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboards"),
        backgroundColor: clr.color_2,
      ),
      body: ListView(
          children:<Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Quizzes for Biology Block 1"
                ,textScaleFactor: 2,style: TextStyle(fontWeight:FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: [
                  TableRow(
                      children: [
                        Text("Leaderboard",textScaleFactor: 1.5, textAlign: TextAlign.center),
                        Text("Grade Distribution",textScaleFactor: 1.5, textAlign: TextAlign.center),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.5),
                        Text("",textScaleFactor: 1.5),
                      ]),
                  TableRow(
                      children: [
                        Text("Qui",textScaleFactor: 1.5,textAlign: TextAlign.right,),
                        Text("z 1",textScaleFactor: 1.5, textAlign: TextAlign.left),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: .8),
                        Text("",textScaleFactor: .8),
                      ]),
                  TableRow(
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Quiz 1 Leaderboards'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeacherViewLeaderboardsRanks()),
                            );
                          },
                        ),
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_1,
                          disabledColor: clr.color_1,
                          child: Text('Quiz 1 Distribution'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Leaderboard.withSampleData()),
                            );
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.5),
                        Text("",textScaleFactor: 1.5),
                      ]),
                  TableRow(
                      children: [
                        Text("Qui",textScaleFactor: 1.5,textAlign: TextAlign.right,),
                        Text("z 2",textScaleFactor: 1.5, textAlign: TextAlign.left),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: .8),
                        Text("",textScaleFactor: .8),
                      ]),
                  TableRow(
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Quiz 2 Leaderboards'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeacherViewLeaderboardsRanks()),
                            );
                          },
                        ),
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_1,
                          disabledColor: clr.color_1,
                          child: Text('Quiz 2 Distribution'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Leaderboard.withSampleData()),
                            );
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.5),
                        Text("",textScaleFactor: 1.5),
                      ]),
                  TableRow(
                      children: [
                        Text("Qui",textScaleFactor: 1.5,textAlign: TextAlign.right,),
                        Text("z 3",textScaleFactor: 1.5, textAlign: TextAlign.left),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: .8),
                        Text("",textScaleFactor: .8),
                      ]),
                  TableRow(
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Quiz 3 Leaderboards'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeacherViewLeaderboardsRanks()),
                            );
                          },
                        ),
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_1,
                          disabledColor: clr.color_1,
                          child: Text('Quiz 3 Distribution'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Leaderboard.withSampleData()),
                            );
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.5),
                        Text("",textScaleFactor: 1.5),
                      ]),
                  TableRow(
                      children: [
                        Text("Qui",textScaleFactor: 1.5,textAlign: TextAlign.right,),
                        Text("z 4",textScaleFactor: 1.5, textAlign: TextAlign.left),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: .8),
                        Text("",textScaleFactor: .8),
                      ]),
                  TableRow(
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Quiz 4 Leaderboards'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TeacherViewLeaderboardsRanks()),
                            );
                          },
                        ),
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_1,
                          disabledColor: clr.color_1,
                          child: Text('Quiz 4 Distribution'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Leaderboard.withSampleData()),
                            );
                          },
                        )]
                  ),
                ],
              ),
            ),
          ]
      )
      ,
    );
  }
}

class TeacherViewLeaderboardsRanks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz 1 Leaderboard Ranks"),
        backgroundColor: clr.color_2,
      ),
      body: ListView(
          children:<Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Table(
                children: [
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.15),
                        Text("", textScaleFactor: 1.15,),
                        Text("AP Biology Peterson",textScaleFactor: 1.15, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 2),
                        Text('Quiz 1', textAlign: TextAlign.center,textScaleFactor: 2.3,),
                        Text("",textScaleFactor: 2),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.4),
                        Text("",textScaleFactor: 1.4),
                        Text("",textScaleFactor: 1.4),
                      ]),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 3,),
                        Text("Name",textScaleFactor: 1.5, textAlign: TextAlign.center,),
                        Text("Score",textScaleFactor: 1.5, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Icon(Icons.person_outline, color: clr.color_2, size: 50),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Purdue Pete A', textAlign: TextAlign.left),
                          onPressed: () {
                          },
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('10/10', textAlign: TextAlign.right),
                          onPressed: () {
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.2,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Icon(Icons.person_outline, color: clr.color_2, size: 50),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Purdue Pete B', textAlign: TextAlign.left),
                          onPressed: () {
                          },
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('10/10', textAlign: TextAlign.right),
                          onPressed: () {
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.2,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Icon(Icons.person_outline, color: clr.color_2, size: 50),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Purdue Pete C', textAlign: TextAlign.left),
                          onPressed: () {
                          },
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('9/10', textAlign: TextAlign.right),
                          onPressed: () {
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.2,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Icon(Icons.person_outline, color: clr.color_2, size: 50),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Purdue Pete D', textAlign: TextAlign.left),
                          onPressed: () {
                          },
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('9/10', textAlign: TextAlign.right),
                          onPressed: () {
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.2,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Icon(Icons.person_outline, color: clr.color_2, size: 50),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Purdue Pete E', textAlign: TextAlign.left),
                          onPressed: () {
                          },
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('9/10', textAlign: TextAlign.right),
                          onPressed: () {
                          },
                        )]
                  ),
                  TableRow(
                      children: [
                        Text("",textScaleFactor: 1.2,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                        Text("",textScaleFactor: 1.2, textAlign: TextAlign.center,),
                      ]),
                  TableRow(
                      children: [
                        Icon(Icons.person_outline, color: clr.color_2, size: 50),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('Purdue Pete F', textAlign: TextAlign.left),
                          onPressed: () {
                          },
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: clr.color_2,
                          disabledColor: clr.color_2,
                          child: Text('9/10', textAlign: TextAlign.right),
                          onPressed: () {
                          },
                        )]
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}