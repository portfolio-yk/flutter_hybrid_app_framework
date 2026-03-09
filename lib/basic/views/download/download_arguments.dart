import 'package:hybrid_module/basic/base/basic_arguments.dart';

class DownloadArguments extends Arguments {
  String type;

  DownloadArguments(
      {required this.type});

  @override
  String toQueryString() {
    return '?type=' + type;
  }


  @override
  Map<String, String>? toParameters() {
    var result = {
      'type': type,
    };
    return result;
  }

  static DownloadArguments getArgumentsFromParameters(
      Map<String, String?> parameters) {
    return DownloadArguments(type: parameters['type']!);
  }
}
