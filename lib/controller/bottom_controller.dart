import 'package:get/get.dart';

class BottomController extends GetxController {
  int bottomSelected = 0;
  setBottomSelected(value) {
    bottomSelected = value;
    update();
  }
}
