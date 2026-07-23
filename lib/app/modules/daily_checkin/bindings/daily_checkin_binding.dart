import 'package:get/get.dart';
import 'package:dowhatworks/app/modules/daily_checkin/controllers/daily_checkin_controller.dart';

class DailyCheckinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyCheckinController>(() => DailyCheckinController());
  }
}
