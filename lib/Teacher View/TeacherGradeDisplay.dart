import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/Teacher View/TeacherGrades.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

class TeacherGradeDisplay extends StatefulWidget {
  final Teacher teacher;
  final List<Map<String, dynamic>> lq;
  TeacherGradeDisplay({Key key, @required this.teacher, @required this.lq}) : super(key : key);

  @override
  _quizList createState() => _quizList(teacher: teacher, list_quiz: this.lq);
}

class _quizList extends State<TeacherGradeDisplay> {
  final Teacher teacher;
  final List<Map<String, dynamic>> list_quiz;
  _quizList({@required this.teacher, @required this.list_quiz});

  studentList() async {
    var sL = await MongoDatabase.checkAccessCodeTeacher(teacher.accessCode);

    //sL is List<Map<String, dynamic>>
    print("Printing student list...");
    for (int i = 0; i < sL.length; i++) {
      print("name: ${sL[i]}");
    }

    return sL;
  }

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
                  studentList().then((sL) async {
                    List<String> attemptList = [];
                    int highestGrade = -1;
                    List<int> newGradeList = [];
                    for (int i = 0; i < sL.length; i++) {
                      bool flag = false;
                      //get student info
                      await MongoDatabase.findStudent(sL[i]).then((stud) {
                        print("studName: ${stud['name']}");
                        var gL = stud['grade'];

                        for (int j = 0; j < gL.length; j++) {
                          var keysList = gL[j].keys.toList();

                          for (int k = 0; k < keysList.length; k++) {
                            print("Key: ${keysList[k]}");
                            print("Key length: ${gL[j][keysList[k]].length}");
                            if (keysList[k] == quiz['quiz_name']) {
                              print("Am I here");
                              //gradeList.add("${gL[j][keysList[k]]}");
                              for (int n = 0; n<gL[j][keysList[k]].length; n++) {
                                if (gL[j][keysList[k]][n] > highestGrade) {
                                  highestGrade = gL[j][keysList[k]][n];
                                }
                              }
                              attemptList.add("${gL[j][keysList[k]].length}");
                              newGradeList.add(highestGrade);
                              flag = true;
                            }
                          }
                        }
                      });
                      if (flag == false) attemptList.add("Unattempted");
                      if (flag == false) newGradeList.add(0);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeacherGrades(teacher: teacher, studentList: sL, quiz: quiz['quiz_name'], aL: attemptList, gL: newGradeList)),
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
          title: Text("Student Grades"),
          backgroundColor: clr.header,
        ),
        body: listBuilding()
    );
  }

}