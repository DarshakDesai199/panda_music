import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/controller/bottom_controller.dart';
import 'package:panda_music/view/favourite/favourite_screen.dart';
import 'package:panda_music/view/home/home_screen.dart';
import 'package:panda_music/view/profile/profile_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  List iconList = [
    ImagePath.home,
    ImagePath.favourite,
    ImagePath.profileRound,
  ];
  List screen = [
    HomeScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];
  BottomController bottomController = Get.put(BottomController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GetBuilder<BottomController>(
        builder: (controller) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              screen[controller.bottomSelected],
              Container(
                height: 70.h,
                width: Get.width,
                decoration: BoxDecoration(
                    // color: AppColor.offWhite.withOpacity(0.3),
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      colors: const [
                        Color.fromRGBO(97, 97, 97, 0.4),
                        Color.fromRGBO(97, 97, 97, 0.1),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                          blurRadius: 20,
                          blurStyle: BlurStyle.inner)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    iconList.length,
                    (index) => InkWell(
                      onTap: () {
                        controller.setBottomSelected(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: SvgPicture.asset(
                          iconList[index],
                          color: controller.bottomSelected == index
                              ? AppColor.purple1
                              : Color.fromRGBO(199, 199, 199, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
