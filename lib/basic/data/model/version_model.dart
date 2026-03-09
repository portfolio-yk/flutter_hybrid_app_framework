class VersionModel {
  late String ver;

  VersionModel.fromJson(Map<String, dynamic> json){
    ver = json['ver'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> result = <String, dynamic>{};
    result['ver'] = ver;
    return result;
  }
}