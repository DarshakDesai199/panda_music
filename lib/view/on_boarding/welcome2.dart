import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/view/auth/sign_up_screen.dart';

class Welcome2 extends StatefulWidget {
  const Welcome2({Key? key}) : super(key: key);

  @override
  State<Welcome2> createState() => _Welcome2State();
}

class _Welcome2State extends State<Welcome2> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.offAll(
        SignUpScreen(),
        transition: Transition.rightToLeft,
      );
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SvgPicture.asset(
              ImagePath.onBoardingBg,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: EdgeInsets.only(top: 235.h),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Sleep",
                      style: FontTextStyle.kWhite30W700Roboto,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "Explore the new king of sleep. It uses sound\nand vesualization to create perfect\nconditions for refreshing sleep.",
                      textAlign: TextAlign.center,
                      style: FontTextStyle.kWhite16W300Roboto
                          .copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
