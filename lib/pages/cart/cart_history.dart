import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/base/no_data_page.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/app_icon.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:flutter_application_1/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList =
        Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, List<CartModel>> cartItemsPerOrder = {};
    for (var item in getCartHistoryList) {
      if (item.time != null) {
        if (!cartItemsPerOrder.containsKey(item.time)) {
          cartItemsPerOrder[item.time!] = [];
        }
        cartItemsPerOrder[item.time!]!.add(item);
      }
    }

    var orderTimes = cartItemsPerOrder.keys.toList();

    Widget timeWidget(String time) {
      String outputDate = "Invalid Date";
      try {
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
        var outputFormat = DateFormat("dd/MM/yyyy hh:mm a");
        outputDate = outputFormat.format(parseDate);
      } catch (e) {
        outputDate = time;
      }
      return BigText(text: outputDate);
    }

    return Scaffold(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cart History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      "Your previous orders",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: Dimensions.font14,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: Dimensions.radius30 * 0.93,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.shopping_cart,
                      color: AppColors.mainColor, size: Dimensions.iconSize24),
                ),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<CartController>(builder: (_cartController) {
              return orderTimes.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                        top: Dimensions.height20,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                      ),
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          itemCount: orderTimes.length,
                          itemBuilder: (context, index) {
                            String orderTime = orderTimes[index];
                            List<CartModel> items =
                                cartItemsPerOrder[orderTime]!;

                            return Container(
                              height: Dimensions.height30 * 4,
                              margin:
                                  EdgeInsets.only(bottom: Dimensions.height20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      timeWidget(orderTime),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: List.generate(
                                          items.length > 3 ? 3 : items.length,
                                          (imgIndex) => Container(
                                            height: Dimensions.height20 * 3,
                                            width: Dimensions.height20 * 3,
                                            margin: EdgeInsets.only(
                                                right: Dimensions.width10 / 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius15 / 2),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    items[imgIndex].img!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: Dimensions.height20 * 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SmallText(
                                              text: "Total",
                                              color: AppColors.titleGoloc,
                                            ),
                                            BigText(
                                              text: "${items.length} items",
                                              color: AppColors.titleGoloc,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Buat Map<int, CartModel> dari order yang dipilih
                                                Map<int, CartModel> moreOrder =
                                                    {};
                                                for (var item in items) {
                                                  if (item.id != null) {
                                                    moreOrder.putIfAbsent(
                                                        item.id!, () => item);
                                                  }
                                                }
                                                // Set items di controller lalu buka halaman cart
                                                Get.find<CartController>()
                                                    .setItems = moreOrder;
                                                Get.find<CartController>()
                                                    .addToCartList();
                                                Get.toNamed(
                                                    RouteHelper.getCartPage());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimensions.width10,
                                                    vertical:
                                                        Dimensions.height10 /
                                                            2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius15 /
                                                              3),
                                                  border: Border.all(
                                                      color:
                                                          AppColors.mainColor,
                                                      width: 1),
                                                ),
                                                child: SmallText(
                                                  text: "one more",
                                                  color: AppColors.mainColor,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: const Center(
                        child: NoDataPage(
                          text: "You didn't buy anything so far!",
                        ),
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
