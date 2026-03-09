import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/modules/sns_login/data/const.dart';

//TODO 수정 하셈
final loginType = LocalData(key: 'loginType', type: String, defaultValue: SnsType.none.value);