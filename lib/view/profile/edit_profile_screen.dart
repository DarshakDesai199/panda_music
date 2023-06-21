import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/common_widget/button.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/cache_network_image.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/controller/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: GetBuilder<EditProfileController>(
          builder: (controller) {
            return Padding(
              padding: AppConstant.commonPadding,
              child: Column(children: [
                SizedBox(
                  height: 50.h,
                ),
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
                        child: controller.image != null
                            ? Image.file(
                                controller.image!,
                                fit: BoxFit.fill,
                              )
                            : controller.profileImage != ""
                                ? CachedImage(
                                    url: controller.profileImage,
                                  )
                                : Image.asset(ImagePath.girls,
                                    fit: BoxFit.fill),
                      ),
                      InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            controller.pickImage();
                          },
                          child: SvgPicture.asset(
                            ImagePath.camera,
                            height: 50.h,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: Text(
                    controller.username.text.toString().toUpperCase(),
                    style: FontTextStyle.kWhite28W400Roboto
                        .copyWith(fontSize: 25.h),
                  ),
                ),
                TextFormField(
                  controller: controller.username,
                  cursorColor: AppColor.blue,
                  style: FontTextStyle.kWhite16W300Roboto.copyWith(
                      color: Color.fromRGBO(63, 65, 78, 1),
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.offWhite,
                    hintText: "Username",
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
                  controller: controller.email,
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
                /* SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  controller: controller.password,
                  cursorColor: AppColor.blue,
                  style: FontTextStyle.kWhite16W300Roboto.copyWith(
                      color: Color.fromRGBO(63, 65, 78, 1),
                      fontWeight: FontWeight.w400),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.offWhite,
                    hintText: "Password",
                    hintStyle: FontTextStyle.kWhite16W300Roboto
                        .copyWith(color: AppColor.lightPurple),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.h),
                        borderSide: BorderSide.none),
                  ),
                ),*/
                SizedBox(
                  height: 50.h,
                ),
                controller.loader == false
                    ? CommonButton.button(
                        onTap: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus &&
                              currentFocus.focusedChild != null) {
                            currentFocus.focusedChild!.unfocus();
                          }
                          await controller.updateProfileData();
                          Get.back();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Profile Update SuccessFully")));
                        },
                        title: "Save",
                        horPadding: 0)
                    : Center(
                        child:
                            CircularProgressIndicator(color: AppColor.white)),
                SizedBox(
                  height: 30.h,
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        splashRadius: 20,
        icon: Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      title: Text(
        "Edit Profile",
        style: FontTextStyle.kWhite15W500Roboto,
      ),
      actions: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              "Save",
              style: FontTextStyle.kWhite18W600Roboto
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        )
      ],
    );
  }
}
