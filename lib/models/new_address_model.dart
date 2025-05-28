class NewAddressModel {
  String province;
  String provinceId;
  String city;
  String cityId;
  String subdistrict;
  String subdistrictId;
  String receivedName;
  String address;
  String postalCode;

  NewAddressModel({
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

  factory NewAddressModel.fromJson(Map<String, dynamic> json) {
    return NewAddressModel(
      province: json['province'] ?? "",
      provinceId: json['province_id'] ?? "",
      city: json['city'] ?? "",
      cityId: json['city_id'] ?? "",
      subdistrict: json['subdistrict'] ?? "",
      subdistrictId: json['subdistrict_id'] ?? "",
      receivedName: json['received_name'] ?? "",
      address: json['address'] ?? "",
      postalCode: json['postal_code'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "province": province,
      "province_id": provinceId,
      "city": city,
      "city_id": cityId,
      "subdistrict": subdistrict,
      "subdistrict_id": subdistrictId,
      "received_name": receivedName,
      "address": address,
      "postal_code": postalCode,
    };
  }
}