import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/popular_product_controller.dart';
import 'package:flutter_application_1/controllers/recommended_product_controller.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

    Future<void> _loadResources() async {
         await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
    }

  Future<void> _clearOldCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AppConstants.CART_LIST);
    prefs.remove(AppConstants.CART_HISTORY_LIST);
    print("Cart dan Cart History lama telah dihapus ");
  }


  @override
  void initState() {
    super.initState();
    _loadResources();
    _clearOldCart();
    controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(const Duration(seconds: 3), () => Get.offNamed(RouteHelper.getSignInPage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 237, 221),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Image.asset(
                "assets/images/logo.jpg",
                width: Dimensions.splashImg,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/images/namalogo.jpg",
              width: Dimensions.splashImg,
            ),
          ),
        ],
      ),
    );
  }
}
