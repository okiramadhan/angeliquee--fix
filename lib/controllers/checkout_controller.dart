import 'package:flutter_application_1/data/repository/checkout_repo.dart';
import 'package:flutter_application_1/pages/payment/webview_page.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final CheckoutRepo checkoutRepo;

  CheckoutController({required this.checkoutRepo});

  Future<void> placeOrderAndPay({
    required String courier,
    required String costService,
    required String addressId,
    required String callbackFinish,
    String? voucherCode,
  }) async {
    final data = {
      "cost_name": courier,
      "cost_service": costService,
      "address_id": addressId,
      "callback_finish": callbackFinish,
    };

    if (voucherCode != null && voucherCode.isNotEmpty) {
      data["voucher_code"] = voucherCode;
    }

    try {
      Response response = await checkoutRepo.placeOrder(data);

      print("📦 Status: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      final resData = response.body['data'];
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          resData != null) {
        final snapUrl = resData['midtrans_redirect_url'] ?? resData['redirect_url'];
        if (snapUrl != null && snapUrl.toString().isNotEmpty) {
          Get.to(() => WebViewPage(snapUrl: snapUrl));
        } else {
          Get.snackbar("Gagal", "URL pembayaran tidak tersedia");
        }
      } else {
        final err = response.body['errors'] ??
            response.body['message'] ??
            'Gagal melakukan checkout';
        Get.snackbar("Gagal", err.toString());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
  void clearCheckout() {
  // Tambahkan data checkout yang perlu direset jika kamu pakai Rx variable
  // Misalnya: selectedCourier.value = '';
  // Tapi kalau tidak pakai .obs, cukup kosongkan state internal yang ada

  // Contoh: reset state lokal kalau kamu simpan value di controller
  print("Checkout data cleared");
}

}


