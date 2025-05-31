import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/checkout_controller.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/data/repository/checkout_repo.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedCourier;
  String? selectedService;
  TextEditingController voucherController = TextEditingController();

  final List<String> courierOptions = ['jne'];
  final List<String> serviceOptions = ['REG'];

  final RxBool isLoading = false.obs;
  final RxInt shippingCost = 0.obs;
  final RxInt voucherDiscount = 0.obs;
  final RxInt total = 0.obs;

  final Map<String, Map<String, int>> shippingRates = {
    'jne': {'REG': 140000},
  };

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<CheckoutRepo>(() => CheckoutRepo(apiClient: Get.find()));
    Get.lazyPut<CheckoutController>(
        () => CheckoutController(checkoutRepo: Get.find()));

    final cartController = Get.find<CartController>();
    final locationController = Get.find<LocationController>();
    final checkoutController = Get.find<CheckoutController>();

    total.value =
        cartController.totalAmount + shippingCost.value - voucherDiscount.value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: AppColors.mainColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.buttonBackgroundColor,
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildShippingCard(cartController),
                    SizedBox(height: 20),
                    _buildSummaryCard(cartController),
                  ],
                ),
              ),
              if (isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.mainColor),
                  ),
                ),
            ],
          )),
      bottomNavigationBar: _buildBottomButton(
          cartController, locationController, checkoutController),
    );
  }

  Widget _buildShippingCard(CartController cartController) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Pilih Jasa Kirim",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: selectedCourier,
              items: courierOptions
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourier = value;
                  _updateShipping(cartController);
                });
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Pilih Jenis Pengiriman",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: selectedService,
              items: serviceOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                  _updateShipping(cartController);
                });
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: voucherController,
              decoration: InputDecoration(
                labelText: "Masukkan kode voucher",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon:
                    Icon(Icons.card_giftcard, color: AppColors.mainColor),
              ),
              onChanged: (value) {
                voucherDiscount.value =
                    value.trim().toLowerCase() == "diskon5" ? 5000 : 0;
                total.value = cartController.totalAmount +
                    shippingCost.value -
                    voucherDiscount.value;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateShipping(CartController cartController) {
    if (selectedCourier != null && selectedService != null) {
      final cost = shippingRates[selectedCourier!]?[selectedService!] ?? 0;
      shippingCost.value = cost;
      total.value = cartController.totalAmount +
          shippingCost.value -
          voucherDiscount.value;
    }
  }

  Widget _buildSummaryCard(CartController cartController) {
    return Obx(() => Card(
          color: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              children: [
                _checkoutRow("Subtotal", "Rp ${cartController.totalAmount}"),
                SizedBox(height: 8),
                _checkoutRow("Ongkos Kirim", "Rp ${shippingCost.value}"),
                SizedBox(height: 8),
                _checkoutRow("Diskon Voucher", "- Rp ${voucherDiscount.value}"),
                Divider(thickness: 1, height: 24),
                _checkoutRow("Total", "Rp ${total.value}",
                    isBold: true, valueColor: AppColors.mainColor),
              ],
            ),
          ),
        ));
  }

  Widget _buildBottomButton(
      CartController cartController,
      LocationController locationController,
      CheckoutController checkoutController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
          onPressed: () async {
            if (selectedCourier != null &&
                selectedService != null &&
                locationController.addressList.isNotEmpty) {
              isLoading.value = true;

              final latestAddress = locationController.addressList.reduce(
                (a, b) => int.parse(a.id) > int.parse(b.id) ? a : b,
              );

              await checkoutController.placeOrderAndPay(
                courier: selectedCourier!,
                costService: selectedService!,
                addressId: latestAddress.id,
                callbackFinish: "https://digitalkeun.id/",
                voucherCode: voucherController.text.trim(),
              );

              cartController.addToHistory();
              isLoading.value = false;
            } else {
              Get.snackbar("Error",
                  "Pilih jasa kirim, jenis pengiriman, dan pastikan alamat tersedia");
            }
          },
          child: Text(
            "Bayar Sekarang",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _checkoutRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16)),
        Text(value,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: valueColor)),
      ],
    );
  }
}
