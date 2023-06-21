import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstant {
  static EdgeInsetsGeometry commonPadding =
      EdgeInsets.symmetric(horizontal: 20.h);
  static String downloadBox = "DownloadSongBox";
}

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;
