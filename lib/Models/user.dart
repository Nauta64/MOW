class User {
  final String? Mail;
  final String? UserName;
  final String? Password;

  const User({this.Mail,this.UserName, this.Password});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      Mail : json['mail'],
      UserName : json['userName'],
      Password : json['password'],
      //Role_Id : json['role_Id'],
    );
  }

  Map toJson() => {
    'mail': Mail,
    'userName': UserName,
    'password': Password,
  };
//u.Role_Id = userResponse['role_Id'];
}