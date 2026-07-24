import 'package:dowhatworks/app/modules/experiment_detail/controllers/experiment_detail_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/custom_navbar.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
            child: _buildTopRightGradient(),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildDivider(),
                  SizedBox(height: 24.h),
                  _buildContentSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onItemTap: (index) {
          if (index == 0) {
            Get.offNamed(AppRoutes.home);
          } else if (index == 1) {
            Get.offNamed(AppRoutes.daniel);
          } else if (index == 2) {
            Get.offNamed(AppRoutes.lab);
          } else if (index == 3) {
            Get.offNamed(AppRoutes.results);
          } else {
            Get.snackbar(
              'Coming soon',
              'This screen is under development',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF1A1A1A),
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }

  Widget _buildTopRightGradient() {
    return Container(
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
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.offNamed(AppRoutes.lab),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white.withValues(alpha: 0.55),
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'The Lab',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        height: 1.333,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF612020), width: 1),
                    color: const Color(0xFF231111),
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    color: const Color(0xFFF87171),
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(color: const Color(0xFF184E3B), width: 1),
                    color: const Color(0xFF0E1E18),
                  ),
            child: Text(
              'Active',
              style: TextStyle(
                color: const Color(0xFF6EE7B7),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                height: 1.5,
                letterSpacing: 0.25,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '"If I remove social media after 8PM, then my sleep quality and morning clarity will improve."',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 25.sp,
              height: 1.25,
              letterSpacing: -0.63,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withValues(alpha: 0.5),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Started July 19 · ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
              Icon(
                Icons.track_changes,
                color: Colors.white.withValues(alpha: 0.5),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Sleep Quality',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Duration',
                      value: '0',
                      suffix: '/ 7 days',
                      valueColor: Colors.white,
                      suffixColor: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      label: 'Completion',
                      value: '0%',
                      suffix: '',
                      valueColor: const Color(0xFF34D399),
                      suffixColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Sleep quality',
                      value: '0',
                      suffix: '',
                      valueColor: Colors.white,
                      suffixColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      label: 'Streak',
                      value: '0',
                      suffix: '',
                      valueColor: Colors.white,
                      suffixColor: Colors.transparent,
                      showFire: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildMetricTrendsCard(),
          SizedBox(height: 24.h),
          _buildTodaysProtocolCard(),
          SizedBox(height: 32.h),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _StatCard({
    required String label,
    required String value,
    required String suffix,
    required Color valueColor,
    required Color suffixColor,
    bool showFire = false,
  }) {
    return Container(
      width: double.infinity,
      height: 91.h,
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
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
                height: 1.5,
                letterSpacing: 0.45,
              ),
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
                    height: 1.333,
                    letterSpacing: 0,
                  ),
                ),
                if (showFire) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 18.sp,
                  ),
                ],
                if (suffix.isNotEmpty) ...[
                  SizedBox(width: 2.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.h),
                      Text(
                        suffix,
                        style: TextStyle(
                          color: suffixColor,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          height: 1.333,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysProtocolCard() {
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
              'Today\'s protocol',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                fontSize: 9.sp,
                height: 1.5,
                letterSpacing: 0.9,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  '"Do not open any social media apps after 8:00 PM."',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: 14.sp,
                    height: 1.626,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Log your first observation to begin the analysis.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                height: 1.626,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTrendsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/metric.png',
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Metric trends',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                Text(
                  'SLEEP QUALITY',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 9.sp,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 1,
                  height: 100.h,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    children: [
                      _buildHorizontalLine(16.h),
                      _buildHorizontalLine(16.h),
                      _buildHorizontalLine(16.h),
                      _buildHorizontalLine(8.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Evidence will appear after your first log.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalLine(double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: bottomPadding),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.white.withValues(alpha: 0.4),
      ),
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
        Image.asset(
          'assets/icons/top_logo.png',
          width: 32.w,
          height: 32.w,
        ),
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
            height: 32.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF843D23), width: 1.5),
              color: const Color(0xFF3A1E14),
            ),
            child: Center(
              child: Text(
                'F',
                style: TextStyle(
                  color: const Color(0xFFFF8A5B),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
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
