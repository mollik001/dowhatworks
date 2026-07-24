import 'package:dowhatworks/app/modules/custom_protocol/controllers/custom_protocol_controller.dart';
import 'package:get/get.dart';

class CustomProtocolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomProtocolController>(() => CustomProtocolController());
  }
}
