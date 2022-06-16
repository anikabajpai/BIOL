import 'package:mongo_dart/mongo_dart.dart';
import 'package:BIOL/src/models/studentUser.dart';
import 'package:BIOL/src/models/teacherUser.dart';
import 'package:BIOL/src/models/quizModel.dart';
import 'package:BIOL/src/models/helpcenterModel.dart';

const mongo_url = "mongodb+srv://admin:biol03092021@cluster0.uplqn.mongodb.net/biol?retryWrites=true&w=majority";
const user_collection = "users";
const teacher_collection = "teachers";
const quiz_collection = "quizzes";
const help_collection = "helpcenter";

class MongoDatabase {
  static var db, userCollection, teacherCollection, quizCollection, helpCollection;

  static connect() async {
    db = await Db.create(mongo_url);
    await db.open();
    userCollection = db.collection(user_collection);
    teacherCollection = db.collection(teacher_collection);
    quizCollection = db.collection(quiz_collection);
    helpCollection = db.collection(help_collection);
  }

  // get / search functions ----------------------------------------------------
  static Future<Map<String, dynamic>> loginStudent(email, pass) async {
    var u = await userCollection.findOne({"email": email, "password": pass});
    return u;
  }

  static Future<Map<String, dynamic>> loginTeacher(email, pass) async {
    var u = await teacherCollection.findOne({"email": email, "password": pass});
    return u;
  }

  static searchMail(String email, String role) async {
    var u;
    if (role == "Teacher") {  //teacher
      u = await teacherCollection.findOne({"email": email});
    } else {  //student
      u = await userCollection.findOne({"email": email});
    }
    return u;
  }

  static searchAccount(String email, String role) async {
    var u;
    if (role == "Teacher") {  //teacher
      u = await teacherCollection.findOne({"email": email});
    } else {  //student
      u = await userCollection.findOne({"email": email});
    }
    return u;
  }

  static findStudent(String name) async {
    var u = await userCollection.findOne({"name": name});
    return u;
  }

  static Future<Map<String, dynamic>> findQuery(String queryName) async {
    // return help center query based on the name of query
    var queryDetails = await helpCollection.findOne({"question" : queryName});
    return queryDetails;
  }

  static Future<Map<String, dynamic>> findQuiz(String quizName) async {
    // return quiz information based on the name of quiz
    var quizDetails = await quizCollection.findOne({"quiz_name" : quizName});
    return quizDetails;
  }

  static Future<List<Map<String, dynamic>>> getCustomQuizzes(String accessCode) async {
    // return quizzes that have been created by a given teacher
    // (AKA fetch quizzes that match the teacher's access code)
    var quizzes = await quizCollection.find(
        { "\$or" : [ {"accessCode" : accessCode}, { "accessCode" : null }]}
    ).toList();
    print(quizzes);
    return quizzes;
  }

  static Future<List<Map<String, dynamic>>> getCustomQuizzes2(String accessCode) async {
    // return quizzes that have been created by a given teacher
    // (AKA fetch quizzes that match the teacher's access code)
    var quizzes = await quizCollection.find().toList();
    return quizzes;
  }

  static Future<List<Map<String, dynamic>>> getStudents(String accessCode) async {
    // return list of students with given access code
    final students = await userCollection.find({"accessCode" : accessCode}).toList();
    return students;
  }

  static Future<List<Map<String, dynamic>>> getDocumentsHelp(String accessCode) async {
    // return help center queries containing the teacher's access code
    try {
      final queries = await helpCollection.find({"accessCode" : accessCode}).toList();
      if (queries == null)
        {
          return null;
        }
      else
        return queries;
    } catch (e) {
      print(e);
      return Future.value(e);
    }
  }

  // insert functions ----------------------------------------------------------
  static insertStudent(StudentUser student) async {
    await userCollection.insertAll([student.toMap()]);
  }

  static insertTeacher(TeacherUser teacher) async {
    await teacherCollection.insertAll([teacher.toMap()]);
  }

  static insertQuiz(QuizModel quiz) async {
    await quizCollection.insertAll([quiz.toMap()]);
  }

  static insertQuery(HelpCenterModel query) async {
    await helpCollection.insertAll([query.toMap()]);
  }

  // update functions ----------------------------------------------------------
  static updatePassword(String newPassword, user, String role) async {
    String email = user['email'];
    var u;
    if (role == "Teacher") {  //teacher
      u = await teacherCollection.findOne({"email": email});
    } else {  //student
      u = await userCollection.findOne({"email": email});
    }

    u["password"] = newPassword;

    if (role == "Teacher") {  //teacher
      u = await teacherCollection.save(u);
    } else {  //student
      u = await userCollection.save(u);
    }
  }

  static updateGrade(int grade, String email, String quizName) async {

    var curr = await userCollection.findOne({"email": email});
    int element = 0;
    bool x = false;
    for (int i = 0; i < curr['grade'].length; i++) {
      if (curr['grade'][i].containsKey(quizName)) {
        x = true;
        element = i;
        break;
      }
    }

    print(x);
    if (!x) {
      //quiz first time
      await userCollection.update(
        {"email": email},
          { "\$push": { "grade": {quizName: [grade]} } }
      );
    } else {
      print(element);
      await userCollection.update(
          {"email": email},
          { "\$push": { "grade.$element.$quizName": grade},
            },

      );
    }
  }

  static updateWebsiteGrade(int grade, String email, String quizName) async {

    var curr = await userCollection.findOne({"email": email});
    int element = 0;
    bool x = false;
    if (curr['extraGrade'] == null) {
      await userCollection.update(
          {"email": email},
          { "\$push": { "extraGrade": {quizName: [grade]} } }
      );
      return;
    }
    print("length of extra grade: ${curr['extraGrade'].length}");
    for (int i = 0; i < curr['extraGrade'].length; i++) {
      if (curr['extraGrade'][i].containsKey(quizName)) {
        x = true;
        element = i;
        break;
      }
    }

    print(x);
    if (!x) {
      //quiz first time
      await userCollection.update(
          {"email": email},
          { "\$push": { "extraGrade": {quizName: [grade]} } }
      );
    } else {
      print(element);
      await userCollection.update(
        {"email": email},
        { "\$set": { "extraGrade.$element.$quizName": [grade]},
        },

      );
    }
  }

  static updateAlias(String email, String alias) async {
    await userCollection.update({ "email": email },
        {
          "\$set": { "alias": alias},
        });
  }

  static updateImage(String email, String image) async {
    await userCollection.update({ "email": email },
        {
          "\$set": { "image": image},
        });
  }

  static updateAccessCode(String ac, String nameT, String nameS) async {
    if(nameS == null) { // user is a teacher - update teacher access code
      await teacherCollection.update({ "name": nameT },
          {
            "\$set": { "accessCode": ac},
          });
    } else {            // user is a student - update student access code
      await userCollection.update({ "name": nameS },
          {
            "\$set": { "accessCode": ac},
          });
    }
  }

  static answerQuery(String query, String answer) async {
    await helpCollection.update({"question" : query},
        {
          "\$set": { "answer": answer, "visibleToStudents": true},
        });
  }

  static setDueDate(String quizName, DateTime dueDate) async {
    await quizCollection.update({"quiz_name" : quizName},
        {
          "\$set" : { "dueDate" : dueDate},
        });
  }

  static addQuestion(String quizName, String questionsN, List<String> answersN, String correctN) async {
    print(quizName);
    print(questionsN);
    print(answersN);
    print(correctN);
    await quizCollection.update({"quiz_name" : quizName},
        {
            "\$push":{
              "questions":questionsN,
              "answers":answersN,
              "correct":correctN
            }
        });
  }

  static removeQuestion(String quizName, String questionsN, List<dynamic> answersN, String correctN, int questionNumber) async {
    print(quizName);
    print(questionsN);
    print(answersN);
    print(correctN);
    print(questionNumber);
    await quizCollection.update({"quiz_name" : quizName},
        {
          "\$pull":{
            "questions":questionsN,
            "answers":answersN,
            "correct":correctN
          }
        });
  }

  static removeAC(String email) async {
    print(email);
    var u = await userCollection.findOne({"email" : email});
    u["accessCode"] = "";
    await userCollection.save(u);
  }

  static addNewStudentToClass(String email, String teacherAC) async {
    print(email);
    var u = await userCollection.findOne({"email" : email});
    u["accessCode"] = teacherAC;
    await userCollection.save(u);
  }

  static updateQuiz(QuizModel quiz, String quizName) async {
    var u = await quizCollection.findOne({"quiz_name" : quizName});
    u["quiz_name"] = quiz.quizName;
    u["questions"] = quiz.questions;
    u["answers"] = quiz.answers;
    u["correct"] = quiz.correct;
    await quizCollection.save(u);
  }

  static updateOfr(String quizName, bool ofr) async{
    var u = await quizCollection.findOne({"quiz_name" : quizName});
    u["openForReview"] = ofr;
    await quizCollection.save(u);
  }

  static updateAttempts(String quizName, int attempts) async{
    var u = await quizCollection.findOne({"quiz_name" : quizName});
    u["attempts"] = attempts;
    await quizCollection.save(u);
  }



  static updateStud(String prevEmail, String Name, String Email) async {
    var u = await userCollection.findOne({"email" : prevEmail});
    u["name"] = Name;
    u["email"] = Email;
    await userCollection.save(u);
  }

  static updateTeacher(String prevEmail, String Name, String Email) async {
    var u = await teacherCollection.findOne({"email" : prevEmail});
    u["name"] = Name;
    u["email"] = Email;
    await teacherCollection.save(u);
  }

  static checkAccessCode(String sCode) async {
    final teacherName = await teacherCollection.find().toList();
    for (int i = 0; i < teacherName.length; i++) {
      if (teacherName[i]["accessCode"] == sCode) {
        return true;
      }
    }
    return false;
  }

  static checkAccessCodeTeacher(String tCode) async {
    final userName = await userCollection.find().toList();
    List<String> studentList = [];
    for (int i = 0; i < userName.length; i++) {
      if (userName[i]["accessCode"] == tCode) {
        studentList.add(userName[i]['name']);
      }
    }
    return studentList;
  }

  static addRecentlyViewedQuiz(String name, String recentQuiz) async {
    await userCollection.update({ "name": name },
        {
          "\$set": { "recentQuiz": recentQuiz},
        });
  }

  static Future<Map<String, dynamic>> studentUpdate(email) async {
    var u = await userCollection.findOne({"email": email});
    return u;
  }

  // collection deletion functions ----------------------------------------------------------

  static removeQuiz(String quizName) async {
    print(quizName);
    await quizCollection.remove({"quiz_name" : quizName});
  }

  static removeUser(String email, String role) async {
    print(email);
    if (role == "Teacher") {  //teacher
      await teacherCollection.remove({"email": email});
    }
    else {
      await userCollection.remove({"email": email});
    }
  }

  static removeQuery(String question) async {
    await helpCollection.remove({"question": question});
  }
}