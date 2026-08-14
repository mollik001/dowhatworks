import 'package:dowhatworks/app/data/models/experiment_models.dart';
import 'package:dowhatworks/app/modules/results/controllers/results_controller.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResultsView extends GetView<ResultsController> {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResultsHeader(),
        _Divider(),
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFFFF8A5B),
            backgroundColor: const Color(0xFF0F0F0F),
            onRefresh: controller.loadExperiments,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Text(
                    'Experiments',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 28.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Your behavioral evidence archive.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 60.h),
                          child: const CircularProgressIndicator(
                            color: Color(0xFFFF8A5B),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    if (controller.experiments.isEmpty) {
                      return _EmptyState();
                    }
                    return Column(
                      children: [
                        ...controller.experiments.map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: e.isActive
                                ? _ActiveCard(experiment: e)
                                : _QueuedCard(experiment: e),
                          ),
                        ),
                        _PrimeCard(),
                        SizedBox(height: 32.h),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ACTIVE EXPERIMENT CARD
// =============================================================================

class _ActiveCard extends StatelessWidget {
  final Experiment experiment;
  const _ActiveCard({required this.experiment});

  @override
  Widget build(BuildContext context) {
    final totalDays = experiment.durationDays;
    final elapsed = experiment.elapsedDays;
    final progress = totalDays > 0 ? elapsed / totalDays : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1612),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFF154231), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + status
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
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
              experiment.hypothesis,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 8.h),
            // Metric
            Text(
              experiment.metric,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
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
              height: 8.h,
              decoration: BoxDecoration(
                color: const Color(0xFF242D29),
                borderRadius: BorderRadius.circular(9999.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
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
            // View Analysis button
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.experimentDetail, arguments: experiment.id),
              child: Container(
                width: double.infinity,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    'View Analysis',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// QUEUED EXPERIMENT CARD
// =============================================================================

class _QueuedCard extends StatelessWidget {
  final Experiment experiment;
  const _QueuedCard({required this.experiment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFF2E2E30), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF28282B),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/nav3.png',
                      width: 16.w,
                      height: 16.w,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    experiment.hypothesis,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(color: const Color(0xFF534877), width: 1),
                    color: const Color(0xFF272431),
                  ),
                  child: Text(
                    'Queued',
                    style: TextStyle(
                      color: const Color(0xFFC4B5FD),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 44.w),
              child: Text(
                'QUEUED · ${experiment.metric.toUpperCase()}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                  letterSpacing: 0.45,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Divider(
              color: Colors.white.withValues(alpha: 0.08),
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DURATION',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    letterSpacing: 0.45,
                  ),
                ),
                Text(
                  '${experiment.durationDays} days',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(9999.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================

class _EmptyState extends StatelessWidget {
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
          Icon(Icons.science_outlined,
              color: Colors.white.withValues(alpha: 0.2), size: 36.sp),
          SizedBox(height: 12.h),
          Text(
            'No experiments yet.\nCreate one from the Lab.',
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
// PRIME UPSELL CARD
// =============================================================================

class _PrimeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFF272727), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock full evidence history',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Activate Prime Cycle Access',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFFF8A5B),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _ResultsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
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
                ),
              ),
              Text(
                'RESULTS',
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
          const Spacer(),
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
      ),
    );
  }
}

// =============================================================================
// DIVIDER
// =============================================================================

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
