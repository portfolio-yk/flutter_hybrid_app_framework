import 'dart:io';

import 'package:hybrid_module/modules/camera/data/enums.dart';

class CameraOption {
  String? title;
  String? filePath;
  bool isCamera = true;
  bool isVideo = false;
  bool isSelf = true;
  bool isFlash = true;

  //TODO ?? .뒤에 수정
  CameraOption.fromJson(json) {
    title = json['title'] ?? "";
    isCamera = json['isCamera'] ?? true;
    isVideo = json['isVideo'] ?? false;
    isSelf = json['isSelf'] ?? true;
    isFlash = json['isFlash'] ?? true;
    filePath = json['filePath'];
  }
}
