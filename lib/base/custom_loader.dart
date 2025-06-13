import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  final double? size;
  const CustomLoader({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final loaderSize = size ?? Dimensions.height20 * 5;
    return Center(
      child: Container(
        height: loaderSize,
        width: loaderSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.mainColor, AppColors.yellowColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4,
        ),
      ),
    );
  }
}
