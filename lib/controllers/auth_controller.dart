import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/controllers/checkout_controller.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/notification_controller.dart';
import 'package:flutter_application_1/data/repository/notification_repo.dart';
import 'package:flutter_application_1/models/address_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/data/repository/auth_repo.dart';
import 'package:flutter_application_1/models/response_model.dart';
import 'package:flutter_application_1/models/signup_body_model.dart';
import 'package:flutter_application_1/models/user_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final ApiClient apiClient;

  AuthController({required this.authRepo, required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    print(response.body);
    late ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      final token = response.body['data']['token'];
      authRepo.saveUserToken(token);
      apiClient.updateHeader(token);
      responseModel = ResponseModel(true, token);
    } else {
      responseModel = ResponseModel(
          false, response.body['message'] ?? "Registration failed");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['data'] != null) {
      String token = response.body['data']['token']['token'];
      await authRepo.saveUserToken(token);
      apiClient.updateHeader(token);
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        if (!Get.isRegistered<NotificationController>()) {
  try {
    Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));
    Get.put(NotificationController(notificationRepo: Get.find()));
  } catch (e) {
    print("Failed to register NotificationRepo/Controller: $e");
  }
}
await Get.find<NotificationController>().sendTokenToServer(fcmToken);

      }
      responseModel = ResponseModel(true, "Login berhasil");

      if (Get.isRegistered<LocationController>()) {
        await Get.find<LocationController>().getAddressList();
      }
    } else {
      responseModel =
          ResponseModel(false, response.statusText ?? "Login gagal");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getUserInfo() async {
    _isLoading = true;
    update();
    Response response = await authRepo.getUserInfo();
    if (response.statusCode == 200 && response.body['data'] != null) {
      _userModel = UserModel.fromJson(response.body['data']);
      if (response.body['data']['token'] != null &&
          response.body['data']['token']['token'] != null) {
        String newToken = response.body['data']['token']['token'];
        await authRepo
            .saveUserToken(newToken); 
      }
    } else {
      print("Gagal memuat user info: ${response.statusText}");
    }
    _isLoading = false;
    update();
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  Future<void> logout() async {
    final locationController = Get.find<LocationController>();
    for (var address
        in List<AddressModel>.from(locationController.addressList)) {
      await locationController.deleteAddress(address.id);
    }

    await authRepo.clearUserToken();
    clearSharedData();

    locationController.clearAddressList();

    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().clear();
    }

    if (Get.isRegistered<CheckoutController>()) {
      Get.find<CheckoutController>().clearCheckout();
    }
    Get.offAllNamed(RouteHelper.getSignInPage());
  }
}
