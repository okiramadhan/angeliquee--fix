class AppConstants {
  static const String APP_NAME = "DBAngelique";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "https://dev-api.cakrawaladzikrateknologi.com/api";
  static const String POPULAR_PRODUCT_URI = '/product';
  static const String RECOMMENDED_PRODUCT_URI = '/product';
  // static const String UPLOAD_URL = "/uploads/";

  //user & auth endpoints
  static const String REGISTRATION_URI = '/users/register';
  static const String LOGIN_URI = '/users/login';
  static const String USER_INFO_URI = '/users/current';
  //new
  static const String USER_ADDRESS = "user_address";
  static const String ADD_USER_ADDRESS = "/users/address/create";
  static const String REMOVE_USER_ADDRESS = "/users/address/remove";
  static const String ADDRESS_LIST_URI = "/users/address";
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';

  // Order
  static const String ORDER_URI = '/users/order';
  static const String SHIPPING_COST_URI = '/shipping/cost';

  //cart
  static const String CART_URI = "/users/cart";

  //notification
  static const String DEVICE_TOKEN_URI = '/notification/device_token';

  //payment
  static const String MIDTRANS_BASE_URL = "https://app.midtrans.com/snap/v2/vtweb";

  static const String TOKEN = 'token';
  static const String PHONE = '';
  static const String PASSWORD = '';
  static const String CART_LIST = 'cart-list';
  static const String CART_HISTORY_LIST = 'cart-history-list';
  static const String APP_KEY = "7654c6d42b57683a1c1d06ec68e44a97511e0c466d79c5f93c40a78c0bb504eb";

}
