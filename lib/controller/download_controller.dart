import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController {
  /// Song Play/Pause Button Toggle Set

  bool isPause = true;
  togglePause() {
    isPause = !isPause;
    update();
  }

  /// Song Current Index
  int currentIndex = 0;
  setCurrentIndex(value) {
    currentIndex = value;
    print('Current Index === $currentIndex');
    update();
  }

  /// Song Details

  /*String? songName, singerName;
  Uint8List? thumbnail;
  putValue({
    required String song,
    required String singer,
    required Uint8List image,
  }) {
    thumbnail = null;
    songName = song;
    singerName = singer;
    thumbnail = image;
    update();
  }
*/
  /// Audio Player Controller & Function

  AudioPlayer? player;
  Duration duration = Duration();
  Duration position = Duration();

  audioPlay({required Uint8List data}) async {
    // await player!.play(UrlSource(url));
    await player!.play(BytesSource(data));
    // update();
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

  /// Hive Uint8List Song Thumbnail Data Convert Into File

  File? thumbnailFile;
  fileConvert({required Uint8List imageInUnit8List}) async {
    thumbnailFile = null;
    // Uint8List? imageInUnit8List; // store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    thumbnailFile = await File(
            '${tempDir.path}/image${Random().nextInt(1000).toString()}.png')
        .create();
    thumbnailFile!.writeAsBytesSync(imageInUnit8List);
    update();
    return thumbnailFile;
  }

  setPreviousNextIndex({required bool previous}) {
    isPause = true;
    if (previous) {
      if (currentIndex > 0) {
        currentIndex--;
        print('previous---- $currentIndex');
      }
    } else {
      currentIndex++;
      print('next++++ $currentIndex');
    }
    update();
  }
}
