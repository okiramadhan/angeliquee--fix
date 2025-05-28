import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/models/address_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/data/repository/auth_repo.dart';
import 'package:flutter_application_1/models/response_model.dart';
import 'package:flutter_application_1/models/signup_body_model.dart';
import 'package:flutter_application_1/models/user_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final ApiClient apiClient;

  AuthController({required this.authRepo, required this.apiClient});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    print(response.body); 
    late ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['status'] == true) {
      final token = response.body['data']['token'];
      authRepo.saveUserToken(token);
      apiClient.updateHeader(token);
      responseModel = ResponseModel(true, token);
    } else {
      responseModel = ResponseModel(
          false, response.body['message'] ?? "Registration failed");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200 && response.body['data'] != null) {
      // Ambil token dari field yang benar!
      String token = response.body['data']['token']['token'];
      await authRepo.saveUserToken(token); // Simpan & update header
      responseModel = ResponseModel(true, "Login berhasil");
    } else {
      responseModel = ResponseModel(false, response.statusText ?? "Login gagal");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getUserInfo() async {
  _isLoading = true;
  update();
  Response response = await authRepo.getUserInfo();
  if (response.statusCode == 200 && response.body['data'] != null) {
    _userModel = UserModel.fromJson(response.body['data']);
    // Ambil token baru jika ada di response user info
    if (response.body['data']['token'] != null &&
        response.body['data']['token']['token'] != null) {
      String newToken = response.body['data']['token']['token'];
      await authRepo.saveUserToken(newToken); // update header & simpan token baru
    }
  } else {
    print("Gagal memuat user info: ${response.statusText}");
  }
  _isLoading = false;
  update();
}

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

Future<void> logout() async {
  final locationController = Get.find<LocationController>();
  for (var address in List<AddressModel>.from(locationController.addressList)) {
    await locationController.deleteAddress(address.id);
  }
  await authRepo.clearUserToken();
  clearSharedData();
  locationController.clearAddressList(); 
  Get.offAllNamed(RouteHelper.getSignInPage());
}
}
