import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/values/constants.dart';
import '../../../data/services/storage_service.dart';

class HomeController extends GetxController {
  // Loading state
  final isLoading = true.obs;

  // Today's check-in
  final hasCheckedInToday = false.obs;
  final sleepValue = Rxn<double>();
  final focusValue = Rxn<double>();

  // History
  final totalLogs = 0.obs;

  // Date display
  final dayLabel = ''.obs; // e.g. "Wednesday"

  @override
  void onInit() {
    super.onInit();
    _computeDayLabel();
    fetchData();
  }

  void _computeDayLabel() {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    final now = DateTime.now();
    // DateTime.weekday: 1=Monday … 7=Sunday
    dayLabel.value = days[now.weekday - 1];
  }

  Future<void> fetchData() async {
    final token = StorageService.getAccessToken();
    if (token == null || token.isEmpty) return;

    try {
      isLoading.value = true;

      // Fire both requests in parallel
      final results = await Future.wait([
        ApiClient.get(ApiConstants.dailyCheckin, token: token),
        ApiClient.get('${ApiConstants.dailyCheckin}?history=true', token: token),
      ]);

      final todayResponse   = results[0];
      final historyResponse = results[1];

      print('[Home] Today: $todayResponse');
      print('[Home] History: $historyResponse');

      // Today's check-in
      hasCheckedInToday.value = todayResponse['has_checked_in_today'] == true;
      final checkin = todayResponse['checkin'];
      if (checkin is Map) {
        sleepValue.value = (checkin['sleep'] as num?)?.toDouble();
        focusValue.value = (checkin['focus'] as num?)?.toDouble();
      }

      // Total logs = number of entries in history
      final history = historyResponse['data'];
      if (history is List) {
        totalLogs.value = history.length;
      } else if (historyResponse is List) {
        // In case the API returns the array directly (wrapped by ApiClient as {'data': [...]})
        totalLogs.value = (historyResponse['data'] as List?)?.length ?? 0;
      }
    } catch (e) {
      print('[Home] Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Called after a successful daily check-in so the UI refreshes.
  void onCheckinSubmitted() {
    fetchData();
  }

  String formatMetric(double? value) {
    if (value == null) return '-';
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
