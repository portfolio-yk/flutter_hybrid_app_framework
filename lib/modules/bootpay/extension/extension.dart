import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/modules/bootpay/data/coupon.dart';
import 'package:hybrid_module/modules/bootpay/data/pay_validate_model.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/user.dart';
import '../config/bootpay_config.dart';

extension MyRepositoryExtension on MyRepository {
  Future<PayValidateModel> sendPayData({required String receiptId, required Item item, required User user, Coupon? coupon}) async {
    return await apiClient.sendPayData(receiptId: receiptId, item: item, user: user, coupon: coupon);
  }

  Future<PayValidateModel> sendPayDataForFree({required Item item, required User user, Coupon? coupon}) async {
    return await apiClient.sendPayDataForFree(item: item, user: user, coupon: coupon);
  }

  Future<PayValidateModel> sendPayDataForRefund({required Map data }) async {
    return await apiClient.sendPayDataForRefund(data: data);
  }
}