import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/controllers/checkout_controller.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/notification_controller.dart';
import 'package:flutter_application_1/controllers/popular_product_controller.dart';
import 'package:flutter_application_1/controllers/recommended_product_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/data/repository/auth_repo.dart';
import 'package:flutter_application_1/data/repository/cart_repo.dart';
import 'package:flutter_application_1/data/repository/checkout_repo.dart';
import 'package:flutter_application_1/data/repository/location_repo.dart';
import 'package:flutter_application_1/data/repository/notification_repo.dart';
import 'package:flutter_application_1/data/repository/popular_product_repo.dart';
import 'package:flutter_application_1/data/repository/recommended_product_repo.dart';
import 'package:flutter_application_1/data/repository/user_repo.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_application_1/controllers/payment_controller.dart';
// import 'package:flutter_application_1/data/repository/payment_repo.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

//api client
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));

//repos
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(
      () => CartRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(
      () => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => PaymentRepo(apiClient: Get.find()));
  Get.lazyPut(
    () => CheckoutRepo(apiClient: Get.find()),
  );

//controllers
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(
      () => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(
    () => AuthController(authRepo: Get.find(), apiClient: Get.find()),
  );
  Get.lazyPut(
    () => UserController(userRepo: Get.find()),
  );
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  // Get.lazyPut(() => PaymentController(paymentRepo: Get.find()));
  Get.lazyPut(() => CheckoutController(checkoutRepo: Get.find()));
}
