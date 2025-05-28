import 'dart:convert';

import 'package:flutter_application_1/data/repository/recommended_product_repo.dart';
import 'package:flutter_application_1/models/products_model.dart';
import 'package:get/get.dart';

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo recommendedProductRepo;
  RecommendedProductController({required this.recommendedProductRepo});
  List<dynamic> _recommendedProductList = [];
  List<dynamic> get recommendedProductList => _recommendedProductList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getRecommendedProductList() async {
    Response response =
        await recommendedProductRepo.getRecommendedProductList();
    if (response.statusCode == 200) {
      print(jsonEncode(response.body));
      _recommendedProductList = [];
      _recommendedProductList.addAll((response.body['data']['product'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList()
          .reversed
          .toList());
      _isLoaded = true;
      update();
    } else {
      print("Failed to load recommended products: ${response.statusText}");
    }
  }
}
