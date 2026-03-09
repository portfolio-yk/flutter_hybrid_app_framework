class FcmMessageCase {
  String pushUrl; // 푸시가 올 경우 해당 페이지로 이동
  List<String> blockNotiUrls; // 포그라운드 상태 시 보고 있는 Page Name일 경우 FCM 알림 X
  String? paramName; // FCM에 실려오는 파라미터

  FcmMessageCase({ required this.pushUrl,required this.blockNotiUrls, this.paramName});
}