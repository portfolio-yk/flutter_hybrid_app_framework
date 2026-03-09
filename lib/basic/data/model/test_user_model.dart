class TestUserModel {
  late String deviceNo;
  late String useAt;
  late String url;

  TestUserModel.fromJson(Map<String, dynamic> json){
    deviceNo = json['deviceNo'];
    useAt = json['useAt'];
    url = json['url'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceNo'] = deviceNo;
    data['url'] = url;
    data['useAt'] = useAt;
    return data;
  }
}