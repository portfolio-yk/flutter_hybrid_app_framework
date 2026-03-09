import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/modules/sns_login/config/sns_login_config.dart';
import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/local_data.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_result.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_user.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/basic_sns_login_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginHandler implements SnsLoginHandler {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  SnsType get snsType => SnsType.google;

  @override
  init() {
    _googleSignIn.signInSilently();
  }

  @override
  Future<String> getToken() async {
    final token = (await _googleSignIn.currentUser!.authentication).idToken!;
    return token;
  }

  @override
  Future<SnsResult> login() async {
    try {
      var account = await _googleSignIn.signIn();

      var authentication = await account!.authentication;
      print("???-> ${authentication.idToken}");
      setLocalData(loginType, SnsType.google.value);

      return SnsResult(
          code: SnsCode.success,
          snsType: snsType,
          token: authentication.idToken!,
          user: SnsUser(
            id: 'GOOGLE' + account.email.replaceAll(RegExp('@.+'), ''),
            nickname: account.displayName!,
            email: account.email,
          ));
    } catch (e, s) {
      debugPrint('$s');

      return SnsResult(
          code: SnsCode.defaultError,
          message: SnsCode.defaultError.message);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await setLocalData(loginType, SnsType.none.value);
      await _googleSignIn.disconnect();
      return true;
    } catch (e, s) {
      debugPrint(s.toString());
      return false;
    }
  }

}
