import 'package:dowhatworks/app/data/models/experiment_models.dart';
import 'package:dowhatworks/app/modules/lab/controllers/lab_controller.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LabView extends GetView<LabController> {
  const LabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabHeader(),
        _Divider(),
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFFFF8A5B),
            backgroundColor: const Color(0xFF0F0F0F),
            onRefresh: controller.loadTemplates,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  _ExploreProtocolsSection(),
                  SizedBox(height: 32.h),
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
// EXPLORE PROTOCOLS SECTION
// =============================================================================

class _ExploreProtocolsSection extends GetView<LabController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore Protocols',
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
                      'Start with a proven behavioral template.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.customProtocol),
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Obx(() {
            if (controller.isLoadingTemplates.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: const CircularProgressIndicator(
                    color: Color(0xFFFF8A5B),
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            if (controller.templates.isEmpty) {
              return _EmptyState(
                icon: Icons.explore_outlined,
                message: 'No templates available right now.',
              );
            }
            return Column(
              children: controller.templates
                  .map((t) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _TemplateCard(template: t, controller: controller),
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

// =============================================================================
// TEMPLATE CARD
// =============================================================================

class _TemplateCard extends StatelessWidget {
  final ExperimentTemplate template;
  final LabController controller;
  const _TemplateCard({required this.template, required this.controller});

  Color _categoryColor() {
    switch (template.category.toLowerCase()) {
      case 'discipline':  return const Color(0xFFFF8A5B);
      case 'attention':   return const Color(0xFF60A5FA);
      case 'execution':   return const Color(0xFFA78BFA);
      case 'energy':      return const Color(0xFF4ADE80);
      case 'social':      return const Color(0xFFFBBF24);
      default:            return const Color(0xFFFF8A5B);
    }
  }

  Color _categoryBg() {
    switch (template.category.toLowerCase()) {
      case 'discipline':  return const Color(0xFF261914);
      case 'attention':   return const Color(0xFF0D1F36);
      case 'execution':   return const Color(0xFF1A1427);
      case 'energy':      return const Color(0xFF0D2D1A);
      case 'social':      return const Color(0xFF2D2208);
      default:            return const Color(0xFF261914);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor();
    final catBg = _categoryBg();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: catBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    template.category,
                    style: TextStyle(
                      color: catColor,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${template.durationDays} days',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              template.title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '"${template.hypothesis}"',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.customProtocol,
                      arguments: template,
                    ),
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Customize',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Obx(() {
                    final isLaunching =
                        controller.launchingId.value == template.id;
                    return GestureDetector(
                      onTap: isLaunching
                          ? null
                          : () => controller.launchTemplate(template),
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: isLaunching
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: isLaunching
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.black),
                                )
                              : Text(
                                  'Launch now',
                                  style: TextStyle(
                                    color: const Color(0xFF0A0A0B),
                                    fontFamily: 'IBM Plex Sans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
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
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.2), size: 36.sp),
          SizedBox(height: 12.h),
          Text(
            message,
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
// HEADER
// =============================================================================

class _LabHeader extends GetView<LabController> {
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
                'THE LAB',
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
