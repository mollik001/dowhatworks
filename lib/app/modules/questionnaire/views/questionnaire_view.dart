import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../onboarding/widgets/custom_button.dart';
import '../controllers/questionnaire_controller.dart';
import '../models/question_model.dart';

class QuestionnaireView extends GetView<QuestionnaireController> {
  const QuestionnaireView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.questions.length,
        itemBuilder: (context, index) {
          final question = controller.questions[index];
          final isLast = index == controller.questions.length - 1;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 65.h),
                Text(
                  'Belief audit · ${index + 1} of ${controller.questions.length}',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    height: 16.5 / 12,
                    letterSpacing: 1.98.sp,
                    color: const Color(0xFFF26B3A),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  question.title,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 20.sp,
                    height: 1.0,
                    letterSpacing: -0.73.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  question.subtitle,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 24.h),
                DashIndicator(
                  currentPage: index,
                  totalPages: controller.questions.length,
                ),
                SizedBox(height: 32.h),
                _buildQuestionInput(question),
                SizedBox(height: 24.h),
                CustomButton(
                  text: isLast ? 'FINISH' : 'NEXT',
                  onPressed: () => controller.nextPage(),
                ),
                SizedBox(height: 70.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionInput(Question question) {
    if (question.options != null && question.options!.isNotEmpty) {
      return Column(
        children: question.options!.map((option) {
          final isSelected = controller.selectedOptions[question.id] == option;
          return GestureDetector(
            onTap: () => controller.selectOption(question.id, option),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0x33F16B3A) : const Color(0xFF1A1A1A),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF16B3A) : const Color(0xFF5A5A5A),
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.0,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF5A5A5A)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: question.controller,
        keyboardType: question.keyboardType ?? TextInputType.text,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans',
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: question.hint,
          hintStyle: TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: const Color(0xFF888888),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}

class DashIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const DashIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPages, (index) {
        final isCurrent = index == currentPage;
        final isCompleted = index < currentPage;
        final color = isCurrent
            ? const Color(0xFF7F3A23)
            : isCompleted
                ? const Color(0xFFF16B3A)
                : const Color(0xFF222222);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < totalPages - 1 ? 10.w : 0,
            ),
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
        );
      }),
    );
  }
}
