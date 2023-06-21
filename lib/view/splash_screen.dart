import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/constant/prefrence_manager.dart';
import 'package:panda_music/view/bottom_bar_screen.dart';

import 'on_boarding/welcome1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.offAll(
        PreferenceManager.getUid() == null ? Welcome1() : BottomBarScreen(),
        transition: Transition.rightToLeft,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(ImagePath.logo),
            ),
            SizedBox(
              height: 65.h,
            ),
            Text(
              "PANDA",
              style: FontTextStyle.kWhite32W400Roboto,
            )
          ],
        ),
      ),
    );
  }
}
