import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPages, (index) {
        final isActive = index <= currentPage;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < totalPages - 1 ? 8.w : 0,
            ),
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFF26B3A) : const Color(0xFF949596),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
        );
      }),
    );
  }
}
