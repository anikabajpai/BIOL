import 'package:BIOL/Shared%20View%20(Sign%20Up,%20Login,%20Help%20Center,%20etc)/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:duration_picker/duration_picker.dart';

// padding values - can be changed if needed
const double topPadding = 15.0;             // between top and question number/image row
const double imagePadding = 10.0;           // between image and question
const double paddingBetweenAnswers = 5.0;   // between answer choice buttons
const double paddingExitQuiz = 10.0;        // between last answer choice and exit quiz button

// answer choices height & width
const double buttonHeight = 80.0;
const double buttonWidth = 500.0;

int timer = 0;

class CreateQuiz extends StatefulWidget {
  final Teacher teacher;
  final int numQuestions;

  CreateQuiz({Key key, @required this.teacher, @required this.numQuestions}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CreateQuizState(teacher: this.teacher, numQuestions: this.numQuestions);
  }
}

class CreateQuizState extends State<CreateQuiz> {
  final teacher;
  final numQuestions;

  final quizNameController = TextEditingController();
  final attemptsController = TextEditingController();

  // initialize local variables
  int questionNumber = 0;   // which question we are currently viewing
  int selected = 1;         // which radio button (correct answer) is selected
  List<String> questions;   // stores all questions
  List<List<String>> answers; // stores all answers
  List<int> correct;        // stores index of correct answer
  List<String> correctStr;  // stores correct answer as text
  String quizName;          // stores name of the quiz
  int attempts; // stores number of attempts
  DateTime dueDate; //due date
  bool oFR = false; //open for review - default set to false
  Duration _duration = Duration(hours: 0, minutes: 0);

  CreateQuizState({Key key, @required this.teacher, @required this.numQuestions}) {
    // initialize all questions and answers as blank string arrays
    questions = List<String>.filled(numQuestions,"", growable: true);
    answers = List.generate(numQuestions, (_) => List<String>.filled(4, "", growable: false));
    for(int i = 0; i < numQuestions; i++) {
      for(int j = 0; j < 4; j++) {
        answers[i][j] = "";
      }
    }
    correct = List<int>.filled(numQuestions,0, growable: true);
    correctStr = List<String>.filled(numQuestions, "", growable: true);
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: new Container(
              margin: const EdgeInsets.all(10.0),
              alignment: Alignment.topCenter,
              child: new ListView(
                children: <Widget>[

                  new Container(
                    alignment: Alignment.centerRight,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Question ${questionNumber + 1} of $numQuestions",
                          style: new TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                        new Image.asset(
                          "images/BIOL_LOGO_128x62.png",
                        ),
                      ],
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(imagePadding)),

                  new Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new TextFormField(
                        controller: TextEditingController(text: questions[questionNumber]),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter question...'
                        ),
                        onChanged: (String str) {
                          questions[questionNumber] = str;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter question...';
                          }
                          return null;
                        }
                      ),

                      new Padding(padding: EdgeInsets.all(20)),

                      new TextFormField(
                        controller: TextEditingController(text: answers[questionNumber][0]),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter answer choice 1...'
                          ),
                        onChanged: (String str) {
                          answers[questionNumber][0] = str;
                        },
                      ),

                      new Padding(
                          padding: EdgeInsets.all(paddingBetweenAnswers)),

                      new TextFormField(
                          controller: TextEditingController(text: answers[questionNumber][1]),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter answer choice 2...'
                          ),
                        onChanged: (String str) {
                          answers[questionNumber][1] = str;
                        },
                      ),

                      new Padding(
                          padding: EdgeInsets.all(paddingBetweenAnswers)),

                      new TextFormField(
                          controller: TextEditingController(text: answers[questionNumber][2]),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter answer choice 3...'
                          ),
                        onChanged: (String str) {
                          answers[questionNumber][2] = str;
                        },
                      ),

                      new Padding(
                          padding: EdgeInsets.all(paddingBetweenAnswers)),

                      new TextFormField(
                          controller: TextEditingController(text: answers[questionNumber][3]),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter answer choice 4...'
                          ),
                        onChanged: (String str) {
                          answers[questionNumber][3] = str;
                        },
                      ),

                      new Padding(padding: EdgeInsets.all(paddingExitQuiz)),

                      new Text("Correct Answer:",
                        style: new TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text('1'),
                              Radio(
                                  value: 0,
                                  groupValue: correct[questionNumber],
                                  onChanged: (int value) {
                                    setState(() {
                                      correct[questionNumber] = value;
                                      }
                                      );
                                    },
                              )
                            ]
                          ),
                          Row(
                              children: [
                                Text('2'),
                                Radio(
                                  value: 1,
                                  groupValue: correct[questionNumber],
                                  onChanged: (int value) {
                                    setState(() {
                                      correct[questionNumber] = value;
                                    }
                                    );
                                  },
                                )
                              ]
                          ),
                          Row(
                              children: [
                                Text('3'),
                                Radio(
                                  value: 2,
                                  groupValue: correct[questionNumber],
                                  onChanged: (int value) {
                                    setState(() {
                                      correct[questionNumber] = value;
                                    }
                                    );
                                  },
                                )
                              ]
                          ),
                          Row(
                              children: [
                                Text('4'),
                                Radio(
                                  value: 3,
                                  groupValue: correct[questionNumber],
                                  onChanged: (int value) {
                                    setState(() {
                                      correct[questionNumber] = value;
                                    }
                                    );
                                  },
                                )
                              ]
                          )
                        ]
                      ),

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
                              setState(() {
                                if(questionNumber != 0)
                                  questionNumber--;
                              });
                            },
                            child: new Text("Back",
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                              ),),
                          ),
                          new MaterialButton(
                            color: clr.color_1,
                            minWidth: 100.0,
                            height: 30.0,
                            onPressed: () {
                              if(inputChecker()) {
                                setState(() {
                                  if (questionNumber + 1 != numQuestions)
                                    questionNumber++;
                                });
                              }
                              else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Please fill in all fields!"),
                                        actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK")
                                        )
                                        ]
                                    )
                                  );
                                }
                            },
                            child: new Text("Next",
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                              ),),
                          ),
                        ],
                      ),
                      new Container(
                        alignment: Alignment.bottomCenter,
                        child: new MaterialButton(
                          color: clr.color_2,
                          minWidth: 120.0,
                          height: 30.0,
                          onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text("Set Number of Attempts?"),
                                  content: Text("The default would give students unlimited attempts"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel")
                                    ),

                                    TextButton(
                                        onPressed: () => setState(() {
                                          Navigator.pop(context);
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                                title: Text("Please enter number of attempts allowed:"),
                                                content: TextFormField(
                                                  controller: attemptsController,
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      hintText: 'Enter quantity...'
                                                  ),
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      attempts = int.parse(attemptsController.text);
                                                    }
                                                    );
                                                  },
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text("Cancel")
                                                  ),

                                                  TextButton(
                                                      onPressed: () => setState((){
                                                        bool check = true;
                                                        for(int i = 0; i < numQuestions; i++) {
                                                          if(inputCheckerInd(i) == false) check = false;
                                                        }
                                                        print(attempts);
                                                        // push the attempts to MongoDB
                                                        if(check) {
                                                          //set attempts
                                                          Navigator.pop(context);
                                                        }
                                                        else {
                                                          showDialog<String>(
                                                              context: context,
                                                              builder: (BuildContext context) => AlertDialog(
                                                                  title: Text("Could Not Set Attempts"),
                                                                  content: Text("Please fill in all fields"),

                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                        onPressed: () => Navigator.pop(context),
                                                                        child: Text("OK")
                                                                    )
                                                                  ]
                                                              )
                                                          );
                                                        }
                                                      }),
                                                      child: Text("Save")
                                                  )
                                                ]
                                            ),
                                          );
                                        }),
                                        child: Text("Yes")
                                    )
                                  ]
                              )
                          ),
                          child: new Text("Set Attempts",
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            alignment: Alignment.bottomCenter,
                            child: new MaterialButton(
                              color: clr.color_2,
                              minWidth: 120.0,
                              height: 30.0,
                              onPressed: (){
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
                                    }
                                );
                              },
                              child: new Text("Set Due Date",
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
                              color: clr.color_2,
                              minWidth: 120.0,
                              height: 30.0,
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                      title: Text("Set Timer?"),
                                      content: Text("The default would give students unlimited time."),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("Cancel")
                                        ),

                                        TextButton(
                                            onPressed: () => setState(() {
                                              Navigator.pop(context);
                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                    title: Text("Set a timer:"),
                                                    content: TimerWork(),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: Text("Cancel")
                                                      ),

                                                      TextButton(
                                                          onPressed: () => setState((){
                                                              print(timer);
                                                              Navigator.pop(context);
                                                          }),
                                                          child: Text("Save")
                                                      )
                                                    ]
                                                ),
                                              );
                                            }),
                                            child: Text("Yes")
                                        )
                                      ]
                                  )
                              ),
                              child: new Text("Set Timer",
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Padding(padding: EdgeInsets.all(2)),

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
                                  title: Text("Save Quiz?"),
                                  content: Text("Are you sure you want to save?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel")
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Quit")
                                    ),

                                    TextButton(
                                        onPressed: () => setState(() {
                                          Navigator.pop(context);
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text("Please name your quiz:"),
                                              content: TextFormField(
                                                controller: quizNameController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    hintText: 'Enter quiz name...'
                                                ),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    quizName = quizNameController.text;
                                                  }
                                                  );
                                                },
                                              ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                              child: Text("Cancel")
                                              ),

                                            TextButton(
                                              onPressed: () => setState((){
                                                bool check = true;
                                                for(int i = 0; i < numQuestions; i++) {
                                                  if(inputCheckerInd(i) == false) check = false;
                                                }

                                                // push the quiz to MongoDB
                                                if(check) {
                                                  for(int i = 0; i < numQuestions; i++) {
                                                    correctStr[i] = answers[i][correct[i]];
                                                  }
                                                  pushQuiz(quizName, questions, answers, correctStr, teacher.accessCode, attempts, timer);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                                else {
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) => AlertDialog(
                                                          title: Text("Could Not Save Quiz"),
                                                          content: Text("Please fill in all fields"),

                                                          actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text("OK")
                                                          )
                                                          ]
                                                  )
                                                  );
                                                }
                                              }),
                                              child: Text("Save")
                                            )
                                            ]
                                          ),
                                          );
                                        }),
                                        child: Text("Save")
                                    )
                                  ]
                              )
                          ),
                          child: new Text("Save Quiz",
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
              )
            )
        )
    );
  }

  // function to push quiz to MongoDB
  pushQuiz(String quizName, List<String> questions, List<List<String>> answers, List<String> correct, String accessCode, int attempts, int timer) async {
    print(timer);
    final quiz = QuizModel(
      id: M.ObjectId(),
      quizName: quizName,
      questions: questions,
      answers: answers,
      correct: correct,
      accessCode: accessCode,
      dueDate: dueDate,
      open: oFR,
      attempts: attempts,
      timer: timer,
    );
    //print(dueDate.timeZoneName);
    await MongoDatabase.insertQuiz(quiz);
  }

  // helper function to check if all fields on a question are filled in
  bool inputChecker() {
    if(questions[questionNumber] == "" || answers[questionNumber][0] == "" ||
       answers[questionNumber][1] == "" || answers[questionNumber][2] == "" ||
        answers[questionNumber][3] == "") return false;
    return true;
  }

  // same as above, just takes an index input instead of using a preset number
  bool inputCheckerInd(int i) {
    if(questions[i] == "" || answers[i][0] == "" || answers[i][1] == "" ||
        answers[i][2] == "" || answers[i][3] == "") return false;
    return true;
  }
}

class TimerWork extends StatefulWidget {

  TimerWork();

  @override
  _TimerWorkState createState() => _TimerWorkState();
}

class _TimerWorkState extends State<TimerWork> {
  Duration _duration = new Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    return  DurationPicker(
      duration: _duration,
      onChange: (val) {
        setState(() {
          _duration = val;
          timer = val.inSeconds;

        });
      },
      snapToMins: 5.0,
    );
  }
}
