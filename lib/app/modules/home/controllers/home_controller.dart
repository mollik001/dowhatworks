import 'package:get/get.dart';

class HomeController extends GetxController {
  final counter = 0.obs;

  void increment() {
    counter.value++;
  }

  @override
  void onInit() {
    super.onInit();
    ever(counter, (_) => update(['counter']));
  }
}
