import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/models/address_model.dart';
import 'package:flutter_application_1/models/new_address_model.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/app_text_field.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  late LatLng _initialPosition;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    if (_isLogged && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    if (Get.find<LocationController>().getAddress.isNotEmpty) {
      var location = Get.find<LocationController>().getAddress;
      final lat = location['latitude'];
      final lng = location['longitude'];
      if (lat != null && lng != null) {
        _initialPosition = LatLng(
          double.tryParse(lat.toString()) ?? -6.2,
          double.tryParse(lng.toString()) ?? 106.816666,
        );
      } else {
        _initialPosition = LatLng(-6.2, 106.816666);
      }
    } else {
      _initialPosition = LatLng(-6.2, 106.816666);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackgroundColor,
      body: GetBuilder<UserController>(builder: (userController) {
        if (userController.userModel != null &&
            _contactPersonName.text.isEmpty) {
          _contactPersonName.text = '${userController.userModel?.fName}';
          _contactPersonNumber.text = '${userController.userModel?.phone}';
          if (Get.find<LocationController>().addressList.isNotEmpty) {
            final userAddress = Get.find<LocationController>().getUserAddress();
            if (userAddress != null) {
              _addressController.text = userAddress.address;
            }
          }
        }
        return GetBuilder<LocationController>(builder: (locationController) {
          _addressController.text = '${locationController.placemark.name ?? ''}'
              '${locationController.placemark.locality ?? ''}'
              '${locationController.placemark.postalCode ?? ''}'
              '${locationController.placemark.country ?? ''}';
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER GRADIENT
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top +
                        Dimensions.height20,
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.mainColor, AppColors.yellowColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimensions.radius20 * 1.2),
                      bottomRight: Radius.circular(Dimensions.radius20 * 1.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: Dimensions.iconSize24,
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: Dimensions.radius30,
                        child: Icon(Icons.location_on,
                            color: AppColors.mainColor,
                            size: Dimensions.height30),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add New Address",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Text(
                            "Set your delivery location",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: Dimensions.font14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // MAP CARD
                Container(
                  height: Dimensions.height20 * 7,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    border: Border.all(width: 2, color: AppColors.mainColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _initialPosition,
                        initialZoom: 16,
                        onTap: (tapPosition, latLng) {
                          locationController.updatePositionWithLatLng(
                              latLng, false);
                        },
                        onPositionChanged: (position, hasGesture) {
                          if (hasGesture) {
                            locationController.updatePositionWithLatLng(
                                position.center!, true);
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: locationController.selectedPosition,
                              width: Dimensions.height20 * 2,
                              height: Dimensions.height20 * 2,
                              child: const Icon(Icons.location_pin,
                                  color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // ADDRESS TYPE SELECTOR
                Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.width20,
                      top: Dimensions.height10,
                      bottom: Dimensions.height10),
                  child: SizedBox(
                    height: Dimensions.height20 * 2.5,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locationController.addressTypeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              locationController.setAddressTypeIndex(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                  vertical: Dimensions.height10),
                              margin:
                                  EdgeInsets.only(right: Dimensions.width10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20 / 4),
                                  color: locationController.addressTypeIndex ==
                                          index
                                      ? AppColors.mainColor.withOpacity(0.15)
                                      : Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200]!,
                                        spreadRadius: 1,
                                        blurRadius: 5)
                                  ]),
                              child: Row(
                                children: [
                                  Icon(
                                    index == 0
                                        ? Icons.home_filled
                                        : index == 1
                                            ? Icons.work
                                            : Icons.location_on,
                                    color:
                                        locationController.addressTypeIndex ==
                                                index
                                            ? AppColors.mainColor
                                            : Theme.of(context).disabledColor,
                                  ),
                                  SizedBox(width: Dimensions.width10 / 2),
                                  Text(
                                    locationController.addressTypeList[index],
                                    style: TextStyle(
                                      color:
                                          locationController.addressTypeIndex ==
                                                  index
                                              ? AppColors.mainColor
                                              : Theme.of(context).disabledColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                // FORM SECTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.height10),
                      BigText(text: "Delivery address"),
                      SizedBox(height: Dimensions.height10 / 2),
                      AppTextField(
                          textController: _addressController,
                          hintText: "Your address",
                          icon: Icons.map),
                      SizedBox(height: Dimensions.height20),
                      BigText(text: "Contact name"),
                      SizedBox(height: Dimensions.height10 / 2),
                      AppTextField(
                          textController: _contactPersonName,
                          hintText: "Your name",
                          icon: Icons.person),
                      SizedBox(height: Dimensions.height20),
                      BigText(text: "Your number"),
                      SizedBox(height: Dimensions.height10 / 2),
                      AppTextField(
                          textController: _contactPersonNumber,
                          hintText: "Your Number",
                          icon: Icons.phone),
                      SizedBox(height: Dimensions.height20),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      }),
      bottomNavigationBar:
          GetBuilder<LocationController>(builder: (locationController) {
        return Container(
          padding: EdgeInsets.only(
            top: Dimensions.height10,
            bottom: Dimensions.height10 + MediaQuery.of(context).padding.bottom,
            left: Dimensions.width20,
            right: Dimensions.width20,
          ),
          decoration: BoxDecoration(
            color: AppColors.buttonBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20 * 2),
              topRight: Radius.circular(Dimensions.radius20 * 2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  final placemark = locationController.placemark;
                  NewAddressModel newAddress = NewAddressModel(
                    province: placemark.administrativeArea ?? "DKI Jakarta",
                    provinceId: "5",
                    city: placemark.locality ?? "Jakarta Pusat",
                    cityId: "5",
                    subdistrict: placemark.subLocality ?? "Tanah Abang",
                    subdistrictId: "419",
                    receivedName: _contactPersonName.text,
                    address: _addressController.text,
                    postalCode: placemark.postalCode ?? "10270",
                  );
                  locationController.addAddress(newAddress).then((response) {
                    if (response.isSuccess) {
                      Get.toNamed(RouteHelper.getInitial());
                      Get.snackbar("Address", "Added Successfully");
                    } else {
                      Get.snackbar("Address", "Couldnt save address");
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width30,
                      vertical: Dimensions.height15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: AppColors.mainColor,
                  ),
                  child: BigText(
                    text: "Save address",
                    color: Colors.white,
                    size: Dimensions.font20,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
