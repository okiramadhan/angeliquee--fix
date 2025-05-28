// import 'package:get/get.dart';
// import 'package:flutter_application_1/data/repository/payment_repo.dart';
// import 'package:flutter_application_1/routes/route_helper.dart';

// class PaymentController extends GetxController {
//   final PaymentRepo paymentRepo;

//   PaymentController({required this.paymentRepo});

//   Future<void> createOrderAndRedirect({
//     required String costName,
//     required String costService,
//     required String addressId,
//   }) async {
//     const callbackFinish = "https://digitalkeun.id/";

//     final body = {
//       "cost_name": costName,
//       "cost_service": costService,
//       "address_id": addressId,
//       "callback_finish": callbackFinish,
//     };

//     try {
//       Response response = await paymentRepo.createOrder(body);

//       // 🧪 Tambahan log untuk debug lebih aman:
//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");
//       print(
//           "Apakah response.body['data'] != null: ${response.body['data'] != null}");
//       print(
//           "Midtrans redirect URL: ${response.body['data']?['midtrans_redirect_url']}");
//       print(
//           "Redirect URL (fallback): ${response.body['data']?['redirect_url']}");

//       if ((response.statusCode == 200 || response.statusCode == 201) && response.body['data'] != null) {
//         final snapUrl = response.body['data']['midtrans_redirect_url'] ??
//             response.body['data']['redirect_url'];

//         print('snapUrl: $snapUrl');

//         if (snapUrl != null && snapUrl.toString().isNotEmpty) {
//           Get.toNamed(RouteHelper.getPaymentPage(Uri.encodeComponent(snapUrl)));
//           return;
//         } else {
//           print('Tidak ada URL pembayaran');
//           Get.snackbar("Payment Error", "Tidak ada URL pembayaran.");
//           return;
//         }
//       }

//       print('Payment error: ${response.body}');
//       final error = response.body['errors'] ??
//           response.body['message'] ??
//           response.body.toString() ??
//           'Unknown error';
//       Get.snackbar("Payment Error", error.toString());
//     } catch (e) {
//       print('Exception saat payment: $e');
//       Get.snackbar("Payment Error", e.toString());
//     }
//   }
// }
