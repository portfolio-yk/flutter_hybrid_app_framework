import 'package:hybrid_module/modules/sns_login/data/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {

  String key;
  Type type;
  dynamic defaultValue;

  LocalData({required this.key, required this.type, required this.defaultValue});

  static final contentsVersion = LocalData(key: 'contentsVersion', type: String, defaultValue: '0.0.0');
}

resetAllData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(LocalData.contentsVersion.key);
  prefs.remove(loginType.key);
  prefs.remove('NOTICE');

}

setLocalData(LocalData localData, value) async {
  if (value.runtimeType != localData.type) {
    throw Exception("넣으려는 value가 세팅된 타입과 다릅니다만");
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    switch (localData.type) {
      case bool:
        await prefs.setBool(localData.key, value);
        break;
      case int:
        await prefs.setInt(localData.key, value);
        break;
      case String:
        await prefs.setString(localData.key, value);
        break;
      default:
        throw Exception('타입 에러');
    }
  } catch (e) {
    print(e);
  }
}

Future<dynamic> getLocalData(LocalData localData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  switch (localData.type) {
    case bool:
      return prefs.getBool(localData.key) ?? localData.defaultValue;
    case int:
      return prefs.getInt(localData.key) ?? localData.defaultValue;
    case String:
      return prefs.getString(localData.key) ?? localData.defaultValue;
    default:
      throw Exception('타입 에러');
  }

}