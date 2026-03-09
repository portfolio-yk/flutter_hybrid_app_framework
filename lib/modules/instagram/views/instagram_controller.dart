import 'dart:convert';

import 'package:hybrid_module/basic/data/provider/api.dart';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/util/http.dart';
import 'package:hybrid_module/modules/instagram/config/instagram_config.dart';
import 'package:hybrid_module/modules/instagram/data/instagram_profile.dart';
import 'package:hybrid_module/modules/instagram/data/instagram_result.dart';
import 'package:hybrid_module/modules/instagram/data/instagram_site.dart';
import 'package:hybrid_module/modules/instagram/extension/instagram_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class InstagramController extends GetxController {
  final url =
      'https://api.instagram.com/oauth/authorize?client_id=${InstagramConfig.clientID}&redirect_uri=${InstagramConfig.redirectUri}&scope=${InstagramConfig.scope}&response_type=${InstagramConfig.responseType}'
          .obs;

  goURL(url) async {
    var urlStr = url.toString();
    if (urlStr.startsWith(InstagramConfig.redirectUri)) {
      //파싱
      try {
        final repo = MyRepository();
        final code = getAuthorizationCode(urlStr);
        final accessToken =
            await repo.getTokenAndUserId(authorizationCode: code.toString());

        if (accessToken.isNotEmpty) {
          final userProfile =
              await repo.getUserProfile(accessToken: accessToken.toString());

          Get.back(
              result: InstagramResult(
                  code: Instagram.success, userProfile: userProfile));
        } else {
          Get.back(result: InstagramResult(code: Instagram.cancel));
        }
      } catch (e) {
        debugPrint(e.toString());
        Get.back(result: InstagramResult(code: Instagram.cancel));
      }
    } else if (urlStr.startsWith(InstagramSite.oauth.value) ||
        urlStr.startsWith(InstagramSite.accountsLogin.value) ||
        urlStr.startsWith(InstagramSite.accountsOneTap.value) ||
        urlStr.startsWith(InstagramSite.prevRedirect.value)) {
      return Future<NavigationActionPolicy>(() => NavigationActionPolicy.ALLOW);
    } else {
      Get.back(result: InstagramResult(code: Instagram.isOutRoute));
    }
  }

  getAuthorizationCode(String url) {
    /// Parsing the code from string url.
    print(url);
    final authorizationCode = url
        .replaceAll('${InstagramConfig.redirectUri}?code=', '')
        .split('#/')[0];
    return authorizationCode;
  }
}

extension MyApiClientExtension on MyApiClient {
  //TODO try catch 도 추가해야함
  Future<String> getTokenAndUserID({required String authorizationCode}) async {
    final body = {
      "client_id": InstagramConfig.clientID,
      "redirect_uri": InstagramConfig.redirectUri,
      "client_secret": InstagramConfig.appSecret,
      "code": authorizationCode,
      "grant_type": "authorization_code"
    };
    final response = await httpPost(httpClient,
        url: "https://api.instagram.com/oauth/access_token", body: body);
    if (response.statusCode == 200) {
      final accessToken = json.decode(response.body)['access_token'];
      return accessToken;
    } else {
      throw Exception("200 아님");
    }
  }

  Future<InstagramProfile> getUserProfile({required String accessToken}) async {
    //TODO try catch 도 추가해야함
    final params = {
      'fields': InstagramConfig.userFields.join(',').toString(),
      'access_token': accessToken,
    };
    final response = await httpGet(httpClient,
        url: "https://graph.instagram.com/me", queryParams: params);
    if (response.statusCode == 200) {
      final instagramProfile =
          InstagramProfile.fromJson(json.decode(response.body));
      return instagramProfile;
    } else {
      throw Exception("200 아님");
    }
  }
}
