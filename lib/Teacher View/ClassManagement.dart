import 'package:flutter/material.dart';
import 'package:BIOL/Collection Classes/Student.dart';
import 'package:BIOL/Student View/StudentDashboard.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:BIOL/MongoConnect.dart';

class ClassManagement extends StatelessWidget {

  final Teacher teacher;
  ClassManagement({Key key, @required this.teacher}) : super(key : key);

  studentList() async {
    var sL = await MongoDatabase.checkAccessCodeTeacher(teacher.accessCode);

    //sL is List<Map<String, dynamic>>
    print("Printing student list...");
    for (int i = 0; i < sL.length; i++) {
      print("name: ${sL[i]}");
    }

    return sL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Class Management"),
          backgroundColor: clr.color_2,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  //Spacer(flex: 3),
                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: Text('Class 1 - Access Code: ' + teacher.accessCode, style: TextStyle(fontSize: 15)),
                        onPressed: () {studentList().then((sL) async {
                          List<String> attemptList = [];
                          int highestGrade = -1;
                          List<int> newGradeList = [];
                          for (int i = 0; i < sL.length; i++) {
                            await MongoDatabase.findStudent(sL[i]).then((stud) {
                              print("studname: ${stud['name']}");
                            });
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewingClass(teacher: teacher, studentList: sL)),
                          );
                        });
                        },
                      )),
                ])));
  }
}

class ViewingClass extends StatefulWidget {
  final Teacher teacher;
  final List studentList;

  ViewingClass({Key key, @required this.teacher, @required this.studentList}) : super(key : key);

  @override
  ViewingClassClass createState() => ViewingClassClass(teacher: teacher, studentList: this.studentList);
}

class ViewingClassClass extends State<ViewingClass> {
  final Teacher teacher;
  final List studentList;

  final studentEmailController = TextEditingController();
  String studEmail;

  ViewingClassClass({Key key, @required this.teacher, @required this.studentList});

  Padding listBuilding() {
    return Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Table(
            children: [
              for (int i = 0; i < studentList.length; i++)
                TableRow(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: clr.color_2,
                            padding: const EdgeInsets.all(25),
                            side: BorderSide(width: 5.0, color: Colors.white),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),),
                        onPressed: () {
                          MongoDatabase.findStudent(studentList[i]).then((student){
                            Student student2 = new Student(
                                id: student["_id"],
                                username: student["name"],
                                emailId: student['email'],
                                password: student["password"],
                                grade: student["grade"],
                                accessCode: student["accessCode"],
                                image: student["image"],
                                alias: student["alias"],
                                recentQuiz: student["recentQuiz"],
                                completedQuizzes: null,
                                viewedQuizzes: null,
                                percentageCorrect: 0.0,
                                percentageWrong: 0.0
                            );

                            MongoDatabase.getCustomQuizzes(student2.accessCode).then((lq2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StudentDetails(student: student2, teacher: teacher, lq: lq2)),
                              );
                            });

                          });

                        },
                        child: Text("${studentList[i]}", textScaleFactor: 1.3,),
                      ),
                    ])
            ])
    );
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Student List"),
          backgroundColor: clr.color_2,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(0, 35, 10, 5),
                      child: Text('Student Names:\n ',
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                      )
                  ),

                  listBuilding(),

                  new Padding(padding : EdgeInsets.all(20.0)),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: new Text("Enroll New Student", style: new TextStyle( fontSize: 18.0, color: Colors.white)),
                        onPressed: () => showDialog<String>(context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Please enter the student's in-app email:"),
                              content: TextFormField(
                                controller: studentEmailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter Email...'
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    studEmail = studentEmailController.text;
                                  }
                                  );
                                },
                              ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")
                                  ),

                                  TextButton(
                                      onPressed: ()
                                      {
                                        print(studEmail);
                                        MongoDatabase.searchAccount(studentEmailController.text, "Student").then((student) {
                                          if (student == null) {
                                            NoUserFailedAlert(context);
                                          }
                                          else{
                                            addStudent(studEmail, teacher.accessCode);
                                            exitQuiz();
                                            exitQuiz();
                                          }
                                        });

                                      },
                                      child: Text("Add Student")
                                  )
                                ]
                            )
                        ),
                      )
                  ),

                ])
    ));
  }

  addStudent(String email, String aC) async{
    await MongoDatabase.addNewStudentToClass(email, aC);
  }

  void exitQuiz() {
    setState(() {
      Navigator.pop(context);
    });
  }

}

NoUserFailedAlert(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Enrollment Failed"),
    content: Text("This Email isn't present in the database. Please try again."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// padding constants - change as needed
const double topPadding = 15.0;
const double EnterQuizPadding = 30.0;
const double paddingBetweenAnswers = 5.0;

// answer choices height & width
const double buttonHeight = 60.0;
const double buttonWidth = 800.0;

class StudentDetails extends StatefulWidget{
  final Student student;
  final Teacher teacher;
  final List<Map<String, dynamic>> lq;

  StudentDetails({Key key, @required this.student, @required this.teacher, @required this.lq}) : super(key : key);
  @override
  State<StatefulWidget> createState() {
    return new StudentDetailsState(student: this.student, teacher: this.teacher, lq: this.lq);
  }
}

class StudentDetailsState extends State<StudentDetails> {

  // local variables - filled in build()

  Student student;
  Teacher teacher;
  final List<Map<String, dynamic>> lq;

  StudentDetailsState({Key key, @required this.student, @required this.teacher,  @required this.lq});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student Details", style: new TextStyle( fontSize: 18.0, color: Colors.white),),
          backgroundColor: clr.color_2,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[

                  Image.asset(
                    student!=null?student.image:'images/profile/green.png', width: 600, height: 240,),
                  //Spacer(flex: 3),

                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(5, 35, 5, 5),
                      child: Text('Name: ' + student.username,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),) //want it to do nothing
                  ),


                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(5, 35, 5, 5),
                      child: Text('Email: ' + student.emailId,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),) //want it to do nothing
                  ),

                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.fromLTRB(5, 35, 5, 5),
                      child: Text('Alias: '+student.alias,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),) //want it to do nothing
                  ),

                  new Padding(padding : EdgeInsets.all(25.0)),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: new Text("View Grades", style: new TextStyle( fontSize: 18.0, color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StudentGrades(student: student, lq: lq)),
                          );
                        },
                      )),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: new Text("Remove from Class", style: new TextStyle( fontSize: 18.0, color: Colors.white)),
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text("Reset Student Access Code?"),
                                content: Text("Are you sure you want to remove this student from your class?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")
                                  ),

                                  TextButton(
                                      onPressed: ()
                                      {
                                        removeAC(student.emailId);
                                        exitQuiz();
                                        exitQuiz();
                                        exitQuiz();
                                      },
                                      child: Text("Yes")
                                  )
                                ]
                            )
                        ),
                      )),

                  Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_2,
                        child: new Text("Delete Account", style: new TextStyle( fontSize: 18.0, color: Colors.white)),
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text("Delete Account?"),
                                content: Text("Are you sure you want to delete this account?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")
                                  ),

                                  TextButton(
                                      onPressed: ()
                                      {
                                          removeUser(student.emailId, "Student");
                                          exitQuiz();
                                          exitQuiz();
                                          exitQuiz();
                                      },
                                      child: Text("Delete Account")
                                  )
                                ]
                            )
                        ),
                      )),

                  new Padding(padding : EdgeInsets.all(35.0)),


                ])));
  }


  void exitQuiz() {
    setState(() {
      Navigator.pop(context);
    });
  }

  removeUser(String email, String role) async{
    await MongoDatabase.removeUser(email, role);
  }

  removeAC(String email) async{
    await MongoDatabase.removeAC(email);
  }

}
