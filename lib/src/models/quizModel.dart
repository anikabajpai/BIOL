import 'package:mongo_dart/mongo_dart.dart';

class QuizModel {
  final ObjectId id;
  final String quizName;
  final List<dynamic> questions;
  final List<List<dynamic>> answers;
  final List<dynamic> correct;
  final String accessCode;
  final DateTime dueDate;
  final bool open;
  final int attempts;
  final int timer;

  const QuizModel({this.id, this.quizName, this.questions, this.answers, this.correct, this.accessCode, this.dueDate, this.open, this.attempts, this.timer});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'quiz_name': quizName,
      'questions': questions,
      'answers': answers,
      'correct': correct,
      'accessCode': accessCode,
      'dueDate': dueDate,
      'openForReview': open,
      'attempts': attempts,
      'timer': timer,
    };
  }

  QuizModel.fromMap(Map<String, dynamic> map)
      : quizName = map['quiz_name'],
        id = map['_id'],
        questions = map['questions'],
        answers = map['answers'],
        correct = map['correct'],
        accessCode = map['accessCode'],
        dueDate = map['dueDate'],
        open = map['openForReview'],
        attempts = map['attempts'],
        timer = map['timer'];
}
