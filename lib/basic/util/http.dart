import 'dart:convert';

import 'package:http/http.dart';

String _getSuffix(String url, Map<String, dynamic>? queryParams) {
  var suffix = url.contains('?') ? '&' : '?';
  if (queryParams != null) {
    var queryString = Uri(queryParameters: queryParams.cast<String, String>()).query;
    suffix += queryString;
  }

  return suffix;
}
Future<Response> httpGet(Client httpClient,
    {required String url, Map<String, String>? queryParams}) {
  return httpClient.get(Uri.parse(url + _getSuffix(url, queryParams)));
}

Future<Response> httpPost(Client httpClient,
    {required String url, Map<String, String>? body}) {
  return httpClient.post(Uri.parse(url), body: body);
}

Future<StreamedResponse> httpStreamGet(Client httpClient,
    {required String url, Map<String, dynamic>? queryParams}) {
  return httpClient.send(Request('GET', Uri.parse(url + _getSuffix(url, queryParams))));
}

Future<StreamedResponse> httpMultipartRequest(
    {required String url, required Map<String, String> body, required Map<String,String> file}) async {
  var formData = MultipartRequest('POST', Uri.parse(url));
  formData.fields.addAll(body);
  for (var e in file.entries) {
    formData.files.add(await MultipartFile.fromPath(e.key, e.value));
  }
  return formData.send();
}
