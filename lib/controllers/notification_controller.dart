import 'package:flutter_application_1/data/repository/notification_repo.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationRepo notificationRepo;

  NotificationController({required this.notificationRepo});

  Future<void> sendTokenToServer(String token) async {
    try {
      Response response = await notificationRepo.sendDeviceToken(token);
      if (response.statusCode == 200) {
        print("Token berhasil dikirim ke backend");
      } else {
        print("Gagal kirim token: ${response.statusCode}");
      }
    } catch (e) {
      print("Error kirim token: $e");
    }
  }
}