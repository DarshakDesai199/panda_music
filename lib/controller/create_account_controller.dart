import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_music/constant/app_constant.dart';

class CreateAccountController extends GetxController {
  int buttonSelected = 0;

  setButtonTap(value) {
    buttonSelected = value;
    update();
  }

  bool isCheck = false;
  toggleCheck() {
    isCheck = !isCheck;
    update();
  }

  bool isVisible = true;
  togglePasswordVisible() {
    isVisible = !isVisible;
    update();
  }

  bool isEmail = false;
  setEmailValue(value) {
    isEmail = value;
    update();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      {required BuildContext context, required String title}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  bool isLoading = false;
  setLoading(value) {
    isLoading = value;
    update();
  }
}
