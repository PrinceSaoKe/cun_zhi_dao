class PushBean {
  List pushList = [];

  PushBean.fromMap(Map<String, dynamic> map) {
    map.forEach((key, value) {
      pushList.add(value);
    });
  }
}
