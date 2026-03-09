import 'package:hybrid_module/basic/data/model/oinon_sns_user_model.dart';

class SnsUserResult {
  bool success;
  OnionSnsUserModel? onionSnsUser;
  String? message;


  SnsUserResult({required this.success, this.onionSnsUser, this.message});

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error-message'] = message;
    data['mberSeq'] = onionSnsUser?.mberSeq;
    data['mberId'] = onionSnsUser?.mberId;
    data['sessionId'] = onionSnsUser?.sessionId;
    data['snsType'] = onionSnsUser?.snsType;
    data['email'] = onionSnsUser?.email;
    return data;
  }
}
