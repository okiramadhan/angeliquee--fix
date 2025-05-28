import 'package:flutter_application_1/pages/address/add_address_page.dart';
import 'package:flutter_application_1/pages/auth/sign_in_page.dart';
import 'package:flutter_application_1/pages/cart/cart_page.dart';
import 'package:flutter_application_1/pages/home/home_page.dart';
import 'package:flutter_application_1/pages/home/main_shop_page.dart';
import 'package:flutter_application_1/pages/payment/checkout_page.dart';
import 'package:flutter_application_1/pages/shop/popular_shop_detail.dart';
import 'package:flutter_application_1/pages/shop/recommended_shop_detail.dart';
import 'package:flutter_application_1/pages/splash/splash_page.dart';
import 'package:flutter_application_1/pages/payment/webview_page.dart';
import 'package:get/get.dart';

import '../utils/app_constants.dart';

class RouteHelper {
  static const String splashPage = '/splash-page';
  static const String initial = '/';
  static const String popularShop = '/popular-shop';
  static const String recommendedShop = '/recommended-shop';
  static const String cartPage = '/cart-page';
  static const String signIn = '/sign-in';
  static const String paymentPage = '/payment';
  static const String checkoutPage = '/checkout';

  static const String addAddress = '/add-address';



  static String getSplashPage() => "$splashPage";
  static String getInitial() => "$initial";
  static String getPopularShop(int pageId, String page) =>
      '$popularShop?pageID=$pageId&page=$page';
  static String getRecommendedShop(int pageId, String page) =>
      '$recommendedShop?pageID=$pageId&page=$page';
  static String getCartPage() => "$cartPage";
  static String getSignInPage() => "$signIn";
  static String getAddressPage() => "$addAddress";
  static String getCheckoutPage() => "$checkoutPage";
  static String getPaymentPage(String snapUrl) => '$paymentPage?url=$snapUrl';

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    GetPage(
        name: initial,
        page: () {
          return HomePage();
        }, transition: Transition.fade),
    GetPage(
        name: signIn,
        page: () {
          return SignInPage();
        },
        transition: Transition.fade),
    GetPage(
        name: popularShop,
        page: () {
          var pageId = Get.parameters['pageID'];
          var page = Get.parameters['page'];
          return PopularShopDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: recommendedShop,
        page: () {
          var pageId = Get.parameters['pageID'];
          var page = Get.parameters['page'];
          return RecommendedShopDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: cartPage,
        page: () {
          return const CartPage();
        },
        transition: Transition.fadeIn),
    GetPage(
      name: addAddress,
      page: () {
        return AddAddressPage();
      },
    ),
    GetPage(
    name: checkoutPage,
    page: () => CheckoutPage(),
  ),
    GetPage(
      name: paymentPage,
      page: () {
        final snapUrl = Uri.decodeComponent(Get.parameters['url']!);
        return WebViewPage(snapUrl: snapUrl);
      },
    ),
  ];
}
