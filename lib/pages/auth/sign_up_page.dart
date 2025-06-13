import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/base/custom_loader.dart';
import 'package:flutter_application_1/base/show_custom_snackbar.dart';
import 'package:flutter_application_1/controllers/auth_controller.dart';
import 'package:flutter_application_1/models/signup_body_model.dart';
import 'package:flutter_application_1/pages/auth/sign_in_page.dart';
import 'package:flutter_application_1/routes/route_helper.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/dimensions.dart';
import 'package:flutter_application_1/widgets/app_text_field.dart';
import 'package:flutter_application_1/widgets/auth_card.dart';
import 'package:flutter_application_1/widgets/big_text.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      "google.jpg",
      "facebook.jpg",
      "twitter.jpg",
    ];

    void _registration(AuthController authController) {
      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String phone = phoneController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone number", title: "Phone Number");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email address", title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in your valid email address", title: "Valid Email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can not be less than 6 characters", title: "Password");
      } else {
        SignUpBody signUpBody = SignUpBody(
          fullName: name,
          email: email,
          password: password,
          phoneNumber: phone,
          confirmPassword: password,
        );
        authController.registration(signUpBody).then((status) {
          if (status.isSuccess) {
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      body: GetBuilder<AuthController>(builder: (_authController) {
        return !_authController.isLoading
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
                            "Create Account",
                            style: TextStyle(
                              fontSize: Dimensions.font26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          AppTextField(
                              textController: nameController,
                              hintText: "Name",
                              icon: Icons.person),
                          SizedBox(height: Dimensions.height20),
                          AppTextField(
                              textController: phoneController,
                              hintText: "Phone",
                              icon: Icons.phone),
                          SizedBox(height: Dimensions.height20),
                          AppTextField(
                              textController: emailController,
                              hintText: "Email",
                              icon: Icons.email),
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
                                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () => _registration(_authController),
                              child: Text(
                                "Sign Up",
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
                              text: "Already have an account?",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: Dimensions.font16,
                              ),
                              children: [
                                TextSpan(
                                  text: " Sign In",
                                  style: TextStyle(
                                    color: AppColors.mainBlacklalor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.to(() => const SignInPage(),
                                        transition: Transition.fade),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),
                          Text(
                            "Or sign up using",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.font16,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10),
                          Wrap(
                            children: List.generate(
                              signUpImages.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: Dimensions.radius30,
                                  backgroundImage: AssetImage(
                                      "assets/images/" + signUpImages[index]),
                                ),
                              ),
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
