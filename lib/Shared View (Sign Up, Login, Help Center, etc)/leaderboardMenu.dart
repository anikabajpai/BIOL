import 'package:flutter/material.dart';
import 'dart:math';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/LeaderboardHistogram.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/Teacher View/LeaderboardPerStudentHistogram.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();
class LeaderBoardMenu extends StatefulWidget {
  final List<Map<String, dynamic>> listQ;
  final String accessCode;
  final Student student;
  final Teacher teacher;
  const LeaderBoardMenu(this.listQ, this.accessCode, this.student, this.teacher);

  @override
  _LeaderBoardMenuState createState() => _LeaderBoardMenuState(listQ, accessCode, student, teacher);
}

class _LeaderBoardMenuState extends State<LeaderBoardMenu> {
  final List<Map<String, dynamic>> listQ;
  final String accessCode;
  final Student student;
  final Teacher teacher;

  _LeaderBoardMenuState(this.listQ, this.accessCode, this.student, this.teacher);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        backgroundColor: clr.color_1,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
          ...listQ
              .map<Widget>(
                  (quiz) => QuizCard(name: quiz['quiz_name'], accessCode: accessCode, quizLength: quiz['correct'].length, student: student, teacher: teacher)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String name;
  final String accessCode;
  final int quizLength;
  final Student student;
  final Teacher teacher;
  const QuizCard({
    Key key, this.name, this.accessCode, this.quizLength, this.student, this.teacher
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: clr.color_5,
          //color:Color(0xd),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: Color(0X0048BA).withOpacity(0.23),
            ),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(

                padding: EdgeInsets.all(10.0),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(

              padding: EdgeInsets.all(10.0),


              child: Column(

                children: [

                  ElevatedButton(

                    child: Text("Ranking"),
                    style: ElevatedButton.styleFrom(
                    primary: clr.color_2,
                    //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(
                        fontSize: 17,
                    fontWeight: FontWeight.bold)),
                    onPressed: () {
                      MongoDatabase.getStudents(accessCode).then((studentList) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              StudentLeaderboardRanks(name, studentList)),
                        );
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text("Distribution"),
                    style: ElevatedButton.styleFrom(
                        primary: clr.color_2,
                        //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaderboardHistogram(accessCode, name, quizLength)),
                      );
                    },
                  ),

                  // only show the per student scores if the user is a teacher
                  if(teacher != null)
                    ElevatedButton(
                      child: Text("Per Student"),
                      style: ElevatedButton.styleFrom(
                          primary: clr.color_2,
                          //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LeaderboardPerStudentHistogram(accessCode, name, quizLength)),
                        );
                      },
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StudentLeaderboardRanks extends StatelessWidget {
  // given student access code and quiz name (below), determine student ranking
  final String name;
  final studentList;

  StudentLeaderboardRanks(this.name, this.studentList);

  @override
  Widget build(BuildContext context) {
    // get width of screen once, then use for all sizing
    double screenWidth = MediaQuery.of(context).size.width;

    // using the raw studentList, containing all student information, pull only
    // scores and aliases for the given quiz
    // leaderboard info indexes:
    //    0: max score on given quiz
    //    1: student alias
    //    2: student profile picture

    List leaderboardInfo = List.filled(studentList.length, [-1, 'Not Yet Taken', '/images/profile/white.png']);
    for(int i = 0; i < studentList.length; i++) {
      int maxScore = -1;
      for(int j = 0; j < studentList[i]['grade'].length; j++) {
        if(studentList[i]['grade'][j][name] != null) {
          for(int k = 0; k < studentList[i]['grade'][j][name].length; k++) {
            if(studentList[i]['grade'][j][name][k] > maxScore) {
              maxScore = studentList[i]['grade'][j][name][k];
            }
          }
        }
      }
      leaderboardInfo[i] = [maxScore, studentList[i]['alias'], studentList[i]['image']];
    }

    // sort the leaderboard info by score to easily construct leaderboard
    leaderboardInfo = leaderboardInfo
      ..sort((y, x) => (x[0] as dynamic)
          .compareTo((y[0] as dynamic)));

    // get images for top three slots, plus top student (if taken)
    String firstImg = leaderboardInfo.length > 0 && leaderboardInfo[0][0] != -1 ? leaderboardInfo[0][2] : 'n/a';
    String secondImg = leaderboardInfo.length > 1 && leaderboardInfo[1][0] != -1 ? leaderboardInfo[1][2] : 'n/a';
    String thirdImg = leaderboardInfo.length > 2 && leaderboardInfo[2][0] != -1 ? leaderboardInfo[2][2] : 'n/a';
    String firstTxt = leaderboardInfo.length > 0 && leaderboardInfo[0][0] != -1 ? leaderboardInfo[0][1] : 'Not Yet Taken';

    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard Ranks"),
        backgroundColor: clr.color_1,
      ),
      body: SingleChildScrollView( child: Column(
          children: [
            new Padding(padding: EdgeInsets.all(10.0)),
            new Container(
              width: screenWidth - screenWidth / 16,
              height: 80,
              child: new Text(name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 32
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(10.0)),
            new Text(firstTxt == "Not Yet Taken" ? "No results yet..." : getFirstMessage(firstTxt),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 24
              ),
            ),
            new Padding(padding: EdgeInsets.all(10.0)),
            new Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: new Stack(
                children: [
                  new Positioned(
                    top: 120.0,
                    child: Image.asset('images/podium.jpg', width: MediaQuery.of(context).size.width)
                  ),

                  // first place profile image - don't display if no student has
                  // placed...
                  if(firstImg != 'n/a')
                    new Positioned(
                        top: 10.0,
                        left: (screenWidth / 2) - (150 / 2) + (screenWidth / 50),
                        child: CircleAvatar(
                            radius: 150/2,
                            backgroundColor: Color(0xff978425),
                            child: CircleAvatar(
                                radius: 150/2 - 5,
                                backgroundImage: AssetImage(firstImg)
                            )
                        )
                    ),

                  if(firstImg != 'n/a')
                    new Positioned(
                        top: 0.0,
                        left: (screenWidth / 2) - (175 / 2) + (screenWidth / 50),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(175/2),
                            child: new Image.asset('images/wreath.png', width: 175, height: 175)
                        )
                    ),

                  // second place profile image - don't display if no student
                  // has placed...
                  if(secondImg != 'n/a')
                    new Positioned(
                      top: 70.0,
                      left: (screenWidth / 16) - (100 / 16),
                        child: CircleAvatar(
                            radius: 100/2,
                            backgroundColor: Color(0xff6d6d6d),
                            child: CircleAvatar(
                                radius: 100/2 - 5,
                                backgroundImage: AssetImage(secondImg)
                            )
                        )
                    ),

                  // third place profile image - don't display if no student has
                  // placed...
                  if(thirdImg != 'n/a')
                    new Positioned(
                        top: 120.0,
                        left: (15 * screenWidth / 16) - (15 * 75 / 16) - (screenWidth / 64),
                        child: CircleAvatar(
                            radius: 75/2,
                            backgroundColor: Color(0xff6f3716),
                            child: CircleAvatar(
                                radius: 75/2 - 5,
                                backgroundImage: AssetImage(thirdImg)
                            )
                        )
                    )
                ]
              )
            ),

            Column(
              children:<Widget>[
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Table(
                    columnWidths: {0: FixedColumnWidth(60.0), 1: FixedColumnWidth(screenWidth - screenWidth / 2),
                                   2: FixedColumnWidth(7.0)},
                    children: [
                      TableRow(
                        children: [
                          Text("",textScaleFactor: 2.0,),
                          Text("Name",textScaleFactor: 1.5, textAlign: TextAlign.center,),
                          Text("",textScaleFactor: 2.0,),
                          Text("Score",textScaleFactor: 1.5, textAlign: TextAlign.center,),
                        ]),
                      for(int i = 0; i < leaderboardInfo.length; i++)
                      TableRow(
                        children: [
                          Image.asset(leaderboardInfo[i][2], width: 45, height: 45),
                          MaterialButton(
                            textColor: Colors.white,
                            color: clr.color_2,
                            disabledColor: clr.color_2,
                            child: Text(leaderboardInfo[i][1], textAlign: TextAlign.left),
                            onPressed: () {
                            },
                          ),
                          Text("",textScaleFactor: 2.0,),
                          MaterialButton(
                            textColor: Colors.white,
                            color: clr.color_2,
                            disabledColor: clr.color_2,
                            child: Text(leaderboardInfo[i][0] == -1 ? '-' : '${leaderboardInfo[i][0]}', textAlign: TextAlign.right),
                            onPressed: () {
                            },
                          )]
                      ),
                    ]
                  )
                )
              ]
            )
          ]
      )
      )
    );
  }
}

// function to generate a first place message on the leaderboard
// variety is the spice of life!
String getFirstMessage(String first) {
  List<String> possible = [
    first + ' is in the lead!',
    first + ' has the score to beat!',
    'Amazing! ' + first + ' holds 1st place!'
  ];
  Random rand = new Random();
  return possible[rand.nextInt(possible.length)];
}
