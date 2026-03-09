import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_user.dart';

class SnsResult {
  SnsCode code;
  SnsType? snsType;
  String message;
  String token;
  SnsUser? user;

  SnsResult({required this.code, this.snsType, this.message = '', this.token = '', this.user}) : assert(code == SnsCode.success ? snsType != null : true);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code.value;
    data['snsType'] = snsType?.value;
    data['message'] = message;
    data['token'] = token;
    data['user'] = user?.toJson();
    return data;
  }
}
