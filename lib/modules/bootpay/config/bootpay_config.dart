import 'dart:convert';
import 'package:hybrid_module/basic/data/provider/api.dart';
import 'package:hybrid_module/basic/util/http.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:hybrid_module/modules/bootpay/data/coupon.dart';
import 'package:hybrid_module/modules/bootpay/data/pay_validate_model.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/user.dart';

class BootpayConfig {
  static String webApplicationId = '';
  static String androidApplicationId = '';
  static String iosApplicationId = '';
  static String pg = '';
}

//일반 결제 시, model 정의
class ValidModel {
  late bool success;
  String? message;

  ValidModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['error-message'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message ?? '';
    return data;
  }
}

//무료 결제 시, model 정의
class ValidForFreeModel {
  late bool success;
  String? message;

  ValidForFreeModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['error-message'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message ?? '';
    return data;
  }
}

extension MyApiClientExtension on MyApiClient {
  //일반 결제 완료 후 처리 api 구현
  Future<PayValidateModel> sendPayData({required String receiptId, required Item item, required User user, Coupon? coupon}) async {

    final body = coupon != null ? {
      'receiptId': receiptId,
      'travelSeq': item.unique!,
      'mberSeq': user.id!,
      'couponCode': coupon.code
    } : {
      'receiptId': receiptId,
      'travelSeq': item.unique!,
      'mberSeq': user.id!,
    };

    final response = await httpPost(httpClient, url: Config.baseUrl + 'uat/uia/bootpayConfirm', body: body).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      var result = ValidModel.fromJson(json.decode(response.body));
      return PayValidateModel(success: result.success, message: result.message ?? '');
    } else {
      throw Exception("200 아님");
    }
  }


  //무료 결제 완료 후 처리 api 구현
  Future<PayValidateModel> sendPayDataForFree({required Item item, required User user, Coupon? coupon}) async {
    final body = coupon != null ? {
      'travelSeq': item.unique!,
      'mberSeq': user.id!,
      'couponCode': coupon.code
    } : {
      'travelSeq': item.unique!,
      'mberSeq': user.id!,
    };

    final response = await httpPost(httpClient, url: Config.baseUrl + 'uat/uia/freepayConfirm', body: body).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      var result = ValidForFreeModel.fromJson(json.decode(response.body));
      return PayValidateModel(success: result.success, message: result.message ?? '');
    } else {
      throw Exception("200 아님");
    }
  }

  //TODO
  //결제 처리 시 요청할 api 구현
  Future<PayValidateModel> sendPayDataForRefund({required Map data }) async {

    final body = {
      'missionProgrsSeq': data['missionProgrsSeq'].toString()
    };

    final response = await httpPost(httpClient, url: Config.baseUrl + 'uat/uia/payCancel.do', body: body).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      var result = ValidForFreeModel.fromJson(json.decode(response.body));
      return PayValidateModel(success: result.success, message: result.message ?? '');
    } else {
      throw Exception("200 아님");
    }
  }
}