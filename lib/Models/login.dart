class LogUser {
  final String? UserName;
  final String? Password;
  final String? img;

  const LogUser({this.UserName, this.Password, this.img});

  factory LogUser.fromJson(Map<String, dynamic> json){
    return LogUser(
      UserName : json['userName'],
      Password : json['password'],
      img : json['img'],
      //Role_Id : json['role_Id'],
    );
  }

  Map toJson() => {
    'userName': UserName,
    'password': Password,
    'img': img,
  };
//u.Role_Id = userResponse['role_Id'];
}