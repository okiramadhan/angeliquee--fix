import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? '';
    updateHeader(token);
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': token,
      'x-app-key': AppConstants.APP_KEY,
    };
  }
  void updateHeader(String token) {
    this.token = token;
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': token,
      'x-app-key': AppConstants.APP_KEY,
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    String token = sharedPreferences.getString(AppConstants.TOKEN) ?? '';
    final customHeaders = {
      'Accept': 'application/json',
      'Authorization': token,
    };
    print("🔐 [GET] Semua header: $customHeaders");
    Response response = await get(uri, headers: customHeaders);
    print("RESPONSE: ${response.body}");
    return response;
  }

  Future<Response> postData(String uri, dynamic body) async {
    print("🔐 [POST] Token yang dipakai: ${_mainHeaders['Authorization']}");
    print("🔐 [POST] Semua header: $_mainHeaders");
    print(body.toString());
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      print(response.toString());
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postDataWithHeaders(
      String uri, dynamic body, Map<String, String> customHeaders) async {
    print("📦 Custom POST $uri with headers: $customHeaders");
    try {
      Response response = await post(uri, body, headers: customHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
  Future<Response> deleteData(String uri) async {
  print("🔐 [DELETE] Header: $_mainHeaders");
  try {
    Response response = await delete(uri, headers: _mainHeaders);
    print("🔐 [DELETE] Response: ${response.body}");
    return response;
  } catch (e) {
    print(e.toString());
    return Response(statusCode: 1, statusText: e.toString());
  }
}
}
