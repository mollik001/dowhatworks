import 'package:get/get.dart';
import '../modules/home/controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
