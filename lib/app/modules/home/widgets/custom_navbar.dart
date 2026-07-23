import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  static const _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E10),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _itemCount; i++)
            Expanded(
              child: Center(
                child: _NavContent(
                  iconPath: 'assets/icons/nav${i + 1}.png',
                  label: _labels[i],
                  isSelected: selectedIndex == i,
                  onTap: () => onItemTap(i),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const _labels = ['Home', 'Daniel', 'Lab', 'Results'];
}

class _NavContent extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const _selectedColor = Color(0xFF000000);
  static const _unselectedColor = Color(0xFF7B7B7C);

  const _NavContent({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  Color get _iconColor => isSelected ? _selectedColor : _unselectedColor;

  Widget _buildSelected() {
    return Container(
      width: 94.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 24.w,
            height: 24.w,
            color: _selectedColor,
          ),
          if (label.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                label,
                style: TextStyle(
                  color: _selectedColor,
                  fontSize: 12.sp,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUnselected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 24.w,
          height: 24.w,
          color: _unselectedColor,
        ),
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              label,
              style: TextStyle(
                color: _unselectedColor,
                fontSize: 12.sp,
                height: 1,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(child: isSelected ? _buildSelected() : _buildUnselected()),
    );
  }
}
