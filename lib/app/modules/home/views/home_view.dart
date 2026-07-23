import 'package:dowhatworks/app/modules/home/controllers/home_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/custom_navbar.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
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
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 0,
        onItemTap: (index) {
          if (index == 0) {
            Get.offNamed(AppRoutes.home);
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

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saturday · Day 1 of 10',
            style: TextStyle(
              color: const Color(0xFFFF8A5B),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.178,
              letterSpacing: 1.98,
            ),
          ),
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
    final cards = const [
      _CardData(iconPath: 'assets/icons/sleep.png', label: 'Sleep quality', value: '', valueColor: Color(0xFFA5B4FC)),
      _CardData(iconPath: 'assets/icons/focus.png', label: 'Focus', value: '', valueColor: Color(0xFFC4B5FD)),
      _CardData(iconPath: 'assets/icons/logs.png', label: 'Total logs', value: '0', valueColor: Color(0xFFFCD34D)),
      _CardData(iconPath: 'assets/icons/experiment.png', label: 'Experiment day', value: '1', valueColor: Color(0xFF6EE7B7)),
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

  Widget _buildDailyLogCard() {
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
              'Calibrate today\'s signal',
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
              'Check in on eight everyday metrics. It takes less than a minute.',
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
                onPressed: () => Get.toNamed(AppRoutes.dailyCheckin),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Daily Check In',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        Container(
          width: 32.w,
          height: 32.w,
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
    required this.iconPath,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  String get _displayValue => value.isEmpty ? '-' : value;

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
              _displayValue,
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
            Image.asset(
              iconPath,
              width: 24.w,
              height: 24.w,
              color: iconColor,
            ),
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
