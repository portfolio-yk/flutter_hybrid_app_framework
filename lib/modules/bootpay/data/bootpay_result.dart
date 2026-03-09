import 'package:hybrid_module/modules/bootpay/data/enums.dart';

class BootpayResult {
  BootpayCode code;
  String redirectPage;
  String message;

  BootpayResult({required this.code, required this.redirectPage, this.message = ''});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code.value;
    data['redirectPage'] = redirectPage;
    data['message'] = message;
    return data;
  }


}
