import 'package:flutter/material.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Student View/StudentDashboard.dart';
import 'package:BIOL/src/models/studentUser.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

class TeacherGrades extends StatefulWidget {
  final Teacher teacher;
  final List studentList;
  final String quiz;
  final List<String> aL;
  final List<int> gL;

  TeacherGrades({Key key, @required this.teacher, @required this.studentList, @required this.quiz, @required this.aL, @required this.gL}) : super(key : key);

  @override
  TeacherGradeClass createState() => TeacherGradeClass(teacher: teacher, studentList: this.studentList, quiz: this.quiz, aL: this.aL, gL: this.gL);


}

class TeacherGradeClass extends State<TeacherGrades> {
  final Teacher teacher;
  final List studentList;
  final List<String> aL;
  final String quiz;
  final List<int> gL;
  final StudentUser student;
  final List<Map<String, dynamic>> lq;
  TeacherGradeClass({Key key, @required this.teacher, @required this.studentList, @required this.quiz, @required this.aL, @required this.gL, @required this.student, @required this.lq});

   Padding listBuilding() {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Table(
            children: [
              for (int i = 0; i < studentList.length; i++)
                TableRow(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        MongoDatabase.findStudent(studentList[i]).then((student){
                          Student student2 = new Student(
                              id: student["_id"],
                              username: student["name"],
                              emailId: student['email'],
                              password: student["password"],
                              grade: student["grade"],
                              accessCode: student["accessCode"],
                              completedQuizzes: null,
                              viewedQuizzes: null,
                              percentageCorrect: 0.0,
                              percentageWrong: 0.0
                          );

                          MongoDatabase.getCustomQuizzes(student2.accessCode).then((lq2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StudentGrades(student: student2, lq: lq2)),
                            );
                          });

                        });

                       },
                      child: Text("${studentList[i]}", textScaleFactor: 1.5,),
                    ),
                     
                    Text("${aL[i]}", textScaleFactor: 1.5),
                    Text("${gL[i]}",textScaleFactor: 1.5),
                  ])
            ])
    );

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Grades"),
        backgroundColor: clr.header,
      ),
      body: ListView(
          children:<Widget>[
      Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(quiz + ' Grades'
        ,textScaleFactor: 2,style: TextStyle(fontWeight:FontWeight.bold),),
        ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Table(

      // textDirection: TextDirection.rtl,
      // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      // border:TableBorder.all(width: 2.0,color: Colors.red),
          children: [
            TableRow(
              children: [
              Text("Student Name",textScaleFactor: 1.5,),
              Text("Attempts",textScaleFactor: 1.5),
              Text("Grade",textScaleFactor: 1.5),
            ]),
          TableRow(
            children: [
              Text("",textScaleFactor: 1.5,),
              Text("",textScaleFactor: 1.5),
              Text("",textScaleFactor: 1.5),
          ]),
        ])
    ),
            listBuilding()])
  );
}


}
