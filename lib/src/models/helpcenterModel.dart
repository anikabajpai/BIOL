import 'package:mongo_dart/mongo_dart.dart';

class HelpCenterModel{
  final ObjectId id;
  final String question;
  final String answer;
  final String accessCode;
  final bool visibleToStudents;
  final bool privateQuestion;
  final String userEmail;
  final String userName;
  final bool anonymousQuestion;

  const HelpCenterModel({this.id, this.question, this.answer, this.accessCode, this.visibleToStudents, this.privateQuestion, this.userEmail, this.userName, this.anonymousQuestion});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'question': question,
      'answer': answer,
      'accessCode': accessCode,
      'visibleToStudents': visibleToStudents,
      'privateQuestion': privateQuestion,
      'userEmail': userEmail,
      'userName': userName,
      'anonymousQuestion': anonymousQuestion
    };
  }

  HelpCenterModel.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        question = map['question'],
        answer = map['answer'],
        accessCode = map['accessCode'],
        visibleToStudents = map['visibleToStudents'],
        privateQuestion = map['privateQuestion'],
        userEmail = map['userEmail'],
        userName = map['userName'],
        anonymousQuestion = map['anonymousQuestion'];
}