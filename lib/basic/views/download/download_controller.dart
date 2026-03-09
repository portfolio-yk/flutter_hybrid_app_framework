import 'package:hybrid_module/basic/const/const.dart';
import 'package:hybrid_module/basic/data/repository/repository.dart';
import 'package:hybrid_module/basic/util/file.dart';
import 'package:hybrid_module/basic/util/shared_preference.dart';
import 'package:hybrid_module/basic/util/util.dart' as util;
import 'package:hybrid_module/basic/views/download/download_arguments.dart';
import 'package:hybrid_module/basic/views/webview/webview_page.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadController extends GetxController {
  final MyRepository repository;

  late DownloadArguments arguments;

  final _downloadImageUrl = Config.downloadImageUrl.obs;
  get downloadImageUrl => _downloadImageUrl.value;

  final _currentStatus = "".obs;
  get currentStatus => _currentStatus.value;

  final _progress = (0.0).obs;
  get progress => _progress.value.toStringAsFixed(1);

  DownloadController({required this.repository}) {
    arguments = DownloadArguments.getArgumentsFromParameters(Get.parameters);
  }

  void startPage() async {
    switch (arguments.type) {
      case DownloadArgType.appUpdate:
        _updateApp();
        break;
      case DownloadArgType.contentsUpdate:
        _updateContents();
        break;
      case DownloadArgType.timeoutError:
        _openDialog(text: 'TIMEOUT_ERROR'.tr, onTap: util.exitApp);
        break;
      case DownloadArgType.error:
      default:
        _openDialog(text: 'DEFAULT_ERROR'.tr, onTap: util.exitApp);
    }
  }

  void _updateApp() {
    var url = util.storeUrl;
    _openDialog(text: 'APP_UPDATE'.tr, onTap: () async {
      await canLaunch(url)
          ? await launch(url, forceSafariVC: false, forceWebView: false)
          : throw "URL_ERROR".tr;
    });
  }

  void _updateContents() async {
    var downloadResultType = await _startDownload();

    switch (downloadResultType) {
      case DownloadType.success:
        Get.toNamed(Routes.webView);
        break;
      case DownloadType.networkError:
        _openDialog(text: 'NETWORK_ERROR'.tr, onTap: util.exitApp);
        break;
      case DownloadType.zipError:
        _openDialog(text: 'ZIP_ERROR'.tr, onTap: util.exitApp);
        break;
      default:
        _openDialog(text: 'DEFAULT_ERROR'.tr, onTap: util.exitApp);
    }
  }

  Future<DownloadType> _startDownload() async {
    //인터넷 확인
    if (await (Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      return DownloadType.networkError;
    }

    try {
      var latestVersion = await repository.getLatestContentsVersion();
      var result =  await _download();
      if(result == DownloadType.success) {
        setLocalData(LocalData.contentsVersion, latestVersion);
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());

      return DownloadType.defaultError;
    }
  }

  Future<DownloadType> _download() async {
    //서버에서 온 데이터 다운로드
    try {

      var file = await localFile('assets.zip');
      var dir = await localDirectory('assets');
      bool b = await dir.exists();
      if (b) {
        await dir.delete(recursive: true);
        await deleteFile('assets.zip');
      }
      _currentStatus.value =
          'REQUESTING_SERVER'.tr;
      await repository.getZipBytes(
          curVer: await getLocalData(LocalData.contentsVersion),
          dstbAll: await Config.isTestUser ? Yn.Y : Yn.N,
          onListen: (progress) {
            _progress.value = progress;
          });

      //다운로드 받은 zip 파일 압축 해제
      _currentStatus.value =
          'EXTRACTING_ZIP'.tr;
      await extractZip('assets.zip', onExtracting: (progress) {
        _progress.value = progress;
      });

      //zip 삭제
      await deleteFile('assets.zip');

      return DownloadType.success;
    } catch (e) {
      debugPrint(e.toString());
      return DownloadType.zipError;
    }
  }

  void _openDialog({required String text, required Function() onTap}) {
    Get.defaultDialog(
        title: 'NOTICE'.tr,
        middleText: text,
        confirm: GestureDetector(
          child: Text('CONFIRM_TEXT'.tr),
          onTap: () {
            onTap();
          },
        ),
        barrierDismissible: false,
        onWillPop: () {
          return Future<bool>(() => false);
        }
    );
  }
}
