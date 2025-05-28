import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/models/signup_body_model.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});
  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  bool userLoggedIn() {
  return sharedPreferences.containsKey(AppConstants.TOKEN) &&
         sharedPreferences.getString(AppConstants.TOKEN)!.isNotEmpty;
}

Future<void> clearUserToken() async {
  await sharedPreferences.remove(AppConstants.TOKEN);
  apiClient.updateHeader('');
}

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  Future<Response> login(String email, String password) async {
  return await apiClient.postDataWithHeaders(
    AppConstants.LOGIN_URI,
    {"email": email, "password": password},
    {
      'Content-type': 'application/json; charset=UTF-8',
      'x-app-key': AppConstants.APP_KEY, // ✅ HARUS Dikirim saat login
    },
  );
}



  Future<bool> saveUserToken(String token) async {
  apiClient.token = token;
  apiClient.updateHeader(token); // Penting!
  return await sharedPreferences.setString(AppConstants.TOKEN, token);
}


  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PHONE);
    sharedPreferences.remove(AppConstants.PASSWORD);
    apiClient.token = '';
    apiClient.updateHeader("");
    return true;
  }

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }
}
