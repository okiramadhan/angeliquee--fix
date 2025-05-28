import 'package:flutter_application_1/data/repository/user_repo.dart';
import 'package:flutter_application_1/models/response_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});
  bool _isLoading = false;
  UserModel? _userModel;
  bool get isLoading => _isLoading;
  UserModel? get userModel => _userModel;

 Future<ResponseModel> getUserInfo() async {
  print("📞 [getUserInfo] Dipanggil");

  Response response = await userRepo.getUserInfo();

  print("📥 [getUserInfo] Status code: ${response.statusCode}");
  print("📥 [getUserInfo] Response body: ${response.body}");

  late ResponseModel responseModel;

  if (response.statusCode == 200 && response.body['data'] != null) {
  _userModel = UserModel.fromJson(response.body['data']);
  responseModel = ResponseModel(true, "successfully");
} else {
  print("❌ [getUserInfo] Error: ${response.statusCode}, ${response.body}");
  responseModel = ResponseModel(false, response.statusText ?? "Unknown error");
}

_isLoading = false;
update();
return responseModel;
}
}
