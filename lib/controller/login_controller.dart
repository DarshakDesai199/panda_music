import 'package:get/get.dart';

class LoginController extends GetxController {
  int buttonSelected = 0;

  setButtonTap(value) {
    buttonSelected = value;
    update();
  }

  bool isEmail = false;
  setEmailValue(value) {
    isEmail = value;
    update();
  }

  bool isVisible = true;
  togglePasswordVisible() {
    isVisible = !isVisible;
    update();
  }

  bool isLoading = false;
  setLoading(value) {
    isLoading = value;
    update();
  }
}
