import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/modules/sns_login/config/sns_login_config.dart';
import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/local_data.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_result.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_user.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/basic_sns_login_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLoginHandler implements SnsLoginHandler {
  @override
  SnsType get snsType => SnsType.kakao;

  @override
  init() {
    KakaoSdk.init(nativeAppKey: SnsLoginConfig.kakaoClientId);
  }

  @override
  Future<String> getToken() async {
    final token =
        (await TokenManagerProvider.instance.manager.getToken())!.accessToken;
    return token;
  }

  @override
  Future<SnsResult> login() async {
    OAuthToken token;
    try {
      final installed = await isKakaoTalkInstalled();

      if (installed) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        return SnsResult(code: SnsCode.notInstalledKakaoTalk, message: SnsCode.notInstalledKakaoTalk.message);
      }

      TokenManagerProvider.instance.manager.setToken(token);

      User user = await UserApi.instance.me();

      await setLocalData(loginType, SnsType.kakao.value);

      if (user.kakaoAccount!.profile!.nickname == null ||
          user.kakaoAccount!.email == null) {
        return SnsResult(
            code: SnsCode.emptyUserInfo,
            message: SnsCode.emptyUserInfo.message);
      }

      debugPrint("카카오 access token :: ${token.accessToken}");
      return SnsResult(
          code: SnsCode.success,
          snsType: snsType,
          token: token.accessToken,
          user: SnsUser(
              id: 'KAKAO' + user.kakaoAccount!.email!.replaceAll(RegExp('@.+'), ''),
              nickname: user.kakaoAccount!.profile!.nickname!,
              email: user.kakaoAccount!.email!));
    } on PlatformException catch (e) {
      debugPrint("카카오톡 플랫폼 오류");
      if (e.code == "CANCELED") {
        return SnsResult(code: SnsCode.cancel);
      } else if (e.code == "NotSupportError") {
        return SnsResult(
            code: SnsCode.kakaoInstalledButNotLogin,
            message: SnsCode.kakaoInstalledButNotLogin.message);
      } else {
        throw Exception(SnsCode.defaultError);
      }
    } catch (e, s) {
      debugPrint(s.toString());
      return SnsResult(code: SnsCode.defaultError);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await setLocalData(loginType, SnsType.none.value);
      await TokenManagerProvider.instance.manager.clear();
      return true;
    } catch (e, s) {
      debugPrint(s.toString());
      return false;
    }
  }

}
