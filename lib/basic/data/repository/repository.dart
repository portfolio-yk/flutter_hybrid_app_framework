import 'package:hybrid_module/basic/data/model/oinon_sns_user_model.dart';
import 'package:hybrid_module/basic/data/model/test_user_model.dart';
import 'package:hybrid_module/basic/data/provider/api.dart';
import 'package:http/http.dart' as http;

class MyRepository {
  final MyApiClient apiClient;

  static final MyRepository _instance = MyRepository._internal(MyApiClient(httpClient: http.Client()));

  factory MyRepository() {
    return _instance;
  }

  MyRepository._internal(this.apiClient);

  Future<TestUserModel?> getTestUser({required String deviceId }) async {
    return await apiClient.getTestUser(deviceId: deviceId);
  }

  Future<String> getLatestContentsVersion() async {
    return await apiClient.getLatestContentsVersion();
  }

  Future<List<int>> getZipBytes({required String curVer, String? dstbAll, Function(double)? onListen}) async {
    return await apiClient.getZipBytes(curVer: curVer, dstbAll: dstbAll, onListen: onListen);
  }

  Future<List<int>> getTargetZipBytes({required String curVer, String? dstbAll, required String downloadUrl,Map<String,dynamic>? params, required String zipName , Function(double)? onListen}) async {
    return await apiClient.getTargetZipBytes(curVer: curVer, dstbAll: dstbAll,downloadUrl: downloadUrl,params: params?.cast<String,dynamic>() , zipName: zipName);
  }
  Future<OnionSnsUserModel> snsLogin({required String snsToken, required String snsType }) async {
    return await apiClient.snsLogin(snsToken: snsToken, snsType: snsType);
  }
}