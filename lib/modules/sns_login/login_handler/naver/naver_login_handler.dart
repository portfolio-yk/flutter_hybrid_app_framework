import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/modules/sns_login/config/sns_login_config.dart';
import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/local_data.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_result.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_user.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/basic_sns_login_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverLoginHandler implements SnsLoginHandler {
  @override
  SnsType get snsType => SnsType.naver;

  @override
  init() {}

  @override
  Future<String> getToken() async {
    final token = (await FlutterNaverLogin.currentAccessToken).accessToken;
    return token;
  }

  @override
  Future<SnsResult> login() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      setLocalData(loginType, SnsType.naver.value);

      if (result.status == NaverLoginStatus.error) {
        return SnsResult(code: SnsCode.cancel);
      }

      if (result.account.nickname == '' || result.account.email == '') {
        await FlutterNaverLogin.logOutAndDeleteToken();
        return SnsResult(
            code: SnsCode.emptyUserInfo,
            message: SnsCode.emptyUserInfo.message);
      }

      return SnsResult(
          code: SnsCode.success,
          snsType: snsType,
          token: token.accessToken,
          user: SnsUser(
              id: 'NAVER' + result.account.email.replaceAll(RegExp('@.+'), ''),
              nickname: result.account.nickname,
              email: result.account.email));
    } catch (e, s) {
      return SnsResult(
          code: SnsCode.defaultError.message,
          message: SnsCode.defaultError.message);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await setLocalData(loginType, SnsType.none.value);
      await FlutterNaverLogin.logOutAndDeleteToken();

      return true;
    } catch (e, s) {
      debugPrint(s.toString());
      return false;
    }
  }
}
