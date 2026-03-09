

import 'package:hybrid_module/modules/instagram/data/instagram_profile.dart';

class InstagramResult {
  Instagram code;
  InstagramProfile? userProfile;

  InstagramResult({required this.code, this.userProfile});

  Map<String, dynamic> toJson() => {
    'code' : code.value,
    'userProfile' : userProfile?.toJson()
  };
}

enum Instagram {
  success, cancel , isOutRoute
}

extension InstagramCodeExtension on Instagram {
  get value {
    switch(this) {
      case Instagram.success :
        return "INSTAGRAM_SUCCESS";
      case Instagram.cancel :
        return "INSTAGRAM_CANCEL";
      case Instagram.isOutRoute :
        return "INSTAGRAM_OUT_ROUTE";
    }
  }
}

