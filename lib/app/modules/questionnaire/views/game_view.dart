import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../onboarding/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/game.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 80.h, left: 24.w, right: 24.w),
                child: CustomButton(
                  text: 'Begin test',
                  onPressed: () => Get.toNamed(AppRoutes.digitSpan),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
