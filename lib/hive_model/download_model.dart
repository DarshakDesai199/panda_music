import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
part 'download_model.g.dart';

// $ flutter packages pub run build_runner build

@HiveType(typeId: 0)
class DownloadModel {
  @HiveField(0)
  final String singer;
  @HiveField(1)
  final String songName;
  @HiveField(2)
  final String created;
  @HiveField(3)
  final Uint8List song;
  @HiveField(4)
  final Uint8List thumbnail;
  @HiveField(5)
  final String uid;

  DownloadModel(this.singer, this.songName, this.created, this.song,
      this.thumbnail, this.uid);
}
