import 'dart:io';

import 'enums.dart';

class CameraResult {
  CameraCode code;
  String? imgData;
  DateTime? date;
  String? filePath;

  CameraResult({required this.code, this.imgData, this.date, this.filePath});
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code.value;
    data['imgData'] = imgData;
    data['time'] = date?.millisecondsSinceEpoch;
    data['filePath'] = filePath;
    return data;
  }
}
