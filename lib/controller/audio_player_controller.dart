import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/test1.dart';

class AudioPlayerController extends GetxController {
  /// Song Play/Pause Button Toggle Set

  bool isPause = true;
  togglePause() {
    isPause = !isPause;
    update();
  }

  /// Song Details

  String? songName, singerName, thumbnail, songUrl;
  putValue(
      {required String song,
      required String singer,
      required String image,
      required String url}) {
    songName = song;
    singerName = singer;
    thumbnail = image;
    songUrl = url;
    update();
  }

  /// Audio Player Controller & Function

  AudioPlayer? player;
  Duration duration = Duration();
  Duration position = Duration();

  audioPlay({required String url}) async {
    await player!.play(UrlSource(url));
    // var d = await fetchAudio(
    //     "https://firebasestorage.googleapis.com/v0/b/pandamusic-30591.appspot.com/o/song%2FA.R.Rahman9?alt=media&token=f475260f-cbb2-437b-b97d-4a883f460958");
    // await player!.play(BytesSource(d));
  }

  audioResume() async {
    await player!.resume();
  }

  audioPause() async {
    await player!.pause();
  }

  audioStop() async {
    await player!.stop();
    position = Duration();
    update();
  }

  playerComplete() {
    player!.onPlayerComplete.listen((event) {
      player!.stop();
      update();
    });
  }

  getAudioDuration() {
    player!.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      update();
    });
  }

  getAudioPosition() {
    player!.onPositionChanged.listen((newPosition) {
      position = newPosition;
      update();
    });
  }

  void seekToSecond(int second) {
    Duration duration = Duration(seconds: second);
    player!.seek(duration);
  }

  @override
  void onInit() {
    player = AudioPlayer();
    super.onInit();
  }

  /// Current Index of recent song in List of Song

  int currentSongIndex = 0;
  setCurrentSongIndex({required int index}) {
    currentSongIndex = index;
    update();
  }

  setPreviousNextIndex({required bool previous}) {
    isPause = true;
    if (previous) {
      if (currentSongIndex > 0) {
        currentSongIndex--;
        print('previous---- $currentSongIndex');
      }
    } else {
      currentSongIndex++;
      print('next++++ $currentSongIndex');
    }
    update();
  }

  /// Check-- Song Already Download Or Not.

  bool isDownload = false;
  checkDownload({required String uid}) {
    // print('Enter in checkDownload');
    DocumentReference dbRef = FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection('download')
        .doc(uid);
    dbRef.get().then((value) {
      print('Enter in checkDownload value------------');

      if (value.exists) {
        /// Already download
        isDownload = true;
        update();
      } else {
        /// Not download
        isDownload = false;
        update();
      }
    });
  }

  setDownload(value) {
    isDownload = value;
    update();
  }
}
