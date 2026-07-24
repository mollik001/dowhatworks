import 'package:dowhatworks/app/modules/lab/controllers/lab_controller.dart';
import 'package:get/get.dart';

class LabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabController>(() => LabController());
  }
}
