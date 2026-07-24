import 'package:dowhatworks/app/modules/daniel/controllers/daniel_controller.dart';
import 'package:get/get.dart';

class DanielBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DanielController>(() => DanielController());
  }
}
