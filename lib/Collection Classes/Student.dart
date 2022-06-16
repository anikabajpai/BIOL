import 'package:BIOL/Collection%20Classes/User.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Student extends User {
  List<String> completedQuizzes;
  List<String> viewedQuizzes;
  double percentageCorrect;
  double percentageWrong;
  List<String> enrolledClasses;
  List<String> studentQuestions;
  List<String> teacherAnswers;
  List<dynamic> grade;
  List<dynamic> extraGrade;
  String accessCode;
  String alias;
  String image;
  String recentQuiz;
  ObjectId id;
  Student({username, emailId, password, this.accessCode, this.grade, this.alias, this.image, this.recentQuiz, this.completedQuizzes, this.viewedQuizzes,
  this.percentageCorrect, this.percentageWrong, this.enrolledClasses, this.studentQuestions, this.teacherAnswers,
  this.id, this.extraGrade})
  : super(username: username, emailId: emailId, password: password);


  List<String> getCompletedQuizzes() {
    return completedQuizzes;
  }

  void setCompletedQuizzes(List<String> completedQuizzes) {
    this.completedQuizzes = completedQuizzes;
  }

  List<String> getViewedQuizzes() {
    return viewedQuizzes;
  }

  void setViewedQuizzes(List<String> viewedQuizzes) {
    this.viewedQuizzes = viewedQuizzes;
  }

  double getPercentageCorrect() {
    return this.percentageCorrect;
  }

  void setPercentageCorrect(double percentageCorrect) {
    this.percentageCorrect = percentageCorrect;
  }

  double getPercentageWrong() {
    return this.percentageWrong;
  }

  void setPercentageWrong(double percentageWrong) {
    this.percentageWrong = percentageWrong;
  }

  List<String> getEnrolledClasses() {
    return this.enrolledClasses;
  }

  void setEnrolledClasses(List<String> enrolledClasses) {
    this.enrolledClasses = enrolledClasses;
  }

  List<String> getStudentQuestions(List<String> studentQuestions) {
    return this.studentQuestions;
  }

  void setStudentQuestions(List<String> studentQuestions) {
    this.studentQuestions = studentQuestions;
  }

  List<String> getTeacherAnswers(List<String> teacherAnswers){
    return this.teacherAnswers;
  }

  void setTeacherAnswers(List<String> teacherAnswers){
    this.teacherAnswers = teacherAnswers;
  }

}