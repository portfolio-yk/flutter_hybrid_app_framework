class InstagramProfile {
  String? id;
  String? username;

  InstagramProfile.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      username = json['username'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'username' : username
  };
}