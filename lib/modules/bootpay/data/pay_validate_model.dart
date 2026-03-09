class PayValidateModel {
  late bool success;
  late String message;

  PayValidateModel({required this.success, this.message = ''});

  PayValidateModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}
