import 'package:flutter/material.dart';
import 'package:flutter_application_1/base/no_data_page.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/popular_product_controller.dart';
import 'package:flutter_application_1/controllers/recommended_product_controller.dart';
import 'package:flutter_application_1/models/products_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/app_icon.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:flutter_application_1/widgets/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackgroundColor,
      body: Column(
        children: [
          // HEADER GRADIENT
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + Dimensions.height20 * 2,
              bottom: Dimensions.height20 * 2,
              left: Dimensions.width20,
              right: Dimensions.width20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.mainColor, AppColors.yellowColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radius20 * 1.6),
                bottomRight: Radius.circular(Dimensions.radius20 * 1.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: Dimensions.radius20,
                    child: Icon(Icons.arrow_back_ios,
                        color: AppColors.mainColor,
                        size: Dimensions.iconSize24),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Your Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      "Check your selected items",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: Dimensions.font16,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Dimensions.radius20,
                  child: Icon(Icons.shopping_cart,
                      color: AppColors.mainColor, size: Dimensions.iconSize24),
                ),
              ],
            ),
          ),
          // CART LIST
          Expanded(
            child: GetBuilder<CartController>(builder: (cartController) {
              var cartList = cartController.getItems;
              if (cartList.isEmpty) {
                return Center(
                  child: BigText(text: "Your cart is empty!"),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(Dimensions.height15),
                itemCount: cartList.length,
                itemBuilder: (_, index) {
                  final cartItem = cartList[index];
                  final product = cartItem.product;
                  final imageUrl =
                      cartItem.img ?? "https://via.placeholder.com/150";
                  return Card(
                    margin: EdgeInsets.only(bottom: Dimensions.height15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.height10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius15),
                            child: Image.network(
                              imageUrl,
                              width: Dimensions.height45 * 1.8,
                              height: Dimensions.height45 * 1.8,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: Dimensions.width15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  text: cartItem.name ?? "Produk tanpa nama",
                                  color: Colors.black87,
                                  size: Dimensions.font16,
                                ),
                                SizedBox(height: Dimensions.height10 / 2),
                                BigText(
                                  text:
                                      "Rp. ${(cartItem.price ?? 0).toString()}",
                                  color: Colors.redAccent,
                                  size: Dimensions.font16,
                                ),
                                SizedBox(height: Dimensions.height10 / 2),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (product != null) {
                                          cartController.addItem(product, -1);
                                        }
                                      },
                                      child: Icon(Icons.remove,
                                          color: AppColors.signColor,
                                          size: Dimensions.iconSize24),
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    BigText(
                                        text: cartItem.quantity.toString(),
                                        size: Dimensions.font16),
                                    SizedBox(width: Dimensions.width10),
                                    GestureDetector(
                                      onTap: () {
                                        if (product != null) {
                                          cartController.addItem(product, 1);
                                        }
                                      },
                                      child: Icon(Icons.add,
                                          color: AppColors.signColor,
                                          size: Dimensions.iconSize24),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar:
          GetBuilder<CartController>(builder: (cartController) {
        return cartController.getItems.isNotEmpty
            ? Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Dimensions.radius20 * 1.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Rp. ${cartController.totalAmount}",
                      color: AppColors.mainColor,
                      size: Dimensions.font20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (Get.find<AuthController>().userLoggedIn()) {
                          if (Get.find<LocationController>()
                              .addressList
                              .isEmpty) {
                            Get.toNamed(RouteHelper.getAddressPage());
                          } else {
                            final userAddress = Get.find<LocationController>()
                                .addressList
                                .last
                                .address;
                            if (userAddress != null) {
                              int totalAmount =
                                  cartController.totalAmount.toInt();
                              if (totalAmount > 0) {
                                for (var item in cartController.getItems) {
                                    await cartController.addItemToServer(
                                        item.product!, item.quantity!);
                                  }
                                Get.toNamed('/checkout');
                              } else {
                                Get.snackbar("Invalid",
                                    "Total pembayaran tidak boleh 0");
                              }
                            } else {
                              Get.snackbar("Alamat tidak ditemukan",
                                  "Silakan isi alamat terlebih dahulu");
                              Get.toNamed(RouteHelper.getAddressPage());
                            }
                          }
                        } else {
                          Get.toNamed(RouteHelper.getSignInPage());
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width30,
                            vertical: Dimensions.height15),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          color: AppColors.mainColor,
                        ),
                        child: BigText(
                            text: "Check out",
                            color: Colors.white,
                            size: Dimensions.font16),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink();
      }),
    );
  }
}
