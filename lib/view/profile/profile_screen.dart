import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/cache_network_image.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/constant/prefrence_manager.dart';
import 'package:panda_music/controller/edit_profile_controller.dart';
import 'package:panda_music/hive_model/download_model.dart';
import 'package:panda_music/view/auth/login_screen.dart';
import 'package:panda_music/view/download/download_screen.dart';
import 'package:panda_music/view/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(children: [
            SizedBox(
              height: 90.h,
            ),
            GetBuilder<EditProfileController>(
              builder: (controller) {
                return Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: 165.h,
                            width: 165.h,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            // child: Image.asset(ImagePath.girls, fit: BoxFit.fill),
                            child: controller.profileImage == ""
                                ? Image.asset(ImagePath.girls, fit: BoxFit.fill)
                                : CachedImage(url: controller.profileImage),
                          ),
                          InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: EdgeInsets.all(8.h),
                                child: SvgPicture.asset(ImagePath.crown),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 36.h),
                      child: Text(
                        controller.username.text,
                        style: FontTextStyle.kWhite28W400Roboto
                            .copyWith(fontSize: 25.h),
                      ),
                    ),
                  ],
                );
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.h),
              onTap: () {
                Get.to(EditProfileScreen());
              },
              child: ListTile(
                leading: Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    color: AppColor.offWhite,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImagePath.profile,
                    ),
                  ),
                ),
                title: Text(
                  "Edit Profile",
                  style: FontTextStyle.kWhite16W400Roboto
                      .copyWith(fontSize: 17.sp),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: AppColor.offWhite),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.h),
              onTap: () {
                Get.to(DownloadScreen());
              },
              child: ListTile(
                leading: Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    color: AppColor.offWhite,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImagePath.download,
                      color: AppColor.blue,
                    ),
                  ),
                ),
                title: Text(
                  "My Downloads",
                  style: FontTextStyle.kWhite16W400Roboto
                      .copyWith(fontSize: 17.sp),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: AppColor.offWhite),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.h),
              onTap: () {},
              child: ListTile(
                leading: Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    color: AppColor.offWhite,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImagePath.paper,
                      color: AppColor.blue,
                    ),
                  ),
                ),
                title: Text(
                  "Terms & Privacy Policy",
                  style: FontTextStyle.kWhite16W400Roboto
                      .copyWith(fontSize: 17.sp),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: AppColor.offWhite),
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            // Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(8.h),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: AppColor.white,
                      insetPadding: EdgeInsets.symmetric(vertical: 0.h),
                      titlePadding: EdgeInsets.symmetric(vertical: 5.h),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SvgPicture.asset(
                              ImagePath.logo,
                              width: 75.h,
                              height: 70.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Center(
                            child: Text(
                              "Are you sure you want to\nLog Out?",
                              style: FontTextStyle.kWhite16W600Roboto
                                  .copyWith(color: AppColor.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.blue),
                            onPressed: () {
                              Get.back();
                              Get.offAll(LoginScreen());
                              PreferenceManager.clearData();

                              /// Local Database Hive-- Download Data Clear.
                              Hive.box(AppConstant.downloadBox).clear();
                              Hive.box(AppConstant.downloadBox).close();
                            },
                            child: Text("Log Out")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.blue),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Cancel")),
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                leading: Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    color: AppColor.offWhite,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImagePath.logout,
                      color: AppColor.blue,
                    ),
                  ),
                ),
                title: Text(
                  "Log Out",
                  style: FontTextStyle.kWhite16W400Roboto
                      .copyWith(fontSize: 17.sp),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: AppColor.offWhite),
              ),
            ),
            SizedBox(
              height: 85.h,
            ),
          ]),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      /*     leading: IconButton(
        onPressed: () {},
        splashRadius: 20,
        icon: Icon(Icons.arrow_back),
      ),*/
      centerTitle: true,
      title: Text(
        "Profile",
        style: FontTextStyle.kWhite15W500Roboto,
      ),
    );
  }
}
