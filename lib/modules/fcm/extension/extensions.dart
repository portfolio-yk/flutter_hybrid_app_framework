import 'package:hybrid_module/basic/const/local_data.dart';

extension StringExtension on String {
  String addParameter(Map<String, String> parameters) {
    final arr = split('/');
    final paramsStr = parameters.entries
        .map((e) => '&${e.key}=${e.value}')
        .reduce((value, element) => value + element);
    if (arr.last.contains('?')) {
      return this + paramsStr;
    } else {
      final re = RegExp('^&');
      return this + paramsStr.replaceAll(re, '?');
    }
  }
}