class SnsUser {
  String id;
  String nickname;
  String email;

  SnsUser({required this.id, required this.nickname, required this.email });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickname'] = nickname;
    data['email'] = email;
    return data;
  }
}