// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:html/parser.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:http/http.dart' as http;
// import 'model/version_status.dart';
//
// class NewVersion2 {
//   final String? iOSId;
//   final String? androidId;
//   final String? iOSAppStoreCountry;
//   final String? forceAppVersion;
//
//
//   NewVersion2({required this.iOSId, required this.androidId, required this.iOSAppStoreCountry, required this.forceAppVersion});
//   Future<VersionStatus?> getVersionStatus() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     if (Platform.isIOS) {
//       return _getiOSStoreVersion(packageInfo);
//     } else if (Platform.isAndroid) {
//       return _getAndroidStoreVersion(packageInfo);
//     } else {
//       debugPrint(
//           'The target platform "${Platform.operatingSystem}" is not yet supported by this package.');
//     }
//   }
//   String _getCleanVersion(String version) =>
//       RegExp(r'\d+\.\d+\.\d+').stringMatch(version) ?? '0.0.0';
//
//   Future<VersionStatus?> _getiOSStoreVersion(PackageInfo packageInfo) async {
//     final id = iOSId ?? packageInfo.packageName;
//     final parameters = {"bundleId": "$id"};
//     if (iOSAppStoreCountry != null) {
//       parameters.addAll({"country": iOSAppStoreCountry!});
//     }
//     var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
//     final response = await http.get(uri);
//     if (response.statusCode != 200) {
//       debugPrint('Failed to query iOS App Store');
//       return null;
//     }
//     final jsonObj = json.decode(response.body);
//     final List results = jsonObj['results'];
//     if (results.isEmpty) {
//       debugPrint('Can\'t find an app in the App Store with the id: $id');
//       return null;
//     }
//     return VersionStatus(
//       localVersion: _getCleanVersion(packageInfo.version),
//       storeVersion:
//       _getCleanVersion(forceAppVersion ?? jsonObj['results'][0]['version']),
//       appStoreLink: jsonObj['results'][0]['trackViewUrl'],
//       releaseNotes: jsonObj['results'][0]['releaseNotes'],
//     );
//   }
//
//   Future<VersionStatus?> _getAndroidStoreVersion(
//       PackageInfo packageInfo) async {
//     final id = androidId ?? packageInfo.packageName;
//     final uri =
//     Uri.https("play.google.com", "/store/apps/details", {"id": "$id", "hl": "en"});
//     final response = await http.get(uri);
//     if (response.statusCode != 200) {
//       debugPrint('Can\'t find an app in the Play Store with the id: $id');
//       return null;
//     }
//     final document = parse(response.body);
//
//     String storeVersion = '0.0.0';
//     String? releaseNotes;
//
//     final additionalInfoElements = document.getElementsByClassName('hAyfc');
//     if (additionalInfoElements.isNotEmpty) {
//       final versionElement = additionalInfoElements.firstWhere(
//             (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
//       );
//       storeVersion = versionElement.querySelector('.htlgb')!.text;
//
//       final sectionElements = document.getElementsByClassName('W4P4ne');
//       final releaseNotesElement = sectionElements.firstWhereOrNull(
//             (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
//       );
//       releaseNotes = releaseNotesElement
//           ?.querySelector('.PHBdkd')
//           ?.querySelector('.DWPxHb')
//           ?.text;
//     } else {
//       final scriptElements = document.getElementsByTagName('script');
//       final infoScriptElement = scriptElements.firstWhere(
//             (elm) => elm.text.contains('key: \'ds:5\''),
//       );
//
//       final param = infoScriptElement.text.substring(20, infoScriptElement.text.length - 2)
//           .replaceAll('key:', '"key":')
//           .replaceAll('hash:', '"hash":')
//           .replaceAll('data:', '"data":')
//           .replaceAll('sideChannel:', '"sideChannel":')
//           .replaceAll('\'', '"');
//       final parsed = json.decode(param);
//       final data =  parsed['data'];
//
//       storeVersion = data[1][2][140][0][0][0];
//       releaseNotes = data[1][2][144][1][1];
//     }
//
//     return VersionStatus(
//       localVersion: _getCleanVersion(packageInfo.version),
//       storeVersion: _getCleanVersion(forceAppVersion ?? storeVersion),
//       appStoreLink: uri.toString(),
//       releaseNotes: releaseNotes,
//     );
//   }
// }