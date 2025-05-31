import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repository/cart_repo.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/models/products_model.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});
  Map<int, CartModel> _items = {};
  Map<int, CartModel> get items => _items;
  List<CartModel> storageItems = [];
  

  Future<void> addItemToServer(ProductModel product, int quantity) async {
  try {
    Response response = await cartRepo.addToCartRemote(
      productId: product.id!,
      productVariantId: null,
      quantity: quantity,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Berhasil", "Produk ditambahkan");
    } else {
      Get.snackbar("Gagal", "Gagal tambah ke server: ${response.bodyString}");
    }
  } catch (e) {
    Get.snackbar("Error", "Terjadi kesalahan: $e");
  }
}

  void addItem(ProductModel product, int quantity) {
    var totalQuantity = 0;
    if (_items.containsKey(product.id!)) {
      _items.update(
        product.id!,
        (value) {
          totalQuantity = value.quantity! + quantity;

          return CartModel(
              id: value.id,
              name: value.name,
              price: value.price,
              img: value.img,
              quantity: value.quantity! + quantity,
              isExist: true,
              time: DateTime.now().toString(),
              product: product);
        },
      );
      if (totalQuantity <= 0) {
        _items.remove(product.id);
      }
    } else {
      if (quantity > 0) {
        _items.putIfAbsent(product.id!, () {
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
          );
        });
      } else {
        Get.snackbar("Item count", "You can't add less than 1!",
            backgroundColor: AppColors.mainColor, colorText: Colors.white);
      }
    }
    cartRepo.addtoCartList(getItems);
    update();
  }

  bool existInCart(ProductModel product) {
    if (_items.containsKey(product.id!)) {
      return true;
    } else {
      return false;
    }
  }

  getQuantity(ProductModel product) {
    var quantity = 0;
    if (_items.containsKey(product.id!)) {
      _items.forEach(
        (key, value) {
          if (key == product.id) {
            quantity = value.quantity!;
          }
        },
      );
    }
    return quantity;
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      final price = value.price ?? 0;
      final quantity = value.quantity ?? 0;
      total += price * quantity;
    });
    return total;
  }

  List<CartModel> getCartData() {
    setCart = cartRepo.getCartList();
    return storageItems;
  }

  set setCart(List<CartModel> items) {
    storageItems = items;

    for (int i = 0; i < storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
  }

  void addToHistory({String paymentStatus = "pending"}) {
    List<CartModel> updatedCart = getItems.map((item) {
      return item;
    }).toList();

    cartRepo.addtoCartHistoryList(updatedCart);
  }

  void clear() {
    _items = {};
    cartRepo.removeCart();
    update();
  }

  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  set setItems(Map<int, CartModel> setItems) {
    _items = {};
    _items = setItems;
  }

  void addToCartList() {
    cartRepo.addtoCartList(getItems);
    update();
  }
  void clearCartHistory(){
    cartRepo.clearCartHistory();
    update();
  }
}
