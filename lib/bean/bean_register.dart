class RegisterBean {
  int id = 1;
  String password = '';
  String telephone = '';
  String userName = '';

  RegisterBean.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    password = map['password'];
    telephone = map['telephone'];
    userName = map['username'];
  }
}
