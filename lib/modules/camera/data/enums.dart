enum CameraMode {
  normal, self,
}

enum CameraCode {
  success, cancel
}

extension CameraCodeExtension on CameraCode {
  get value {
    switch (this) {
      case CameraCode.success:
        return 'CAMERA_SUCCESS';
      case CameraCode.cancel:
        return 'CAMERA_CANCEL';
    }
  }
}