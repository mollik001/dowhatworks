import 'package:dowhatworks/app/modules/daily_checkin/controllers/daily_checkin_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/custom_navbar.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DailyCheckinView extends GetView<DailyCheckinController> {
  const DailyCheckinView({super.key});

  static const _metrics = [
    _MetricData(iconPath: 'assets/icons/sleep.png',    label: 'Sleep quality', key: 'sleep'),
    _MetricData(iconPath: 'assets/icons/exercise.png', label: 'Exercise',      key: 'exercise'),
    _MetricData(iconPath: 'assets/icons/focus.png',    label: 'Focus',         key: 'focus'),
    _MetricData(iconPath: 'assets/icons/logs.png',     label: 'Energy',        key: 'energy'),
    _MetricData(iconPath: 'assets/icons/mood.png',     label: 'Mood',          key: 'mood'),
    _MetricData(iconPath: 'assets/icons/stress.png',   label: 'Stress',        key: 'stress'),
    _MetricData(iconPath: 'assets/icons/social.png',   label: 'Social',        key: 'social'),
    _MetricData(iconPath: 'assets/icons/progress.png', label: 'Progress',      key: 'progress'),
  ];

  RxDouble _valueFor(String key) {
    switch (key) {
      case 'sleep':    return controller.sleep;
      case 'exercise': return controller.exercise;
      case 'focus':    return controller.focus;
      case 'energy':   return controller.energy;
      case 'mood':     return controller.mood;
      case 'stress':   return controller.stress;
      case 'social':   return controller.social;
      case 'progress': return controller.progress;
      default:         return controller.sleep;
    }
  }

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
                  _buildCard(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 0,
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

  Widget _buildCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily metrics check-in',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 22.sp,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Calibrate your signal',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            height: 1.5,
                            letterSpacing: 1.32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withValues(alpha: 0.45),
                      size: 24.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _metrics.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 155 / 125,
                ),
                itemBuilder: (context, index) {
                  final metric = _metrics[index];
                  final rxValue = _valueFor(metric.key);
                  return _MetricCard(metric: metric, rxValue: rxValue);
                },
              ),
              SizedBox(height: 20.h),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.submitCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 18.h,
                          width: 18.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/nav4.png',
                              width: 20.w,
                              height: 20.w,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Submit daily check in',
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                height: 1.0,
                              ),
                            ),
                          ],
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

// ---------------------------------------------------------------------------

class _MetricData {
  final String iconPath;
  final String label;
  final String key;

  const _MetricData({
    required this.iconPath,
    required this.label,
    required this.key,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricData metric;
  final RxDouble rxValue;

  const _MetricCard({super.key, required this.metric, required this.rxValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 12.w, bottom: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(metric.iconPath, width: 24.w, height: 24.w),
                Container(
                  width: 34.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF542B1D), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '${rxValue.value.round()}',
                      style: TextStyle(
                        color: const Color(0xFFFF8A5B),
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(height: 12.h),
            Text(
              metric.label,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(() => _MetricSlider(
              value: rxValue.value,
              onChanged: (v) => rxValue.value = v,
            )),
          ],
        ),
      ),
    );
  }
}

class _MetricSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _MetricSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4.h,
        activeTrackColor: Colors.white,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
        thumbColor: Colors.white,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 10.r),
      ),
      child: Slider(
        value: value,
        min: 1,
        max: 10,
        divisions: 9,
        onChanged: onChanged,
      ),
    );
  }
}
