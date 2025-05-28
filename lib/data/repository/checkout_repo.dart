import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get.dart';

class CheckoutRepo {
  final ApiClient apiClient;
  CheckoutRepo({required this.apiClient});

  Future<Response> placeOrder(Map<String, dynamic> orderData) async {
    return await apiClient.postData(AppConstants.ORDER_URI, orderData);
  }
}
