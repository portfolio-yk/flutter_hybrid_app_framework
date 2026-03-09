import 'package:hybrid_module/modules/fcm/model/fcm_message_case.dart';
import 'package:flutter/cupertino.dart';

class FcmConfig {
  //푸시 알림의 종류
  static final Map<String, FcmMessageCase> caseMap = {
    'NOTICE': FcmMessageCase(pushUrl: 'Home/MessagePage?mode=NOTICE', blockNotiUrls: ['MessagePage'], paramName: 'nttSeq'),
    'CHAT': FcmMessageCase(pushUrl: 'Home/MessagePage?mode=CHAT', blockNotiUrls: ['MessagePage']),
  };

  //토픽의 종류 (true 로 설정 시, 앱 최초 실행 시 구독된다.
  static final Map<String, bool> topicMap = {
    'NOTICE': true,
  };

  static void add(Map<String, FcmMessageCase> fcmCaseMap) {
    fcmCaseMap.entries.map((entry) => {
      caseMap[entry.key] = entry.value,
      debugPrint("FCM CASE MAP 추가 완료 ${entry.key} : ${entry.value}")
    });
  }
}
