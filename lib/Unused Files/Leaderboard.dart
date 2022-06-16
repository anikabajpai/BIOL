import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';

class Leaderboard extends StatelessWidget {

  final List<charts.Series> seriesList;
  final bool animate;

  Leaderboard(this.seriesList, {this.animate});

  /// Creates a bar chart with sample data and no transition.
  factory Leaderboard.withSampleData() {
    return new Leaderboard(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
}

  factory Leaderboard.withRandomData() {
    return new Leaderboard(_createRandomData());
  }

  /// Create random data.
  static List<charts.Series<studentStats, String>> _createRandomData() {
    final random = new Random();

    final data = [
      new studentStats('S1', random.nextInt(100)),
      new studentStats('S2', random.nextInt(100)),
      new studentStats('S3', random.nextInt(100)),
      new studentStats('S4', random.nextInt(100)),
      new studentStats('S5', random.nextInt(100)),
      new studentStats('S6', random.nextInt(100)),
      new studentStats('S7', random.nextInt(100)),
      new studentStats('S8', random.nextInt(100)),
    ];

    return [
      new charts.Series<studentStats, String>(
        id: 'Stats',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (studentStats stats, _) => stats.studentName,
        measureFn: (studentStats stats, _) => stats.totalPoints,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Quiz Leaderboards',
              ),
              Expanded(
                child: charts.BarChart(seriesList, animate: animate),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<studentStats, String>> _createSampleData() {
    final data = [
      new studentStats('Student 1', 100),
      new studentStats('Student 2', 75),
      new studentStats('Student 3', 25),
      new studentStats('Student 4', 5),
    ];
    return [
      new charts.Series<studentStats, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (studentStats stats, _) => stats.studentName,
        measureFn: (studentStats stats, _) => stats.totalPoints,
        data: data,
      )
    ];
  }
}

/// Student statistics data type.
class studentStats {
  final String studentName;
  final int totalPoints;
  studentStats(this.studentName, this.totalPoints);
}