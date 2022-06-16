
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:encrypt/encrypt.dart' as K;
import 'package:BIOL/src/models/colortheme.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'StudentDashboard.dart';

var clr = AppColors();

// padding constants - change as needed
const double topPadding = 15.0;
const double imagePadding = 20.0;
const double paddingBetweenAnswers = 5.0;
const double paddingExitQuiz = 20.0;

// answer choices height & width
const double buttonHeight = 80.0;
const double buttonWidth = 500.0;

int finalScore = 0;     // stores the student's score on quiz
int questionNumber = 0; // stores the current question number (NOT ACTUAL INDEX)

class StudentQuizView extends StatefulWidget{

  final QuizModel quiz;
  final Student student;

  int endTime;
  StudentQuizView({Key key, @required this.quiz, @required this.student, endTime}) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    return new StudentQuizViewState(quiz: this.quiz, student: this.student, endTime: this.endTime);
  }
}

class StudentQuizViewState extends State<StudentQuizView> {

  final QuizModel quiz;
  final Student student;
  int endTime;

  List<String> questionsQ;
  List<List<String>> answersQ;
  List<String> correctQ;
  List<int> indexer;

  StudentQuizViewState({Key key, @required this.quiz, @required this.student, this.endTime}) {
    // convert all of the dynamic arrays into String arrays - I believe dynamic
    // arrays were why the randomized questions weren't correctly displayed
    questionsQ = quiz.questions.cast<String>();
    answersQ = List.generate(questionsQ.length, (i) => List<String>.filled(4, "", growable: false));
    for(int i = 0; i < questionsQ.length; i++) {
      answersQ[i] = quiz.answers[i].cast<String>();
      answersQ[i].shuffle();    // shuffle answer choices in here!
    }
    correctQ = quiz.correct.cast<String>();

    // also create a random indexer - shuffle for randomization
    indexer = List.filled(questionsQ.length, 0);
    for(int i = 0; i < questionsQ.length; i++) {
      indexer[i] = i;
    }
    indexer.shuffle();
    print(endTime);
  }

  //timer setup


  @override
  Widget build(BuildContext context) {

    if (quiz.timer != null && quiz.timer != 0) endTime = DateTime.now().millisecondsSinceEpoch + quiz.timer * 1000;
    return new WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(

        body: new Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: new ListView(
            children: <Widget>[
              //timer
              (quiz.timer != null && quiz.timer != 0) ?
              CountdownTimer(
                endTime: endTime,
                onEnd: () {
                  //alert
                  TimeUp(context, student, finalScore, quiz);
                },
                widgetBuilder: (_, CurrentRemainingTime time) {
                  if (time == null) {
                    return Text('Done');
                  }
                  if (time.days == null) {
                    if (time.hours == null) {
                      if (time.min == null) {
                        return Text('Timer: ${time.sec}');
                      } else {
                        //there's min
                        return Text('Timer: ${time.min}:${time.sec}');
                      }
                    } else {
                      //there's hours
                      return Text('Timer: ${time.hours}:${time.min}:${time.sec}');
                    }
                  } else {
                    return Text(
                        'Timer: ${time.days}:${time.hours}:${time.min}:${time.sec}'
                    );
                  }
                },
              ) : Text(''),

              new Padding(padding: EdgeInsets.all(topPadding)),

              new Container(
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Text("Question ${questionNumber + 1} of ${questionsQ.length}",
                      style: new TextStyle(
                      fontSize: 22.0,
                      ),
                    ),

                    new Padding(padding : EdgeInsets.all(35.0)),

                    new Image.asset(
                        "images/BIOL_LOGO_128x62.png",
                    ),
                  ],
                ),
              ),

              new Padding(padding : EdgeInsets.all(imagePadding)),

              new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    height: 50,
                    alignment : Alignment.center,
                    child : (
                        new Text(questionsQ[indexer[questionNumber]].toString(),
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20,
                          ),
                        )
                    ),
                  ),

                  new Padding(padding : EdgeInsets.all(20)),

                  //button 1
                  new MaterialButton(
                      minWidth: buttonWidth,
                      height: buttonHeight,
                      color: clr.color_2,
                      onPressed: () {
                        String ans = answersQ[indexer[questionNumber]][0];
                        if(ans == correctQ[indexer[questionNumber]]) {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                    child: new Text(answersQ[indexer[questionNumber]][0],
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center),
                  ),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  //button 2
                new MaterialButton(
                    minWidth: buttonWidth,
                    height: buttonHeight,
                    color: clr.color_2,
                    onPressed: () {
                      String ans = answersQ[indexer[questionNumber]][1];
                      if(ans == correctQ[indexer[questionNumber]]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(answersQ[indexer[questionNumber]][1],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                        textAlign: TextAlign.center),
                  ),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  //button 3
                  new MaterialButton(
                    minWidth: buttonWidth,
                    height: buttonHeight,
                    color: clr.color_2,
                    onPressed: () {
                      String ans = answersQ[indexer[questionNumber]][2];
                      if(ans == correctQ[indexer[questionNumber]]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(answersQ[indexer[questionNumber]][2],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                        textAlign: TextAlign.center),
                  ),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

              //button 4
                  new MaterialButton(
                    minWidth: buttonWidth,
                    height: buttonHeight,
                    color: clr.color_2,
                    onPressed: () {
                      String ans = answersQ[indexer[questionNumber]][3];
                      if(ans == correctQ[indexer[questionNumber]]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(answersQ[indexer[questionNumber]][3],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                        textAlign: TextAlign.center),
                  ),
                  new Padding(padding: EdgeInsets.all(paddingExitQuiz)),

              new Container(
                alignment: Alignment.bottomCenter,
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  color: clr.color_1,
                  minWidth: 120,
                  height: 50,
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("Exit Quiz?"),
                      content: Text("Are you sure you want to exit?\nAll progress will be lost."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel")
                        ),

                        TextButton(
                          onPressed: () => resetQuiz(),
                          child: Text("Exit")
                        )
                      ]
                    )
                  ),
                  child: new Text("Exit Quiz",
                    style: new TextStyle(
                      fontSize:  18.0,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    ));
  }

  // this constitutes two pops that reset the score and question number
  void resetQuiz() {
    setState(() {
      finalScore = 0;
      questionNumber = 0;
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  // this constitutes a single pop that resets the score and question number
  void quitQuiz() {
    setState(() {
      finalScore = 0;
      questionNumber = 0;
      Navigator.pop(context);
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == questionsQ.length - 1) {
        pushGrade(finalScore, student.emailId, quiz.quizName);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new Summary(score: finalScore, name: student.username, student: student, quizName: quiz.quizName)));
      } else {
        questionNumber++;
      }
    });
  }
}

void pushGrade(int grade, String email, String quizName) async {
  await MongoDatabase.updateGrade(grade,email, quizName);
}

class Summary extends StatelessWidget{
  final int score;
  final String name;
  final Student student;
  final String quizName;
  Summary({Key key, @required this.score, @required this.name, @required this.student, this.quizName}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(
        body: new Container(
          child: Align(
            alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(name + "'s Final Score: ${(score * 100 / (questionNumber + 1)).round()}%",
              style: new TextStyle(
                fontSize: 25.0
              ),),

              new Padding(padding: EdgeInsets.all(10.0)),

              new MaterialButton(
                color: clr.color_1,
                onPressed: (){
                  student.recentQuiz = quizName;
                  questionNumber = 0;
                  finalScore = 0;
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  String passE = student.password;
                  print(passE);
                  print(student.emailId);

                },
                child: new Text("Exit Quiz",
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),),
      ),
    );
  }
}

TimeUp(BuildContext context, Student student, int finalScore, QuizModel quiz) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      pushGrade(finalScore, student.emailId, quiz.quizName);
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new Summary(score: finalScore, name: student.username, student: student, quizName: quiz.quizName)));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Time's Up"),
    content: Text("Time's up for the quiz!"),
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
