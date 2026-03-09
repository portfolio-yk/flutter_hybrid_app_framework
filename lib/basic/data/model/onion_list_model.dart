class OnionListModel {
  late bool success;
  late List data;

  OnionListModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = json['data'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> result = <String, dynamic>{};
    result['success'] = success;
    result['data'] = data;
    return result;
  }
}