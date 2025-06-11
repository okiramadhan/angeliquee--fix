class ProductModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stars;
  String? img;
  String? location;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stars,
    this.img,
    this.location,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  description = json['desc'];
  price = json['real_price'];
  stars = json['stars'];
  location = json['location'];
  if (json['product_image'] != null &&
    json['product_image'] is List &&
    json['product_image'].isNotEmpty) {
  String rawUrl = json['product_image'][0]['image_url'].toString();
  if (rawUrl.contains("apihttps")) {
    rawUrl = rawUrl.replaceFirst("https://dev-api.cakrawaladzikrateknologi.com/api", "");
  }

  img = rawUrl.startsWith('http') 
    ? rawUrl 
    : "https://dev-api.cakrawaladzikrateknologi.com$rawUrl";
} else {
  img = null;
}

}


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "desc": description,
      "real_price": price,
      "img": img,
      "location": location,
    };
  }
}
