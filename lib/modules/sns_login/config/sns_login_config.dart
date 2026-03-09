import 'package:hybrid_module/modules/sns_login/data/const.dart';

class SnsLoginConfig {
  static String kakaoClientId = '';
  static List<SnsType> supportedSnsLogin = [
    SnsType.kakao,
    SnsType.naver,
    SnsType.google,
    SnsType.apple
  ];
  static List<SnsInfo> supportedSnsInfo = [SnsInfo.nickname, SnsInfo.email, SnsInfo.id];
}
