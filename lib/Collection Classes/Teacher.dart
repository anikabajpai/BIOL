import 'package:BIOL/Collection%20Classes/User.dart';

class Teacher extends User {
  List<String> createdQuizzes;
  List<String> studentActivity;
  List<String> assignedClasses;
  String accessCode;
  Teacher(
      {username, password, emailId, this.accessCode,
      this.createdQuizzes,
      this.studentActivity, this.assignedClasses})
      : super(username: username, password: password, emailId: emailId);

  List<String> getCreatedQuizzes() {
    return createdQuizzes;
  }

  void setCreatedQuizzes(List<String> createdQuizzes) {
    this.createdQuizzes = createdQuizzes;
  }

  List<String> getStudentActivity() {
    return studentActivity;
  }

  void setStudentActivity(List<String> studentActivity) {
    this.studentActivity = studentActivity;
  }

   List<String> getAssignedClasses() {
    return this.assignedClasses;
  }

  void setAssignedClasses(List<String> assignedClasses) {
    this.assignedClasses = assignedClasses;
  }


}
