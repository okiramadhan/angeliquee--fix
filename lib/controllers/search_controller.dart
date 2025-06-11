import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/models/products_model.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get.dart';

class SearchControllerr extends GetxController {
  final ApiClient apiClient;
  SearchControllerr({required this.apiClient});

  var searchResults = <ProductModel>[].obs;

  Future<void> searchProducts(String query) async {
    final response = await apiClient.getData("${AppConstants.POPULAR_PRODUCT_URI}?search=$query");
    if (response.statusCode == 200) {
      final data = response.body['data']['product'] as List;
      searchResults.value = data.map((e) => ProductModel.fromJson(e)).toList();
    }else{
      searchResults.clear();
    }
  }
}