import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/cache_network_image.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/controller/edit_profile_controller.dart';
import 'package:panda_music/view/audio_player/audio_player_screen.dart';
import 'package:panda_music/view/home/album/album_screen.dart';
import 'package:panda_music/view/search/search_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();

  EditProfileController editProfileController =
      Get.put(EditProfileController());

  List trendingSongList = [];
  List recentSongList = [];
  @override
  void initState() {
    editProfileController.getProfileData();
    super.initState();
  }

  getTrendingSongUid() async {
    trendingSongList = [];
    var data = FirebaseFirestore.instance
        .collection('trending')
        .orderBy('created', descending: false);
    var info = await data.get();
    info.docs.forEach((element) {
      if (!trendingSongList.contains(element.id)) {
        trendingSongList.add(element.id);
      }
    });
  }

  getRecentSongUid() async {
    recentSongList = [];
    var data = FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection('recent_song')
        .orderBy("created", descending: true);
    var info = await data.get();
    info.docs.forEach((element) {
      if (!recentSongList.contains(element.id)) {
        recentSongList.add(element.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // List main = [10, 20, 30, 40, 50, 60];
    // print('index of == ${main.indexOf(20)}');
    // print('value of == ${main.elementAt(1)}');

    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: AppConstant.commonPadding,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 35.h),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(SearchScreen());
                    },
                    child: TextFormField(
                      onTap: () {},
                      controller: search,
                      enabled: false,
                      cursorColor: AppColor.blue,
                      style: FontTextStyle.kWhite16W300Roboto.copyWith(
                          color: Color.fromRGBO(63, 65, 78, 1),
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Search song",
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
                titleRow(onTap: () {}, title: "Albums"),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('albums')
                      .orderBy('created', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: SizedBox(
                          height: 95.h,
                          width: Get.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              /*print(
                                  'DAATAA == ${snapshot.data!.docs[index].id}');*/
                              var albumData = snapshot.data!.docs[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15.h),
                                  onTap: () {
                                    Get.to(AlbumSongScreen(
                                      albumName: albumData['album_name'],
                                      albumImage: albumData['thumbnail'],
                                      singerName: albumData['singer_name'],
                                    ));
                                  },
                                  child: Container(
                                    height: 92.h,
                                    width: 92.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.h)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.h),
                                      child: CachedImage(
                                          url: albumData['thumbnail']),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppColor.white,
                      ));
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),

                /// Trending Music

                titleRow(onTap: () {}, title: "Trending"),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('trending')
                      .orderBy("created", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: SizedBox(
                          height: 170.h,
                          width: Get.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var trendingData = snapshot.data!.docs[index];

                              // print(
                              //     'trending id == ${snapshot.data!.docs[index].id}');

                              return Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15.h),
                                  onTap: () async {
                                    await getTrendingSongUid();
                                    Get.to(
                                      AudioPlayerScreen(
                                        songUidList: trendingSongList,
                                        uid: trendingData.id,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 170.h,
                                    width: 130.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.h)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.h),
                                      child: CachedImage(
                                          url: trendingData['thumbnail']),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.white,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),

                /// Recent Song

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: titleRow(onTap: () {}, title: "Recent songs"),
                ),
                SizedBox(
                  height: 20.h,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(kFirebaseAuth.currentUser!.uid)
                      .collection('recent_song')
                      .orderBy("created", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      /// When Recent Song List Is Not Empty .
                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 22.h,
                            );
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('trending')
                                  .snapshots(),
                              builder: (context, recentSnapshot) {
                                if (recentSnapshot.hasData) {
                                  if (snapshot.data!.docs.length > 10) {
                                    var lengthOfDelete =
                                        snapshot.data!.docs.length - 1;
                                    // print('delete == $lengthOfDelete');
                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(kFirebaseAuth.currentUser!.uid)
                                        .collection('recent_song')
                                        .doc(snapshot
                                            .data!.docs[lengthOfDelete].id)
                                        .delete();
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: recentSnapshot.data!.docs.length,
                                    itemBuilder: (context, index1) {
                                      if (snapshot.data!.docs[index].id ==
                                          recentSnapshot
                                              .data!.docs[index1].id) {
                                        return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15.h),
                                          onTap: () async {
                                            await getRecentSongUid();
                                            Get.to(AudioPlayerScreen(
                                              songUidList: recentSongList,
                                              uid:
                                                  snapshot.data!.docs[index].id,
                                            ));
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
                                                        BorderRadius.circular(
                                                            15.h),
                                                    child: CachedImage(
                                                        url: recentSnapshot
                                                                .data!
                                                                .docs[index1]
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
                                                      recentSnapshot.data!
                                                              .docs[index1]
                                                          ['song_name'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: FontTextStyle
                                                          .kWhite14W500Roboto
                                                          .copyWith(
                                                              height: 1.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "3:20",
                                                      style: FontTextStyle
                                                          .kWhite14W500Roboto,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            );
                          },
                        );
                      }

                      /// When Recent Song List is Empty Then Show Trending Song Data.
                      else {
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('trending')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.h),
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 22.h,
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(15.h),
                                      onTap: () async {
                                        await getRecentSongUid();
                                        Get.to(AudioPlayerScreen(
                                          songUidList: trendingSongList,
                                          uid: snapshot.data!.docs[index].id,
                                        ));
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
                                                    url: snapshot
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
                                                  snapshot.data!.docs[index]
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.white,
                                ),
                              );
                            }
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.white,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 85.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector titleRow(
      {required GestureTapCallback onTap, required String title}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: FontTextStyle.kWhite18W600Roboto,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColor.white,
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
