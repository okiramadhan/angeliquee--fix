import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/dimensions.dart';

class SplashLogo extends StatelessWidget {
  final double? size;
  const SplashLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? Dimensions.splashImg,
      height: size ?? Dimensions.splashImg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          "assets/images/logo.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}