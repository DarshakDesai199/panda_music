import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/hive_model/download_model.dart';

import '../../controller/download_controller.dart';

class DownloadAudioPlayerScreen extends StatefulWidget {
  final Uint8List imageThumbnail;
  final Uint8List songData;
  final String songName, singerName;
  final DownloadModel model;
  final int index;
  const DownloadAudioPlayerScreen({
    Key? key,
    required this.imageThumbnail,
    required this.songData,
    required this.songName,
    required this.singerName,
    required this.model,
    required this.index,
  }) : super(key: key);

  @override
  State<DownloadAudioPlayerScreen> createState() =>
      _DownloadAudioPlayerScreenState();
}

class _DownloadAudioPlayerScreenState extends State<DownloadAudioPlayerScreen> {
  DownloadController audioPlayerController = Get.put(DownloadController());
  Box<DownloadModel>? boxTask;

  @override
  void initState() {
    boxTask = Hive.box<DownloadModel>(AppConstant.downloadBox);
    audioPlayerController.audioPlay(data: widget.songData);
    audioPlayerController.setCurrentIndex(widget.index);
/*    audioPlayerController.putValue(
        image: widget.imageThumbnail,
        singer: widget.singerName,
        song: widget.songName);*/
    audioPlayerController.playerComplete();
    audioPlayerController.getAudioDuration();
    audioPlayerController.getAudioPosition();
    audioPlayerController.fileConvert(imageInUnit8List: widget.imageThumbnail);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayerController.audioStop();
    audioPlayerController.player!.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Name ${widget.songName}');
    print('singerName ${widget.singerName}');
    return Scaffold(
      appBar: buildAppBar(),
      body: GetBuilder<DownloadController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ValueListenableBuilder(
                    valueListenable: boxTask!.listenable(),
                    builder: (context, Box<DownloadModel> value, child) {
                      // print(
                      //     'controllercurrentindex === ${controller.currentIndex}');
                      final key = value.keys.toList()[controller.currentIndex];
                      final data = boxTask!.get(key);
                      String _base64 = base64.encode(data!.thumbnail);
                      return Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 50.h),
                              child: Container(
                                height: 410.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        offset: Offset(0, 4),
                                        blurRadius: 10,
                                        spreadRadius: 2),
                                  ],
                                  gradient: LinearGradient(
                                    colors: const [
                                      Color.fromRGBO(27, 5, 78, 0.32),
                                      Color.fromRGBO(118, 118, 118, 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25.h),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 200.h,
                                      width: 185.w,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.25),
                                              offset: Offset(2, 2),
                                              blurRadius: 10,
                                              spreadRadius: 10),
                                        ],

                                        borderRadius:
                                            BorderRadius.circular(15.h),
                                      ),
                                      child: controller.thumbnailFile == null
                                          ? SizedBox()
                                          : Image.file(
                                              controller.thumbnailFile!,
                                              fit: BoxFit.fill),
                                      // child: Image.memory(base64Decode(_base64),
                                      //     fit: BoxFit.fill),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${data.songName}\n",
                                          style:
                                              FontTextStyle.kWhite16W600Roboto,
                                        ),
                                        Text(
                                          "${data.singer}\n",
                                          style:
                                              FontTextStyle.kWhite14W400Roboto,
                                        ),
                                        Text(
                                          "Length - 3:10 mins",
                                          style:
                                              FontTextStyle.kWhite12W300Roboto,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          musicControlPanel(
                              controller: controller,
                              songData: data.song,
                              length: value.length,
                              data: value.keys.toList()),
                          songProgress(context, controller),
                          SizedBox(
                            height: 60.h,
                          )
                        ],
                      );
                    },
                  )),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format =
        "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
    return format;
  }

  Widget songProgress(BuildContext context, DownloadController controller) {
    var style = TextStyle(color: Colors.white);
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(controller.position),
          style: style,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Colors.amberAccent,
                  overlayColor: Colors.amber,
                  thumbShape: const RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Colors.amberAccent,
                  inactiveTrackColor: Colors.grey,
                ),
                child: Slider(
                  value: controller.position.inSeconds.toDouble(),
                  max: controller.duration.inSeconds.toDouble() + 2,
                  onChanged: (value) {
                    controller.seekToSecond(value.toInt());
                    value = value;
                  },
                  onChangeEnd: (value) {},
                )),
          ),
        ),
        Text(
          _formatDuration(controller.duration),
          style: style,
        ),
      ],
    );
  }

  Padding musicControlPanel(
      {required DownloadController controller,
      required Uint8List songData,
      required int length,
      required List data}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Previous Music Button

          controller.currentIndex != 0
              ? InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    if (controller.currentIndex > 0) {
                      controller.setPreviousNextIndex(previous: true);
                      final keys = data[controller.currentIndex];
                      final data1 = boxTask!.get(keys);
                      // print('song === ${data1!.song}');
                      controller.audioPlay(data: data1!.song);
                      controller.fileConvert(imageInUnit8List: data1.thumbnail);
                    }
                    print('Tap on previous button');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ImagePath.musicBack,
                      height: 16.h,
                      width: 16.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : SizedBox(),

          // InkWell(
          //   onTap: () {},
          //   child: SvgPicture.asset(
          //     ImagePath.musicDoubleBack,
          //     height: 17.h,
          //     width: 25.w,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          /// Music Play\Pause Button

          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              controller.togglePause();
              if (controller.isPause) {
                print('resume');
                controller.audioResume();
              } else {
                print('pause');
                controller.audioPause();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: !controller.isPause
                  ? SvgPicture.asset(
                      ImagePath.musicPlay,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.fill,
                    )
                  : SvgPicture.asset(
                      ImagePath.pause,
                      height: 24.h,
                      width: 24.h,
                      color: AppColor.white,
                      fit: BoxFit.fill,
                    ),
            ),
          ),

          // InkWell(
          //     onTap: () {},
          //     child: SvgPicture.asset(
          //       ImagePath.musicDoubleForward,
          //       height: 17.h,
          //       width: 25.w,
          //       fit: BoxFit.fill,
          //     )),
          /// Next Music Button

          length - 1 == controller.currentIndex
              ? SizedBox()
              : InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    if (length - 1 > controller.currentIndex) {
                      controller.setPreviousNextIndex(previous: false);
                      final keys = data[controller.currentIndex];
                      final data1 = boxTask!.get(keys);
                      // print('song === ${data1!.song}');
                      controller.audioPlay(data: data1!.song);
                      controller.fileConvert(imageInUnit8List: data1.thumbnail);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ImagePath.musicForward,
                      height: 16.h,
                      width: 16.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ],
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SvgPicture.asset(
              ImagePath.logo,
              width: 60.h,
              height: 60.h,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'PANDA',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          splashRadius: 20,
          icon: Icon(
            Icons.more_vert,
            size: 30.h,
          ),
        )
      ],
    );
  }
}
