import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/common_widget/button.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/view/auth/create_account_screen.dart';
import 'package:panda_music/view/auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: SvgPicture.asset(
                ImagePath.onBoarding,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "We are what we do",
                    style: FontTextStyle.kWhite30W700Roboto,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "Thousand of people are usign silent moon\nfor smalls meditation",
                    textAlign: TextAlign.center,
                    style:
                        FontTextStyle.kWhite16W300Roboto.copyWith(height: 1.5),
                  ),
                  SizedBox(
                    height: 62.h,
                  ),
                  CommonButton.button(
                    onTap: () {
                      Get.to(
                        CreateAccountScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    title: "SIGN UP",
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
                            Get.to(
                              LoginScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Text(
                            " LOG IN",
                            style: FontTextStyle.kWhite14W500Roboto
                                .copyWith(color: AppColor.purple),
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
