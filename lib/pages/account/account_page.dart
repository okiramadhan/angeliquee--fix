import 'package:flutter/material.dart';
import 'package:flutter_application_1/base/custom_loader.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/models/address_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    return Scaffold(
      body: GetBuilder<UserController>(builder: (userController) {
        return !_userLoggedIn
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: Dimensions.height20 * 8,
                      margin:
                          EdgeInsets.symmetric(horizontal: Dimensions.width20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        image: const DecorationImage(
                          image:
                              AssetImage("assets/images/signintocontinue.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteHelper.getSignInPage()),
                      child: Container(
                        width: double.maxFinite,
                        height: Dimensions.height20 * 2,
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                        ),
                        child: Center(
                          child: BigText(
                            text: "Sign in",
                            color: Colors.white,
                            size: Dimensions.font26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : userController.isLoading
                ? const CustomLoader()
                : (userController.userModel == null
                    ? const CustomLoader()
                    : Column(
                        children: [
                          // HEADER
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top +
                                  Dimensions.height20 * 2,
                              bottom: Dimensions.height20 * 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.mainColor,
                                  AppColors.yellowColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(Dimensions.radius20 * 1.6),
                                bottomRight:
                                    Radius.circular(Dimensions.radius20 * 1.6),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.font26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height15),
                                CircleAvatar(
                                  radius: Dimensions.radius30 * 1.6,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person,
                                      size: Dimensions.iconSize24 * 1.6,
                                      color: AppColors.mainColor),
                                ),
                                SizedBox(height: Dimensions.height10),
                                Text(
                                  userController.userModel!.fName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10 / 2),
                                Text(
                                  userController.userModel!.email,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Dimensions.font14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),
                          // MENU
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width15,
                                  vertical: Dimensions.height10),
                              children: [
                                _accountMenuTile(
                                  icon: Icons.phone,
                                  title: userController.userModel!.phone,
                                  color: AppColors.mainColor,
                                ),
                                _accountMenuTile(
                                  icon: Icons.location_on,
                                  title: Get.find<LocationController>()
                                          .addressList
                                          .isEmpty
                                      ? "Fill in your address"
                                      : Get.find<LocationController>()
                                          .addressList
                                          .last
                                          .address,
                                  color: AppColors.yellowColor,
                                  onTap: () => Get.toNamed(
                                      RouteHelper.getAddressPage()),
                                ),
                                _accountMenuTile(
                                  icon: Icons.message_outlined,
                                  title: "Messages",
                                  color: Colors.redAccent,
                                ),
                                Divider(height: Dimensions.height30),
                                _accountMenuTile(
                                  icon: Icons.logout,
                                  title: "Logout",
                                  color: Colors.redAccent,
                                  onTap: () async {
                                    if (Get.find<AuthController>()
                                        .userLoggedIn()) {
                                      final locationController =
                                          Get.find<LocationController>();
                                      for (var address
                                          in List<AddressModel>.from(
                                              locationController.addressList)) {
                                        await locationController
                                            .deleteAddress(address.id);
                                      }
                                      Get.find<AuthController>()
                                          .clearSharedData();
                                      Get.find<CartController>().clear();
                                      Get.find<CartController>()
                                          .clearCartHistory();
                                      Get.find<LocationController>()
                                          .clearAddressList();
                                      Get.offNamed(RouteHelper.getSignInPage());
                                    } else {
                                      Get.offNamed(RouteHelper.getSignInPage());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
      }),
    );
  }

  Widget _accountMenuTile({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15)),
      margin: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: Dimensions.radius20,
          child: Icon(icon, color: color, size: Dimensions.iconSize24),
        ),
        title: Text(title,
            style: TextStyle(fontSize: Dimensions.font16, color: Colors.black)),
        trailing: onTap != null
            ? Icon(Icons.arrow_forward_ios, size: Dimensions.iconSize16)
            : null,
        onTap: onTap,
      ),
    );
  }
}
