import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/modules/instagram/data/instagram_profile.dart';
import 'package:hybrid_module/modules/instagram/views/instagram_controller.dart';
extension MyRepositoryExtension on MyRepository {

  Future<String> getTokenAndUserId({required String authorizationCode}) async {
    return await apiClient.getTokenAndUserID(authorizationCode : authorizationCode);
  }
  Future<InstagramProfile> getUserProfile({required String accessToken}) async {
    return await apiClient.getUserProfile(accessToken: accessToken);
  }
}