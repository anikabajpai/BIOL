class Quizzes {

  // Variables contained in quizzes class
  String quizName;
  List<String> questions;
  List<List<String>> answers;
  List<int> correct;

  // Constructor
  Quizzes({this.quizName, this.questions, this.answers, this.correct}) {
    this.quizName = quizName;
    this.questions = questions;
    this.answers = answers;
    this.correct = correct;
  }

  String getQuizName() {
    return this.quizName;
  }

  void setQuizName(String newQuizName) {
    this.quizName = newQuizName;
  }
}