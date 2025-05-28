import 'dart:convert';

import 'package:flutter_application_1/data/repository/location_repo.dart';
import 'package:flutter_application_1/models/address_model.dart';
import 'package:flutter_application_1/models/new_address_model.dart';
import 'package:flutter_application_1/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;
  late Position _position;
  late Position _pickPosition;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark=> _placemark;
  Placemark get pickPlacemark=>_pickPlacemark;
  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;
  late List<AddressModel> _allAddressList;
  List<AddressModel> get allAddress =>_allAddressList;
  final List<String> _addressTypeList = [
    'home',
    'office',
    'other',
  ];
  List<String> get addressTypeList=>_addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;
  LatLng selectedPosition = LatLng(-6.2, 106.816666);


  bool _updateAddressData=true;
  bool _changeAddress=true;

  bool get loading =>_loading;
  Position get position =>_position;
  Position get pickPosition =>_pickPosition;



  void updatePositionWithLatLng(LatLng latLng, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        final newPosition = Position(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          timestamp: DateTime.now(),
          heading: 0,
          accuracy: 1,
          altitude: 0,
          speedAccuracy: 1,
          speed: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );

        if (fromAddress) {
          _position = newPosition;
        } else {
          _pickPosition = newPosition;
        }

        selectedPosition = latLng;

        if (_changeAddress) {
          String _address = await getAddressfromGeocode(latLng);
          if (fromAddress) {
            _placemark = Placemark(name: _address);
          } else {
            _pickPlacemark = Placemark(name: _address);
          }
        }
      } catch (e) {
        print("Error in updatePositionWithLatLng: $e");
      }
      _loading = false;
      update();
    }
  }
  Future<String> getAddressfromGeocode(LatLng latlng) async {
    String _address = "Unknown Location Found";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latlng.latitude,
        latlng.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _address =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      }
    } catch (e) {
      print("Reverse geocoding failed: $e");
    }
    update();
    return _address;
  }

  Map<String, dynamic> _getAddress = {};
  Map get getAddress => _getAddress;

  NewAddressModel? getUserAddress() {
  String? userAddress = locationRepo.getUserAddress();
  if (userAddress != null && userAddress.isNotEmpty) {
    _getAddress = jsonDecode(userAddress);
    try {
      return NewAddressModel.fromJson(jsonDecode(userAddress));
    } catch (e) {
      print("Error decoding address: $e");
    }
  } else {
    print("User address is empty.");
  }
  return null;
}

  void setAddressTypeIndex(int index){
    _addressTypeIndex=index;
    update();
  }
  
  Future<ResponseModel> addAddress(NewAddressModel addressModel) async {
  _loading = true;
  update();
  print("📤 [addAddress] Body: ${addressModel.toJson()}");
  Response response = await locationRepo.addAddress(addressModel);
  print("📦 [addAddress] Status code: ${response.statusCode}");
  print("📦 [addAddress] Response body: ${response.body}");
  ResponseModel responseModel;
  if (response.statusCode == 200) {
    await getAddressList();
    String message = response.body["message"] ?? "Address added";
    responseModel = ResponseModel(true, message);
    await saveUserAddress(addressModel);
  } else {
    print("couldnt save the address: ${response.statusText}");
    responseModel = ResponseModel(false, response.statusText ?? "Failed");
  }
  _loading = false;
  update();
  return responseModel;
}

  Future<void> getAddressList() async {
  Response response = await locationRepo.getAllAddress();
  _addressList = [];
  _allAddressList = [];
  if (response.statusCode == 200) {
    if (response.body is List) {
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else if (response.body is Map && response.body['data'] is List) {
      response.body['data'].forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    }
  }
  update();
}
  Future<bool> saveUserAddress(NewAddressModel addressModel)async{
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }
  void clearAddressList(){
    _addressList=[];
    _allAddressList=[];
    update();
  }
  Future<ResponseModel> deleteAddress(String addressId) async {
  Response response = await locationRepo.removeAddress(addressId);
  if (response.statusCode == 200) {
    await getAddressList(); // Refresh list address setelah hapus
    return ResponseModel(true, "Address deleted");
  } else {
    return ResponseModel(false, response.statusText ?? "Failed");
  }
}
}
