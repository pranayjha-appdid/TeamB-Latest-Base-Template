import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DashBoardController extends GetxController implements GetxService {
  int _dashPage = 0;

  int get dashPage => _dashPage;

  set dashPage(int page) {
    _dashPage = page;
    update();
  }
}
