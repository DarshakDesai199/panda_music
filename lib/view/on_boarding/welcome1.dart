import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/view/on_boarding/welcome2.dart';

class Welcome1 extends StatefulWidget {
  const Welcome1({Key? key}) : super(key: key);

  @override
  State<Welcome1> createState() => _Welcome1State();
}

class _Welcome1State extends State<Welcome1> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.offAll(
        Welcome2(),
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
