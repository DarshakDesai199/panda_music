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
import 'package:panda_music/view/audio_player/audio_player_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List favouriteSongList = [];
  getSongUid() async {
    favouriteSongList = [];
    var data = FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection('favourite')
        .orderBy("created", descending: true);
    var info = await data.get();
    info.docs.forEach((element) {
      if (!favouriteSongList.contains(element.id)) {
        favouriteSongList.add(element.id);
      }
    });
    print('info.docs.length == ${info.docs.length}');
    print('song uid == ${favouriteSongList}');
    print('song uid length== ${favouriteSongList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(kFirebaseAuth.currentUser!.uid)
            .collection('favourite')
            .orderBy("created", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(bottom: 70.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No Data',
                            style: FontTextStyle.kWhite16W400Roboto,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('trending')
                            .snapshots(),
                        builder: (context, musicSnapshot) {
                          if (musicSnapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: musicSnapshot.data!.docs.length,
                              itemBuilder: (context, index1) {
                                if (snapshot.data!.docs[index].id ==
                                    musicSnapshot.data!.docs[index1].id) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: index ==
                                                snapshot.data!.docs.length - 1
                                            ? 85.h
                                            : 18.h,
                                        right: 20.w,
                                        left: 20.w),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.h),
                                      onTap: () async {
                                        await getSongUid();

                                        Get.to(
                                          AudioPlayerScreen(
                                              songUidList: favouriteSongList,
                                              uid: snapshot
                                                  .data!.docs[index].id),
                                        );
                                      },
                                      child: Container(
                                        height: 105.h,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          // color: AppColor.white,
                                          border: Border.all(
                                              color: AppColor.offWhite1),
                                          borderRadius:
                                              BorderRadius.circular(12.h),
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
                                                        BorderRadius.circular(
                                                            15.h),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.h),
                                                      child: CachedImage(
                                                        url: musicSnapshot.data!
                                                                .docs[index1]
                                                            ['thumbnail'],
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Text(
                                                    musicSnapshot
                                                            .data!.docs[index1]
                                                        ['song_name'],
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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '3:20',
                                                      style: FontTextStyle
                                                          .kWhite14W500Roboto,
                                                    ),
                                                    Column(
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user')
                                                              .doc(kFirebaseAuth
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'favourite')
                                                              .where(
                                                                'uid',
                                                                isEqualTo:
                                                                    musicSnapshot
                                                                        .data!
                                                                        .docs[
                                                                            index1]
                                                                        .id,
                                                              )
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return InkWell(
                                                                splashFactory:
                                                                    NoSplash
                                                                        .splashFactory,
                                                                onTap: () {
                                                                  print(
                                                                      'Tap on favourite');

                                                                  DocumentReference dbRef = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'user')
                                                                      .doc(kFirebaseAuth
                                                                          .currentUser!
                                                                          .uid)
                                                                      .collection(
                                                                          'favourite')
                                                                      .doc(musicSnapshot
                                                                          .data!
                                                                          .docs[
                                                                              index1]
                                                                          .id);
                                                                  dbRef
                                                                      .get()
                                                                      .then(
                                                                    (value) {
                                                                      if (value
                                                                          .exists) {
                                                                        print(
                                                                            'Already In favourite');
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('user')
                                                                            .doc(kFirebaseAuth.currentUser!.uid)
                                                                            .collection('favourite')
                                                                            .doc(musicSnapshot.data!.docs[index1].id)
                                                                            .delete();
                                                                      } else {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('user')
                                                                            .doc(kFirebaseAuth.currentUser!.uid)
                                                                            .collection('favourite')
                                                                            .doc(musicSnapshot.data!.docs[index1].id)
                                                                            .set(
                                                                          {
                                                                            "created":
                                                                                DateTime.now().toString(),
                                                                            'uid':
                                                                                musicSnapshot.data!.docs[index1].id
                                                                          },
                                                                        ).catchError(
                                                                          (e) {
                                                                            print('Favourite error == $e');
                                                                          },
                                                                        );
                                                                      }
                                                                    },
                                                                  );
                                                                },
                                                                child: Center(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    ImagePath
                                                                        .favourite,
                                                                    color: snapshot
                                                                            .data!
                                                                            .docs
                                                                            .isEmpty
                                                                        ? AppColor
                                                                            .offWhite1
                                                                        : Colors
                                                                            .red,
                                                                    height:
                                                                        28.h,
                                                                    width: 28.h,
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return Center(
                                                                child: SvgPicture.asset(
                                                                    ImagePath
                                                                        .favourite,
                                                                    color: AppColor
                                                                        .offWhite1),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
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
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: AppColor.white,
            ));
          }
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      /* leading: IconButton(
        onPressed: () {},
        splashRadius: 20,
        icon: Icon(Icons.arrow_back),
      ),*/
      centerTitle: true,
      title: Text(
        "Favorite",
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
