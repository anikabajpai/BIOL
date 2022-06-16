import 'package:BIOL/Collection%20Classes/Teacher.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:BIOL/Teacher View/TeacherQuizView.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

// padding constants - change as needed
const double topPadding = 15.0;
const double imagePadding = 5.0;
const double paddingBetweenAnswers = 5.0;

// answer choices height & width
const double buttonHeight = 60.0;
const double buttonWidth = 500.0;

var finalScore = 0;
var questionNumber = 0;

class TeacherEditView extends StatefulWidget{
  final QuizModel quiz;
  final Teacher teacher;

  final quizNameController = TextEditingController();

  TeacherEditView({Key key, @required this.quiz, @required this.teacher}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new TeacherEditViewState(quiz: this.quiz, teacher:this.teacher);
  }
}

class TeacherEditViewState extends State<TeacherEditView> {

  final QuizModel quiz;
  final Teacher teacher;
  var quizName;
  var questionsQ;
  var answersQ;
  var correctQ;
  String ac;

  TeacherEditViewState({Key key, @required this.quiz,  @required this.teacher});

  @override
  Widget build(BuildContext context) {
    quizName = quiz.quizName;
    questionsQ = quiz.questions;
    answersQ = quiz.answers;
    correctQ = quiz.correct;
    ac = quiz.accessCode;

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: new ListView(
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
                  new TextFormField(
                      controller: TextEditingController(text: questionsQ[questionNumber].toString()),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter question...'
                      ),
                      onChanged: (String str) {
                        questionsQ[questionNumber] = str;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter question...';
                        }
                        return null;
                      }
                  ),

                  new Padding(padding : EdgeInsets.all(10)),

                  getTextFormField(0),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  getTextFormField(1),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  getTextFormField(2),

                  new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                  getTextFormField(3),

                  new Padding(padding: EdgeInsets.all(10)),

                  new Text("Correct Answer:",
                    style: new TextStyle(
                    fontSize: 20,
                    ),
                  ),

                  new TextFormField(
                      controller: TextEditingController(text: correctQ[questionNumber].toString()),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter correct answer...'
                      ),
                      onChanged: (String str) {
                        correctQ[questionNumber] = str;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter correct answer...';
                        }
                        return null;
                      }
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

                  new Padding(padding: EdgeInsets.all(5.0)),

                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      new MaterialButton(
                        color: clr.color_2,
                        minWidth: 100.0,
                        height: 30.0,
                        onPressed:(){removeQuestion(quizName,  questionsQ[questionNumber], answersQ[questionNumber],  correctQ[questionNumber].toString(), questionNumber);
                        resetQuiz();
                        resetQuiz();
                        },
                        child: new Text("Delete Question",
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                          ),),
                      ),


                      new MaterialButton(
                        color: clr.color_2,
                        minWidth: 100.0,
                        height: 30.0,
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TeacherAddQuestion(quiz: quiz)),
                        );},
                        child: new Text("Add Question",
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                          ),),
                      ),
                    ],
                  ),

                  new Padding(padding: EdgeInsets.all(5.0)),

                  new Container(
                    alignment: Alignment.bottomCenter,
                    child: new MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      color: clr.color_1,
                      minWidth: 240.0,
                      height: 30.0,
                      onPressed: (){
                        alterQuiz(quizName, questionsQ, answersQ, correctQ, ac);
                        resetQuiz();
                        resetQuiz();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TeacherQuizView(quiz: quiz, teacher: teacher)),
                        );
                      },
                      child: new Text("Submit Changes",
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
                  color: clr.color_1,
                  minWidth: 240.0,
                  height: 30.0,
                  onPressed: resetQuiz,
                  child: new Text("Back to Quiz",
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

  TextFormField getTextFormField(int index) {
    return new TextFormField(
        controller: TextEditingController(text: answersQ[questionNumber][index].toString()),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter answer option...'
        ),
        onChanged: (String str) {
          answersQ[questionNumber][index] = str;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter answer option...';
          }
          return null;
        }
    );
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  removeQuestion(String quizName, String questionsN, List<dynamic> answersN, String correctN, int questionNumber) async{
    await MongoDatabase.removeQuestion(quizName, questionsN, answersN, correctN, questionNumber);
  }

  alterQuiz(String quizName, List<dynamic> questions, List<List<dynamic>> answers, List<dynamic> correct, String accessCode) async {
    final quiz = QuizModel(
        id: M.ObjectId(),
        quizName: quizName,
        questions: questions,
        answers: answers,
        correct: correct,
        accessCode: accessCode
    );

   await MongoDatabase.updateQuiz(quiz, quizName);
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

class TeacherAddQuestion extends StatefulWidget{
  final QuizModel quiz;
  final quizNameController = TextEditingController();

  TeacherAddQuestion({Key key, @required this.quiz}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new TeacherAddQuestionState(quiz: this.quiz);
  }
}

class TeacherAddQuestionState extends State<TeacherAddQuestion> {

  final QuizModel quiz;
  var questionsQ;

  String quizName;
  String questionsN;
  List<String> answersN = ["", "", "", ""];
  String correctN;
  String ac;

  TeacherAddQuestionState({Key key, @required this.quiz});

  @override
  Widget build(BuildContext context) {
    quizName = quiz.quizName;
    questionsQ = quiz.questions;
    ac = quiz.accessCode;

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
                            new Text("Question ${questionsQ.length+1} of ${questionsQ.length+1}",
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
                            new TextFormField(
                                controller: TextEditingController(),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter question...'),
                                onChanged: (String str) { questionsN = str; },
                                validator: (value) { if (value.isEmpty) {
                                  return 'Enter question...';
                                }
                                return null;
                                }),

                            new Padding(padding: EdgeInsets.all(10)),

                            new TextFormField(
                                controller: TextEditingController(),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter answer option...'),
                                onChanged: (String str) {
                              answersN[0] = str;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter answer option...';
                              }
                              return null;
                            }),

                            new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                            new TextFormField(
                            controller: TextEditingController(),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter answer option...'),
                            onChanged: (String str) {
                              answersN[1] = str;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter answer option...';
                              }
                              return null;
                            }),

                            new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                            new TextFormField(
                            controller: TextEditingController(),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter answer option...'),
                            onChanged: (String str) {
                              answersN[2] = str;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter answer option...';
                              }
                              return null;
                            }),

                            new Padding(padding: EdgeInsets.all(paddingBetweenAnswers)),

                            new TextFormField(
                            controller: TextEditingController(),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter answer option...'),
                            onChanged: (String str) {
                              answersN[3] = str;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter answer option...';
                              }
                              return null;
                            }),

                            new Padding(padding: EdgeInsets.all(10)),

                            new Text("Correct Answer:",
                              style: new TextStyle(
                                fontSize: 20,
                              ),
                            ),

                            new Padding(padding: EdgeInsets.all(5.0)),

                            new TextFormField(
                            controller: TextEditingController(),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter correct answer...'),
                            onChanged: (String str) {
                              correctN = str;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter correct answer...';
                              }
                              return null;
                            }),
                          ]),

                      new Padding(padding: EdgeInsets.all(10.0)),

                      new Container(
                        alignment: Alignment.bottomCenter,
                        child: new MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: clr.color_1,
                          minWidth: 240.0,
                          height: 30.0,
                          onPressed: () {
                            appendQuestion(quizName, questionsN, answersN, correctN);
                            resetQuiz();
                            resetQuiz();
                            resetQuiz();
                            },
                          child: new Text("Submit New Question",
                            style: new TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),

                      new Container(
                        alignment: Alignment.bottomCenter,
                        child: new MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          color: clr.color_1,
                          minWidth: 240.0,
                          height: 30.0,
                          onPressed: resetQuiz,
                          child: new Text("Back to Quiz",
                            style: new TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ]
                ))));
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  appendQuestion(String quizName, String questionsN, List<String> answersN, String correctN) async {
    await MongoDatabase.addQuestion(quizName, questionsN, answersN, correctN);
  }
}