import 'dart:convert';
import 'dart:io';

import 'package:hybrid_module/basic/const/const.dart';
import 'package:hybrid_module/basic/data/model/oinon_sns_user_model.dart';
import 'package:hybrid_module/basic/data/model/onion_list_model.dart';
import 'package:hybrid_module/basic/data/model/test_user_model.dart';
import 'package:hybrid_module/basic/data/model/version_model.dart';
import 'package:hybrid_module/basic/util/file.dart';
import 'package:hybrid_module/basic/util/http.dart';
import 'package:hybrid_module/basic/config/basic_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyApiClient {
  final http.Client httpClient;
  MyApiClient({required this.httpClient});

  Future<TestUserModel?> getTestUser({required String deviceId}) async {
    var response = await httpGet(httpClient,
        url: Config.baseUrl + 'usr/wap/jsonList.do?app=1002',
        queryParams: {
          'deviceIdSearch': deviceId,
        }).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      var onionListModel = OnionListModel.fromJson(json.decode(response.body));
      List<TestUserModel> list =
          onionListModel.data.map((e) => TestUserModel.fromJson(e)).toList();
      return list.firstWhereOrNull((e) => e.deviceNo == deviceId);
    } else {
      throw Exception("200 아님");
    }
  }

  Future<String> getLatestContentsVersion() async {
    var response = await httpGet(httpClient,
        url: Config.baseUrl + 'usr/wap/jsonList.do?app=1001',
        queryParams: {
          'idSearch': Config.appName,
        });

    if (response.statusCode == 200) {
      var onionListModel = OnionListModel.fromJson(json.decode(response.body));
      List<VersionModel> list =
          onionListModel.data.map((e) => VersionModel.fromJson(e)).toList();
      return list.first.ver;
    } else {
      throw Exception("200 아니라공");
    }
  }

  Future<List<int>> getZipBytes(
      {required String curVer,
      String? dstbAll,
      Function(double)? onListen}) async {
    List<int> bytes = [];
    var response = await httpStreamGet(httpClient,
        url: Config.baseUrl + 'usr/app/downloadUpdt.do',
        queryParams: {
          'appId': Config.appName,
          'curVer': curVer,
          'dstbAll': dstbAll ?? Yn.N,
        });

    var contentLength = response.contentLength;
    var currentLength = 0;

    final path = await localPath;
    final filePath = '$path/assets.zip';
    var i = 0;
    await response.stream.listen((value) {
      debugPrint('${value.length}');
      bytes.addAll(value);

      if (bytes.length > 100000) {
        writeFileAsBytesSync(filePath, bytes);
        bytes = [];
      }
      if (onListen != null) {
        try {
          currentLength += value.length;
          onListen((currentLength / contentLength!) * 100);
        } catch (e, s) {
          debugPrint('$s');
          onListen(0.0);
        }
      }
    }).asFuture();

    writeFileAsBytesSync(filePath, bytes);

    return bytes;
  }

  Future<List<int>> getTargetZipBytes(
      {required String curVer,
        String? dstbAll,
        required String downloadUrl,
        Map<String,dynamic>? params,
        Function(double)? onListen,  required String zipName}) async {
    List<int> bytes = [];
    var response = await httpStreamGet(httpClient,
        url: Config.baseUrl + downloadUrl,
        queryParams: params?.cast<String,dynamic>() ?? {});

    var contentLength = response.contentLength;
    var currentLength = 0;

    final path = await localPath;
    final filePath = '$path/${zipName}.zip';
    var i = 0;
    await response.stream.listen((value) {
      debugPrint('${value.length}');
      bytes.addAll(value);

      if (bytes.length > 100000) {
        writeFileAsBytesSync(filePath, bytes);
        bytes = [];
      }
      if (onListen != null) {
        try {
          currentLength += value.length;
          onListen((currentLength / contentLength!) * 100);
        } catch (e, s) {
          debugPrint('$s');
          onListen(0.0);
        }
      }
    }).asFuture();

    writeFileAsBytesSync(filePath, bytes);

    return bytes;
  }
  Future snsLogin({required String snsToken,required String snsType}) async {
    Map<String, String> body = {
      "token" : snsToken,
      "snsType" : snsType,
    };

    final response = await httpPost(
        httpClient, url: "/uat/uia/jsonSnsLogin.do", body: body);
    if (response.statusCode == 200) {
      var onionSnsUserModel = OnionSnsUserModel.fromJson(
          json.decode(response.body));
      return onionSnsUserModel;
    } else {
      throw ("zz");
    }

  }
}
