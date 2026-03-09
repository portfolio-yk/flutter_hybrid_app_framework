import 'package:hybrid_module/basic/util/shared_preference.dart';

enum SnsType {
  apple,
  naver,
  kakao,
  google,
  none,
}

extension SnsTypeExtension on SnsType {
  get value {
    switch (this) {
      case SnsType.kakao:
        return 'KAKAO';
      case SnsType.naver:
        return 'NAVER';
      case SnsType.google:
        return 'GOOGLE';
      case SnsType.apple:
        return 'APPLE';
      case SnsType.none:
        return 'NONE';
    }
  }
}

enum SnsCode {
  success,
  cancel,
  defaultError,
  emptyUserInfo,
  kakaoInstalledButNotLogin,
  emptyToken,
  notLogin,
  notSupportedLoginType,
  notInstalledKakaoTalk
}

extension SnsCodeExtension on SnsCode {
  get message {
    switch (this) {
      case SnsCode.success:
        return '';
      case SnsCode.cancel:
        return '로그인이 취소 되었습니다.';
      case SnsCode.emptyUserInfo:
        return '사용자 정보 제공에 모두 동의해주세요.';
      case SnsCode.kakaoInstalledButNotLogin:
        return '카카오톡 앱에서 로그인을 먼저 진행해주세요.';
      case SnsCode.notInstalledKakaoTalk:
        return '카카오톡이 설치되어 있지 않습니다.';
      case SnsCode.emptyToken:
        return 'SNS 토큰 값이 비어있습니다.';
      case SnsCode.notLogin:
        return '로그인이 되지 않았습니다.';
      case SnsCode.notSupportedLoginType:
        return '지원하지 않는 SNS 로그인입니다.';
      case SnsCode.defaultError:
      default:
        return 'SNS 로그인 처리 중 오류가 발생했습니다.';
    }
  }

  get value {
    switch (this) {
      case SnsCode.success:
        return 'SNS_SUCCESS';
      case SnsCode.cancel:
        return 'SNS_CANCEL';
      case SnsCode.emptyUserInfo:
        return 'SNS_EMPTY_USER_INFO';
      case SnsCode.kakaoInstalledButNotLogin:
        return 'SNS_KAKAO_INSTALLED_BUT_NOT_LOGIN';
      case SnsCode.notInstalledKakaoTalk:
        return 'SNS_NOT_INSTALLED_KAKAOTALK';
      case SnsCode.emptyToken:
        return 'SNS_EMPTY_TOKEN';
      case SnsCode.notLogin:
        return 'SNS_NOT_LOGIN';
      case SnsCode.notSupportedLoginType:
        return 'SNS_NOT_SUPPORTED_LOGIN_TYPE';
      case SnsCode.defaultError:
      default:
        return 'SNS_DEFAULT_ERROR';
    }
  }
}
enum SnsInfo {
  nickname, id, email, gender, age, birthday, profileImage
}

extension SnsInfoExtension on SnsInfo {
  get value {
    switch (this) {
      case SnsInfo.nickname:
        return 'NICKNAME';
      case SnsInfo.id:
        return 'ID';
      case SnsInfo.email:
        return 'EMAIL';
      case SnsInfo.gender:
        return 'GENDER';
      case SnsInfo.age:
        return 'AGE';
    }
  }
}