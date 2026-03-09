part of './native_call_handler.dart';

Map<String, Function(List<dynamic>)> getBasicCallBacks() {
  //기본 네이티브 함수들 추가
  final Map<String, Function(List<dynamic>)> result = {};

  result['fileDownload'] = fileDownload;
  result['checkNetwork'] = checkNetwork;
  result['requestPermissions'] = requestPermissions;
  result['getMyPosition'] = getMyPosition;
  result['getDeviceId'] = getDeviceId;
  result['exitApp'] = exitApp;
  result['turnOnResize'] = turnOnResize;
  result['turnOffResize'] = turnOffResize;
  result['getContentsVersion'] = getContentsVersion;
  result['showToastMessage'] = showToastMessage;
  result['setCurrentPage'] = setCurrentPage;
  result['mailto'] = mailto;
  result['sendFile'] = sendFile;
  result['getPermissionStatus'] = getPermissionStatus;

  return result;
}

checkNetwork(args) async {
  debugPrint('checkNetwork');
  var result = await (Connectivity().checkConnectivity());
  return result != ConnectivityResult.none;
}

Future<bool> requestPermissions(args) async {
  print('requestPermissions');
  try {
    List<Permission> requestList = (args[0] as List)
        .where((element) => element != "fcm")
        .map((e) => permissions[e]!)
        .toList();
    Map<Permission, PermissionStatus> statuses = await requestList.request();
    var isGranted = statuses.entries
        .where((element) => element.value.isDenied)
        .toList()
        .isEmpty;
    return isGranted;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

getPermissionStatus(args) async {
  Map<String, bool> permissionStatuses = {};
  try {
    final permissionList = (args[0] as Iterable);
    final completer = Completer();
    permissionList.forEach((permissionName) async {
      permissionStatuses[permissionName] = await permissions[permissionName]!.status.isGranted;
      if (permissionName == permissionList.last) {
        print(permissionStatuses.toString());
        completer.complete(permissionStatuses);
      }
    });
    return completer.future;
  } catch (e) {
    return permissionStatuses;
  }
}


getMyPosition(args) async {
  var location = await Geolocator.getCurrentPosition();
  return [location.longitude, location.latitude];
}

getDeviceId(args) async {
  debugPrint('getDeviceId');
  return await util.deviceId;
}

exitApp(args) async {
  util.exitApp();
  return 0;
}

getAppVersion(args) async {
  return await util.getAppVersion();
}

getLatestAppVersion(args) async {
  return await util.getLatestAppVersion();
}

fileDownload(args) async {
  var result = await NativeCallHandler.instance.platform.invokeMethod(
      'fileDownload',
      {'fileUrl': args[0].toString(), 'fileName': args[1].toString()});
  return {'result': result};
}

turnOnResize(args) async {
  WebViewController.to.turnOnResize();
  return true;
}

turnOffResize(args) async {
  WebViewController.to.turnOffResize();
  return true;
}

//버전 정보 가져오기
getContentsVersion(args) async {
  return await getLocalData(LocalData.contentsVersion);
}

//토스트 처리
showToastMessage(args) async {
  Fluttertoast.showToast(
      msg: args[0],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
  return true;
}

setCurrentPage(args) async {
  WebViewController.to.setCurrentPage(args[0]);
  return true;
}

mailto(args) async {
  print("머가 담길까${args}");
  final mailtoLink = Mailto(
    to: [args[0].toString()],
    //cc: ['cc1@example.com', 'cc2@example.com'], 참조
    //subject: 'mailto example subject', 제목
    //body: 'mailto example body', 내용
  );
  await launch('$mailtoLink');
}

sendFile(args) async {
  /*
    args[0] = {
      url : url,
      parameter : {
        fileName : "/data/.."
      },
    }
  */
  String url = (args[0] as Map)['url'];
  Map<String, dynamic> parameter = (args[0] as Map)['parameter'];
  Map<String, String> file = {};
  Map<String, String> body = {};
  for (var element in parameter.entries) {
    if(element.value.toString().startsWith('/data')) {
      file[element.key.toString()] = element.value.toString();
    }
    else {
      body[element.key.toString()] = element.value.toString();
    }
  }
  final res = await httpMultipartRequest(url: url, body: body, file : file);
  if(res.statusCode == 200){
    return true;
  } else {
    return false;
  }
}

