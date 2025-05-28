import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/controllers/checkout_controller.dart';

class WebViewPage extends StatefulWidget {
  final String snapUrl;
  const WebViewPage({super.key, required this.snapUrl});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.snapUrl));
  }

  void _handleBackToHome() {
    Get.find<CartController>().clear();
    Get.find<CheckoutController>().clearCheckout();

    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackToHome,
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
