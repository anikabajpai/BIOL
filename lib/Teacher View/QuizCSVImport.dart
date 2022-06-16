import 'dart:convert';
import 'dart:io';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:BIOL/Collection Classes/Teacher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:BIOL/src/models/colortheme.dart';
import 'package:BIOL/MongoConnect.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:url_launcher/url_launcher.dart';
var clr = AppColors();

class QuizCSVImport extends StatelessWidget {
  final Teacher teacher;

  QuizCSVImport({Key key, @required this.teacher}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Import from CSV"),
        backgroundColor: clr.header,
      ),
      body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
              children: <Widget>[
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 5),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text('Hello, ' + teacher.username + '!',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),)
                  ),
                ),
                getTextSection('Here you can upload a custom quiz from a .csv file. Please follow the instructions below:'),
                getSubTextSection('A YouTube video demonstration can be found here:'),
                Padding(padding: EdgeInsets.all(10.0)),
                new InkWell(
                  child: new Text('https://youtu.be/Uf0d7zE_7Eo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: clr.color_1,
                        fontSize: 20),
                  ),
                  onTap: () {
                    launch('https://youtu.be/Uf0d7zE_7Eo');
                  }
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                getTextSection('1. Click the below button to receive an email containing the CSV template:'),
                Padding(padding: EdgeInsets.all(10.0)),
                Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child:
                    MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('Email Me the CSV Template'),
                        onPressed: () async {
                          //send email
                          String usernameC = 'cHVyZHVlLmVwaWNzLmJsYWNrQGdtYWlsLmNvbQ==';
                          String passwordC = 'YmxhY2tAZXBpY3M=';
                          Codec<String, String> stringToBase64 = utf8.fuse(base64);
                          usernameC = stringToBase64.decode(usernameC);
                          passwordC = stringToBase64.decode(passwordC);

                          final smtpServer = SmtpServer('smtp.gmail.com',
                              username: usernameC, password: passwordC);

                          fetchTemplate().then((File file) async {

                            final message = Message()
                              ..from = Address(usernameC, usernameC)
                              ..recipients.add(teacher.emailId)
                              ..subject = 'BIOL Quiz Upload Template'
                              ..text = 'Hello,\n\nThank you for requesting the BIOL quiz upload '
                                  'template. Please find the file attached. If you have any doubts, '
                                  'please refer to the YouTube demonstration -- a link can be found '
                                  'under Import from CSV section in the app.\n\nBest regards,\n'
                                  'The BIOL Team'
                              ..attachments = [
                                FileAttachment(file)
                                  ..location = Location.inline
                              ];

                            try {
                              final sendReport = await send(message, smtpServer);
                              print('Message sent: ' + sendReport.toString());
                            }
                            on MailerException catch (e) {
                              print('Message not sent.');
                              print(e);
                              for (var p in e.problems) {
                                print('Problem: ${p.code}: ${p.msg}');
                              }
                            }
                          });
                        }
                    )
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                getTextSection('2. Fill in the quiz name, then fill in a quiz question, four answer choices, and a answer choice number'
                ' in each row. You may enter as many questions as you would like. Please note that all fields are required.'),
                getSubTextSection('Note: Please do not overwrite the column titles. Imports with incorrect formatting cannot be accepted.'
                ' Please see the link above for a YouTube detailed explanation.'),
                getTextSection('3. Once all of the quiz details have been entered, please upload the .csv file by clicking the'
                ' button below. The quiz will be viewable immediately after uploading.'),
                Padding(padding: EdgeInsets.all(10.0)),
                Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child:
                    MaterialButton(
                        shape: StadiumBorder(),
                        textColor: Colors.white,
                        color: clr.color_1,
                        child: Text('Upload CSV'),
                        onPressed: () async {
                          // opens dialogue for file selection -- awaits teacher selection
                          // note that the teacher chooses file from either device files OR
                          // Google Drive if they have given the app permission
                          FilePickerResult result = await FilePicker.platform.pickFiles();

                          // check result and begin parsing if valid
                          if (result != null) {
                            File file = File(result.files.single.path);
                            String fileName = file.path;
                            String ext = file.path.substring(fileName.length - 3, fileName.length);

                            // check for CSV file
                            if(ext != "csv") {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text("File selected is not a .CSV file"),
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
                              file.readAsLines().then((List<String> s) {
                                // containers for eventual quiz
                                String quizName = "";
                                List<String> questions = [];
                                List<List<String>> answers = [];
                                List<String> correct = [];
                                List<String> errorReading = [];
                                var splitData = [];

                                // split the data for easier processing
                                for(int i = 0; i < s.length; i++) {
                                  splitData.add(s[i].split(','));
                                }

                                // initial check for details - do not process if
                                // no data is present OR if there are too few rows
                                // to be a valid file (quiz name and column headers
                                // take up two rows, so there should be at least
                                // three rows for a one-question quiz...
                                if (splitData == []) {
                                  errorReading.add("Please insert a correct file!");
                                }
                                else if(splitData.length < 3) {
                                  errorReading.add("Not enough lines in file");
                                }

                                // UNCOMMENT TO SEE CSV INPUT DETAILS
                                // --------------------------------------------
                                //for(int i = 0; i < splitData.length; i++) {
                                //  print(i.toString() + ": " + splitData[i].toString());
                                //}

                                // now that we're all set, let's begin constructing the quiz info...
                                for(int i = 0; i < splitData.length; i++) {
                                  if (i == 0) {
                                    // get quiz name from column 2 (index 1)
                                    if (splitData[i][1] == '') {
                                      errorReading.add("Quiz name not specified");
                                    } else {
                                      quizName = splitData[0][1];
                                    }
                                  }
                                  else if (i >= 2) {
                                    //  0  1  2  3  4  5 <- quiz name stored here in 1
                                    //  6  7  8  9 10 11 <- column headers (ignore)
                                    // 12 13 14 15 16 17 <- questions start here and continue

                                    // get question
                                    if(splitData[i][0] == '') {
                                      errorReading.add("In row " + (i+1).toString() + ": Question not specified");
                                    }
                                    else {
                                      questions.add(splitData[i][0]);
                                    }

                                    // get answer choices
                                    List<String> tempAns = [];
                                    if(splitData[i][1] == '') {
                                      errorReading.add("In row " + (i+1).toString() + ": Option 1 not specified");
                                    }
                                    else {
                                      tempAns.add(splitData[i][1]);
                                    }

                                    if(splitData[i][2] == '') {
                                      errorReading.add("In row " + (i+1).toString() + ": Option 2 not specified");
                                    }
                                    else {
                                      tempAns.add(splitData[i][2]);
                                    }


                                    if(splitData[i][3] == '') {
                                      errorReading.add("In row " + (i+1).toString() + ": Option 3 not specified");
                                    }
                                    else {
                                      tempAns.add(splitData[i][3]);
                                    }

                                    if(splitData[i][4] == '') {
                                      errorReading.add("In row " + (i+1).toString() + ": Option 4 not specified");
                                    }
                                    else {
                                      tempAns.add(splitData[i][4]);
                                    }
                                    answers.add(tempAns);

                                    // get correct answer
                                    if(splitData[i][5] == '') {
                                      errorReading.add("In row " + (i+1).toString() + ": Correct answer not specified");
                                    }
                                    else {
                                      if(isNumeric(splitData[i][5])) {
                                        int corr = int.parse(splitData[i][5]);
                                        if(corr == 1 || corr == 2 || corr == 3 || corr == 4) {
                                          correct.add(splitData[i][corr]);
                                        } else {
                                          errorReading.add("Correct answer must be 1, 2, 3, or 4");
                                        }
                                      } else {
                                        errorReading.add("Must have numeric correct answer choices");
                                      }
                                    }
                                  }
                                  else {
                                    // double-check that columns have not been overwritten
                                    if(splitData[i][0] != "Question" || splitData[i][1] != "Option 1" || splitData[i][2] != "Option 2" || splitData[i][3] != "Option 3" || splitData[i][4] != "Option 4" || splitData[i][5] != "Correct Answer") {
                                      errorReading.add("Please ensure columns have not been overwritten");
                                    }
                                  }
                                }

                                // great, now quiz details 'should' be fully stored...let's check
                                if(errorReading.isEmpty) {
                                  // clean read -- add to quizzes
                                  pushQuiz(quizName, questions, answers, correct, teacher.accessCode, 10, 0);
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                          title: Text("Quiz Uploaded Successfully!"),
                                          content: Text("Your quiz is immediately viewable in the 'View Quiz Information' section of the app"),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text("OK")
                                            )
                                          ]
                                      )
                                  );
                                } else {
                                  String text = "";
                                  for(int i = 0; i < errorReading.length; i++) {
                                    text = text + "\n" + errorReading[i];
                                  }
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                          title: Text("Error importing quiz for the following reasons:"),
                                          content: Text(text),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text("OK")
                                            )
                                          ]
                                      )
                                  );
                                }
                              });
                            }
                          }
                          else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text("File not selected. Quiz has not been imported"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK")
                                      )
                                    ]
                                )
                            );
                          }
                        }
                    )
                ),
                Padding(padding: EdgeInsets.all(10.0)),
              ])),
    );
  }
}

Widget getTextSection(String text) {
  Widget textSection = Padding(
    padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
    child: Text(text,
        softWrap: true, style: TextStyle(fontSize: 20)
    ),
  );
  return textSection;
}

Widget getSubTextSection(String text) {
  Widget textSection = Padding(
    padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
    child: Text(text,
        softWrap: true, style: TextStyle(fontSize: 16)
    ),
  );
  return textSection;
}

// simple checker to see if a string is numeric or not - source code via
// https://stackoverflow.com/questions/24085385/checking-if-string-is-numeric-in-dart
bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

pushQuiz(String quizName, List<String> questions, List<List<String>> answers, List<String> correct, String accessCode, int attempts, int timer) async {
  DateTime dueDate; //due date
  bool oFR = false;
  final quiz = QuizModel(
    id: M.ObjectId(),
    quizName: quizName,
    questions: questions,
    answers: answers,
    correct: correct,
    accessCode: accessCode,
    dueDate: dueDate,
    open: oFR,
    attempts: attempts,
    timer: timer,
  );
  //print(dueDate.timeZoneName);
  await MongoDatabase.insertQuiz(quiz);
}

// function to fetch and reconstruct CSV file to send to teacher
// based on https://www.codegrepper.com/code-examples/whatever/flutter+load+asset+as+file
Future<File> fetchTemplate() async {
  final data = await rootBundle.load('assets/BIOL_Import_Template.csv');
  final template = File('${(await getTemporaryDirectory()).path}/BIOL_Import_Template.csv');
  await template.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  return template;
}