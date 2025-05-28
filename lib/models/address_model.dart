class AddressModel {
  final String id;
  final String province;
  final String provinceId;
  final String city;
  final String cityId;
  final String subdistrict;
  final String subdistrictId;
  final String receivedName;
  final String address;
  final String postalCode;

  AddressModel({
    required this.id,
    required this.province,
    required this.provinceId,
    required this.city,
    required this.cityId,
    required this.subdistrict,
    required this.subdistrictId,
    required this.receivedName,
    required this.address,
    required this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'].toString(),
      province: json['province'] ?? "",
      provinceId: json['province_vendor_id'] ?? "",
      city: json['city'] ?? "",
      cityId: json['city_vendor_id'] ?? "",
      subdistrict: json['subdistrict'] ?? "",
      subdistrictId: json['subdistrict_vendor_id'] ?? "",
      receivedName: json['received_name'] ?? "",
      address: json['address'] ?? "",
      postalCode: json['postal_code'] ?? "",
    );
  }
}
