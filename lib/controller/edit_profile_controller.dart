import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/prefrence_manager.dart';

class EditProfileController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String profileImage = '';

  File? image;
  pickImage() async {
    image = null;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result == null) {
      print("No file selected");
    } else {
      image = File(result.files.single.path!);
      update();
    }
  }

  getProfileData() async {
    var data = await FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .get();
    Map<String, dynamic>? info = data.data();
    username.text = info!['username'];
    email.text = info['email'];
    profileImage = info['image'];
    update();
  }

  /// Firebase upload image function

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:$file");

    try {
      var response = await FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file!);

      var data =
          await response.storage.ref("user_image/$filename").getDownloadURL();
      return data;
    } on FirebaseException catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  /// Update profile
  bool loader = false;
  updateProfileData() async {
    loader = true;
    update();
    String? imageData = image != null
        ? await uploadFile(
            file: image, filename: kFirebaseAuth.currentUser!.email)
        : profileImage;
    FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .update({
      "image": imageData,
      "email": email.text,
      "username": username.text
    }).then((value) {
      loader = false;
      update();
    });
    getProfileData();
    image = null;
    update();
  }
}
