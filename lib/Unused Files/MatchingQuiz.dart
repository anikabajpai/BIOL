import 'package:flutter/material.dart';

class MatchingQuiz {
  var images = [
    "BIOL_LOGO", "BIOL_LOGO", "BIOL_LOGO", "BIOL_LOGO"
  ];

  var questions = [
    "Indiana",
    "West Virginia",
    "Florida",
    "Texas",
  ];

  var choices = [
    ["Indianapolis", "Charleston", "Tallahassee", "Austin",]
  ];

  var correctAnswers = [
    "Indianapolis", "Charleston", "Tallahassee", "Austin"
  ];
}

var finalScore = 0;
var questionNumber = 0;
var quiz = new MatchingQuiz();
int _ans1 = 0;
int _ans2 = 0;
int _ans3 = 0;

class MatchingQuiz1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MatchingQuiz1State();
  }
}

class MatchingQuiz1State extends State<MatchingQuiz1> {
  @override
  Widget build(BuildContext context) {


    return new WillPopScope(
      onWillPop: () async => false,
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
                    new Text("Question 1 of 1",
                      style: new TextStyle(
                          fontSize: 22.0
                      ),),

                  ],
                ),
              ),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Image.asset(
                  "images/${quiz.images[questionNumber]}.png"
              ),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Text('Match the states with their state capital\n'
                  'A. Indiana\n'
                  'B. West Virginia\n'
                  'C. Florida\n',
                style: new TextStyle(
                  fontSize: 20,
                ),),

              new Padding(padding: EdgeInsets.all(10.0)),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text("A."),
                  new DropdownButton(
                      value: _ans1,
                      items: [
                        DropdownMenuItem(
                          child: Text(quiz.choices[0][0],
                              style: new TextStyle(fontSize: 20)),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text(quiz.choices[0][1],
                              style: new TextStyle(fontSize: 20)),
                          value: 1,
                        ),

                        DropdownMenuItem(
                          child: Text(quiz.choices[0][2],
                              style: new TextStyle(fontSize: 20)),
                          value: 2,
                        ),

                       DropdownMenuItem(
                          child: Text(quiz.choices[0][3],
                              style: new TextStyle(fontSize: 20)),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _ans1 = value;
                        });
                      }),

                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text("B."),
                  new DropdownButton(
                      value: _ans2,
                      items: [
                        DropdownMenuItem(
                          child: Text(quiz.choices[0][0],
                              style: new TextStyle(fontSize: 20)),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text(quiz.choices[0][1],
                              style: new TextStyle(fontSize: 20)),
                          value: 1,
                        ),

                        DropdownMenuItem(
                          child: Text(quiz.choices[0][2],
                              style: new TextStyle(fontSize: 20)),
                          value: 2,
                        ),

                        DropdownMenuItem(
                          child: Text(quiz.choices[0][3],
                              style: new TextStyle(fontSize: 20)),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _ans2 = value;
                        });
                      }),

                ],
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text("C."),
                  new DropdownButton(
                      value: _ans3,
                      items: [
                        DropdownMenuItem(
                          child: Text(quiz.choices[0][0],
                              style: new TextStyle(fontSize: 20)),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text(quiz.choices[0][1],
                              style: new TextStyle(fontSize: 20)),
                          value: 1,
                        ),

                        DropdownMenuItem(
                          child: Text(quiz.choices[0][2],
                              style: new TextStyle(fontSize: 20)),
                          value: 2,
                        ),

                        DropdownMenuItem(
                          child: Text(quiz.choices[0][3],
                              style: new TextStyle(fontSize: 20)),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _ans3 = value;
                        });
                      }),

                ],
              ),




             // new Padding(padding: EdgeInsets.all(10.0)),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                ],
              ),

             // new Padding(padding: EdgeInsets.all(10.0)),

              new Container(
                alignment: Alignment.bottomCenter,
                child: new MaterialButton(
                  color: Colors.blue,
                  minWidth: 240.0,
                  height: 30.0,
                  onPressed: resetQuiz,
                  child: new Text("Submit",
                    style: new TextStyle(
                        fontSize: 18.0,
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
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new Summary()));
      finalScore = 0;
      questionNumber = 0;
    });
  }

}

class Summary extends StatelessWidget{
  int score = 0;

  @override
  Widget build(BuildContext context) {
    if(_ans1 == 0) {
      score++;
    }
    if(_ans2 == 1) {
      score++;
    }
    if(_ans2 == 2){
      score++;
    }
    double percentage  = (score / 3) * 100;
    return new WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(
        body: new Container(
          child: Align(
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Final Score: ${percentage}%",
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