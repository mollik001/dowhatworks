import 'package:dowhatworks/app/modules/profile/controllers/profile_controller.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
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
                          fontSize: 20.sp,
                        ),
                      )),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          UserService.to.username.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 24.sp,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        )),
                        SizedBox(height: 4.h),
                        Obx(() => Text(
                          UserService.to.email.value,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        )),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999.r),
                            border: Border.all(color: const Color(0xFF1B4A39), width: 1),
                            color: Colors.transparent,
                          ),
                          child: Text(
                            'Prime member',
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
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildSubscriptionCard(),
          SizedBox(height: 16.h),
          _buildAssessmentCard(),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
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
              'Subscription',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                height: 1.5,
                letterSpacing: 1.65,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 32.sp,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'days left',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'Your Elite access is active. You have full access to Daniel and live experiment tracking.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                height: 1.626,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF8A5B), width: 1.5),
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.person_outline,
                color: const Color(0xFFFF8A5B),
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Retake baseline assessment',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
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
        Container(
          width: 32.w,
          height: 32.h,
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
