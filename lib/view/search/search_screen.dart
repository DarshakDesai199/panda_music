import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/cache_network_image.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/view/audio_player/audio_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List recentSongList = [];

  getRecentSongUid() async {
    recentSongList = [];
    var data = FirebaseFirestore.instance.collection('trending');
    var info = await data.get();
    info.docs.forEach((element) {
      if (!recentSongList.contains(element.id)) {
        recentSongList.add(element.id);
      }
    });
  }

  TextEditingController search = TextEditingController();
  String searchValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppConstant.commonPadding,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          splashRadius: 15,
                          icon: Icon(Icons.arrow_back_ios,
                              color: AppColor.offWhite),
                        )),
                    Expanded(
                      flex: 10,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(SearchScreen());
                        },
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              searchValue = value;
                            });
                          },
                          controller: search,
                          cursorColor: AppColor.blue,
                          style: FontTextStyle.kWhite16W300Roboto.copyWith(
                              color: Color.fromRGBO(63, 65, 78, 1),
                              fontWeight: FontWeight.w400),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Search song name...",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 8.h),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(14.h),
                              child: SvgPicture.asset(ImagePath.search,
                                  height: 20.h, width: 20.h),
                            ),
                            filled: true,
                            fillColor: AppColor.offWhite,
                            // hintText: "Email address",
                            // hintStyle: FontTextStyle.kWhite16W300Roboto
                            //     .copyWith(color: AppColor.lightPurple),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.h),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('trending')
                    // .where("song_name", isLessThanOrEqualTo: searchValue)
                    .snapshots(),
                builder: (context, recentSnapshot) {
                  if (recentSnapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: recentSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return recentSnapshot.data!.docs[index]['song_name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue)
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 22.h),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15.h),
                                    onTap: () async {
                                      await getRecentSongUid();

                                      Get.to(
                                        AudioPlayerScreen(
                                          songUidList: recentSongList,
                                          uid: recentSnapshot
                                              .data!.docs[index].id,
                                        ),
                                      );
                                    },
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.h)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.h),
                                              child: CachedImage(
                                                  url: recentSnapshot
                                                          .data!.docs[index]
                                                      ['thumbnail']),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            child: Center(
                                              child: Text(
                                                recentSnapshot.data!.docs[index]
                                                    ['song_name'],
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "3:20",
                                                style: FontTextStyle
                                                    .kWhite14W500Roboto,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.w),
                                                child: SvgPicture.asset(
                                                  ImagePath.play,
                                                  height: 25.h,
                                                  width: 25.h,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox();
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
