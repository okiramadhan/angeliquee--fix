import 'dart:convert';

import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  CartRepo({required this.sharedPreferences, required this.apiClient});

  List<String> cart = [];
  List<String> cartHistory = [];

  Future<Response> addToCartRemote({
    required int productId,
    int? productVariantId,
    required int quantity,
  }) async {
    final body = {
      "product_id": productId,
      "product_variant_id": productVariantId,
      "quantity": quantity,
    };

    return await apiClient.postData(AppConstants.CART_URI, body);
  }

  void addtoCartList(List<CartModel> cartList) {
    // sharedPreferences.remove(AppConstants.CART_LIST);
    // sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    var time = DateTime.now().toString();
    cart = [];

    cartList.forEach((element) {
      element.time = time;
      return cart.add(jsonEncode(element));
    });

    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    // print(sharedPreferences.getStringList(AppConstants.CART_LIST));
    getCartList();
  }

  List<CartModel> getCartList() {
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
    }

    List<CartModel> cartList = [];

    for (var element in carts) {
      try {
        final decoded = jsonDecode(element);
        final cartModel = CartModel.fromJson(decoded);
        cartList.add(cartModel);
      } catch (e) {
        // Hapus data rusak
        sharedPreferences.remove(AppConstants.CART_LIST);
        sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
        print(" Cart corrupt terdeteksi dan dibersihkan: $e");
        break;
      }
    }

    return cartList;
  }

  List<CartModel> getCartHistoryList() {
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = [];

      cartHistory =
          sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    List<CartModel> cartListHistory = [];

    cartHistory.forEach((element) =>
        cartListHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartListHistory;
  }

  void addtoCartHistoryList(List<CartModel> updatedCart) {
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory =
          sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    for (var item in updatedCart) {
      cartHistory.add(jsonEncode(item));
    }
    removeCart();
    sharedPreferences.setStringList(
        AppConstants.CART_HISTORY_LIST, cartHistory);
    for (int j = 0; j < getCartHistoryList().length; j++) {
      print("the time for order is " + getCartHistoryList()[j].time.toString());
    }
  }

  void removeCart() {
    cart = [];
    sharedPreferences.remove(AppConstants.CART_LIST);
  }

  void clearCartHistory() {
    removeCart();
    cartHistory = [];
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }
}
