import 'package:hybrid_module/basic/util/file.dart';
import 'package:hybrid_module/basic/views/webview/native/native_call_handler.dart';
import 'package:hybrid_module/modules/hybrid_manager.dart';
import 'package:hybrid_module/modules/sound/sound_controller.dart';

class SoundManager extends HybridManager<void> {
  @override
  void init(options) async {
    SoundController.init();
    final soundInstance = SoundController.instance;
    final path = await localPath;
    //사운드를 겹쳐서 재생하고 싶을 때
    NativeCallHandler.instance.addCallBack(name: 'playSound', callback: (args) async {

        final soundConfig = args[0] as Map;
        final filePath = soundConfig['filePath'];
        final isSubSound = soundConfig['isSubSound'] ?? false;
        final isAssets = soundConfig['isAssets'] ?? false;
        final source =  isAssets
                          ? soundInstance.getAssetsSource(filePath) // assets/{filePath} -> assets에 등록한 파일
                          : soundInstance.getDeviceFileSource('$path/$filePath'); // data/user/0/{package}/app_flutter/{filePath} -> 로컬디바이스에 있는 파일

        return soundInstance.playSound(filePath: filePath, isSubSound: isSubSound, audioSource: source);
    });

    //사운드를 다시 재생 하였을 때 모두 종료후 다시 사운드 재생하고 싶을 때
    NativeCallHandler.instance.addCallBack(name: 'replaySound', callback: (args) async {
      final soundConfig = args[0] as Map;
      final filePath = soundConfig['filePath'];

      final isAssets = soundConfig['isAssets'] ?? false;
      final source =  isAssets
          ? soundInstance.getAssetsSource(filePath) // assets/{filePath} -> assets에 등록한 파일
          : await soundInstance.getDeviceFileSource('$path/$filePath'); // data/user/0/{package}/app_flutter/{filePath} -> 로컬디바이스에 있는 파일

      return soundInstance.replaySound(source);
    });

    //사운드 일시정지
    NativeCallHandler.instance.addCallBack(name: 'stopSound', callback: (args) async {
      soundInstance.stopSound();
    });

    //사운드 종료
    NativeCallHandler.instance.addCallBack(name: 'cancelSound', callback: (args) async {
      soundInstance.cancel();
    });
  }
}