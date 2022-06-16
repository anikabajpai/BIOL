import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/QuizFrontCover.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();

class BiologyQuizListStudents extends StatefulWidget {

  final Function pressChange;
  final Student student;
  final List<Map<String, dynamic>> lq;
  BiologyQuizListStudents({Key key, @required this.student, @required this.lq, this.pressChange}) : super(key : key);

  @override
  _quizList createState() => _quizList(student: student, list_quiz: this.lq, pressChange: this.pressChange);
}

class _quizList extends State<BiologyQuizListStudents> {
  final Function pressChange;
  final Student student;
  final List<Map<String, dynamic>> list_quiz;
  var quizGrades;
  int numberOfAttempts;

  _quizList({@required this.student, @required this.list_quiz, this.pressChange});

  ListView listBuilding() {
    return ListView(
        children: [
      ...list_quiz
          .map<Widget>(
              (quiz) => Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: MaterialButton(
                shape: StadiumBorder(),
                textColor: Colors.white,
                color: clr.color_2,
                child: Text(quiz['quiz_name']),
                onPressed: () {
                  String passE = student.password;

                  MongoDatabase.loginStudent(student.emailId, student.password)
                      .then((student) {
                    if (student != null) {
                      Student s = new Student(
                          id: student["_id"],
                          username: student["name"],
                          emailId: student['email'],
                          password: student["password"],
                          grade: student["grade"],
                          extraGrade: student["extraGrade"],
                          accessCode: student["accessCode"],
                          alias: student["alias"],
                          image: student["image"],
                          recentQuiz: student["recentQuiz"],
                          completedQuizzes: null,
                          viewedQuizzes: null,
                          percentageCorrect: 0.0,
                          percentageWrong: 0.0);

                      s.password = passE;

                      List<dynamic> gradeL = s.grade;

                      for (int i = 0; i < gradeL.length; i++) {
                        if (gradeL[i].containsKey(quiz['quiz_name'])) {
                          quizGrades = gradeL[i];
                        }
                      }
                      if(quizGrades == null)
                      {
                        numberOfAttempts = 0;
                        print(numberOfAttempts);
                      }
                      else
                      {
                        var templist = quizGrades.keys.toList();
                        for (int j = 0; j < templist.length; j++) {
                          numberOfAttempts = quizGrades[templist[j]].length;
                        }
                        print(numberOfAttempts);
                      }

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
                            timer: quiz['timer']
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizFrontCover(quiz: quizT, student: s, teacher: null, numberOfAttempts: numberOfAttempts, pressChange: pressChange)),
                        );
                      });
                    }
                    else {
                      print("Didn't work");
                    }
                  });
                },
              ))
      ).toList(),
      SizedBox(height: 70),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biology Quizzes"),
        backgroundColor: clr.color_1,
      ),
      body: listBuilding()
    );
  }

}

