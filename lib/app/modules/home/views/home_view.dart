import 'package:dowhatworks/app/data/models/experiment_models.dart';
import 'package:dowhatworks/app/modules/home/controllers/home_controller.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildDivider(),
          SizedBox(height: 24.h),
          _buildContentSection(),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                '${controller.dayLabel.value} · ${controller.experimentDayLabel.value}',
                style: TextStyle(
                  color: const Color(0xFFFF8A5B),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.178,
                  letterSpacing: 1.98,
                ),
              )),
              SizedBox(height: 12.h),
              Text(
                'Your experiment, in focus.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 26.sp,
                  height: 1.0,
                  letterSpacing: -0.75,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Small data points become a clear view of what works for you.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.625,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
        _HomeSectionTabs(controller: controller),
        SizedBox(height: 24.h),
        Obx(() {
          final tab = controller.homeTabIndex.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: tab == 0
                ? _buildMetricsSection()
                : _buildBeliefsSection(),
          );
        }),
      ],
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardsGrid(),
        SizedBox(height: 24.h),
        _buildDailyLogCard(),
        SizedBox(height: 24.h),
        _buildActiveProtocolCard(),
        SizedBox(height: 24.h),
        _buildPerformanceHistoryCard(),
        SizedBox(height: 32.h),
        _buildActionCardsRow(),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildBeliefsSection() {
    return Obx(() {
      final entries = controller.baselineHistory;
      if (entries.isEmpty) {
        return _BeliefsEmptyState();
      }
      // Use only the latest entry for the summary cards
      final latest = entries.last;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBaselineCardsGrid(latest),
          SizedBox(height: 24.h),
          _BaselineComparisonChart(entries: entries),
          SizedBox(height: 24.h),
          Obx(() {
            final data = controller.onboardingData.value;
            if (data == null) return const SizedBox.shrink();
            return _BeliefDistributionCard(data: data);
          }),
          SizedBox(height: 32.h),
        ],
      );
    });
  }

  Widget _buildBaselineCardsGrid(BaselineEntry latest) {
    final cards = [
      _CardData(
        iconPath: 'assets/icons/focus.png',
        label: 'Attention',
        value: '${latest.attentionScore.toStringAsFixed(0)}%',
        valueColor: const Color(0xFFA5B4FC),
      ),
      _CardData(
        iconPath: 'assets/icons/stress.png',
        label: 'Endurance',
        value: '${latest.enduranceScore.toStringAsFixed(0)}%',
        valueColor: const Color(0xFF6EE7B7),
      ),
      _CardData(
        iconPath: 'assets/icons/brain.png',
        label: 'Control',
        value: '${latest.controlScore.toStringAsFixed(0)}%',
        valueColor: const Color(0xFFFCD34D),
      ),
      _CardData(
        iconPath: 'assets/icons/progress.png',
        label: 'Capacity',
        value: '${latest.capacityScore}/7',
        valueColor: const Color(0xFFF9A8D4),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 175 / 117,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];
        return _CardItem(
          iconPath: card.iconPath,
          label: card.label,
          value: card.value,
          valueColor: card.valueColor,
        );
      },
    );
  }

  Widget _buildCardsGrid() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final sleep = controller.formatMetric(controller.sleepValue.value);
      final focus = controller.formatMetric(controller.focusValue.value);

      final cards = [
        _CardData(
          iconPath: 'assets/icons/sleep.png',
          label: 'Sleep quality',
          value: isLoading ? '…' : sleep,
          valueColor: const Color(0xFFA5B4FC),
        ),
        _CardData(
          iconPath: 'assets/icons/focus.png',
          label: 'Focus',
          value: isLoading ? '…' : focus,
          valueColor: const Color(0xFFC4B5FD),
        ),
        _CardData(
          iconPath: 'assets/icons/logs.png',
          label: 'Total logs',
          value: isLoading ? '…' : '${controller.totalLogs.value}',
          valueColor: const Color(0xFFFCD34D),
        ),
        _CardData(
          iconPath: 'assets/icons/experiment.png',
          label: 'Experiment day',
          value: isLoading
              ? '…'
              : controller.experimentDuration.value > 0
                  ? '${controller.experimentElapsed.value}'
                  : '-',
          valueColor: const Color(0xFF6EE7B7),
        ),
      ];

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 175 / 117,
        ),
        itemBuilder: (context, index) {
          final card = cards[index];
          return _CardItem(
            iconPath: card.iconPath,
            label: card.label,
            value: card.value,
            valueColor: card.valueColor,
          );
        },
      );
    });
  }

  Widget _buildDailyLogCard() {
    return Obx(() {
      final hasCheckedIn = controller.hasCheckedInToday.value;
      final isLoading = controller.isLoading.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily log',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.178,
                  letterSpacing: 1.65,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                hasCheckedIn ? 'Today\'s log complete' : 'Calibrate today\'s signal',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 20.sp,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                hasCheckedIn
                    ? 'You\'ve already checked in today. Come back tomorrow.'
                    : 'Check in on eight everyday metrics. It takes less than a minute.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.509,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading || hasCheckedIn
                      ? null
                      : () async {
                          await Get.toNamed(AppRoutes.dailyCheckin);
                          // Refresh home data after returning from check-in
                          controller.onCheckinSubmitted();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasCheckedIn
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white,
                    foregroundColor: hasCheckedIn ? Colors.white : Colors.black,
                    disabledBackgroundColor: hasCheckedIn
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.4),
                    disabledForegroundColor: hasCheckedIn
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        SizedBox(
                          height: 16.h,
                          width: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        )
                      else if (hasCheckedIn) ...[
                        Icon(Icons.check_circle_outline,
                            size: 18.w,
                            color: Colors.white.withValues(alpha: 0.4)),
                        SizedBox(width: 8.w),
                        Text(
                          'Checked in today',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            height: 1.0,
                          ),
                        ),
                      ] else
                        Text(
                          'Daily Check In',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActiveProtocolCard() {
    return Obx(() {
      final experiment = controller.activeExperiment.value;
      if (experiment == null) return const SizedBox.shrink();
      return _ActiveProtocolCard(experiment: experiment);
    });
  }

  Widget _buildPerformanceHistoryCard() {
    return Obx(() => _PerformanceHistoryCard(
          logs: controller.activeExperimentLogs,
          metric: controller.activeExperimentMetric.value,
          startDate: controller.activeExperimentStartDate.value,
          durationDays: controller.activeExperimentDurationDays.value,
        ));
  }

  Widget _buildActionCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            iconPath: 'assets/icons/bot.png',
            title: 'Talk to Daniel',
            subtitle: 'Refine a belief',
            onTap: () => controller.switchTab(1),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ActionCard(
            iconPath: 'assets/icons/nav3.png',
            iconColor: const Color(0xFFFF8A5B),
            title: 'The Lab',
            subtitle: 'Run a protocol',
            onTap: () => controller.switchTab(2),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          _buildLogoSection(),
          const Spacer(),
          _buildNotificationSection(),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Row(
      children: [
        Image.asset('assets/icons/top_logo.png', width: 32.w, height: 32.w),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DoWhatWorks',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.5,
                letterSpacing: 0,
              ),
            ),
            Text(
              'Homepage',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                height: 1.5,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 24.w,
          ),
        ),
        SizedBox(width: 12.w),
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
                  fontSize: 14.sp,
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
        height: 1,
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _CardData {
  final String iconPath;
  final String label;
  final String value;
  final Color valueColor;

  const _CardData({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.valueColor,
  });
}

class _CardItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final Color valueColor;

  const _CardItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.w,
      height: 117.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 24.w, height: 24.w),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                height: 1.5,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String iconPath;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.iconPath,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(iconPath, width: 24.w, height: 24.w, color: iconColor),
              SizedBox(height: 8.h),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// =============================================================================
// ACTIVE PROTOCOL CARD
// =============================================================================

class _ActiveProtocolCard extends StatelessWidget {
  final Experiment experiment;
  const _ActiveProtocolCard({required this.experiment});

  @override
  Widget build(BuildContext context) {
    final totalDays = experiment.durationDays;
    final elapsed = experiment.elapsedDays;
    final progress = totalDays > 0 ? (elapsed / totalDays).clamp(0.0, 1.0) : 0.0;

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
          // Icon + title + Active badge
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF123326),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/nav3.png',
                    width: 16.w,
                    height: 16.w,
                    color: const Color(0xFF6EE7B7),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Active experiment',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999.r),
                  border: Border.all(color: const Color(0xFF184E3B), width: 1),
                  color: const Color(0xFF0E1E18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: const Color(0xFF6EE7B7),
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Hypothesis
          Text(
            'HYPOTHESIS',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
              letterSpacing: 0.9,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            experiment.hypothesis,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 14.h),

          // Action
          Text(
            'ACTION',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
              letterSpacing: 0.9,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            experiment.action,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 14.h),

          // Metric
          Text(
            'METRIC',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
              letterSpacing: 0.9,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            experiment.metric,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),

          // Progress bar
          Container(
            width: double.infinity,
            height: 6.h,
            decoration: BoxDecoration(
              color: const Color(0xFF242D29),
              borderRadius: BorderRadius.circular(9999.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
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
              Text(
                experiment.startDate != null
                    ? 'Started ${experiment.startDate}'
                    : 'Day 1',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                '$elapsed / ${experiment.durationDays} days',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Progress percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                  letterSpacing: 0.9,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: const Color(0xFF34D399),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PERFORMANCE HISTORY CARD
// =============================================================================

class _PerformanceHistoryCard extends StatelessWidget {
  final List<ExperimentLog> logs;
  final String metric;
  final String? startDate;
  final int durationDays;

  const _PerformanceHistoryCard({
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
              Text(
                'Performance history',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              if (metric.isNotEmpty)
                Text(
                  metric.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 9.sp,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          if (slots.isEmpty) ...[
            // Placeholder when no active experiment or no logs yet
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
                        durationDays == 0
                            ? 'No active experiment.'
                            : 'Evidence will appear after your first log.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          height: 1.5,
                        ),
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
                painter: _HomeLineChartPainter(slots: slots),
                size: Size.infinite,
              ),
            ),
            SizedBox(height: 8.h),
            Row(children: _buildDateLabels(slots)),
            SizedBox(height: 10.h),
            Row(
              children: [
                _HomeLegendDot(
                    color: const Color(0xFF34D399), filled: true),
                SizedBox(width: 4.w),
                Text('Logged',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 9.sp)),
                SizedBox(width: 12.w),
                _HomeLegendDot(
                    color: Colors.white.withValues(alpha: 0.3),
                    filled: false),
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

  List<_HomeDaySlot> _buildDaySlots() {
    if (startDate == null || durationDays == 0) return [];
    final start = DateTime.tryParse(startDate!);
    if (start == null) return [];
    final logByDate = {for (final l in logs) l.date: l};
    final slots = <_HomeDaySlot>[];
    for (int i = 0; i < durationDays; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      final dateStr =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final log = logByDate[dateStr];
      slots.add(_HomeDaySlot(
        date: dateStr,
        log: log,
        isFuture: day.isAfter(DateTime.now()),
      ));
    }
    return slots;
  }

  List<Widget> _buildDateLabels(List<_HomeDaySlot> slots) {
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
// HOME DAY SLOT
// =============================================================================

class _HomeDaySlot {
  final String date;
  final ExperimentLog? log;
  final bool isFuture;

  const _HomeDaySlot({
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
// HOME LINE CHART PAINTER
// =============================================================================

class _HomeLineChartPainter extends CustomPainter {
  final List<_HomeDaySlot> slots;
  const _HomeLineChartPainter({required this.slots});

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
      final x = slots.length == 1 ? w / 2 : i * w / (slots.length - 1);
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
        canvas.drawCircle(Offset(points[i].dx, h), 2,
            Paint()..color = Colors.white.withOpacity(0.12));
        continue;
      }
      if (slot.isPending) {
        canvas.drawCircle(
          points[i],
          4,
          Paint()
            ..color = Colors.white.withOpacity(0.22)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      } else {
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
  bool shouldRepaint(_HomeLineChartPainter old) => old.slots != slots;
}

// =============================================================================
// HOME LEGEND DOT
// =============================================================================

class _HomeLegendDot extends StatelessWidget {
  final Color color;
  final bool filled;
  const _HomeLegendDot({required this.color, required this.filled});

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
// HOME SECTION TABS
// =============================================================================

class _HomeSectionTabs extends StatelessWidget {
  final HomeController controller;
  const _HomeSectionTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.homeTabIndex.value;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07), width: 1),
        ),
        child: Row(
          children: [
            _SectionTab(
              label: 'Metrics',
              selected: selected == 0,
              onTap: () => controller.homeTabIndex.value = 0,
            ),
            _SectionTab(
              label: 'Beliefs & Attention',
              selected: selected == 1,
              onTap: () => controller.homeTabIndex.value = 1,
            ),
          ],
        ),
      );
    });
  }
}

class _SectionTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SectionTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          margin: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF0F0F0F) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: selected
                ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BASELINE COMPARISON CHART (Beliefs & Attention)
// =============================================================================

class _BaselineComparisonChart extends StatelessWidget {
  final List<BaselineEntry> entries;
  const _BaselineComparisonChart({required this.entries});

  static const _metrics = [
    _MetricDef('Attention', Color(0xFFA5B4FC)),
    _MetricDef('Endurance', Color(0xFF6EE7B7)),
    _MetricDef('Control',   Color(0xFFFCD34D)),
  ];

  @override
  Widget build(BuildContext context) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    String shortDate(DateTime d) =>
        '${months[d.toLocal().month - 1]} ${d.toLocal().day}';

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
          // Header
          Row(
            children: [
              Image.asset('assets/icons/brain.png', width: 20.w, height: 20.w),
              SizedBox(width: 8.w),
              Text(
                'Score history',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Chart
          SizedBox(
            height: 160.h,
            child: CustomPaint(
              painter: _BaselineChartPainter(entries: entries),
              size: Size.infinite,
            ),
          ),
          SizedBox(height: 8.h),

          // Date labels along x-axis
          Row(
            children: List.generate(entries.length, (i) {
              return Expanded(
                child: Text(
                  shortDate(entries[i].createdAt),
                  textAlign: i == 0
                      ? TextAlign.left
                      : i == entries.length - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 9.sp,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),

          // Legend
          Wrap(
            spacing: 12.w,
            runSpacing: 6.h,
            children: _metrics.map((m) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w, height: 8.w,
                  decoration: BoxDecoration(
                    color: m.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  m.label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 10.sp,
                  ),
                ),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _MetricDef {
  final String label;
  final Color color;
  const _MetricDef(this.label, this.color);
}

class _BaselineChartPainter extends CustomPainter {
  final List<BaselineEntry> entries;
  const _BaselineChartPainter({required this.entries});

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    const double minVal = 0;
    const double maxVal = 100;
    final double w = size.width;
    final double h = size.height;
    final int n = entries.length;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;
    for (final yVal in [0.0, 25.0, 50.0, 75.0, 100.0]) {
      final dy = h - (yVal / maxVal) * h;
      canvas.drawLine(Offset(0, dy), Offset(w, dy), gridPaint);
    }

    // Y-axis labels
    final labelStyle = TextStyle(
      color: Colors.white.withOpacity(0.3),
      fontFamily: 'IBM Plex Sans',
      fontSize: 8,
    );
    for (final yVal in [0, 50, 100]) {
      final dy = h - (yVal / maxVal) * h;
      final tp = TextPainter(
        text: TextSpan(text: '$yVal', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width - 4, dy - tp.height / 2));
    }

    // Helper: x position for entry index
    double xOf(int i) => n == 1 ? w / 2 : i * w / (n - 1);

    // Helper: y position for a 0–100 value
    double yOf(double val) =>
        h - ((val - minVal) / (maxVal - minVal)) * h;

    // Draw each metric line
    final metricData = [
      (entries.map((e) => e.attentionScore).toList(), const Color(0xFFA5B4FC)),
      (entries.map((e) => e.enduranceScore).toList(), const Color(0xFF6EE7B7)),
      (entries.map((e) => e.controlScore).toList(),   const Color(0xFFFCD34D)),
    ];

    for (final (values, color) in metricData) {
      final points = List.generate(n, (i) => Offset(xOf(i), yOf(values[i])));

      // Fill under the line
      if (n > 1) {
        final fillPath = Path()..moveTo(points.first.dx, h);
        for (final p in points) fillPath.lineTo(p.dx, p.dy);
        fillPath.lineTo(points.last.dx, h);
        fillPath.close();
        canvas.drawPath(
          fillPath,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.12),
                color.withOpacity(0.0),
              ],
            ).createShader(Rect.fromLTWH(0, 0, w, h)),
        );
      }

      // Line segments
      for (int i = 0; i < n - 1; i++) {
        canvas.drawLine(
          points[i],
          points[i + 1],
          Paint()
            ..color = color
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      }

      // Dots
      for (final p in points) {
        canvas.drawCircle(p, 4, Paint()..color = color);
        canvas.drawCircle(
          p, 4,
          Paint()
            ..color = const Color(0xFF0F0F0F)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }

      // Value labels above each dot
      for (int i = 0; i < n; i++) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${values[i].toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontFamily: 'IBM Plex Sans',
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(points[i].dx - tp.width / 2, points[i].dy - tp.height - 6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BaselineChartPainter old) => old.entries != entries;
}

// =============================================================================
// BELIEFS EMPTY STATE
// =============================================================================

class _BeliefsEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
      ),
      child: Column(
        children: [
          Image.asset('assets/icons/brain.png',
              width: 36.w, height: 36.w,
              color: Colors.white.withValues(alpha: 0.2)),
          SizedBox(height: 12.h),
          Text(
            'No baseline data yet.\nComplete an assessment to see your scores.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================

// =============================================================================
// BELIEF DISTRIBUTION CARD (radar chart)
// =============================================================================

class _BeliefDistributionCard extends StatelessWidget {
  final OnboardingData data;
  const _BeliefDistributionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final scores = data.sectionScores;
    final labels = OnboardingData.sections.map((s) => s.label).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/brain.png', width: 20.w, height: 20.w),
              SizedBox(width: 8.w),
              Text(
                'Belief Distribution',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Based on your onboarding answers.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: SizedBox(
              width: 260.w,
              height: 260.w,
              child: CustomPaint(
                painter: _RadarPainter(scores: scores, labels: labels),
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

// =============================================================================
// RADAR PAINTER
// =============================================================================

class _RadarPainter extends CustomPainter {
  final List<double> scores;
  final List<String> labels;

  const _RadarPainter({required this.scores, required this.labels});

  static const double _pi = 3.141592653589793;

  // Taylor-series cos — avoids needing dart:math import
  static double _cos(double a) {
    a = a % (2 * _pi);
    if (a > _pi) a -= 2 * _pi;
    double r = 1, t = 1;
    for (int i = 1; i <= 12; i++) {
      t *= -a * a / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  static double _sin(double a) => _cos(a - _pi / 2);

  @override
  void paint(Canvas canvas, Size size) {
    final int n = scores.length;
    if (n < 3) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.66;

    double axisAngle(int i) => -_pi / 2 + i * (2 * _pi / n);

    Offset pt(int i, double r) => Offset(
          center.dx + r * _cos(axisAngle(i)),
          center.dy + r * _sin(axisAngle(i)),
        );

    // Grid rings
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final p = pt(i, r);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Spokes
    final spokePaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;
    for (int i = 0; i < n; i++) {
      canvas.drawLine(center, pt(i, radius), spokePaint);
    }

    // Filled polygon
    final fillPath = Path();
    for (int i = 0; i < n; i++) {
      final p = pt(i, radius * scores[i].clamp(0.04, 1.0));
      i == 0 ? fillPath.moveTo(p.dx, p.dy) : fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFFFF8A5B).withOpacity(0.18)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFFFF8A5B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Dots
    for (int i = 0; i < n; i++) {
      final p = pt(i, radius * scores[i].clamp(0.04, 1.0));
      canvas.drawCircle(p, 3.5, Paint()..color = const Color(0xFFFF8A5B));
      canvas.drawCircle(
        p, 3.5,
        Paint()
          ..color = const Color(0xFF0F0F0F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Labels
    for (int i = 0; i < n; i++) {
      final lx = center.dx + (radius + 16) * _cos(axisAngle(i));
      final ly = center.dy + (radius + 16) * _sin(axisAngle(i));
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontFamily: 'IBM Plex Sans',
            fontSize: 8.0,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 58);
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) =>
      old.scores != scores || old.labels != labels;
}
