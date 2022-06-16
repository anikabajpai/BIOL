class User {
  String username;
  String password;
  String emailId;
  
  User({this.username, this.emailId, password}) {
    this.username = username;
    this.emailId = emailId;
  }

  String getUsername() {
    return this.username;
  }

  void setUsername(String newUsername) {
    this.username = newUsername;
  }

  String getEmailId() {
    return this.emailId;
  }

  void setEmailId(String newEmailId) {
    this.emailId = newEmailId;
  }

  String getPassword() {
    return this.password;
  }

  void setPassword(String password) {
    this.password = password;
  }
}
