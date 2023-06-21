import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/common_widget/button.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/constant/prefrence_manager.dart';
import 'package:panda_music/controller/login_controller.dart';
import 'package:panda_music/firebase/auth.dart';
import 'package:panda_music/firebase/facebook_service.dart';
import 'package:panda_music/firebase/google_services.dart';
import 'package:panda_music/view/auth/create_account_screen.dart';
import 'package:panda_music/view/bottom_bar_screen.dart';

import 'get_started_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List button = [
    {"image": ImagePath.facebook, "title": "CONTINUE WITH FACEBOOK"},
    {"image": ImagePath.google, "title": "CONTINUE WITH GOOGLE"},
  ];

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(100),
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(ImagePath.back),
          ),
        ),
      ),
      body: GetBuilder<LoginController>(
        builder: (controller) {
          return Form(
            key: _formKey,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppConstant.commonPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Welcome Back!',
                          style: FontTextStyle.kWhite28W400Roboto
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Column(
                        children: List.generate(
                          button.length,
                          (index) => GestureDetector(
                            onTap: () async {
                              controller.setButtonTap(index);
                              if (controller.buttonSelected == 0) {
                                await FaceBookAuthServices.facebookLogin();
                              } else if (controller.buttonSelected == 1) {
                                print('=== Google Tap');
                                signInWithGoogle().then((value) async {
                                  PreferenceManager.setUid(
                                      kFirebaseAuth.currentUser!.uid);
                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(kFirebaseAuth.currentUser!.uid)
                                      .set({
                                    "image": googleImageUrl,
                                    "username": googleName,
                                    "email": googleEmail,
                                    // "password": password.text
                                  });
                                  Get.offAll(GetStartedScreen());
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(
                                  vertical: 17.h,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.buttonSelected == index
                                      ? AppColor.purple
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: controller.buttonSelected != index
                                          ? AppColor.offWhite1
                                          : Colors.transparent),
                                  borderRadius: BorderRadius.circular(100.h),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: SvgPicture.asset(
                                            button[index]['image'])),
                                    Expanded(
                                      flex: 7,
                                      child: Text(button[index]['title'],
                                          style:
                                              FontTextStyle.kWhite14W400Roboto),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: Text(
                            'OR LOG IN WITH EMAIL',
                            style: FontTextStyle.kWhite14W400Roboto
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: email,
                        onChanged: (value) {
                          RegExp regex = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          if (regex.hasMatch(value)) {
                            controller.setEmailValue(true);
                          } else {
                            controller.setEmailValue(false);
                          }
                        },
                        validator: (value) {
                          RegExp regex = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          if (!regex.hasMatch(value!)) {
                            return "Enter valid Email";
                          }
                        },
                        cursorColor: AppColor.blue,
                        style: FontTextStyle.kWhite16W300Roboto.copyWith(
                            color: Color.fromRGBO(63, 65, 78, 1),
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.offWhite,
                          hintText: "Email address",
                          hintStyle: FontTextStyle.kWhite16W300Roboto
                              .copyWith(color: AppColor.lightPurple),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.h),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: password,
                        cursorColor: AppColor.blue,
                        style: FontTextStyle.kWhite16W300Roboto.copyWith(
                            color: Color.fromRGBO(63, 65, 78, 1),
                            fontWeight: FontWeight.w400),
                        obscureText: controller.isVisible,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.offWhite,
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.togglePasswordVisible();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  ImagePath.visible,
                                  height: 15.h,
                                  width: 25.w,
                                ),
                              ],
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: FontTextStyle.kWhite16W300Roboto
                              .copyWith(color: AppColor.lightPurple),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.h),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      controller.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColor.white,
                              ),
                            )
                          : CommonButton.button(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus &&
                                      currentFocus.focusedChild != null) {
                                    currentFocus.focusedChild!.unfocus();
                                  }
                                  controller.setLoading(true);
                                  bool isLogin =
                                      await FirebaseAuthService.login(
                                          email: email.text,
                                          password: password.text,
                                          context: context);
                                  if (isLogin == true) {
                                    controller.setLoading(false);
                                    PreferenceManager.setUid(
                                        kFirebaseAuth.currentUser!.uid);
                                    Get.offAll(BottomBarScreen());
                                  } else {
                                    controller.setLoading(false);
                                  }
                                }
                              },
                              title: "LOG IN",
                              horPadding: 0),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: FontTextStyle.kWhite14W500Roboto,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ALREADY HAVE AN ACCOUNT?",
                            style: FontTextStyle.kWhite14W500Roboto,
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(CreateAccountScreen());
                              },
                              child: Text(
                                " SIGN UP",
                                style: FontTextStyle.kWhite14W500Roboto
                                    .copyWith(color: AppColor.purple),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
