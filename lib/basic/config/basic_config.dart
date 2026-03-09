import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Config {
  //앱 이름
  static String appName = '';

  //웹뷰 시작 화면
  static String webViewUrl = '';

  // Orientation 설정
  static List<DeviceOrientation> orientations = [];

  //다운로드 화면 로고, 배경 화면 설정
  static String downloadImageUrl = '';
  static int downloadBackgroundColor = 0xFFFFFFFF;
  static Color textColor = Colors.black;

  //플레이스토어 앱id
  static String androidStoreId = '';

  //앱스토어 앱 id
  static String iosStoreId = '';

  //안드로이드 실행 시, chrome inspect 활성화 여부
  static bool isDebugMode = true;

  //컨텐츠 업데이트 활성화 여부
  static bool isContentsUpdateApp = true;

  //서버 통신 url
  static String _baseUrl = '';
  static String _customBaseUrl = '';

  static get androidStoreUrl {
    return 'https://play.google.com/store/apps/details?id=${androidStoreId}';
  }

  static get iosStoreUrl {
    return '';
  }

  static setBaseUrl(String url) {
    _baseUrl = url;
  }

  static setCustomUrl(String url) {
    _customBaseUrl = url;
  }

  static get baseUrl {
    return _customBaseUrl == '' ? _baseUrl : _customBaseUrl;
  }

  static get isTestUser {
    return _customBaseUrl != '';
  }
}
