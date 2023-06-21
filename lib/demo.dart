import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:panda_music/constant/app_constant.dart';

class FilePickers extends StatefulWidget {
  const FilePickers({Key? key}) : super(key: key);

  @override
  State<FilePickers> createState() => _FilePickersState();
}

class _FilePickersState extends State<FilePickers> {
  File? song;
  pickAudio() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.audio);
    if (result == null) {
      print("No file selected");
    } else {
      setState(() {
        song = File(result.files.single.path!);
      });
      addUserData();
      print('Audio pick= = ${result.files.single.name}');
    }
  }

  /// Firebase upload image function

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:$file");

    try {
      var response =
          await FirebaseStorage.instance.ref("song/$filename").putFile(file!);

      var data = await response.storage.ref("song/$filename").getDownloadURL();
      return data;
    } on FirebaseException catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  addAlbum() async {
    await FirebaseFirestore.instance.collection('albums').add({
      "album_name": "MC Stan Album",
      "singer_name": "MC Stan",
      "thumbnail":
          "https://cdn.siasat.com/wp-content/uploads/2022/11/mc-stan-660x495.jpg",
      "created": DateTime.now().toString()
    });
  }

  /// Collection method (set UID)
  Future addUserData() async {
/*    DocumentReference doc =
        FirebaseFirestore.instance.collection('trending').doc();
    await doc.set({
      "created": DateTime.now().toString(),
      "singer": "King (iFeelKing)",
      "song":
          "https://firebasestorage.googleapis.com/v0/b/pandamusic-30591.appspot.com/o/song%2FkkSong1?alt=media&token=727b9492-8427-4ad6-9076-a248e9cd9016",
      "song_name": "KK - yaaron",
      "thumbnail":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/KK_%28125%29.jpg/220px-KK_%28125%29.jpg",
      'docId': doc.id
    }).then((value) {

    });*/

    String? songData = await uploadFile(
        file: song, filename: "MC Stan${Random().nextInt(100)}");
    FirebaseFirestore.instance.collection('trending').add({
      "created": DateTime.now().toString(),
      "singer": "MC Stan",
      "song": songData,
      // "song_name": "Ajnabi - Official Music Video",
      "song_name": "MC STAN - Basti Ka Hasti (Official Audio)",
      "thumbnail": "https://i.ytimg.com/vi/zd1Q512gPkQ/maxresdefault.jpg"
    }).catchError((e) {
      print("ERROR==<<$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            pickAudio();
            // addAlbum();
          },
          child: Text("Upload"),
        ),
      ),
    );
  }
}
