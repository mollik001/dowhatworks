import 'package:dowhatworks/app/modules/experiment_detail/controllers/experiment_detail_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/custom_navbar.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/data/models/experiment_models.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// =============================================================================
// MAIN VIEW
// =============================================================================

class ExperimentDetailView extends GetView<ExperimentDetailController> {
  const ExperimentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1,
                  colors: [
                    const Color(0xFF1B110D),
                    const Color(0xFF1B110D).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF8A5B),
                    strokeWidth: 2,
                  ),
                );
              }
              final d = controller.detail.value;
              if (d == null) {
                return Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildContent(d),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onItemTap: (index) {
          if (index == 0) Get.offNamed(AppRoutes.home);
          else if (index == 1) Get.offNamed(AppRoutes.daniel);
          else if (index == 2) Get.offNamed(AppRoutes.lab);
          else if (index == 3) Get.offNamed(AppRoutes.results);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Image.asset('assets/icons/top_logo.png', width: 32.w, height: 32.w),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DoWhatWorks',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 1.5)),
              Text('ANALYSIS',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      height: 1.5,
                      letterSpacing: 1.5)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profile),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF843D23), width: 1.5),
                color: const Color(0xFF3A1E14),
              ),
              child: Center(
                child: Obx(() => Text(
                      UserService.to.initial,
                      style: TextStyle(
                          color: const Color(0xFFFF8A5B),
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ExperimentDetail d) {
    final elapsed = d.elapsedDays;
    final completionPct = d.durationDays > 0
        ? ((elapsed / d.durationDays) * 100).clamp(0, 100).toStringAsFixed(0)
        : '0';
    final progressFraction =
        d.durationDays > 0 ? (elapsed / d.durationDays).clamp(0.0, 1.0) : 0.0;
    final streak = d.completedLogs;
    final avgMetric = d.avgMetricValue;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + delete row
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back,
                        color: Colors.white.withValues(alpha: 0.55),
                        size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Results',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp)),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF612020), width: 1),
                  color: const Color(0xFF231111),
                ),
                child: GestureDetector(
                  onTap: () => controller.deleteExperiment(),
                  child: Icon(Icons.delete_forever,
                      color: const Color(0xFFF87171), size: 18.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999.r),
              border: Border.all(
                  color: d.isActive
                      ? const Color(0xFF184E3B)
                      : const Color(0xFF534877),
                  width: 1),
              color: d.isActive
                  ? const Color(0xFF0E1E18)
                  : const Color(0xFF272431),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: d.isActive
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFFC4B5FD),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  d.isActive ? 'Active' : 'Queued',
                  style: TextStyle(
                      color: d.isActive
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFFC4B5FD),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      letterSpacing: 0.25),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Hypothesis
          Text(
            '"${d.hypothesis}"',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 22.sp,
                height: 1.35,
                letterSpacing: -0.5),
          ),
          SizedBox(height: 16.h),

          // Start date + metric row
          Row(
            children: [
              Icon(Icons.calendar_today,
                  color: Colors.white.withValues(alpha: 0.5), size: 14.sp),
              SizedBox(width: 6.w),
              Text(
                d.startDate != null ? 'Started ${d.startDate}' : 'Not started',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp),
              ),
              SizedBox(width: 12.w),
              Icon(Icons.track_changes,
                  color: Colors.white.withValues(alpha: 0.5), size: 14.sp),
              SizedBox(width: 6.w),
              Text(
                d.metric,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Stat cards row 1
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'DURATION',
                  value: '$elapsed',
                  suffix: '/ ${d.durationDays} days',
                  valueColor: Colors.white,
                  suffixColor: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  label: 'COMPLETION',
                  value: '$completionPct%',
                  suffix: '',
                  valueColor: const Color(0xFF34D399),
                  suffixColor: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Stat cards row 2
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: d.metric.toUpperCase(),
                  value: avgMetric > 0 ? avgMetric.toStringAsFixed(1) : '—',
                  suffix: '',
                  valueColor: Colors.white,
                  suffixColor: Colors.transparent,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  label: 'STREAK',
                  value: '$streak',
                  suffix: '',
                  valueColor: Colors.white,
                  suffixColor: Colors.transparent,
                  showFire: streak > 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Metric trends chart
          _MetricTrendsCard(
            logs: d.logs,
            metric: d.metric,
            startDate: d.startDate,
            durationDays: d.durationDays,
          ),
          SizedBox(height: 24.h),

          // Progress bar card
          _ProgressCard(
            elapsed: elapsed,
            durationDays: d.durationDays,
            progressFraction: progressFraction,
          ),
          SizedBox(height: 24.h),

          // Today's protocol card
          _TodaysProtocolCard(action: d.action),
          SizedBox(height: 16.h),

          // Log Today button
          _LogTodayButton(controller: controller),
          SizedBox(height: 24.h),

          // Logs section
          if (d.logs.isNotEmpty) ...[
            _LogsSection(logs: d.logs, metric: d.metric),
            SizedBox(height: 24.h),
          ],

          // AI Analysis
          if (d.aiAnalysis != null && d.aiAnalysis!.isNotEmpty) ...[
            _AiAnalysisCard(analysis: d.aiAnalysis!),
            SizedBox(height: 24.h),
          ],

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// =============================================================================
// STAT CARD
// =============================================================================

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final Color valueColor;
  final Color suffixColor;
  final bool showFire;

  const _StatCard({
    required this.label,
    required this.value,
    required this.suffix,
    required this.valueColor,
    required this.suffixColor,
    this.showFire = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                fontSize: 9.sp,
                letterSpacing: 0.45),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: valueColor,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 24.sp,
                    height: 1.2),
              ),
              if (showFire) ...[
                SizedBox(width: 4.w),
                Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 18.sp),
              ],
              if (suffix.isNotEmpty) ...[
                SizedBox(width: 4.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Text(
                    suffix,
                    style: TextStyle(
                        color: suffixColor,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PROGRESS CARD
// =============================================================================

class _ProgressCard extends StatelessWidget {
  final int elapsed;
  final int durationDays;
  final double progressFraction;

  const _ProgressCard({
    required this.elapsed,
    required this.durationDays,
    required this.progressFraction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PROGRESS',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                  letterSpacing: 0.9)),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 8.h,
            decoration: BoxDecoration(
              color: const Color(0xFF242D29),
              borderRadius: BorderRadius.circular(9999.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressFraction,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399),
                  borderRadius: BorderRadius.circular(9999.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Day $elapsed',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 11.sp)),
              Text('$elapsed / $durationDays days',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 11.sp)),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TODAY'S PROTOCOL CARD
// =============================================================================

class _TodaysProtocolCard extends StatelessWidget {
  final String action;
  const _TodaysProtocolCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TODAY'S PROTOCOL",
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                  letterSpacing: 0.9)),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(14.w),
            child: Text(
              '"$action"',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  fontSize: 14.sp,
                  height: 1.6),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Log your observation to build your evidence archive.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                height: 1.6),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// LOGS SECTION
// =============================================================================

class _LogsSection extends StatelessWidget {
  final List<ExperimentLog> logs;
  final String metric;
  const _LogsSection({required this.logs, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/metric.png',
                  width: 20.w, height: 20.w),
              SizedBox(width: 8.w),
              Text('Daily Logs',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp)),
              const Spacer(),
              Text(
                metric.toUpperCase(),
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 9.sp,
                    letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...logs.map((log) => _LogItem(log: log)),
        ],
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final ExperimentLog log;
  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    final isPending = log.completed == 'pending';
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.06), width: 1),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  log.date,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isPending
                        ? const Color(0xFF2D2208)
                        : const Color(0xFF0D2D1A),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    isPending ? 'Pending' : 'Done',
                    style: TextStyle(
                        color: isPending
                            ? const Color(0xFFFBBF24)
                            : const Color(0xFF4ADE80),
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 9.sp,
                        letterSpacing: 0.25),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${log.metricValue.toStringAsFixed(1)} / 10',
                  style: TextStyle(
                      color: const Color(0xFF34D399),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp),
                ),
              ],
            ),
            if (log.aiSuggestion.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome,
                      color: const Color(0xFFFF8A5B), size: 12.sp),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      log.aiSuggestion,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          fontSize: 11.sp,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// METRIC TRENDS CARD
// =============================================================================

class _MetricTrendsCard extends StatelessWidget {
  final List<ExperimentLog> logs;
  final String metric;
  final String? startDate;
  final int durationDays;

  const _MetricTrendsCard({
    required this.logs,
    required this.metric,
    required this.startDate,
    required this.durationDays,
  });

  @override
  Widget build(BuildContext context) {
    final slots = _buildDaySlots();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/metric.png',
                  width: 20.w, height: 20.w),
              SizedBox(width: 8.w),
              Text('Metric trends',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp)),
              const Spacer(),
              Text(
                metric.toUpperCase(),
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 9.sp,
                    letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          if (slots.isEmpty) ...[
            // Original placeholder design
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 1,
                    height: 100.h,
                    color: Colors.white.withValues(alpha: 0.4)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        SizedBox(height: 12.h),
                        Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.4)),
                        SizedBox(height: 16.h),
                      ],
                      Text(
                        'Evidence will appear after your first log.',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              height: 120.h,
              child: CustomPaint(
                painter: _LineChartPainter(slots: slots),
                size: Size.infinite,
              ),
            ),
            SizedBox(height: 8.h),
            Row(children: _buildDateLabels(slots)),
            SizedBox(height: 10.h),
            Row(
              children: [
                _LegendDot(color: const Color(0xFF34D399), filled: true),
                SizedBox(width: 4.w),
                Text('Logged',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 9.sp)),
                SizedBox(width: 12.w),
                _LegendDot(
                    color: Colors.white.withValues(alpha: 0.3), filled: false),
                SizedBox(width: 4.w),
                Text('Pending',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 9.sp)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<_DaySlot> _buildDaySlots() {
    if (startDate == null) return [];
    final start = DateTime.tryParse(startDate!);
    if (start == null) return [];
    final logByDate = {for (final l in logs) l.date: l};
    final slots = <_DaySlot>[];
    for (int i = 0; i < durationDays; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      final dateStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final log = logByDate[dateStr];
      slots.add(_DaySlot(
        date: dateStr,
        log: log,
        isFuture: day.isAfter(DateTime.now()),
      ));
    }
    return slots;
  }

  List<Widget> _buildDateLabels(List<_DaySlot> slots) {
    if (slots.isEmpty) return [];
    final indices = <int>{0, slots.length - 1};
    if (slots.length > 2) indices.add(slots.length ~/ 2);
    final sorted = indices.toList()..sort();
    return List.generate(slots.length, (i) {
      final show = sorted.contains(i);
      final label = show ? _shortDate(slots[i].date) : '';
      return Expanded(
        child: Text(
          label,
          textAlign: i == 0
              ? TextAlign.left
              : i == slots.length - 1
                  ? TextAlign.right
                  : TextAlign.center,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontSize: 9.sp),
        ),
      );
    });
  }

  String _shortDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[d.month - 1]} ${d.day}';
    } catch (_) {
      return dateStr;
    }
  }
}

// =============================================================================
// DAY SLOT  (one per experiment day)
// =============================================================================

class _DaySlot {
  final String date;
  final ExperimentLog? log;
  final bool isFuture;

  const _DaySlot({
    required this.date,
    required this.log,
    required this.isFuture,
  });

  bool get hasLog => log != null;
  bool get isPending => log != null && log!.completed == 'pending';
  bool get isCompleted => log != null && log!.completed != 'pending';
  double get metricValue => log?.metricValue ?? 5.0;
}

// =============================================================================
// LINE CHART PAINTER
// =============================================================================

class _LineChartPainter extends CustomPainter {
  final List<_DaySlot> slots;
  const _LineChartPainter({required this.slots});

  @override
  void paint(Canvas canvas, Size size) {
    if (slots.isEmpty) return;

    const double minVal = 1;
    const double maxVal = 10;
    final double w = size.width;
    final double h = size.height;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;
    for (final yVal in [2.5, 5.0, 7.5, 10.0]) {
      final dy = h - ((yVal - minVal) / (maxVal - minVal)) * h;
      canvas.drawLine(Offset(0, dy), Offset(w, dy), gridPaint);
    }

    // Y-axis labels
    final labelStyle = TextStyle(
        color: Colors.white.withOpacity(0.3),
        fontFamily: 'IBM Plex Sans',
        fontSize: 8);
    for (final yVal in [1, 5, 10]) {
      final dy = h - ((yVal - minVal) / (maxVal - minVal)) * h;
      final tp = TextPainter(
        text: TextSpan(text: '$yVal', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width - 4, dy - tp.height / 2));
    }

    // Compute point positions for all slots
    final points = List.generate(slots.length, (i) {
      final x =
          slots.length == 1 ? w / 2 : i * w / (slots.length - 1);
      // Future days without logs: place at midpoint height but won't be drawn
      final val = slots[i].hasLog
          ? slots[i].metricValue.clamp(minVal, maxVal)
          : 5.0;
      final y = h - ((val - minVal) / (maxVal - minVal)) * h;
      return Offset(x, y);
    });

    // Segments between consecutive days that have logs
    for (int i = 0; i < slots.length - 1; i++) {
      if (!slots[i].hasLog || !slots[i + 1].hasLog) continue;
      final isDashed = slots[i].isPending || slots[i + 1].isPending;
      if (isDashed) {
        _drawDashedLine(canvas, points[i], points[i + 1],
            color: Colors.white.withOpacity(0.25));
      } else {
        canvas.drawLine(
          points[i],
          points[i + 1],
          Paint()
            ..color = const Color(0xFF34D399)
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Green fill under completed points only
    final completedIdx = slots
        .asMap()
        .entries
        .where((e) => e.value.isCompleted)
        .map((e) => e.key)
        .toList();
    if (completedIdx.length > 1) {
      final fillPath = Path()
        ..moveTo(points[completedIdx.first].dx, h);
      for (final i in completedIdx) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      }
      fillPath.lineTo(points[completedIdx.last].dx, h);
      fillPath.close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF34D399).withOpacity(0.18),
              const Color(0xFF34D399).withOpacity(0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, w, h)),
      );
    }

    // Dots
    for (int i = 0; i < slots.length; i++) {
      final slot = slots[i];
      if (!slot.hasLog) {
        // Future day: tiny dim tick on baseline
        canvas.drawCircle(Offset(points[i].dx, h), 2,
            Paint()..color = Colors.white.withOpacity(0.12));
        continue;
      }
      if (slot.isPending) {
        // Hollow dimmed dot
        canvas.drawCircle(
          points[i],
          4,
          Paint()
            ..color = Colors.white.withOpacity(0.22)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      } else {
        // Solid green dot
        canvas.drawCircle(
            points[i], 4, Paint()..color = const Color(0xFF34D399));
        canvas.drawCircle(
          points[i],
          4,
          Paint()
            ..color = const Color(0xFF0F0F0F)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2,
      {required Color color, double dashLen = 4, double gapLen = 4}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final total = (p2 - p1).distance;
    final dir = (p2 - p1) / total;
    double drawn = 0;
    bool drawing = true;
    while (drawn < total) {
      final double end =
          (drawn + (drawing ? dashLen : gapLen)).clamp(0.0, total);
      if (drawing) {
        canvas.drawLine(p1 + dir * drawn, p1 + dir * end, paint);
      }
      drawn += drawing ? dashLen : gapLen;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.slots != slots;
}

// =============================================================================
// LEGEND DOT
// =============================================================================

class _LegendDot extends StatelessWidget {
  final Color color;
  final bool filled;
  const _LegendDot({required this.color, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : Colors.transparent,
        border: Border.all(color: color, width: 1.5),
      ),
    );
  }
}

// =============================================================================
// AI ANALYSIS CARD
// =============================================================================

class _AiAnalysisCard extends StatelessWidget {
  final String analysis;
  const _AiAnalysisCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1612),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF154231), width: 1),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/ai.png', width: 20.w, height: 20.w),
              SizedBox(width: 8.w),
              Text('AI Analysis',
                  style: TextStyle(
                      color: const Color(0xFF6EE7B7),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            analysis,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                height: 1.6),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// LOG TODAY BUTTON
// =============================================================================

class _LogTodayButton extends StatelessWidget {
  final ExperimentDetailController controller;
  const _LogTodayButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final alreadyLogged = controller.todayAlreadyLogged;

      return GestureDetector(
        onTap: alreadyLogged
            ? null
            : () {
                controller.resetLogForm();
                _showLogSheet(context, controller);
              },
        child: Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: alreadyLogged ? const Color(0xFF0E1E18) : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: alreadyLogged
                ? Border.all(color: const Color(0xFF184E3B), width: 1)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (alreadyLogged) ...[
                Icon(Icons.check_circle_outline,
                    color: const Color(0xFF4ADE80), size: 18.sp),
                SizedBox(width: 8.w),
                Text('Logged Today',
                    style: TextStyle(
                        color: const Color(0xFF6EE7B7),
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp)),
              ] else ...[
                Icon(Icons.edit_outlined, color: Colors.black, size: 18.sp),
                SizedBox(width: 8.w),
                Text('Log Today',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp)),
              ],
            ],
          ),
        ),
      );
    });
  }

  void _showLogSheet(
      BuildContext context, ExperimentDetailController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LogBottomSheet(controller: controller),
    );
  }
}

// =============================================================================
// LOG BOTTOM SHEET
// =============================================================================

class _LogBottomSheet extends StatelessWidget {
  final ExperimentDetailController controller;
  const _LogBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final metric = controller.detail.value?.metric ?? 'Metric';
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final pendingLog = controller.detail.value?.logs
            .where((l) => l.completed == 'pending')
            .isNotEmpty ==
        true
        ? controller.detail.value!.logs
            .lastWhere((l) => l.completed == 'pending')
        : null;
    final aiSuggestion =
        pendingLog != null && pendingLog.aiSuggestion.isNotEmpty
            ? pendingLog.aiSuggestion
            : null;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Log Today',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 22.sp,
                                height: 1.3)),
                        SizedBox(height: 4.h),
                        Text(todayStr,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w400,
                                fontSize: 11.sp,
                                letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close,
                        color: Colors.white.withValues(alpha: 0.45),
                        size: 22.sp),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              if (aiSuggestion != null) ...[
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1612),
                    borderRadius: BorderRadius.circular(12.r),
                    border:
                        Border.all(color: const Color(0xFF154231), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_awesome,
                          color: const Color(0xFFFF8A5B), size: 14.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          aiSuggestion,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontFamily: 'IBM Plex Sans',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              fontSize: 12.sp,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],

              _SheetLabel(text: metric.toUpperCase()),
              SizedBox(height: 12.h),
              Obx(() => _MetricSliderRow(
                    value: controller.logMetricValue.value,
                    onChanged: (v) => controller.logMetricValue.value = v,
                  )),
              SizedBox(height: 20.h),

              _SheetLabel(text: 'DAILY OBSERVATION'),
              SizedBox(height: 8.h),
              _SheetTextField(
                hint: 'What did you notice today?',
                maxLines: 3,
                onChanged: (v) => controller.logObservation.value = v,
              ),
              SizedBox(height: 16.h),

              _SheetLabel(text: 'NOTES'),
              SizedBox(height: 8.h),
              _SheetTextField(
                hint: 'Any additional notes...',
                maxLines: 2,
                onChanged: (v) => controller.logNotes.value = v,
              ),
              SizedBox(height: 28.h),

              Obx(() => GestureDetector(
                    onTap: controller.isSubmittingLog.value
                        ? null
                        : controller.submitLog,
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: controller.isSubmittingLog.value
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: controller.isSubmittingLog.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check,
                                      color: Colors.black, size: 18.sp),
                                  SizedBox(width: 8.w),
                                  Text('Save Log',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'IBM Plex Sans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp)),
                                ],
                              ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sheet sub-widgets ────────────────────────────────────────────────────────

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontFamily: 'IBM Plex Sans',
          fontWeight: FontWeight.w700,
          fontSize: 9.sp,
          letterSpacing: 0.9),
    );
  }
}

class _MetricSliderRow extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _MetricSliderRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 36.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF542B1D), width: 1),
          ),
          child: Center(
            child: Text(
              value.round().toString(),
              style: TextStyle(
                  color: const Color(0xFFFF8A5B),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.h,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
              thumbColor: Colors.white,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
            ),
            child: Slider(
                value: value, min: 1, max: 10, divisions: 9, onChanged: onChanged),
          ),
        ),
        Text('/ 10',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontFamily: 'IBM Plex Sans',
                fontSize: 12.sp)),
      ],
    );
  }
}

class _SheetTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final ValueChanged<String> onChanged;
  const _SheetTextField(
      {required this.hint, required this.maxLines, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        maxLines: maxLines,
        onChanged: onChanged,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'IBM Plex Sans',
            fontSize: 13.sp,
            height: 1.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontFamily: 'IBM Plex Sans',
              fontSize: 13.sp),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
