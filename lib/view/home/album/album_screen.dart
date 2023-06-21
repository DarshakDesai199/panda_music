import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/cache_network_image.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/view/audio_player/audio_player_screen.dart';

import '../../../constant/font_style.dart';

class AlbumSongScreen extends StatefulWidget {
  final String albumImage, albumName, singerName;
  const AlbumSongScreen(
      {Key? key,
      required this.albumImage,
      required this.albumName,
      required this.singerName})
      : super(key: key);

  @override
  State<AlbumSongScreen> createState() => _AlbumSongScreenState();
}

class _AlbumSongScreenState extends State<AlbumSongScreen> {
  List albumSongList = [];
  getSongUid() async {
    albumSongList = [];
    var data = FirebaseFirestore.instance
        .collection('trending')
        .where("singer", isEqualTo: widget.singerName);
    var info = await data.get();
    info.docs.forEach((element) {
      if (!albumSongList.contains(element.id)) {
        albumSongList.add(element.id);
      }
    });
    // print('info.docs.length == ${info.docs.length}');
    // print('song uid == ${albumSongList}');
    // print('song uid length== ${albumSongList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 200.h,
                            width: 185.w,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                    spreadRadius: 10),
                              ],
                              borderRadius: BorderRadius.circular(15.h),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.h),
                                child: CachedImage(
                                  url: widget.albumImage,
                                )),
                          ),
                          Column(
                            children: [
                              Text(
                                "${widget.albumName} \n",
                                style: FontTextStyle.kWhite16W600Roboto,
                              ),
                              Text(
                                "${widget.singerName} \n",
                                style: FontTextStyle.kWhite14W400Roboto,
                              ),
                              Text(
                                "Length - 3:10 mins",
                                style: FontTextStyle.kWhite12W300Roboto,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('trending')
                      .where("singer", isEqualTo: widget.singerName)
                      // .orderBy("created", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: AppConstant.commonPadding,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 18.h),
                              child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                borderRadius: BorderRadius.circular(12.h),
                                onTap: () async {
                                  await getSongUid();
                                  Get.to(AudioPlayerScreen(
                                    uid: data.id,
                                    songUidList: albumSongList,
                                  ));
                                },
                                child: Container(
                                  height: 105.h,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    // color: AppColor.white,
                                    border:
                                        Border.all(color: AppColor.offWhite1),
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
                                            decoration: BoxDecoration(
                                              color: AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(15.h),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.h),
                                                child: CachedImage(
                                                  url: data['thumbnail'],
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                              data['song_name'],
                                              textAlign: TextAlign.center,
                                              style: FontTextStyle
                                                  .kWhite14W500Roboto,
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
                                                style: FontTextStyle
                                                    .kWhite14W500Roboto,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.w),
                                                child: SvgPicture.asset(
                                                    ImagePath.play),
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
                        ),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppColor.white,
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ));
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
        "Album",
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
