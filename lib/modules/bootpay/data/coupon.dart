class Coupon {
  String code;
  double? amount;
  bool isFree;

  Coupon.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        amount = json['amount']?.toDouble(),
        isFree = json['isFree'], assert(json['isFree'] == false ? json['amount'] != null : true);

  Map<String, dynamic> toJson() => {
    'code': code,
    'amount': amount,
    'isFree': isFree
  };
}
