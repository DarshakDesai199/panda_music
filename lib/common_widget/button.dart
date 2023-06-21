import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/font_style.dart';

class CommonButton {
  static Padding button(
      {required GestureTapCallback onTap,
      required String title,
      Color? buttonColor,
      double? horPadding,
      TextStyle? textStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horPadding ?? 20.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.h),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(
            vertical: 24.h,
          ),
          decoration: BoxDecoration(
            color: buttonColor ?? AppColor.purple,
            borderRadius: BorderRadius.circular(100.h),
          ),
          child: Center(
            child: Text(
              title,
              style: textStyle ?? FontTextStyle.kOffWhite1_14W500Roboto,
            ),
          ),
        ),
      ),
    );
  }
}
