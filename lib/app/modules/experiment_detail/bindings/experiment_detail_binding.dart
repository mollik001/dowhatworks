import 'package:dowhatworks/app/modules/experiment_detail/controllers/experiment_detail_controller.dart';
import 'package:get/get.dart';

class ExperimentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExperimentDetailController>(() => ExperimentDetailController());
  }
}
