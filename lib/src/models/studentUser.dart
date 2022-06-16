import 'package:mongo_dart/mongo_dart.dart';

class StudentUser {
  final ObjectId id;
  final String name;
  final String email;
  final String password;
  String accessCode;
  final List<dynamic> grade;

  StudentUser({this.id, this.name, this.email, this.password, this.accessCode, this.grade});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'accessCode': accessCode,
      'grade': grade,
    };
  }

  StudentUser.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        email = map['email'],
        password = map['password'],
        accessCode = map['accessCode'],
        grade = map['grade'];
}
