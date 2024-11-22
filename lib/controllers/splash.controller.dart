import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:capop_new/views/principal.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(seconds: 2), () {
      Get.to(() => Principal(),
          transition: Transition.zoom, duration: Duration(seconds: 2));
    });
  }
}
