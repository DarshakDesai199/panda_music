import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/cache_network_image.dart';
import 'package:panda_music/constant/file_to_uint8list.dart';
import 'package:panda_music/constant/font_style.dart';
import 'package:panda_music/constant/image_path.dart';
import 'package:panda_music/controller/audio_player_controller.dart';
import 'package:panda_music/hive_model/download_model.dart';
import 'package:panda_music/test1.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String uid;
  final List songUidList;
  const AudioPlayerScreen({
    Key? key,
    required this.uid,
    required this.songUidList,
  }) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  /// Get Song Data From Firebase & Play Music.
  getMusicData({required uid}) async {
    print('UID === $uid');
    var data = FirebaseFirestore.instance.collection('trending');
    var info = await data.get();

    for (var element in info.docs) {
      if (element.id == uid) {
        /// Song Play Function.
        audioPlayerController.audioPlay(url: element['song']);
        audioPlayerController.putValue(
            song: element['song_name'],
            singer: element['singer'],
            url: element['song'],
            image: element['thumbnail']);
      }
    }
  }

  /// Current Play Song Add In Recent Song List.
  recentSong({required uid}) {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection('recent_song')
        .doc(uid);
    doc.set({
      'created': DateTime.now().toString(),
      'uid': doc.id,
    });
  }

  AudioPlayerController audioPlayerController =
      Get.put(AudioPlayerController());
  Box<DownloadModel>? boxTask;

  @override
  void initState() {
    boxTask = Hive.box<DownloadModel>(AppConstant.downloadBox);
    getHiveData();
    getMusicData(uid: widget.uid);
    recentSong(uid: widget.uid);
    getCurrentSongIndex();
    audioPlayerController.playerComplete();
    audioPlayerController.getAudioDuration();
    audioPlayerController.getAudioPosition();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayerController.audioStop();
    audioPlayerController.player!.release();
    super.dispose();
  }

  /// Check Song Available in Hive Download List.
  getHiveData() {
    print('----------------- ENTER IN getHiveData ');
    print('');
    if (boxTask!.values.isNotEmpty) {
      boxTask!.values.forEach(
        (element) {
          print('Song Uid === ${element.uid}');
          if (element.uid == widget.uid) {
            print('------------------- UID MATCH ---------------');
            audioPlayerController.setDownload(true);
          } else {
            print('Nope! Not Match...........');
          }
        },
      );
    }
  }

  getCurrentSongIndex() {
    if (widget.songUidList.isNotEmpty) {
      audioPlayerController.setCurrentSongIndex(
          index: widget.songUidList.indexOf(widget.uid));
    }
    // print('getCurrentSongIndex == ${widget.songUidList.indexOf(widget.uid)}');
    print(
        'audioPlayerController CurrentSongIndex == ${audioPlayerController.currentSongIndex}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: GetBuilder<AudioPlayerController>(
        builder: (controller) {
          return controller.thumbnail == null
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColor.white,
                ))
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
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
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.h),
                                          child: CachedImage(
                                            url: controller.thumbnail!,
                                          )),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${controller.songName!}\n",
                                          style:
                                              FontTextStyle.kWhite16W600Roboto,
                                        ),
                                        Text(
                                          "${controller.singerName!}\n",
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
                          Text(
                            "Switch to video music",
                            style: FontTextStyle.kWhite15W500Roboto,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 22.h, horizontal: 25.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Favourite Button

                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(kFirebaseAuth.currentUser!.uid)
                                      .collection('favourite')
                                      .where('uid', isEqualTo: widget.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        onTap: () {
                                          print('Tap on favourite');

                                          /// Check-- Song Already In Favourite Collection Or Not.
                                          DocumentReference dbRef =
                                              FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(kFirebaseAuth
                                                      .currentUser!.uid)
                                                  .collection('favourite')
                                                  .doc(widget.uid);
                                          dbRef.get().then((value) {
                                            if (value.exists) {
                                              /// Song Already In Favourite Then Remove From Favourite Collection.
                                              FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(kFirebaseAuth
                                                      .currentUser!.uid)
                                                  .collection('favourite')
                                                  .doc(widget.uid)
                                                  .delete();
                                              print(
                                                  '------------------Already In favourite');
                                            } else {
                                              /// Song Added In Favourite Collection Of Firebase.
                                              FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(kFirebaseAuth
                                                      .currentUser!.uid)
                                                  .collection('favourite')
                                                  .doc(widget.uid)
                                                  .set({
                                                "created":
                                                    DateTime.now().toString(),
                                                'uid': widget.uid
                                              }).catchError((e) {
                                                print('Favourite error == $e');
                                              });
                                              print(
                                                  '------------------Added In favourite');
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: SvgPicture.asset(
                                              ImagePath.favourite,
                                              color: snapshot.data!.docs.isEmpty
                                                  ? AppColor.offWhite1
                                                  : Colors.red),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                          child: SvgPicture.asset(
                                              ImagePath.favourite,
                                              color: AppColor.offWhite1));
                                    }
                                  },
                                ),

                                ///Download Button
                                controller.isDownload
                                    ? SizedBox()
                                    : InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        onTap: () async {
                                          print('Tap on Download');

                                          /// Download variable true
                                          controller.setDownload(true);

                                          /// Song Url & Thumbnail Convert Into UInt8list Cause of Adding In Hive Local Database.
                                          var thumbnailData = await fetchAudio(
                                              controller.thumbnail!);
                                          var songData = await fetchAudio(
                                              controller.songUrl!);
                                          // print(
                                          //     'thumbnailData == $thumbnailData');
                                          // print('songData == $songData');
                                          if (thumbnailData.isNotEmpty &&
                                              songData.isNotEmpty) {
                                            /// Data Added in Hive Model.
                                            DownloadModel model = DownloadModel(
                                                controller.singerName!,
                                                controller.songName!,
                                                DateTime.now().toString(),
                                                songData,
                                                thumbnailData,
                                                widget.uid);

                                            boxTask!.add(model).then((value) {
                                              /// Snackbar
                                              Get.snackbar(
                                                  "${controller.songName}",
                                                  "Download Complete",
                                                  colorText: AppColor.white);
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 22.w),
                                          child: SvgPicture.asset(
                                              ImagePath.download),
                                        ),
                                      ),

                                /// MP4
                                InkWell(
                                  onTap: () {},
                                  child: Center(
                                    child: SvgPicture.asset(ImagePath.mp4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          musicControlPanel(controller),
                          songProgress(context, controller),
                          SizedBox(
                            height: 60.h,
                          )
                        ],
                      ),
                    ),
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

  Widget songProgress(BuildContext context, AudioPlayerController controller) {
    var style = TextStyle(color: Colors.white);
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(controller.position),
          style: style,
        ),

        /// Song Slider
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

  Padding musicControlPanel(AudioPlayerController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// Previous Music Button
          controller.currentSongIndex != 0
              ? InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    print('Tap on previous button');
                    if (controller.currentSongIndex > 0) {
                      controller.setPreviousNextIndex(previous: true);
                      var uid = widget.songUidList
                          .elementAt(controller.currentSongIndex);

                      getMusicData(uid: uid);
                      recentSong(uid: uid);
                    }
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

          /// Music Play\Pause Button
          InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                controller.togglePause();
                if (controller.isPause) {
                  /// Resume
                  controller.audioResume();
                  print('resume');
                } else {
                  /// Pause
                  controller.audioPause();
                  print('pause');
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
              )),

          /// Next Music Button
          widget.songUidList.length - 1 == controller.currentSongIndex
              ? SizedBox()
              : InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    print('Tap on Next Button');
                    if (widget.songUidList.length - 1 >
                        controller.currentSongIndex) {
                      controller.setPreviousNextIndex(previous: false);
                      var uid = widget.songUidList
                          .elementAt(controller.currentSongIndex);
                      getMusicData(uid: uid);
                      recentSong(uid: uid);
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

// InkWell(
//     onTap: () {},
//     child: SvgPicture.asset(
//       ImagePath.musicDoubleForward,
//       height: 17.h,
//       width: 25.w,
//       fit: BoxFit.fill,
//     )),

// InkWell(
//   onTap: () {},
//   child: SvgPicture.asset(
//     ImagePath.musicDoubleBack,
//     height: 17.h,
//     width: 25.w,
//     fit: BoxFit.fill,
//   ),
// ),
