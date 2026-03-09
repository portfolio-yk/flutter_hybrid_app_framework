import 'package:flutter/cupertino.dart';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/modules/sns_login/config/sns_login_config.dart';
import 'package:hybrid_module/modules/sns_login/data/const.dart';
import 'package:hybrid_module/modules/sns_login/data/local_data.dart';
import 'package:hybrid_module/modules/sns_login/data/sns_result.dart';
import 'package:hybrid_module/modules/sns_login/login_handler/basic_sns_login_handler.dart';

import 'data/sns_user_result.dart';

class SnsLoginManager {
  static final SnsLoginManager instance = SnsLoginManager._internal();

  Map<String, SnsLoginHandler> loginHandlers = {};

  SnsLoginManager._internal();

  static init({kakaoClientId}) {
    SnsLoginConfig.kakaoClientId = kakaoClientId ?? '';
    SnsLoginManager.instance._init();
  }

  _init() async {
    List<SnsLoginHandler> handlers = SnsLoginConfig.supportedSnsLogin
        .map((type) => SnsLoginHandler.createLoginHandler(type))
        .toList();

    final snsLoginManager = SnsLoginManager.instance;
    for (var handler in handlers) {
      handler.init();
      snsLoginManager.loginHandlers[handler.snsType.value] = handler;
    }

    final nativeCallHandler = NativeCallHandler.instance;
    nativeCallHandler.addCallBack(
        name: 'getLoginInfo',
        callback: (args) async {
          final result = args.isNotEmpty
              ? await snsLoginManager.login(args[0])
              : await snsLoginManager.autoLogin();
          return result.toJson();
        });
    nativeCallHandler.addCallBack(
        name: 'expireLoginInfo',
        callback: (args) async {
          final result = await snsLoginManager.logout();
          print(result);
          return result;
        });
    //2022-07-14 login add
    //test
    nativeCallHandler.addCallBack(name: 'snsLogin', callback: (args) async {
      //TODO login -> getLoginInfo..
      final result = args.isNotEmpty ? await snsLoginManager.login(args[0]) : await snsLoginManager.autoLogin();
      final snsUserResult = await snsLoginManager.snsLogin(result);
      return snsUserResult.toJson();
    });
  }

  static printToken(SnsType snsType) async {
    final result =
        await SnsLoginManager.instance.loginHandlers[snsType.value]!.login();

    debugPrint('${snsType.value} token : ${result.token}');
  }

  Future<SnsUserResult> snsLogin(SnsResult snsResult) async {
    try {
      final onionSnsUser = await MyRepository().snsLogin(
          snsToken: snsResult.token, snsType: snsResult.snsType.toString());
      if (onionSnsUser.success) {
        await setLocalData(loginType, snsResult.snsType);
        return SnsUserResult(success: true, onionSnsUser: onionSnsUser);
      } else {
        return SnsUserResult(success: false, message : onionSnsUser.errorMessage);
      }
    } catch(e) {
      await setLocalData(loginType, SnsType.none.value);
      return SnsUserResult(success: false, message : SnsCode.defaultError.message);
    }
  }

  Future<SnsResult> autoLogin() async {
    try {
      String snsType = await getLocalData(loginType);

      if (snsType == SnsType.none.value) {
        return SnsResult(code: SnsCode.notLogin);
      }

      final loginHandler = loginHandlers[snsType];
      if (loginHandler != null) {
        final token = await loginHandler.getToken();
        if (token.isNotEmpty) {
          final snsResult = await loginHandler.login();
          return snsResult;
        } else {
          await setLocalData(loginType, SnsType.none.value);
          return SnsResult(
              code: SnsCode.emptyToken, message: SnsCode.emptyToken.message);
        }
      } else {
        return SnsResult(
            code: SnsCode.notSupportedLoginType,
            message: SnsCode.notSupportedLoginType.message);
      }
    } catch (e, s) {
      debugPrint('$s');
      await setLocalData(loginType, SnsType.none.value);
      return SnsResult(
          code: SnsCode.defaultError, message: SnsCode.defaultError.message);
    }
  }

  Future<SnsResult> login(String snsType) async {
    try {
      final loginHandler = loginHandlers[snsType];
      if (loginHandler != null) {
        final snsResult = await loginHandler.login();
        await setLocalData(loginType, snsType);
        return snsResult;
      } else {
        return SnsResult(
            code: SnsCode.notSupportedLoginType,
            message: SnsCode.notSupportedLoginType.message);
      }
    } catch (e, s) {
      debugPrint(s.toString());
      return SnsResult(
          code: SnsCode.defaultError, message: SnsCode.defaultError.message);
    }
  }

  Future<bool?> logout() async {
    try {
      final snsType = await getLocalData(loginType);
      await setLocalData(loginType, SnsType.none.value);
      print("snsType :::::::::::: ${snsType}");
      return await SnsLoginManager.instance.loginHandlers[snsType]?.logout();
    } catch (e, s) {
      debugPrint(s.toString());
      debugPrint(e.toString());
      return false;
    }
  }
}
