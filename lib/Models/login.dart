class LogUser {
  final String? UserName;
  final String? Password;

  const LogUser({this.UserName, this.Password});

  factory LogUser.fromJson(Map<String, dynamic> json){
    return LogUser(
      UserName : json['userName'],
      Password : json['password'],
      //Role_Id : json['role_Id'],
    );
  }

  Map toJson() => {
    'userName': UserName,
    'password': Password,
  };
//u.Role_Id = userResponse['role_Id'];
}