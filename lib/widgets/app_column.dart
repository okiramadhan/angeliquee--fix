import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/popular_product_controller.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:flutter_application_1/widgets/small_text.dart';
import 'package:get/get.dart';

class AppColumn extends StatelessWidget {
  final String text;
  final int pageId;
  const AppColumn({
    super.key,
    required this.text,
    required this.pageId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularProductController>(
      builder: (popularProduct) {
        final productAvailable = popularProduct.isLoaded &&
            popularProduct.popularProductList.length > pageId;

        final price = productAvailable
            ? popularProduct.popularProductList[pageId].price ?? 0
            : 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(
              text: text,
              size: Dimensions.font26,
            ),
            SizedBox(height: Dimensions.height5),
            SmallText(
              text: "Rp. $price",
              color: AppColors.mainBlacklalor,
              size: Dimensions.font13,
            ),
            SizedBox(height: Dimensions.height10),
            Row(
              children: [
                Wrap(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      color: AppColors.mainColor,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SmallText(text: "4.5"),
                const SizedBox(width: 10),
                SmallText(text: "20 reviews"),
              ],
            ),
          ],
        );
      },
    );
  }
}
