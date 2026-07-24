import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomProtocolController extends GetxController {
  final selectedStep = 0.obs;
  final hypothesisController = TextEditingController(
    text: 'If I remove social media after 8PM, then my sleep quality and morning clarity will improve.',
  );
  final selectedMetrics = <String>{};
  final actionController = TextEditingController(
    text: 'Do not open any social media apps after 8:00 PM.',
  );
  final duration = '7 days'.obs;

  void toggleMetric(String metric) {
    if (selectedMetrics.contains(metric)) {
      selectedMetrics.remove(metric);
    } else {
      selectedMetrics.add(metric);
    }
    update(['metrics']);
  }

  void setDuration(String value) {
    duration.value = value;
  }

  void reset() {
    selectedStep.value = 0;
    hypothesisController.text = 'If I remove social media after 8PM, then my sleep quality and morning clarity will improve.';
    selectedMetrics.clear();
    actionController.text = 'Do not open any social media apps after 8:00 PM.';
    duration.value = '7 days';
    update(['metrics']);
  }
}
