import 'package:flutter/material.dart';


class MathQuiz {
  var images = [
    "BIOL_LOGO", "BIOL_LOGO", "math_quiz_q3", "math_quiz_q4"
  ];

  var questions = [
    "A vector in standard form has components <3, 10>. What is the initial point?",
    "What is the value of cos(5π/4)",
    "What would be the coordinates of point S after applying the following rule: (x+3, y -2)?",
    "What value on the number line in the figure below divides segment EF into two parts having a ratio of their lengths of 3:1?",
  ];

  var choices = [
    ["(0,0)", "(3,10)", "(6,20)", "(12,40"],
    ["−√2/2", "undefined", "√2/2", "-1"],
    ["(1,-4)", "(-2,-2)", "(2,-2)", "(3,-2)"],
    ["-5", "-3", "-4", "-1"],
  ];

  var correctAnswers = [
    "(0,0)", "−√2/2", "(1,-4)", "-1"
  ];


}

var finalScore = 0;
var questionNumber = 0;
var quiz = new MathQuiz();

class MathQuiz1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new Quiz1State();
  }
}

class Quiz1State extends State<MathQuiz1> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(

        body: new Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.topCenter,
          child: new Column(
            children: <Widget>[

              new Padding(padding: EdgeInsets.all(20.0)),

              new Container(
                alignment: Alignment.centerRight,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text("Question ${questionNumber + 1} of ${quiz.questions.length}",
                      style: new TextStyle(
                          fontSize: 22.0
                      ),),

                    /*
                    new Text("Score: ${(score * 100/questionNumber)}finalScore",
                    style: new TextStyle(
                      fontSize: 22.0
                    ),)
                    */
                  ],
                ),
              ),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Image.asset(
                  "images/${quiz.images[questionNumber]}.png"
              ),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Text(quiz.questions[questionNumber],
                style: new TextStyle(
                  fontSize: 20,
                ),),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  //button 1
                  new MaterialButton(
                    minWidth: 120,
                    color: Colors.green,
                    onPressed: () {
                      if(quiz.choices[questionNumber][0] == quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(quiz.choices[questionNumber][0],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),),
                  ),

                  //button 2
                  new MaterialButton(
                    minWidth: 120,
                    color: Colors.green,
                    onPressed: () {
                      if(quiz.choices[questionNumber][1] == quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(quiz.choices[questionNumber][1],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),),
                  ),

                ],
              ),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  //button 3
                  new MaterialButton(
                    minWidth: 120,
                    color: Colors.green,
                    onPressed: () {
                      if(quiz.choices[questionNumber][2] == quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(quiz.choices[questionNumber][2],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),),
                  ),

                  //button 4
                  new MaterialButton(
                    minWidth: 120,
                    color: Colors.green,
                    onPressed: () {
                      if(quiz.choices[questionNumber][3] == quiz.correctAnswers[questionNumber]) {
                        debugPrint("Correct");
                        finalScore++;
                      } else {
                        debugPrint("Wrong");
                      }
                      updateQuestion();
                    },
                    child: new Text(quiz.choices[questionNumber][3],
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),),
                  ),
                ],
              ),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Container(
                alignment: Alignment.bottomCenter,
                child: new MaterialButton(
                  color: Colors.blue,
                  minWidth: 240.0,
                  height: 30.0,
                  onPressed: resetQuiz,
                  child: new Text("Quit",
                    style: new TextStyle(
                        fontSize:  18.0,
                        color: Colors.white
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == quiz.questions.length - 1) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new Summary(score: finalScore)));
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
                  color: Colors.blue,
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