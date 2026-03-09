class OnionSnsUserModel {
  final bool success;
  final String sessionId;
  final String email;
  final String mberId;
  final String mberSeq;
  final String snsType;
  final String mberSttus;
  final String errorMessage;

  OnionSnsUserModel.fromJson(Map<String, dynamic> json) :
    success = json['success'] ?? false,
    sessionId = json['sessionId'] ?? '',
    email = json['email'] ?? '',
    mberId = json['mberId'] ?? '',
    mberSeq = json['mberSeq'] ?? '',
    snsType = json['snsType'] ?? '',
    mberSttus = json['mberSttus'] ?? '',
    errorMessage = json['error-message'] ?? '';


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> result = <String, dynamic>{};
    result['success'] = success;
    result['sessionId'] = sessionId;
    result['email'] = email;
    result['mberId'] = mberId;
    result['mberSeq'] = mberSeq;
    result['snsType'] = snsType;
    return result;
  }
}