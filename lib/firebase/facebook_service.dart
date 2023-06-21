import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/constant/prefrence_manager.dart';
import 'package:panda_music/view/auth/get_started_screen.dart';

class FaceBookAuthServices {
  static String? fbName;
  static String? fbEmail;
  static String? fbUrl;

  /// FACEBOOK LOGIN WITH FIREBASE
  static facebookLogin() async {
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(facebookCredential);
        final userData = await FacebookAuth.i.getUserData();
        fbName = userData['name'];
        fbEmail = userData['email'];
        fbUrl = userData['url'];
        log(userData.toString());
        log(userData['name']);
        log(userData['email']);
        log(userData['picture']['data']['url']);
        if (userData.isNotEmpty) {
          PreferenceManager.setUid(kFirebaseAuth.currentUser!.uid);
          await FirebaseFirestore.instance
              .collection('user')
              .doc(kFirebaseAuth.currentUser!.uid)
              .set({
            "image": userData['picture']['data']['url'],
            "username": userData['name'],
            "email": userData['email'],
            // "password": password.text
          });
          Get.offAll(GetStartedScreen());
        }
      }
    } catch (error) {
      log('ERROR====>>${error.toString()}');
    }
  }
}
