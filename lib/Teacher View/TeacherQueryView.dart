import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/src/models/helpcenterModel.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/HelpCenter.dart';
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();

// padding constants - change as needed
const double topPadding = 15.0;
const double imagePadding = 20.0;

class TeacherQueryView extends StatefulWidget{
  final HelpCenterModel query;
  final Teacher teacher;
  final Student student;

  TeacherQueryView({Key key, @required this.query, @required this.student, @required this.teacher}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new TeacherQueryViewState(query: this.query, teacher: this.teacher, student: this.student);
  }
}

class TeacherQueryViewState extends State<TeacherQueryView> {

  final HelpCenterModel query;
  String questionQ;
  String answerQ;
  String accessCodeQ;
  Student stud;
  Teacher teach;
  TextEditingController answer1 = TextEditingController();
  bool visibleToStudents;
  String userName;
  bool anonymousQuestion;

  TeacherQueryViewState({Key key, @required this.query, Student student, Teacher teacher, }) {
    questionQ = query.question;
    answerQ = query.answer;
    accessCodeQ = query.accessCode;
    stud = student;
    teach = teacher;
    visibleToStudents = query.visibleToStudents;
    userName = query.userName;
    print(userName);
    anonymousQuestion = query.anonymousQuestion;
    print(anonymousQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
            title: Text("Help Center"),
            backgroundColor: clr.header,
          ),
          body: new Container(
              margin: const EdgeInsets.all(10.0),
              alignment: Alignment.topCenter,
              child: new Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.all(topPadding)),

                    new Container(
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          new Padding(padding : EdgeInsets.all(67.0)),
                          new Image.asset("images/BIOL_LOGO_128x62.png",),
                        ],
                      ),
                    ),

                    new Padding(padding : EdgeInsets.all(imagePadding)),

                    new Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            height: 50,
                            alignment : Alignment.center,
                            child : (
                                new Text(questionQ,
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontSize: 20),
                                )
                            ),
                          ),

                          new Padding(padding : EdgeInsets.all(10)),

                          new Container(
                            height: 50,
                            alignment : Alignment.center,
                            child : (
                                anonymousQuestion==true ? new Text("Asked by: Anonymous", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,)): new Text("Asked by: $userName", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,))
                            ),
                          ),

                          new Padding(padding : EdgeInsets.all(20)),

                          new Container(
                            height: 50,
                            alignment : Alignment.center,
                            child : (
                                teach!=null?(answerQ=="" ? TextField(controller: answer1, decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Answer',),) : new Text(answerQ, textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,),)):(answerQ=="" ? new Text("No Answer available yet", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,),) : new Text(answerQ, textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,),))
                            ),
                          ),

                          new Padding(padding: EdgeInsets.all(20)),

                          new Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              color: clr.color_1,
                              minWidth: 240.0,
                              height: 30.0,
                              onPressed: () {
                                if(answerQ == "") {
                                  if(answer1.text == "") {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                            title: Text("Error"),
                                            content: Text("Please enter a response!"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("OK")
                                              )
                                            ]
                                        )
                                    );
                                  }
                                  else {
                                    answerQ = answer1.text;
                                    MongoDatabase.answerQuery(questionQ, answerQ);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    MongoDatabase.getDocumentsHelp(teach.accessCode).then((queries) {
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => HelpCenterPage(teacher: teach, student: stud, help: queries)),
                                      );
                                    });
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child:
                                new Text(teach!=null?(answerQ == "" ? "Submit" : "OK"):"OK",
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              new MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                color: clr.color_2,
                                minWidth: 240.0,
                                height: 30.0,
                                child:
                                  new Text("Delete", style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white
                                  ),
                                  ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  MongoDatabase.removeQuery(questionQ);
                                  MongoDatabase.getDocumentsHelp(teach.accessCode).then((queries) {
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => HelpCenterPage(teacher: teach, student: stud, help: queries)),
                                    );
                                  });
                                }
                              )
                            ]
                          ),

                          new Padding(padding : EdgeInsets.all(10)),
                        ]
                    )
                  ]
              )
          ),
        )
    );
  }
}

