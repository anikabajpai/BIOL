import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/QuizFrontCover.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

class BiologyQuizListTeachers extends StatefulWidget {
  //might need a variable here
  final Teacher teacher;
  final List<Map<String, dynamic>> lq;
  BiologyQuizListTeachers({Key key, @required this.teacher, @required this.lq}) : super(key : key);

  @override
  _quizList createState() => _quizList(teacher: teacher, list_quiz: this.lq);
}

class _quizList extends State<BiologyQuizListTeachers> {
  final Teacher teacher;
  final List<Map<String, dynamic>> list_quiz;
  _quizList({@required this.teacher, @required this.list_quiz});

  ListView listBuilding() {
    return ListView(children: [
      ...list_quiz
          .map<Widget>(
              (quiz) => Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: MaterialButton(
                shape: StadiumBorder(),
                textColor: Colors.white,
                color: clr.color_1,
                child: Text(quiz['quiz_name']),
                onPressed: () {
                  MongoDatabase.findQuiz(quiz['quiz_name']).then((quiz) {
                    QuizModel quizT = new QuizModel(
                        id: quiz['_id'],
                        quizName: quiz['quiz_name'],
                        questions: quiz['questions'],
                        answers: List<List<dynamic>>.from(quiz['answers']),
                        correct: quiz['correct'],
                        accessCode: quiz['accessCode'],
                        dueDate: quiz['dueDate'],
                        open: quiz['openForReview'],
                        attempts: quiz['attempts'],
                        timer: quiz['timer'],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizFrontCover(quiz: quizT, student: null, teacher: teacher)),
                    );
                  });
                },
              ))
      )
          .toList(),
      SizedBox(height: 70),
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Quizzes Available"),
          backgroundColor: clr.color_2,
        ),
        body: listBuilding()
    );
  }

}
