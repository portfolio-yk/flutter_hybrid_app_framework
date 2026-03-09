
import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_result.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/apple/apple_login_handler.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/google/google_login_handler.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/kakao/kakao_login_handler.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/naver/naver_login_handler.dart';

abstract class SnsLoginHandler {

  SnsType get snsType;

  static SnsLoginHandler createLoginHandler(SnsType snsType) {
    switch (snsType) {
      case SnsType.kakao:
        return KakaoLoginHandler();
      case SnsType.naver:
        return NaverLoginHandler();
      case SnsType.google:
        return GoogleLoginHandler();
      case SnsType.apple:
        return AppleLoginHandler();
      default:
        throw Exception('지원되지 않는 로그인 타입입니다.');
    }
  }

  init();
  Future<String> getToken();
  Future<SnsResult> login();
  Future<bool> logout();

}
