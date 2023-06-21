import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/hive_model/download_model.dart';
import 'package:panda_music/view/audio_player/audio_player_screen.dart';

import 'download_audio_player.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  Box<DownloadModel>? boxTask;

  @override
  void initState() {
    boxTask = Hive.box<DownloadModel>(AppConstant.downloadBox);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: AppConstant.commonPadding,
        child: ValueListenableBuilder(
          valueListenable: boxTask!.listenable(),
          builder: (context, Box<DownloadModel> value, child) {
            return value.isEmpty
                ? Center(
                    child: Text(
                      'No Data',
                      style: FontTextStyle.kWhite16W400Roboto,
                    ),
                  )
                : ListView.builder(
                    itemCount: value.length,
                    // reverse: true,
                    // shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final key = value.keys.toList()[index];
                      final data = boxTask!.get(key);
                      String _base64 = base64.encode(data!.thumbnail);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 18.h),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.h),
                          onTap: () {
                            Get.to(DownloadAudioPlayerScreen(
                              model: data,
                              songData: data.song,
                              imageThumbnail: data.thumbnail,
                              singerName: data.singer,
                              songName: data.songName,
                              index: index,
                            ));
                            print('index == $index');
                          },
                          child: Container(
                            height: 105.h,
                            width: Get.width,
                            decoration: BoxDecoration(
                              // color: AppColor.white,
                              border: Border.all(color: AppColor.offWhite1),
                              borderRadius: BorderRadius.circular(12.h),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 92.h,
                                      width: 92.h,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius:
                                            BorderRadius.circular(15.h),
                                      ),
                                      child: Image.memory(base64Decode(_base64),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Center(
                                        child: Text(
                                          data.songName,
                                          textAlign: TextAlign.center,
                                          style: FontTextStyle
                                              .kWhite14W500Roboto
                                              .copyWith(height: 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '3:20',
                                          style:
                                              FontTextStyle.kWhite14W500Roboto,
                                        ),
                                        InkWell(
                                          splashFactory: NoSplash.splashFactory,
                                          onTap: () {
                                            boxTask!.delete(key);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.w),
                                            child: SvgPicture.asset(
                                                ImagePath.play),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
        "My Downloads",
        style: FontTextStyle.kWhite15W500Roboto,
      ),
      actions: [
        IconButton(
            onPressed: () {},
            splashRadius: 20,
            icon: Icon(
              Icons.more_vert,
              size: 30.h,
            ))
      ],
    );
  }
}
