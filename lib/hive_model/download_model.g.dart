// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadModelAdapter extends TypeAdapter<DownloadModel> {
  @override
  final int typeId = 0;

  @override
  DownloadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as Uint8List,
      fields[4] as Uint8List,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.singer)
      ..writeByte(1)
      ..write(obj.songName)
      ..writeByte(2)
      ..write(obj.created)
      ..writeByte(3)
      ..write(obj.song)
      ..writeByte(4)
      ..write(obj.thumbnail)
      ..writeByte(5)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
