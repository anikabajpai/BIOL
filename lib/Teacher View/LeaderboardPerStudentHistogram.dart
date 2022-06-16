import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

class LeaderboardPerStudentHistogram extends StatelessWidget {
  final String accessCode;
  final String quizName;
  final int quizLength;
  LeaderboardPerStudentHistogram(this.accessCode, this.quizName, this.quizLength);

  void axis(AxisLabelRenderArgs args) {
    args.text = "Scores";
  }

  Future<List<double>> getGrades(ac, qn, length) async {
    List<double> grades = [];
    List<int> temp = [];

    var students = await MongoDatabase.getStudents(ac);
    //print(students);
    for(int i = 0; i < students.length; i++) {
      //print("There are these many students: ");
      //print(students[i]['grade'].length);
      temp = [];
      for (int j = 0; j < students[i]['grade'].length; j++) {
        if (students[i]['grade'][j][qn] != null) {
          for (int k = 0; k < students[i]['grade'][j][qn].length; k++) {
            temp.add(students[i]['grade'][j][qn][k]);
          }
          grades.add(temp.reduce(max) * 100 / length);
        }
      }
    }
    return grades;
  }

  Future<List<String>> getNames(ac) async {
    List<String> names = [];
    var students = await MongoDatabase.getStudents(ac);
    //print(students);
    for(int i = 0; i < students.length; i++) {
      //print("There are these many students: ");
      //print(students[i]['grade'].length);
      names.add(students[i]['name']);

    }
    return names;
  }
  @override
  Widget build(context) {
    Future<List<String>> getNameFuture = getNames(accessCode);
    Future<List<double>> getGradesFuture = getGrades(accessCode, quizName, quizLength);
    List<double> newGrades = [];
    List<String> names = [];

    return FutureBuilder(
        future: Future.wait([getNameFuture, getGradesFuture]),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data[0] != null) {
              names = snapshot.data[0];
            }
            if(snapshot.data[1] != null) {
              newGrades = snapshot.data[1];
            }
          }
          final scores = List<double>.filled(names.length, 0, growable: true);
          if(newGrades.isNotEmpty) {
            for (int j = 0; j < newGrades.length; j++) {
              scores[j] = newGrades[j];
            }
            List<GradesData> gradesData = <GradesData>[];
            for(int i  = 0; i < names.length; i++) {
              gradesData.add(new GradesData(bin: names[i], count: scores[i]));

            }
            if (newGrades.length == 0) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  //TODO: update somehow, was originally just "Quiz 1 Distribution"
                  title: Text(quizName + "Distribution"),
                  backgroundColor: clr.color_2,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'No quiz responses yet.',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  //TODO: update somehow, was originally just "Quiz 1 Distribution"
                  title: Text(quizName + "Distribution"),
                  backgroundColor: clr.color_2,
                ),
                body: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 50, left: 10, right: 20), //changing this value changes which y-axis values are displayed; default = 20
                  child: SfCartesianChart(
                    isTransposed: true,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      title: AxisTitle(
                        text: "Names",
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 1),
                      minimum: 0.0,
                      maximum: 100.0,
                      title: AxisTitle(
                        text: "Scores",
                      ),
                    ),
                    series: <BarSeries> [ //histogram is now a bar graph, but functions as a histogram - no curve though
                      BarSeries<GradesData, String>(
                          dataSource: gradesData,
                          xValueMapper: (GradesData gradesForGraph, _) => gradesForGraph.bin,
                          yValueMapper: (GradesData gradesForGraph, _) => gradesForGraph.count,
                          color: clr.color_2,
                          spacing: 0,
                          width: 1
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                //TODO: update somehow, was originally just "Quiz 1 Distribution"
                title: Text(quizName + "Distribution"),
                backgroundColor: clr.color_2,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Retrieving data...',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}

class GradesData {
  String bin;
  double count;

  GradesData({this.bin, this.count});
}

class StudentData {
  StudentData(this.grade);
  final double grade;
}
