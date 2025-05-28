import 'package:flutter_application_1/data/api/api_client.dart';
import 'package:flutter_application_1/models/new_address_model.dart';
import 'package:flutter_application_1/utils/app_constants.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAddressfromGeocode(LatLng latlng) async {
    return await apiClient.getData('${AppConstants.GEOCODE_URI}'
    '?lat=${latlng.latitude}&lng=${latlng.longitude}');
  }

  String? getUserAddress(){
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";
  }
  Future<Response> addAddress(NewAddressModel addressModel)async{
    print("📤 [addAddress] Body: ${addressModel.toJson()}");
    return await apiClient.postData(AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }
  
  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }
  Future<bool> saveUserAddress(String address)async{
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(AppConstants.USER_ADDRESS, address);
  }
  Future<Response> removeAddress(String addressId) async {
  return await apiClient.deleteData('${AppConstants.REMOVE_USER_ADDRESS}/$addressId');
}
}