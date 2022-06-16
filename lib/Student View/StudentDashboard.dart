import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/AccountSettings.dart';
import 'package:BIOL/Student View/BiologyQuizListStudents.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/leaderboardMenu.dart';
import 'package:BIOL/Student View/ExtraResources.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/HelpCenter.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/src/models/colortheme.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
var clr = AppColors();

// constants that may be changed later if needed
const double titleFont = 30; // font size of title: 'Welcome [Student]!'
const double titleContainer =
    60; // container height of home containers containing titles
const double bodyContainer =
    110; // container height of home containers containing body text


class StudentDashboard extends StatefulWidget {
  final Student student;
  final List<dynamic> ql;
  final String recentanswer;
  final String recentquestion;
  StudentDashboard(
      {Key key,
        @required this.student,
        @required this.ql,
        @required this.recentquestion,
        @required this.recentanswer})
      : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState(
    student, ql, recentanswer, recentquestion);
}

class _StudentDashboardState extends State<StudentDashboard> {
  final Student student;
  final List<dynamic> ql;
  final String recentanswer;
  final String recentquestion;
  _StudentDashboardState(
      this.student,
      this.ql,
      this.recentquestion,
      this.recentanswer);

  String title = "";
  String score = "";
  List<String> assignedQuizzesList;
  String recentQuestion;
  String recentAnswer;
  void upDateWebsite(String title, String score) async {
    //print("Hey I'm Here");
    this.title = title;
    this.score = score;
    //print("Title: ${this.title}, score: ${this.score}");
    score = score.trim();
    score = score.substring(0, score.length - 1);
    await MongoDatabase.updateGrade(int.parse(score), student.username, title);
  }

  void changedRecentQuiz(String recentQuizName) {
    setState(() {
      student.recentQuiz = recentQuizName;
    });
  }

  @override
  Widget build(BuildContext context) {
    assignedQuizzesList = createListOfDueDates(student, ql);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text("BIOL - Student View"),
          backgroundColor: clr.color_1,
      ),
      body: Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView(children: <Widget>[
            SizedBox(height: 10),
            Container(
              height: 60,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Welcome ' + student.username + '!',
                    style: TextStyle(
                        color: clr.text_black,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                    ),
                        // comment
                  )),
            ),
            DisplayCode(student),
            SizedBox(height: 20),
            loadContainer('Upcoming Assignments', titleContainer, "Quizzes",
                context, clr.color_2),
            SizedBox(height: 5),
            Container(
                height: assignedQuizzesList != null ? (assignedQuizzesList.length * 20 + 50).toDouble() : 50,
                width: size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration( //did this need to stay const??
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: clr.color_2.withOpacity(0.5),
                          blurRadius: 20.0,
                          offset: Offset(0, 5),
                        ),
                      ]
                  ),
                  child:
                  assignedQuizzesList == null || assignedQuizzesList.isEmpty ?
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "No Active Quizzes.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: clr.color_2,
                      ),
                    ),
                  )
                      : Container(
                          height: (assignedQuizzesList.length * 20).toDouble(),
                          child: Column(
                            children: <Widget>[
                              for (int i = 0;
                                  i < assignedQuizzesList.length;
                                  i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    assignedQuizzesList[i],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                )),
            SizedBox(height: 25),
            loadContainer("Most Recently Viewed Quiz", titleContainer,
                "Quizzes", context, clr.color_2),
            SizedBox(height: 5),
            Container(
                height: bodyContainer * 0.6,
                width: size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration( //did this need to stay const??
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: clr.color_2.withOpacity(0.5),
                          blurRadius: 20.0,
                          offset: Offset(0, 5),
                        ),
                      ]
                  ),
                  alignment: Alignment.center,
                  child: student.recentQuiz == null || student.recentQuiz.isEmpty
                      ? new Text(
                      "No recently viewed quizzes.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: clr.color_2,
                    ),
                  )
                      : new Text(
                      student.recentQuiz,
                    style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: clr.text_black,
                  ),
                  ),
                )),
            SizedBox(height: 25),
            loadContainer('Help Center Notifications', titleContainer,
                "Help Center", context, clr.color_1),
            SizedBox(height: 5),
            Container(
                height: bodyContainer,
                width: size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration( //did this need to stay const??
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: clr.color_2.withOpacity(0.5),
                          blurRadius: 20.0,
                          offset: Offset(0, 5),
                        ),
                      ]
                  ),
                  alignment: Alignment.center,
                  child: recentanswer == null || recentanswer == ""
                      ? new Text(
                    "No notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: clr.color_2,
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                color: clr.color_2,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 5),
                                    blurRadius: 2,
                                    color: clr.color_2.withOpacity(0.4),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Question",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(recentanswer),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                color: clr.color_2,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 5),
                                    blurRadius: 2,
                                    color: clr.color_2.withOpacity(0.4),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Answer",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(recentquestion),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
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
              'Main Menu\nBiology Online Learning',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 32),
            )),
            Center(
              child: Image.asset('images/BIOL_LOGO.png',
                  width: 130, height: 130, scale: 1.0),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Account Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AccountSettings(student: student, teacher: null)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Quizzes'),
              onTap: () {
                loadQuizzesPage(context, student, changedRecentQuiz);
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('My Grades'),
              onTap: () {
                loadGradesPage(context, student);
              },
            ),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('LeaderBoards'),
              onTap: () {
                loadLeaderboardPage(context, student);
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Help Center'),
              onTap: () {
                loadHelpCenterPage(context, student);
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Access Code'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccessCode(student)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_outlined),
              title: Text('Extra Resources'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExtraResources(student)),
                );
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

  void loadQuizzesPage(BuildContext context, Student student, Function changedRecentQuiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StudentQuizzes(student: this.student, changedRecentQuiz: changedRecentQuiz)),
    );
  }

  void loadGradesPage(BuildContext context, Student stud) {
    MongoDatabase.studentUpdate(stud.emailId).then((student) {
      student == null ? print("Im null") : print("Not null");
      Student s = new Student(
          id: student["_id"],
          username: student["name"],
          emailId: student['email'],
          password: student["password"],
          grade: student["grade"],
          accessCode: student["accessCode"],
          alias: student["alias"],
          image: student["image"],
          recentQuiz: student["recentQuiz"],
          completedQuizzes: null,
          viewedQuizzes: null,
          percentageCorrect: 0.0,
          percentageWrong: 0.0);
      MongoDatabase.getCustomQuizzes(s.accessCode).then((quizL) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentGrades(student: s, lq: quizL)));
      });
    });
  }

  void loadHelpCenterPage(BuildContext context, Student student) {
    // check if the student has entered their access code
    if (student.accessCode.compareTo("") != 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TeacherHelpCenter(teacher: null, student: student)),
      );
    } else {
      // student is not able to access the help center - it will just
      // crash due to the necessity of an access code! give them an error
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("Cannot Enter Help Center"),
                  content: Text(
                      "Please enter your teacher's access code in the 'Access Code' section to use this feature."),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"))
                  ]));
    }
  }

  void loadLeaderboardPage(BuildContext context, Student student) {
    // so far this only loads the page StudentLeaderboards - no meaningful
    // information is passed to the page
    MongoDatabase.getCustomQuizzes(student.accessCode).then((quizL) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LeaderBoardMenu(quizL, student.accessCode, student, null)),
      );
    });
  }

  Padding loadContainer(
      String text, double height, String type, BuildContext context, Color c) {
    // generic driver to load the OutlineButton containers on the home page
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: GestureDetector(
          child: Container(
            height: 40,
            width: size.width * 0.8,
            decoration: BoxDecoration(
                color: clr.color_2,
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )
            ),
            alignment: Alignment.center,
            child: new Text(
              text,
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              ),
            ),
          ),
              onTap: () {
                  if (type.compareTo("Quizzes") == 0) {
                    loadQuizzesPage(context, student, changedRecentQuiz);
                  } else if (type.compareTo("Grades") == 0) {
                    loadGradesPage(context, student);
                  } else if (type.compareTo("Help Center") == 0) {
                    loadHelpCenterPage(context, student);
                  }
              },
        ),
    );
  }
}

class StudentQuizzes extends StatelessWidget {
  final Function changedRecentQuiz;
  final Student student;
  StudentQuizzes({Key key, @required this.student, this.changedRecentQuiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quizzes"),
          backgroundColor: clr.color_1
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              //Spacer(flex: 3),
              Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: MaterialButton(
                    shape: StadiumBorder(),
                    textColor: clr.text_white,
                    color: clr.color_2,
                    child: Text('Biology'),
                    onPressed: () {
                      MongoDatabase.getCustomQuizzes(student.accessCode)
                          .then((quizL) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BiologyQuizListStudents(
                                  student: this.student, lq: quizL, pressChange: changedRecentQuiz)),
                        );
                      });
                    },
                  )),
            ])));
  }
}

class StudentClasses extends StatelessWidget {
  final Student student;
  StudentClasses({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Courses"),
          backgroundColor: clr.color_1
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      splashColor: clr.color_1)),
              //Spacer(flex: 3),
              for (var i = 0; i < student.enrolledClasses.length; i++)
                addContainer(context, student.enrolledClasses.elementAt(i))
            ])));
  }

  Container addContainer(context, String classEnrol) {
    return Container(
        height: 70,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: MaterialButton(
          shape: StadiumBorder(),
          textColor: clr.text_white,
          color: clr.color_1,
          child: Text(classEnrol),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StudentEachClassPage(nameClass: classEnrol)),
            );
          },
        ));
  }
}

class StudentGrades extends StatefulWidget {
  final Student student;
  final List<Map<String, dynamic>> lq;
  StudentGrades({Key key, @required this.student, @required this.lq})
      : super(key: key);

  @override
  _StudentGrades createState() => _StudentGrades(this.student, this.lq);
}

class gradeText extends StatelessWidget {
  ValueChanged<String> onChanged;
  List gOptions = ["H", "a", "L", "f"];
  String gSelected = "H";
  gradeText({this.gSelected, this.onChanged});

  void _handleTap() {
    print(gSelected);
    if (gSelected == "H") {
      onChanged(gSelected = "a");
    } else if (gSelected == "a") {
      onChanged(gSelected = "L");
    }
    else if(gSelected == "L"){
      onChanged(gSelected = "f");
    }
    else if(gSelected == "f"){
      onChanged(gSelected = "H");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: (gSelected == "H")
            ? Text("Highest Grade", textScaleFactor: 1.7)
            : (gSelected == "a") ? Text("Average Grade", textScaleFactor: 1.7)
            : (gSelected == "L") ? Text("Latest Grade", textScaleFactor: 1.7)
            : Text("First Attempt", textScaleFactor: 1.7),
        onPressed: _handleTap);
  }
}

class _StudentGrades extends State<StudentGrades> {
  final Student student;
  final List<Map<String, dynamic>> lq;
  _StudentGrades(this.student, this.lq);
  List gOptions = ["H", "a", "L", "f"];
  String gSelected = "H";

  void _handleGradeChanged(String newVal) {
    setState(() {
      gSelected = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> gradeL = student.grade;

    //make a map of quiz and attempts
    Map<String, int> qaqa = new Map<String, int>();
    //make a map of quiz and highest grades
    Map<String, int> qgqg = new Map<String, int>();
    //make a map of quiz and average grades
    Map<String, double> qag = new Map<String, double>();
    //make a map of quiz and latest grades
    Map<String, int> qLatest = new Map<String, int>();
    //make a map of quiz and first attempt grades
    Map<String, int> qFirst = new Map<String, int>();

    for (int i = 0; i < lq.length; i++) {
      qaqa.putIfAbsent(lq[i]['quiz_name'], () => 0);
      qgqg.putIfAbsent(lq[i]['quiz_name'], () => 0);
      qag.putIfAbsent(lq[i]['quiz_name'], () => 0);
      qLatest.putIfAbsent(lq[i]['quiz_name'], () => 0);
      qFirst.putIfAbsent(lq[i]['quiz_name'], () => 0);
    }

    for (int i = 0; i < gradeL.length; i++) {
      var templist = gradeL[i].keys.toList();
      for (int j = 0; j < templist.length; j++) {
        if (qaqa.containsKey(templist[j])) {
          //student took this quiz; find attempts
          int attempts = gradeL[i][templist[j]].length;
          qaqa.update(templist[j], (value) => attempts);

          //now update the highest grade
          int highestG = 0;
          int totalG = 0; //to calculate average grade
          int latestG = 0; //to acquire latest grade
          int firstG = 0; //to acquire first grade
          for (int k = 0; k < gradeL[i][templist[j]].length; k++) {
            int currGrade = gradeL[i][templist[j]][k];
            totalG += currGrade;
            if (k == 0) {
              firstG = currGrade;
            }
            if (currGrade > highestG) {
              highestG = currGrade;
            }
            if (k == (gradeL[i][templist[j]].length - 1)) {
              latestG = currGrade;
            }
          }
          //put in qFirst
          qFirst.update(templist[j], (value) => firstG);
          //put in qLatest
          qLatest.update(templist[j], (value) => latestG);
          //put into qgqg
          qgqg.update(templist[j], (value) => highestG);
          //put into qag
          qag.update(templist[j], (value) => double.parse(((totalG / attempts)).toStringAsFixed(2)));
          //add the number of questions for the quiz
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Grades"),
        backgroundColor: clr.color_1
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(student.username + "'s Grades",
                textScaleFactor: 2,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              // textDirection: TextDirection.rtl,
              // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              // border:TableBorder.all(width: 2.0,color: clr.color_2),
              children: [
                TableRow(children: [
                  Text(
                    "Item Name",
                    textScaleFactor: 1.7,
                  ),
                  Text("   Attempts", textScaleFactor: 1.7),
                  gradeText(
                    gSelected: this.gSelected,
                    onChanged: this._handleGradeChanged,
                  ),
                ])
              ],
            ),
          ),
          Column(
            children: <Widget>[
              for (int i = 0; i < lq.length; i++)
                Padding(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            lq[i]['quiz_name'],
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text("${qaqa[lq[i]['quiz_name']]}",
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: MaterialButton(
                              shape: StadiumBorder(),
                              textColor: clr.text_black,
                              color: Colors.green,
                              disabledColor: Colors.green,
                              child: (qaqa[lq[i]['quiz_name']] == 0)
                                  ? Text("Unattempted")
                                  : ((gSelected == "H") ? Text("${(qgqg[lq[i]['quiz_name']] * 100 / lq[i]['correct'].length).toStringAsFixed(2)} %")
                                      : (gSelected == "a") ? Text("${(qag[lq[i]['quiz_name']] * 100 / lq[i]['correct'].length).toStringAsFixed(2)} %")
                                      : (gSelected == "L") ? Text("${(qLatest[lq[i]['quiz_name']] * 100 / lq[i]['correct'].length).toStringAsFixed(2)} %")
                                      : Text("${(qFirst[lq[i]['quiz_name']] * 100 / lq[i]['correct'].length).toStringAsFixed(2)} %")),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class StudentEachClassPage extends StatelessWidget {
  final String nameClass;
  StudentEachClassPage({Key key, @required this.nameClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(nameClass),
          backgroundColor: clr.color_1
        ),
        body: Padding(
            padding: EdgeInsets.all(0),
            child: ListView(children: <Widget>[
              Container(
                child: new Text(
                  "",
                  textScaleFactor: 2.5,
                ),
              ),
              Container(
                  height: 26,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text('Announcements'),
                    splashColor: clr.background,
                    highlightedBorderColor: Colors.green,
                    onPressed: () {},
                  )),
              Container(
                  height: 110,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text(
                        'This is where teachers can put announcements '
                        'that are specific to their class.  We expect most of these '
                        'assignments to be reminders and such.'),
                    splashColor: clr.background,
                    highlightedBorderColor: Colors.green,
                    onPressed: () {},
                  )),
              Container(
                  height: 26,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text('Notifications'),
                    splashColor: clr.background,
                    highlightedBorderColor: Colors.green,
                    onPressed: () {},
                  )),
              Container(
                  height: 110,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text('This is where recent quizzes would go; '
                        'students would be able to know when something is '
                        'assigned or when a quiz has been graded through seeing'
                        'this text box.  This box will also direct them to '
                        'where they can see their grades.'),
                    splashColor: Colors.lightGreenAccent,
                    highlightedBorderColor: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentGrades()),
                      );
                    },
                  )),
              Container(
                  height: 26,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green,
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text('Upcoming Assignments'),
                    splashColor: clr.background,
                    highlightedBorderColor: Colors.green,
                    onPressed: () {},
                    color: Colors.green,
                  )),
              Container(
                  height: 110,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text('Here, due dates for assignments will be '
                        'displayed; this will allow students to quickly '
                        'understand and remember when their quizzes are due in '
                        'order to plan accordingly for this specific class.'),
                    splashColor: Colors.lightGreenAccent,
                    highlightedBorderColor: Colors.green,
                    color: Colors.green,
                    onPressed: () {},
                  )),
              Container(
                  height: 26,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text('Contact Information'),
                    splashColor: clr.background,
                    onPressed: () {},
                  )),
              Container(
                  height: 90,
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: OutlineButton(
                    textColor: clr.text_black,
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 3.5, //width of the border
                    ),
                    child: new Text(
                        'Here, teachers can put their contact information'
                        'so students are able to contact them if needed.  We expect teachers '
                        'to put their emails and the hours they will be able to answer questions here.'),
                    splashColor: Colors.lightGreenAccent,
                    highlightedBorderColor: Colors.green,
                    onPressed: () {},
                  )),
            ])));
  }
}

class AccessCode extends StatelessWidget {
  final Student student;
  final TextEditingController codeController = TextEditingController();
  AccessCode(this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Access Code'), backgroundColor: clr.color_1),
      body: Center(
        child: ListView(children: <Widget>[
          new Padding(padding: EdgeInsets.all(125)),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: codeController,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Access Code Here',
              ),
            ),
          ),
          Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: MaterialButton(
                textColor: clr.text_white,
                color: clr.color_1,
                child: Text('Submit'),
                onPressed: () {
                  if (student.accessCode != "") {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Access Code already generated."),
                      ),
                    );
                  } else {
                    student.accessCode = codeController.text.toString();
                    MongoDatabase.checkAccessCode(student.accessCode)
                        .then((varTF) {
                      if (student != null && varTF) {
                        MongoDatabase.updateAccessCode(
                            student.accessCode, null, student.username);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentDashboard(student: student)),
                        );
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Please input the correct Access Code"),
                          ),
                        );
                      }
                    });
                  }
                },
              )),
        ]),
      ),
    );
  }
}

class DisplayCode extends StatefulWidget {
  final Student student;
  DisplayCode(this.student);

  @override
  AccessCodeInput createState() => AccessCodeInput(student);
}

class AccessCodeInput extends State<DisplayCode> {
  final TextEditingController codeController = TextEditingController();
  final Student student;
  AccessCodeInput(this.student);
  bool acNotEmpty = false;

  checkAc() {
    setState(() {
      if (student.accessCode == "") {
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
                color: clr.color_2,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 10),
                    color: clr.color_2.withOpacity(0.5),
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
                          student.accessCode,
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
          ),
    );
  }
}

List<String> createListOfDueDates(Student stud, List<dynamic> ql) {
  List<String> assignedQuizzes = new List();
  print("now: ${DateTime.now()}");
  if (ql == null) return assignedQuizzes;
  for (int i = 0; i < ql.length; i++) {
    if (ql[i]['dueDate'] == null) continue;
    if (DateTime.now().isBefore(ql[i]['dueDate'])) {
      assignedQuizzes.add(ql[i]['quiz_name']);
    }
  }
  return assignedQuizzes;
}
