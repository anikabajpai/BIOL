import 'package:BIOL/src/models/colortheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:BIOL/Collection%20Classes/Student.dart';
import 'package:BIOL/Collection%20Classes/Teacher.dart';
import 'package:BIOL/Teacher%20View/TeacherDashboard.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Teacher View/TeacherQuizView.dart';
import 'package:BIOL/Student View/StudentQuizView.dart';
import 'package:BIOL/Student View/StudentDashboard.dart';
var clr = AppColors();

// padding constants - change as needed
const double topPadding = 15.0;
const double EnterQuizPadding = 30.0;
const double paddingBetweenAnswers = 5.0;

// answer choices height & width
const double buttonHeight = 60.0;
const double buttonWidth = 500.0;

class QuizFrontCover extends StatefulWidget{
  final Function pressChange;
  final QuizModel quiz;
  final Student student;
  final Teacher teacher;
  final int numberOfAttempts;

  QuizFrontCover({Key key, @required this.quiz, @required this.student, @required this.teacher, @required this.numberOfAttempts, this.pressChange}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new QuizFrontCoverState(pressChange: this.pressChange, quiz: this.quiz, student: this.student, teacher: this.teacher, numberOfAttempts: this.numberOfAttempts);
  }
}

passedDueDateAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cannot enter Quiz"),
    content: Text("Quiz Due Date has Passed"),
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

attemptsAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cannot enter Quiz"),
    content: Text("All Attempts have been used"),
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

class QuizFrontCoverState extends State<QuizFrontCover> {

  // local variables - filled in build()
  final Function pressChange;
  final QuizModel quiz;
  Student student;
  Teacher teacher;
  var recentlyViewedQuiz;
  int numberOfAttempts;

  QuizFrontCoverState({Key key, @required this.quiz, @required this.student, @required this.teacher, @required this.numberOfAttempts, this.pressChange});

  @override
  Widget build(BuildContext context) {

    //format the timer
    Duration _duration;
    if (quiz.timer != null && quiz.timer != 0)
      _duration = new Duration(seconds: quiz.timer);
    else _duration = null;

    return Scaffold(
        appBar: AppBar(
          title: Text(quiz.quizName, style: new TextStyle( fontSize: 18.0, color: Colors.white),),
          backgroundColor: clr.color_1,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(10)),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: student==null?new Text("Enter Quiz", style: new TextStyle( fontSize: 18.0, color: Colors.white),)
                            : new Text("Start Quiz!", style: new TextStyle( fontSize: 18.0, color: Colors.white),),
                        onPressed: () {

                          if (teacher == null)
                          {
                            addRecentQuiz(student.username, quiz.quizName);
                          }

                          if(quiz.accessCode == null){

                            if(teacher == null)
                            {
                              pressChange(quiz.quizName);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StudentQuizView(quiz: quiz, student: student, endTime: 0)));
                            }
                            if(student == null)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TeacherQuizView(quiz: quiz, teacher: teacher)),
                              );
                            }
                          }

                          else {

                            if (teacher == null && DateTime.now().isBefore(quiz.dueDate) && numberOfAttempts < quiz.attempts) {
                              print("before due date");
                              int endTime = DateTime.now().second + this.quiz.timer;
                              print('endtime: $endTime');
                              pressChange(quiz.quizName);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      StudentQuizView(
                                          quiz: quiz, student: student, endTime: endTime)));

                            } else if (teacher == null && DateTime.now().isAfter(quiz.dueDate)) {
                              passedDueDateAlert(context);

                            }

                            if (teacher == null && numberOfAttempts >= quiz.attempts) {
                              attemptsAlert(context);
                            }

                            if (student == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    TeacherQuizView(quiz: quiz, teacher: teacher)),
                              );
                            }
                          }
                        },
                      )),

                  new Padding(padding : EdgeInsets.all(15.0)),

                  new Container(
                    alignment: Alignment.bottomCenter,
                    child: new MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)
                      ),
                      color: clr.color_1,
                      minWidth: 240.0,
                      height: 40.0,
                      onPressed: () {
                        if(student==null && quiz.accessCode!=null) {
                          removeQuiz(quiz.quizName);
                          exitQuiz();
                          exitQuiz();
                        }
                        else if (student!=null && quiz.accessCode==null){
                          print(quiz.accessCode);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherQuizView(quiz: quiz, teacher: teacher)),
                          );
                        }
                        else if  (quiz.open == true){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherQuizView(quiz: quiz, teacher: teacher)),
                          );
                        }
                        else if(student != null){
                          print(quiz.accessCode);
                        }
                        else{
                          print(quiz.accessCode);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherQuizView(quiz: quiz, teacher: teacher)),
                          );
                        }
                      },
                      child: (student==null && quiz.accessCode!=null)?new Text("Delete Quiz", style: new TextStyle( fontSize: 18.0, color: Colors.white),)
                          : (student!=null && quiz.accessCode==null) || (quiz.open == true) ? new Text("Review Mode", style: new TextStyle( fontSize: 18.0, color: Colors.white),)
                          : student != null ? new Text("Best of Luck!", style: new TextStyle( fontSize: 18.0, color: Colors.white),)
                          : new Text("Review Mode", style: new TextStyle( fontSize: 18.0, color: Colors.white),),
                    ),
                  ),

                  new Padding(padding : EdgeInsets.all(20.0)),

                  TextButton(
                      onPressed: ()
                      {
                        if(student==null && quiz.accessCode!=null && quiz.open == false) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text("Enable Review?"),
                                  content: Text("Are you sure you want students to be able to review the quiz?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel")
                                    ),

                                    TextButton(
                                        onPressed: ()
                                        {
                                        openForRev(quiz.quizName, true);
                                        exitQuiz();
                                        exitQuiz();
                                        },
                                        child: Text("Open for Student Review")
                                    )
                                  ]
                              )
                          );

                        }
                        else if (student!=null && quiz.open == false){
                        }
                        else if(student != null){
                        }
                        else{
                        }
                      },
                    child: (student==null && quiz.accessCode!=null && quiz.open == false)?new Text("Tap to enable Student Review", style: new TextStyle( fontSize: 20.0, color: Colors.black),)
                        : (student!=null && quiz.open == false) ? new Text("Student Review Disabled", style: new TextStyle( fontSize: 20.0, color: Colors.black),)
                        : (student==null  && quiz.open == true) ? new Text("Student Review Enabled", style: new TextStyle( fontSize: 20.0, color: Colors.black),)
                        :new Text("Student Review Enabled", style: new TextStyle( fontSize: 20.0, color: Colors.black),),
                  ),


                  new Padding(padding : EdgeInsets.all(20.0)),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                          shape: StadiumBorder(),
                          textColor: Colors.white,
                          color: clr.color_2,

                          child: new Text('Back to Dashboard'),

                          onPressed: ()
                          {
                            if (teacher == null) {
                              MongoDatabase.studentUpdate(student.emailId)
                                  .then((stud) {
                                //stud == null ? print("Im null") : print(
                                //"Not null");
                                Student s = new Student(
                                    id: stud["_id"],
                                    username: stud["name"],
                                    emailId: stud['email'],
                                    password: stud["password"],
                                    grade: stud["grade"],
                                    accessCode: stud["accessCode"],
                                    alias: stud["alias"],
                                    image: stud["image"],
                                    recentQuiz: stud["recentQuiz"],
                                    completedQuizzes: null,
                                    viewedQuizzes: null,
                                    percentageCorrect: 0.0,
                                    percentageWrong: 0.0);

                                MongoDatabase.getCustomQuizzes(s.accessCode)
                                    .then((quizL) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          StudentDashboard(
                                              student: s, ql: quizL))
                                  );
                                });
                              });
                            }
                            if (student == null)
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TeacherDashboard(teacher: teacher)),
                                );
                              }
                        })),

                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                      child: quiz.attempts != null && teacher == null? Text('Total Attempts Remaining: ' + (quiz.attempts - numberOfAttempts).toString(),
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),):
                      quiz.attempts != null && student == null? Text('Total Attempts Allowed: ' + (quiz.attempts).toString(),
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),):
                      Text('Total Attempts Allowed: Unlimited', softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),) //want it to do nothing
                  ),

                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                      child: quiz.dueDate != null ? Text('Due date: ' + DateFormat.yMd().add_jm().format(quiz.dueDate.toLocal()).toString(),
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),):
                        Text('') //want it to do nothing
                  ),
                  new Padding(padding : EdgeInsets.all(15.0)),

                  new Container(
                    child: (_duration == null) ? Text(
                        "There is no timer for this quiz.",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                    ) :
                    Text(
                        "Time limit: ${_duration.inHours}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                    alignment: Alignment.center,
                    ),

                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                      child: quiz.dueDate == null ? Text(''): DateTime.now().isBefore(quiz.dueDate) ? Text('Open', //where text is none, I want it to do nothing
                        softWrap: true,
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 24),)

                        : Text('Closed',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 24),)
                  ),
                ])));
  }

  void exitQuiz() {
    setState(() {
      Navigator.pop(context);
    });
  }

  removeQuiz(String quizName) async{
    await MongoDatabase.removeQuiz(quizName);
  }

  openForRev(String quizName, bool ofr) async {
    await MongoDatabase.updateOfr(quizName, ofr);
  }

  addRecentQuiz(String studentN, String quizName) async {
    await MongoDatabase.addRecentlyViewedQuiz(studentN, quizName);
  }

}