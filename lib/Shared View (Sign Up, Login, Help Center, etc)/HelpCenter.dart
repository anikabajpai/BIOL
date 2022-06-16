import 'package:BIOL/Student%20View/StudentQueryView.dart';
import 'package:flutter/material.dart';
import 'SelfHelpCenterPage.dart';
import '../Collection Classes/Teacher.dart';
import '../Collection Classes/Student.dart';
import '../MongoConnect.dart';
import 'package:BIOL/src/models/helpcenterModel.dart';
import '../Teacher View/TeacherQueryView.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:BIOL/src/models/colortheme.dart';
var clr = AppColors();
Future<List<Map<String, dynamic>>> loadHelp(Teacher teacher, Student student) async {
  var queryList;
  if(teacher == null) {
    queryList = await MongoDatabase.getDocumentsHelp(student.accessCode);
  } else {
    queryList = await MongoDatabase.getDocumentsHelp(teacher.accessCode);
  }

  List<Map<String, dynamic>> studentView = [];

  if(teacher == null) {
    for (int i = 0; i < queryList.length; i++) {
      if (queryList[i]['visibleToStudents'] == true) {
        if (queryList[i]['privateQuestion'] == true) {          //if private, check email
          if (queryList[i]['userEmail'] == student.emailId) {
            studentView.add(queryList[i]);
          }
        } else {                                                //else add because it is visible
          studentView.add(queryList[i]);
        }
      }
    }
  } else {
    studentView = queryList;
  }

  return studentView;
}

class Global {
  static final shared =Global();
  bool privateSwitch = false;
  bool anonymousSwitch = false;
}

class PrivateSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SwitchForPrivate();
}

class SwitchForPrivate extends State<PrivateSwitch>{
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: Global.shared.privateSwitch,
      onChanged: (value) {
        setState(() {
          Global.shared.privateSwitch = value;
        });
      }
    );
  }
}

class AnonymousSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SwitchForAnonymous();
}

class SwitchForAnonymous extends State<AnonymousSwitch>{
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: Global.shared.anonymousSwitch,
        onChanged: (value) {
          setState(() {
            Global.shared.anonymousSwitch = value;
          });
        }
    );
  }
}

class TeacherHelpCenter extends StatelessWidget {
  final Teacher teacher;
  final Student student;

  final questionController = TextEditingController();
  String question;

  TeacherHelpCenter({Key key, @required this.teacher, @required this.student}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Help Center"),
          backgroundColor: clr.color_1,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  //Spacer(flex: 3),
                  //Spacer(flex: 3),
                  SizedBox(height: 30),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('All Questions',
                            style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          if(teacher == null) { //show questions for student
                            loadHelp(teacher, student).then((queries) {
                              if (queries == null){
                                showDialog(context: context,builder: (BuildContext context) => _buildPopupDialog(context));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterPage(teacher: this.teacher, student: student, help: queries)),);
                              }
                            });
                          } else { //show class list for teacher
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseClassForQueries(teacher: this.teacher)),);
                          }

                        },
                      )),
                  SizedBox(height: 30),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Enter a New Question',
                            style: TextStyle(fontSize: 20)),
                        onPressed: ()  {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text("Please enter your question:"),
                                  content: TextFormField(
                                    controller: questionController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter your question...'
                                    ),
                                    onChanged: (String value) {
                                      question = questionController.text;
                                    },
                                  ),
                                  actions: <Widget>[
                                    Row(children: [
                                      Expanded(
                                        child: Text("Private?", textAlign: TextAlign.center),
                                      ),
                                      Expanded(
                                        child: PrivateSwitch(),
                                      ),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                        child: Text("Anonymous?", textAlign: TextAlign.center),
                                      ),
                                      Expanded(
                                        child: AnonymousSwitch(),
                                      ),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                          child: TextButton(onPressed: () => Navigator.pop(context),
                                          child: Text("Cancel")
                                      )),
                                      Expanded(
                                        child: TextButton(
                                            onPressed: () {
                                              if(question == "" || question == null) {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) => AlertDialog(
                                                        title: Text("Could Not Save Question"),
                                                        content: Text("Please enter your question"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              child: Text("OK")
                                                          )
                                                        ]
                                                    )
                                                );
                                              } else {
                                                pushQuery(question, "", (teacher != null) ? teacher.accessCode : student.accessCode, false, Global.shared.privateSwitch, (teacher != null) ? teacher.emailId : student.emailId, (teacher != null) ? teacher.username : student.username, Global.shared.anonymousSwitch);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text("OK")
                                        ),
                                      ),
                                    ]),
                                  ]
                              )
                          );
                        },
                      )),
                  SizedBox(height: 30),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Self Help Center', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          loadHelp(teacher, student).then((queries) {
                            if (queries == null) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => _buildPopupDialog(context));
                            }
                            else
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SelfHelpCenterPage(teacher: this.teacher, student: student)),
                              );
                          });

                        },
                      )
                  ),
                  //Spacer(flex: 3)
                ])));
  }

  // function to push quiz to MongoDB
  pushQuery(String question, String answer, String accessCode, bool visibleToStudents, bool privateQuestion, String userEmail, String userName, bool anonymousQuestion) async {
    final query = HelpCenterModel(
      id: M.ObjectId(),
      question: question,
      answer: answer,
      accessCode: accessCode,
      visibleToStudents: visibleToStudents,
      privateQuestion: privateQuestion,
      userEmail: userEmail,
      userName: userName,
      anonymousQuestion: anonymousQuestion
    );
    await MongoDatabase.insertQuery(query);
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Help Center Empty'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("There are currently no questions available"),
      ],
    ),
    actions: <Widget>[
      new MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

class ChooseClassForQueries extends StatefulWidget {
  final Teacher teacher;
  ChooseClassForQueries({Key key, @required this.teacher}) : super(key : key);

  @override
  _classlist createState() => _classlist(teacher: teacher);
}

class _classlist extends State<ChooseClassForQueries> {
  final Teacher teacher;
  var listClasses;
  _classlist({@required this.teacher}) {
    listClasses = [teacher.accessCode]; //will need to be modified when more access codes are allowed
  }

  ListView listBuilding() {
    return ListView(children: [
      ...listClasses
          .map<Widget>(
              (query) => Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: MaterialButton(
                shape: StadiumBorder(),
                textColor: Colors.white,
                color: clr.color_1,
                child: Text('Access Code: ' + teacher.accessCode),
                onPressed: () {
                  loadHelp(teacher, null).then((queries) { //will need to pass a index when multiple access codes are allowed -> also forcing a change to the loadHelp function
                    if (queries == null){
                      showDialog(context: context,builder: (BuildContext context) => _buildPopupDialog(context));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterPage(teacher: this.teacher, student: null, help: queries)),);
                    }
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
          title: Text("Your Classes"),
          backgroundColor: clr.color_2,

        ),
        body: listBuilding()
    );
  }
}


class HelpCenterPage extends StatefulWidget {
  //might need a variable here
  final Teacher teacher;
  final Student student;

  final List<Map<String, dynamic>> help;
  HelpCenterPage({Key key, @required this.teacher, @required this.student, @required this.help}) : super(key : key);

  @override
  _helplist createState() => _helplist(teacher: teacher, student: student, listQueries: this.help);
}

class _helplist extends State<HelpCenterPage> {
  final Teacher teacher;
  final Student student;

  final List<Map<String, dynamic>> listQueries;
  _helplist({@required this.teacher, @required this.student, @required this.listQueries});

  ListView listBuilding() {
    return ListView(children: [
      ...listQueries
          .map<Widget>(
              (query) => Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: MaterialButton(
                shape: StadiumBorder(),
                textColor: Colors.white,
                color: clr.color_1,
                child: Row(
                  children: [
                    SizedBox(child: Text(query['question']),
                    width: 300),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: query['answer'] == "" ? clr.color_2 : clr.color_1,
                        border: Border.all(
                          color: query['answer'] == "" ? Colors.black : clr.color_1,
                          width: 0,
                        ),
                      ),
                    ),
                  ],
                ),

                onPressed: () {

                  MongoDatabase.findQuery(query['question']).then((query) {
                    HelpCenterModel queryX = new HelpCenterModel(
                        id: query['_id'],
                        question:query['question'],
                        answer:query['answer'],
                        accessCode: query['accessCode'],
                        visibleToStudents: query['visibleToStudents'],
                        privateQuestion: query['privateQuestion'],
                        userEmail: query['userEmail'],
                        userName: query['userName'],
                        anonymousQuestion: query['anonymousQuestion']
                    );
                    if (teacher != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TeacherQueryView(query: queryX, student: null, teacher: teacher)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentQueryView(query: queryX, student: student, teacher: null)),
                      );
                    }

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
          title: Text("Help Center"),
          backgroundColor: clr.color_2,
        ),
        body: listBuilding()
    );
  }

}