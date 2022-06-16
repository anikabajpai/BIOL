import 'package:flutter/material.dart';
import 'package:BIOL/Student View/Website.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Student View/WebsiteGrades.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();

class ExtraResources extends StatelessWidget {

  ExtraResources(this.student);

  final Student student;
  String title = "";
  String score = "";
  void upDateWebsite(String title, String score, String website) async {
    //print("Hey I'm Here");
    this.title = title;
    this.score = score;
    //print("Title: ${this.title}, score: ${this.score}");
    if (website.compareTo('hstp') == 0) {
      score = score.trim();
      score = score.substring(0, score.length - 1);
    }
    if (title.contains("&amp;")) title = title.replaceAll("&amp;", "&");
    title += website;
    await MongoDatabase.updateWebsiteGrade(int.parse(score), student.emailId, title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Extra Resources"),
        backgroundColor: clr.color_1,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:15, bottom: 5),
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Website(
                      upDateWebsite,
                      "https://highschooltestprep.com/ap/biology/",
                      "High School Test Prep",
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: clr.color_2,
                ),
                  child: Text("High School Test Prep")),
          ),
          Container(
            padding: EdgeInsets.only(top:15, bottom: 5),
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Website(
                      upDateWebsite,
                      "https://www.proprofs.com/quiz-school/topic/biology",
                      "Pro Profs Quizzes",
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: clr.color_2,
                ),
                child: Text("Pro Profs Quizzes")),
          ),
          Container(
            padding: EdgeInsets.only(top:15, bottom: 5),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                MongoDatabase.findStudent(student.username).then((stud) {
                  List<dynamic> extraG = stud['extraGrade'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebsiteGrades(extraG)),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                primary: clr.color_2,
              ),
              child: Text("Extra Resources Grades"),
            ),
          ),
        ],
      ),
    );
  }
}
