import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/local_data.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_result.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_user.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/basic_sns_login_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AppleLoginHandler implements SnsLoginHandler {

  @override
  SnsType get snsType => SnsType.apple;

  @override
  Future<String> getToken() async {
    return (await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    ))
        .identityToken!;
  }

  @override
  init() {
  }

  @override
  Future<SnsResult> login() async {
    try {
      setLocalData(loginType, SnsType.apple.value);
      var credentails = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      var payload = Jwt.parseJwt(credentails.identityToken.toString());

      return SnsResult(
        code: SnsCode.success,
          token: credentails.identityToken!,
          snsType: snsType,
          user: SnsUser(
            id: 'APPLE' + payload['email']!.replaceAll(RegExp('@.+'), ''),
            nickname: payload['email']!.replaceAll(RegExp('@.+'), ''),
            email: payload['email']!,
          ));

    } catch (e, s) {
      debugPrint('$s');
      return SnsResult(code: SnsCode.defaultError, message: SnsCode.defaultError.message);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await setLocalData(loginType, SnsType.none.value);
      return true;
    } catch (e, s) {
      debugPrint(s.toString());
      return false;
    }
  }

}
