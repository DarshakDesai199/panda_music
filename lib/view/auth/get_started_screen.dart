import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/common_widget/button.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';

import '../bottom_bar_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome\nto Silent Moon',
                    textAlign: TextAlign.center,
                    style: FontTextStyle.kWhite30W700Roboto.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(255, 236, 204, 1)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "Explore the app, Find some peace of mind to\nprepare for meditation.",
                      textAlign: TextAlign.center,
                      style: FontTextStyle.kWhite16W400Roboto.copyWith(
                          color: Color.fromRGBO(235, 234, 236, 1), height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SvgPicture.asset(
                    "asset/image/Group 6814 (1).svg",
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 75.h),
                    child: SizedBox(
                      height: 63.h,
                      child: CommonButton.button(
                        onTap: () {
                          Get.offAll(BottomBarScreen());
                        },
                        title: "GET STARTED",
                        buttonColor: AppColor.offWhite2,
                        textStyle: FontTextStyle.kWhite14W500Roboto
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
