enum BootpayCode {
  success, cancel, payError, validError, lessThanLimitPrice
}

extension BootpayCodeExtension on BootpayCode {
  get value {
    switch (this) {
      case BootpayCode.success:
        return 'BOOTPAY_SUCCESS';
      case BootpayCode.cancel:
        return 'BOTPAY_CANCEL';
      case BootpayCode.payError:
        return 'BOOTPAY_PAY_ERROR';
      case BootpayCode.lessThanLimitPrice:
        return 'LESS_THAN_LIMIT_PRICE';
      case BootpayCode.validError:
        return 'BOOTPAY_VALID_ERROR';
    }
  }

  get message {
    switch (this) {
      case BootpayCode.success:
        return '';
      case BootpayCode.cancel:
        return '';
      case BootpayCode.payError:
        return '결제 도중 오류가 발생횄습니다.';
      case BootpayCode.lessThanLimitPrice:
        return '100원 이상으로 결제해주세요.';
      case BootpayCode.validError:
        return '결제가 유효하지 않습니다.';
    }
  }
}