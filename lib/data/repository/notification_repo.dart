import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  Future<Response> sendDeviceToken(String token) async {
    return await apiClient.postData(
      AppConstants.DEVICE_TOKEN_URI,
      {
        "device_token": token,
      },
    );
  }
}