import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();

class WebsiteGrades extends StatelessWidget {
  const WebsiteGrades(this.extraG);
  final List<dynamic> extraG;

  @override
  Widget build(BuildContext context) {

    List<String> x = new List();
    List<int> y = new List();

    if (extraG == null) {

    } else {
      for (int i = 0; i < extraG.length; i++) {
        var tempList = extraG[i].keys.toList();
        x.add(tempList[0]);
        print("x: ${tempList[0]}");
        y.add(extraG[i][tempList[0]][0]);
        print('y: ${extraG[i][tempList[0]][0]}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Extra Resources Grades"),
        backgroundColor: clr.color_1,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 5),
                  child: Container(
                    alignment: Alignment.center,
                    width: 200,
                    child: Text(
                      "Quiz Name",
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 5),
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: Text(
                    "Score",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          for (int i = 0; i < x.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: Text(
                        x[i],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      "${y[i]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
