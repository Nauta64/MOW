class User {
  final String? Mail;
  final String? UserName;
  final String? Password;
  final String? img;

  const User({this.Mail,this.UserName, this.Password, this.img});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      Mail : json['mail'],
      UserName : json['userName'],
      Password : json['password'],
      img : json['img'],
      //Role_Id : json['role_Id'],
    );
  }

  Map toJson() => {
    'mail': Mail,
    'userName': UserName,
    'password': Password,
    'img': img,
  };
//u.Role_Id = userResponse['role_Id'];
}