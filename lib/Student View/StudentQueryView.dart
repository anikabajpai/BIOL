import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BIOL/src/models/helpcenterModel.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Shared View (Sign Up, Login, Help Center, etc)/HelpCenter.dart';
import 'package:BIOL/src/models/colortheme.dart';

var clr = AppColors();

// padding constants
// change as needed
const double topPadding = 15.0;
const double imagePadding = 20.0;

class StudentQueryView extends StatefulWidget{
  final HelpCenterModel query;
  final Teacher teacher;
  final Student student;

  StudentQueryView({Key key, @required this.query, @required this.student, @required this.teacher}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new StudentQueryViewState(query: this.query, teacher: this.teacher, student: this.student);
  }
}

class StudentQueryViewState extends State<StudentQueryView> {

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

  StudentQueryViewState({Key key, @required this.query, Student student, Teacher teacher, }) {
    questionQ = query.question;
    answerQ = query.answer;
    accessCodeQ = query.accessCode;
    stud = student;
    teach = teacher;
    visibleToStudents = query.visibleToStudents;
    userName = query.userName;
    anonymousQuestion = query.anonymousQuestion;
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
            backgroundColor: clr.color_1,
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

                          new Padding(padding : EdgeInsets.all(20)),

                          new Container(
                            height: 50,
                            alignment : Alignment.center,
                            child : (
                                teach!=null?(answerQ=="" ? TextField(controller: answer1, decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Answer',),) : new Text(answerQ, textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,),)):(answerQ=="" ? new Text("No Answer available yet", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,),) : new Text(answerQ, textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,),))
                            ),
                          ),

                          new Padding(padding: EdgeInsets.all(20)),

                          new Container(
                            height: 50,
                            alignment : Alignment.center,
                            child : (
                                anonymousQuestion==true ? new Text("Asked by: Anonymous", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,)): new Text("Asked by: $userName", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20,))
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
                                    Navigator.pop(context);
                                  },
                                  child:
                                  new Text(teach!=null?(answerQ == "" ? "Submit" : "OK"):"OK",
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ]
                          ),

                          new Padding(padding: EdgeInsets.all(10)),

                        ]
                    )
                  ]
              )
          ),
        )
    );
  }
}

