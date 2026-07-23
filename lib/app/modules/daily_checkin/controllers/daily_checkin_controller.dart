import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyCheckinController extends GetxController {
  void submitCheckIn() {
    Get.back();
    Get.snackbar(
      'Submitted',
      'Daily check-in saved',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A1A),
      colorText: Colors.white,
    );
  }
}
