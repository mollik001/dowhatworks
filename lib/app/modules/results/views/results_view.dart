import 'package:dowhatworks/app/modules/results/controllers/results_controller.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class _OutlinedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final center = size.center(Offset.zero);
    final height = size.height * 0.7;
    final halfWidth = size.width * 0.4;

    path.moveTo(center.dx - halfWidth, center.dy + height / 2);
    path.lineTo(center.dx + halfWidth, center.dy);
    path.lineTo(center.dx - halfWidth, center.dy - height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            'Experiments',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 28.sp,
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your behavioral evidence archive.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 24.h),
          _buildExperimentCard(),
          SizedBox(height: 16.h),
          _buildQueuedCard(),
          SizedBox(height: 16.h),
          _buildPrimeCard(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildExperimentCard() {
    return Container(
      width: 357.w,
      height: 277.h,
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
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'No social media after 8PM',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
                height: 1.5,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Track sleep quality and morning clarity for seven days.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(() {
              final progressValue = Get.find<ResultsController>().progress.value / 7;
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF242D29),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressValue,
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
                        'Day 1',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          height: 1.5,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        '1 / 7 days',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          height: 1.5,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.experimentDetail),
                child: Container(
                  width: 320.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: CustomPaint(
                          painter: _OutlinedTrianglePainter(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'View Analysis',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 1.5,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueuedCard() {
    return Container(
      width: 357.w,
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
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'If I wake at the same time each day...',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                      height: 1.069,
                      letterSpacing: 0,
                    ),
                  ),
                ),
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
                      height: 1.5,
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
                'QUEUED · SLEEP QUALITY',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 9.sp,
                  height: 1.5,
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
                  'Duration',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    height: 1.5,
                    letterSpacing: 0.45,
                  ),
                ),
                Text(
                  '7 days',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    height: 1.5,
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

  Widget _buildPrimeCard() {
    return Container(
      width: 357.w,
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
                      letterSpacing: 0,
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
                      letterSpacing: 0,
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
