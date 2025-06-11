import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/popular_product_controller.dart';
import 'package:flutter_application_1/models/products_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/search_controller.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final SearchControllerr searchController = Get.find<SearchControllerr>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
          color: Colors.white,
          child: const Center(child: Text("Masukkan nama produk")));
    }

    searchController.searchProducts(query);

    return Container(
      color: Colors.white,
      child: Obx(() {
        var suggestions = searchController.searchResults;
        if (suggestions.isEmpty) {
          return const Center(child: Text("Tidak ada saran"));
        }
        return ListView.builder(
          padding: EdgeInsets.all(Dimensions.height10),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            ProductModel product = suggestions[index];
            return InkWell(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              onTap: () {
                final popularList =
                    Get.find<PopularProductController>().popularProductList;
                final productIndex =
                    popularList.indexWhere((p) => p.id == product.id);

                if (productIndex != -1) {
                  close(context, query);
                  Get.toNamed(
                      RouteHelper.getPopularShop(productIndex, "search"));
                } else {
                  Get.snackbar("Produk tidak ditemukan",
                      "Produk tidak ada di daftar populer.");
                }
              },
              child: _buildProductCard(product),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      child: ListTile(
        contentPadding: EdgeInsets.all(Dimensions.height15),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          child: product.img != null
              ? Image.network(
                  product.img!,
                  width: Dimensions.height20 * 3,
                  height: Dimensions.height20 * 3,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported),
        ),
        title: Text(
          product.name ?? "-",
          style: TextStyle(
            fontSize: Dimensions.font16,
            color: AppColors.titleGoloc,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Rp ${product.price}",
          style: TextStyle(
            fontSize: Dimensions.font14,
            color: AppColors.yellowColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: Dimensions.iconSize16,
            color: const Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
