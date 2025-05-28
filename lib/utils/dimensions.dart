import 'package:get/get.dart';

// Screen Height = 683
// Screen Width = 411
class Dimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  static double pageView = screenHeight / 2.34;
  static double pageViewContainer = screenHeight / 3.10;
  static double pageViewTextContainer = screenHeight / 5.69;

  //Dynamic Heigth padding dan margin
  static double height5 = screenHeight / 136.6;
  static double height10 = screenHeight / 68.3;
  static double height15 = screenHeight / 45.53;
  static double height20 = screenHeight / 34.15;
  static double height30 = screenHeight / 22.76;
  static double height45 = screenHeight / 15.17;

  //Dynamic Width padding dan margin
  static double width10 = screenHeight / 68.3;
  static double width15 = screenHeight / 45.53;
  static double width20 = screenHeight / 34.15;
  static double width30 = screenHeight / 22.76;

  //font
  static double font13 = screenHeight / 52.53;
  static double font16 = screenHeight / 42.687;
  static double font20 = screenHeight / 34.15;
  static double font26 = screenHeight / 26.269;
  static double font14 = screenHeight / 60.57;

  //Radius
  static double radius15 = screenHeight / 45.53;
  static double radius20 = screenHeight / 34.15;
  static double radius30 = screenHeight / 22.76;

  //Icon Size
  static double iconSize24 = screenHeight / 28.45;
  static double iconSize16 = screenHeight / 42.68;

  //List View Size
  static double listViewImgSize = screenWidth / 3.4;
  static double listViewTextContSize = screenWidth / 3.8;

  //popular shop
  static double popularShopImgSize = screenHeight / 1.95;

  //bottom height
  static double bottomHeightBar = screenHeight / 5.69;

  //splash screen
  static double splashImg = screenHeight / 2.72;
}
