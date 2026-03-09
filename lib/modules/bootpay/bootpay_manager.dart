import 'dart:async';
import 'dart:convert';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/modules/bootpay/data/bootpay_result.dart';
import 'package:hybrid_module/modules/bootpay/data/coupon.dart';
import 'package:hybrid_module/modules/bootpay/data/enums.dart';
import 'package:hybrid_module/modules/bootpay/data/pay_validate_model.dart';
import 'package:hybrid_module/modules/bootpay/extension/extension.dart';
import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'config/bootpay_config.dart';

class BootpayManager {

  static late final BootpayManager? instance;
  BootpayManager._internal();

  static init({required String webApplicationId, required androidApplicationId, required iosApplicationId, required pg}) {
    instance = BootpayManager._internal();

    BootpayConfig.androidApplicationId = androidApplicationId;
    BootpayConfig.webApplicationId = webApplicationId;
    BootpayConfig.iosApplicationId = iosApplicationId;
    BootpayConfig.pg = pg;

    BootpayManager.instance!._init();
  }

  _init() {
    final nativeCallHandler = NativeCallHandler.instance;

    nativeCallHandler.addCallBack(name: 'requestBootpay', callback: (args) async {
      String? successPage = (args[0] as Map)["successPage"];
      String? errorPage = (args[0] as Map)["errorPage"];
      try {

        Map valueMap = (args[0] as Map)["order"];
        Map userValueMap = valueMap["user"];

        //할인 쿠폰
        Coupon? coupon = valueMap['coupon'] != null ? Coupon.fromJson(valueMap['coupon']) : null;

        //유저 정보
        User user = User();
        user.id = userValueMap["id"];
        user.username = userValueMap["username"];
        user.email = userValueMap["email"];
        user.area = userValueMap["area"];
        user.phone = userValueMap["phone"];

        final itemPrice = valueMap["price"].toDouble();
        final double discount = coupon != null ? (coupon.isFree ? itemPrice : coupon.amount) : 0.0;
        final double price = itemPrice - discount;

        //아이템 정보
        Item item = Item();
        item.itemName = valueMap["name"];
        item.qty = 1;
        item.unique = valueMap["unique"];
        item.price = price;

        String method = valueMap["method"];

        BootpayResult result =  await instance!.purchaseItem(nativeCallHandler.context, item: item, user: user, coupon: coupon, method: method, successPage: successPage, errorPage: errorPage);
        return result.toJson();
      } catch (e, s) {
        debugPrint('$s');
        return BootpayResult(code: BootpayCode.payError, message: BootpayCode.payError.message, redirectPage: errorPage ?? '').toJson();
      }
    });

    //결제 취소
    nativeCallHandler.addCallBack(name: 'requestRefund', callback: (args) async {
      String? successPage = (args[0] as Map)["successPage"];
      String? errorPage = (args[0] as Map)["errorPage"];
      try {

        Map valueMap = (args[0] as Map)["data"];

        BootpayResult result =  await instance!.refundPay(data: valueMap, successPage: successPage, errorPage: errorPage);
        return result.toJson();
      } catch (e, s) {
        debugPrint('$s');
        return BootpayResult(code: BootpayCode.payError, message: BootpayCode.payError.message, redirectPage: errorPage ?? '').toJson();
      }
    });
  }

  Future purchaseItem(BuildContext context, {required Item item, required User user, Coupon? coupon, required String method, String? successPage, String? errorPage, String? startAt, String? endAt }) async{
    if (item.price! >= 100) {
      //100원 이상인 경우
      return await _processForPG(context, item, user, coupon, method, successPage, errorPage);
    } else if (item.price! < 100 && item.price! != 0) {
      //100원 이하인 경우 에러 발생시키자
      return BootpayResult(code: BootpayCode.lessThanLimitPrice, message: BootpayCode.lessThanLimitPrice.message, redirectPage: errorPage ?? '');
    } else if (method == 'card_rebill'){
      //정기 결제인 경우
      item.price = 0; //정기결제면 price 를 항상 0으로 해야함.
      Extra extra = Extra();
      extra.startAt = startAt;
      extra.endAt = endAt;
      return await _processForPG(context, item, user, coupon, method, successPage, errorPage, extra: extra);
    } else if (item.price! == 0) {
      //무료인 경우
      return await _processForFree(item, user, coupon, successPage, errorPage);
    } else {
      throw Exception('부트페이 : 이건 무슨 경우인가...?');
    }
  }

  Future _processForFree(Item item, User user, Coupon? coupon, String? successPage, String? errorPage) async {
    final validResult = await _sendPayDataForFree(item, user, coupon);

    if (validResult.success) {
      return BootpayResult(code: BootpayCode.success, redirectPage: successPage ?? '');
    } else {
      return BootpayResult(code: BootpayCode.validError, redirectPage: errorPage ?? '', message: validResult.message);
    }
  }

  Future _processForPG(BuildContext context, Item item, User user, Coupon? coupon, String method, String? successPage, String? errorPage, {Extra? extra }) {
    Payload payload = Payload();
    payload.webApplicationId = BootpayConfig.webApplicationId;
    payload.androidApplicationId = BootpayConfig.androidApplicationId;
    payload.iosApplicationId = BootpayConfig.iosApplicationId;

    List<Item> itemList = [item];

    payload.pg = BootpayConfig.pg;
    payload.method = method;
    payload.name = item.itemName; //결제할 상품명
    payload.price = item.price; //정기결제시 0 혹은 주석
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함
    payload.items = itemList; // 상품정보 배열
    payload.user = user;

    //정기 결제인 경우 startAt, endAt 넣어주어야함.
    if (extra != null) {
      payload.extra = extra;
      if (extra.startAt != null) {
        var date = DateTime.parse(extra.startAt!);
        if (extra.endAt != null) {
          date = DateTime.parse(extra.endAt!);
        }
      } else {
        throw Exception('startAt이 null이다');
      }
    }



    final Completer completer = Completer();

    final Completer completer2 = Completer();

    BootpayResult? result;

    var isPay = false;

    Bootpay().request(
      context: context,
      payload: payload,
      showCloseButton: false,
      closeButton: const Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
        result = BootpayResult(code: BootpayCode.cancel, redirectPage: '');
        completer2.complete(result);
      },
      onError: (String data) {
        print('------- onError: $data');
        result = BootpayResult(code: BootpayCode.payError, redirectPage: errorPage ?? '', message: BootpayCode.payError.message);
        completer2.complete(result);
      },
      onClose: () async {
        print('------- onClose');
        await completer2.future;
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출

        completer.complete(result);
      },
      onCloseHardware: () {
        print('------- onCloseHardware');
        result = BootpayResult(code: BootpayCode.cancel, redirectPage: '');
        completer.complete(result);
      },
      onReady: (String data) {
        print('------- onReady: $data');
      },
      onConfirm: (String data) { // READ :: 서버 통신을 안하는 PAYAPP 또는 PayLetter PG사의 경우 해당 callback을 실행하지 않음
        Map<String, dynamic> jsonObj = jsonDecode(data);
        //그 외 결제인 경우
        _sendPayData( jsonObj['receipt_id'], item,
            user, coupon).then((res) {
          if (res.success) {
            Bootpay().transactionConfirm(data);
          } else {
            result = BootpayResult(code: BootpayCode.validError, redirectPage: errorPage ?? '', message: res.message);
            Bootpay().removePaymentWindow();
            completer2.complete(result);
          }
        });

        return false;
      },
      onDone: (String data) {
        print('------- onDone: $data');
        Map<String, dynamic> jsonObj = jsonDecode(data);
        //그 외 결제인 경우
        _sendPayData( jsonObj['receipt_id'], item,
            user, coupon).then((res) {
              print("여기뭐가 드렁읗싸ㅡ아 ${res}");
          if (res.success) {
            isPay = true;

            result = BootpayResult(code: BootpayCode.success, redirectPage: successPage ?? '');
            completer2.complete(result);
          } else {
            result = BootpayResult(code: BootpayCode.validError, redirectPage: errorPage ?? '', message: res.message);
            Bootpay().removePaymentWindow();
            completer2.complete(result);
          }
        });

        //result = BootpayResult(code: BootpayCode.success, redirectPage: successPage ?? '');
      },
    );

    return completer.future;
  }

  Future<PayValidateModel> _sendPayData(String receiptId, Item item, User user, Coupon? coupon) async {
    try {
      final repository = MyRepository();
      final res = await repository.sendPayData(receiptId: receiptId, item: item, user: user, coupon: coupon);
      return res;
    } catch (e, s) {
      debugPrint(s.toString());
      return PayValidateModel(success: false, message: "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  Future<PayValidateModel> _sendPayDataForCardRebill(String receiptId, Item item, User user, Coupon? coupon) async {
    try {
      final repository = MyRepository();
      final res = await repository.sendPayData(receiptId: receiptId, item: item, user: user, coupon: coupon);
      return res;
    } catch (e, s) {
      debugPrint(s.toString());
      return PayValidateModel(success: false, message: "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  Future<PayValidateModel> _sendPayDataForFree(Item item, User user, Coupon? coupon) async {
    try {
      final repository = MyRepository();
      final res = await repository.sendPayDataForFree(item: item, user: user, coupon: coupon);

      return res;
    } catch (e) {
      return PayValidateModel(success: false, message: '서버와의 통신 중 오류가 발생했습니다.');
    }

  }

  Future refundPay({required Map data, String? successPage, String? errorPage }) async{
    final res = await _sendPayDataForRefund(data);
    if (res.success) {
      return BootpayResult(code: BootpayCode.success, redirectPage: successPage ?? '');
    } else {
      return BootpayResult(code: BootpayCode.validError, redirectPage: errorPage ?? '', message: res.message);
    }
  }

  Future<PayValidateModel> _sendPayDataForRefund(Map data) async {
    try {
      final repository = MyRepository();
      final res = await repository.sendPayDataForRefund(data: data);
      return res;
    } catch (e) {
      return PayValidateModel(success: false, message: '서버와의 통신 중 오류가 발생했습니다.');
    }

  }
}