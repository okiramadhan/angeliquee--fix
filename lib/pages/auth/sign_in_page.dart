import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/base/custom_loader.dart';
import 'package:flutter_application_1/base/show_custom_snackbar.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/pages/auth/sign_up_page.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/app_text_field.dart';
import 'package:flutter_application_1/widgets/auth_card.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(AuthController authController) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isEmpty) {
        showCustomSnackBar("Type in your email address",
            title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in your valid email address",
            title: "Valid Email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can not be less than 6 characters",
            title: "Password");
      } else {
        authController.login(email, password).then((status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.mainColor, AppColors.yellowColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: AuthCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 48,
                            backgroundImage: AssetImage("assets/images/logo.jpg"),
                          ),
                          SizedBox(height: Dimensions.height20),
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: Dimensions.font26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          AppTextField(
                            textController: emailController,
                            hintText: "Email",
                            icon: Icons.email,
                          ),
                          SizedBox(height: Dimensions.height20),
                          AppTextField(
                            textController: passwordController,
                            hintText: "Password",
                            icon: Icons.lock,
                            isObscure: true,
                          ),
                          SizedBox(height: Dimensions.height20),
                          SizedBox(
                            width: double.infinity,
                            height: Dimensions.height45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.radius15),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () => _login(authController),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          RichText(
                            text: TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: Dimensions.font16,
                              ),
                              children: [
                                TextSpan(
                                  text: " Create",
                                  style: TextStyle(
                                    color: AppColors.mainBlacklalor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.to(() => SignUpPage(),
                                        transition: Transition.fade),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const CustomLoader();
      }),
    );
  }
}
