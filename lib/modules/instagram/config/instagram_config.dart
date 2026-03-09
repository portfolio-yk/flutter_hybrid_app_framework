/*
  인스타그램 사용자 정보를 가져오는
  instagram display api 입니다
  api 업데이트에 반응해야함!
                               */
class InstagramConfig {
  //앱 설정
  static String clientID = '';
  static String appSecret = '';
  static String redirectUri = '';

  //parameters
  static String scope = '';
  static String responseType = '';
  static const List<String> userFields = ['id', 'username'];
}