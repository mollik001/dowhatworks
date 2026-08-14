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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
            '${controller.dayLabel.value} · Day 1 of 10',
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
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 32.h),
          _buildCardsGrid(),
          SizedBox(height: 24.h),
          _buildDailyLogCard(),
          SizedBox(height: 32.h),
          _buildActionCardsRow(),
          SizedBox(height: 32.h),
        ],
      ),
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
          value: '1',
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

  Widget _buildActionCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            iconPath: 'assets/icons/bot.png',
            title: 'Talk to Daniel',
            subtitle: 'Refine a belief',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ActionCard(
            iconPath: 'assets/icons/nav3.png',
            iconColor: const Color(0xFFFF8A5B),
            title: 'The Lab',
            subtitle: 'Run a protocol',
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

  const _ActionCard({
    required this.iconPath,
    this.iconColor,
    required this.title,
    required this.subtitle,
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
    );
  }
}
