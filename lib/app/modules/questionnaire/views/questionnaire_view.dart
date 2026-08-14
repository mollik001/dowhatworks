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
      backgroundColor: const Color(0xFF0A0A0A),
      body: PageView.builder(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.pages.length,
        itemBuilder: (context, pageIndex) {
          final page = controller.pages[pageIndex];
          final pageQuestions = page.questionIds
              .map(controller.getQuestion)
              .whereType<Question>()
              .toList();
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 65.h),
                Text(
                  'Belief audit · ${pageIndex + 1} of ${controller.pages.length}',
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
                  page.title,
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
                  page.subtitle,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 24.h),
                DashIndicator(
                  currentPage: pageIndex,
                  totalPages: controller.pages.length,
                ),
                SizedBox(height: 32.h),
                ...pageQuestions.map((question) => Padding(
                  padding: EdgeInsets.only(bottom: 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          height: 20.63 / 16,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildQuestionInput(question),
                    ],
                  ),
                )),
                SizedBox(height: 16.h),
                Obx(() => CustomButton(
                  text: controller.isLoading.value
                      ? 'Submitting...'
                      : (pageIndex == controller.pages.length - 1 ? 'Submit' : 'Next'),
                  onPressed: controller.isLoading.value
                      ? () {}
                      : () => controller.nextPage(),
                )),
                SizedBox(height: 16.h),
                Center(
                  child: GestureDetector(
                    onTap: () => controller.skip(),
                    child: Text(
                      'Skip',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        height: 16.5 / 14,
                        letterSpacing: 0,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
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
      return Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: question.options!.map((option) {
            final isSelected = controller.selectedOptions[question.id] == option;
            final labelIndex = question.options!.indexOf(option);
            final labels = const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => controller.selectOption(question.id, option),
                      child: Container(
                        width: double.infinity,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F0F),
                          border: Border.all(color: const Color(0xFF5A5A5A)),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: isSelected
                              ? Container(
                                  width: 11.w,
                                  height: 11.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF26B3A),
                                  ),
                                )
                              : Container(
                                  width: 11.w,
                                  height: 11.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 4.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      labels.length > labelIndex
                          ? labels[labelIndex]
                          : option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
                        height: 1.23,
                        letterSpacing: -0.22.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
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
