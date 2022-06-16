import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Teacher View/TeacherEditView1.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

// padding constants - change as needed
const double topPadding = 15.0;
const double imagePadding = 5.0;
const double paddingBetweenAnswers = 5.0;

// answer choices height & width
const double buttonHeight = 60.0;
const double buttonWidth = 500.0;

// global - need to be passed to summary page
var finalScore = 0;
var questionNumber = 0;

class TeacherQuizView extends StatefulWidget{
  final QuizModel quiz;
  final Teacher teacher;

  TeacherQuizView({Key key, @required this.quiz,  @required this.teacher}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new TeacherQuizViewState(quiz: this.quiz, teacher: this.teacher);
  }
}

class TeacherQuizViewState extends State<TeacherQuizView> {

  // local variables - filled in build()
  final QuizModel quiz;
  DateTime dueDate = DateTime.now();  // preset to the current time - will set later
  var questionsQ;
  var answersQ;
  var correctQ;
  var code;
  final Teacher teacher;

  TeacherQuizViewState({Key key, @required this.quiz,  @required this.teacher});

  @override
  Widget build(BuildContext context) {
    questionsQ = quiz.questions;
    answersQ = quiz.answers;
    correctQ = quiz.correct;
    code = quiz.accessCode;

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: new Column(
            children: <Widget>[

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
                        new Text(questionsQ[questionNumber].toString(),
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20,
                          ),
                        )
                    ),
                  ),

                  new Padding(padding : EdgeInsets.all(10)),

                  getAnswerButton(0),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  getAnswerButton(1),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  getAnswerButton(2),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  getAnswerButton(3),

                  new Padding(padding: EdgeInsets.all(10)),

                  new Text("Correct Answer:",
                    style: new TextStyle(
                    fontSize: 20,
                    ),
                  ),
                  new Container(
                      height: 50,
                      alignment : Alignment.center,
                      child : (
                        new Text(correctQ[questionNumber].toString(),
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                          fontSize: 16.0,
                          ),)
                      )
                  ),

              new Padding(padding: EdgeInsets.all(5.0)),

              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  new MaterialButton(
                    color: clr.color_1,
                    minWidth: 100.0,
                    height: 30.0,
                    onPressed: () {
                      revertQuestion();
                    },
                    child: new Text("Back",
                      style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.white
                      ),),
                  ),


                  new MaterialButton(
                    color: clr.color_1,
                    minWidth: 100.0,
                    height: 30.0,
                    onPressed: () {
                      updateQuestion();
                    },
                    child: new Text("Next",
                      style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.white
                      ),),
                  ),
                ],
              ),

              if(quiz.accessCode != null)
              new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.bottomCenter,
                      child: new MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        color: clr.color_2,
                        minWidth: 150.0,
                        height: 30.0,
                        onPressed: (){
                          if(teacher != null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherEditView(quiz: quiz, teacher: teacher)),
                          );}
                          else{
                          }
                          },
                        child: teacher != null?new Text("Edit Quiz",
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                          ),
                        ): new Text("Student",
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),

                    new Container(
                      alignment: Alignment.bottomCenter,
                      child: new MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        color: clr.color_2,
                        minWidth: 150.0,
                        height: 30.0,
                        onPressed: (){
                          if(teacher != null){
                            DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(const Duration(days: 365)),
                                onChanged: (date) {
                                  dueDate = date;
                                },
                                onConfirm: (date) {
                                  dueDate = date;
                                  print(dueDate.timeZoneOffset);
                                  MongoDatabase.setDueDate(quiz.quizName, dueDate);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                          }
                          else {}
                          },
                        child: teacher != null?new Text("Set Due Date", style: new TextStyle(fontSize: 18.0, color: Colors.white),)
                            :new Text("View", style: new TextStyle(fontSize: 18.0, color: Colors.white),),
                      ),
                    )
                  ]
              ),

              new Container(
                alignment: Alignment.bottomCenter,
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  color: clr.color_1,
                  minWidth: 240.0,
                  height: 30.0,
                  onPressed: resetQuiz,
                  child: new Text("Quit",
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white
                    ),
                  ),
                ),
              ),

            ],
          ),
        ]
        ),
      ),
    ));
  }

  MaterialButton getAnswerButton(int index) {
    return new MaterialButton(
      minWidth: buttonWidth,
      height: buttonHeight,
      color: clr.color_2,
      onPressed: () {},
      child: new Text(answersQ[questionNumber][index],
          style: new TextStyle(
              fontSize: 16.0,
              color: Colors.white
          ),
          textAlign: TextAlign.center),
    );
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void revertQuestion() {
    setState(() {
      if (questionNumber == 0) {
      } else {
        questionNumber--;
      }
    });
  }


  void updateQuestion() {
    setState(() {
      if (questionNumber == questionsQ.length - 1) {
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatelessWidget{
  final int score;
  Summary({Key key, @required this.score}) : super(key : key);

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
                new Text("Final Score: ${(score * 100 / (questionNumber + 1)).round()}%",
                  style: new TextStyle(
                      fontSize: 25.0
                  ),),

                new Padding(padding: EdgeInsets.all(10.0)),

                new MaterialButton(
                  color: clr.color_1,
                  onPressed: (){
                    questionNumber = 0;
                    finalScore = 0;
                    Navigator.pop(context);
                  },
                  child: new Text("Reset Quiz",
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