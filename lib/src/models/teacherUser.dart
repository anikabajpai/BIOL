import 'package:mongo_dart/mongo_dart.dart';

class TeacherUser {
  final ObjectId id;
  final String name;
  final String email;
  final String password;
  final String accessCode;

  const TeacherUser({this.id, this.name, this.email, this.password, this.accessCode});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'accessCode': accessCode,
    };
  }

  TeacherUser.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        email = map['email'],
        password = map['password'],
        accessCode = map['accessCode'];
}