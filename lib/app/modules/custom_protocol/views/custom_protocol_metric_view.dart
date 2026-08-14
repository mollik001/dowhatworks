import 'package:dowhatworks/app/modules/custom_protocol/controllers/custom_protocol_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/custom_navbar.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomProtocolMetricView extends GetView<CustomProtocolController> {
  const CustomProtocolMetricView({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = ['Sleep quality', 'Morning clarity', 'Focus', 'EnergyZ'];

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
                  _buildContentSection(metrics),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 2,
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

  Widget _buildContentSection(List<String> metrics) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            'Custom protocol',
            style: TextStyle(
              color: const Color(0xFFFF8A5B),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
              height: 1.5,
              letterSpacing: 1.98,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'New experiment',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w400,
              fontSize: 28.sp,
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Define a testable experiment, step by step.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 24.h),
          _buildStepIndicators(selectedStep: 2),
          SizedBox(height: 32.h),
          Text(
            'How will you measure it?',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w400,
              fontSize: 21.sp,
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Choose the metric that gives this experiment a signal.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return Obx(() {
                final isSelected = controller.selectedMetric.value == metric;
                return GestureDetector(
                  onTap: () => controller.selectMetric(metric),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF21140F)
                          : const Color(0xFF0F0F0F),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFF26B3A)
                            : Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? const Color(0xFFF26B3A)
                                : Colors.white.withValues(alpha: 0.65),
                            size: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              metric,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFFF26B3A)
                                    : Colors.white.withValues(alpha: 0.65),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                height: 1.375,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
          SizedBox(height: 24.h),
          Obx(() => controller.metricError.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
                  child: Text(
                    controller.metricError.value,
                    style: TextStyle(
                      color: const Color(0xFFF87171),
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 11.sp,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          Row(
            children: [
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () => Get.offNamed(AppRoutes.customProtocol),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF262626), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
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
              const Spacer(),
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () => controller.validateAndNext(
                    field: 'metric',
                    route: AppRoutes.customProtocolLaunch,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: const Color(0xFF0A0A0B),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildStepIndicators({required int selectedStep}) {
    final steps = ['hypothesis', 'action', 'metric', 'duration'];
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < steps.length; i++)
              Expanded(
                child: Container(
                  height: 6.h,
                  margin: EdgeInsets.only(
                    left: i == 0 ? 0 : 4.w,
                    right: i == steps.length - 1 ? 0 : 4.w,
                  ),
                  decoration: BoxDecoration(
                    color: i <= selectedStep
                        ? const Color(0xFFF26B3A)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            for (int i = 0; i < steps.length; i++)
              Expanded(
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: i == selectedStep
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 10.sp,
                    height: 1.5,
                    letterSpacing: 0.22,
                  ),
                ),
              ),
          ],
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
