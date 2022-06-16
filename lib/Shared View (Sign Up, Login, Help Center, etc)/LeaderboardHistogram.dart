import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

class LeaderboardHistogram extends StatelessWidget {
  final String accessCode;
  final String quizName;
  final int quizLength;
  LeaderboardHistogram(this.accessCode, this.quizName, this.quizLength);

  void axis(AxisLabelRenderArgs args) {
    args.text = "Scores";
  }

  Future<List<double>> getGrades(ac, qn, length) async {
    List<double> grades = [];
    List<int> temp = [];

    var students = await MongoDatabase.getStudents(ac);
    for(int i = 0; i < students.length; i++) {
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

  @override
  Widget build(context) {
    return FutureBuilder<List<double>>(
        future: getGrades(accessCode, quizName, quizLength),
        builder: (context, AsyncSnapshot newGrades) {
          List<int> binCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
          if(newGrades.hasData) {
            List<double> fixGrades = newGrades.data;
            //List<double> fixGrades = [5, 15, 25, 35, 35, 45, 45, 55, 55, 55, 55, 65, 65, 65, 65, 65, 75, 75, 75, 75, 75, 75, 75, 85, 85, 85, 85, 85, 95, 95, 95];
            for (int j = 0; j < fixGrades.length; j++) {
              if (fixGrades[j] <= 9) binCounts[0] += 1;
              else if (fixGrades[j] <= 19) binCounts[1] += 1;
              else if (fixGrades[j] <= 29) binCounts[2] += 1;
              else if (fixGrades[j] <= 39) binCounts[3] += 1;
              else if (fixGrades[j] <= 49) binCounts[4] += 1;
              else if (fixGrades[j] <= 59) binCounts[5] += 1;
              else if (fixGrades[j] <= 69) binCounts[6] += 1;
              else if (fixGrades[j] <= 79) binCounts[7] += 1;
              else if (fixGrades[j] <= 89) binCounts[8] += 1;
              else if (fixGrades[j] <= 100) binCounts[9] += 1;
            }
            List<GradesData> gradesData = <GradesData>[
              GradesData(bin: '0-9', count: binCounts[0]),
              GradesData(bin: '10-19', count: binCounts[1]),
              GradesData(bin: '20-29', count: binCounts[2]),
              GradesData(bin: '30-39', count: binCounts[3]),
              GradesData(bin: '40-49', count: binCounts[4]),
              GradesData(bin: '50-59', count: binCounts[5]),
              GradesData(bin: '60-69', count: binCounts[6]),
              GradesData(bin: '70-79', count: binCounts[7]),
              GradesData(bin: '80-89', count: binCounts[8]),
              GradesData(bin: '90-100', count: binCounts[9])
            ];
            if (fixGrades.length == 0) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text(quizName + "Distribution"),
                  backgroundColor: clr.color_1,
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
                  title: Text(quizName + "Distribution"),
                  backgroundColor: clr.color_1,
                ),
                body: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 50, left: 10, right: 20), //changing this value changes which y-axis values are displayed; default = 20
                  child: SfCartesianChart(
                    isTransposed: true,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      title: AxisTitle(
                        text: "Scores (%)",
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                        majorGridLines: MajorGridLines(width: 1),
                        minimum: 0.0,
                        title: AxisTitle(
                          text: "Student Frequency",
                        ),
                    ),
                    series: <BarSeries> [ //histogram is now a bar graph, but functions as a histogram - no curve though
                      BarSeries<GradesData, String>(
                        dataSource: gradesData,
                        xValueMapper: (GradesData gradesForGraph, _) => gradesForGraph.bin,
                        yValueMapper: (GradesData gradesForGraph, _) => gradesForGraph.count,
                        color: clr.color_5,
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
                title: Text(quizName + "Distribution"),
                backgroundColor: clr.color_1,
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
  int count;

  GradesData({this.bin, this.count});
}

class StudentData {
  StudentData(this.grade);
  final double grade;
}
