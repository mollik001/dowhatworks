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
    return SafeArea(
      top: false,
      child: Container(
        height: 92.h,
        margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h),
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
                child: _NavContent(
                  key: ValueKey(i),
                  iconPath: 'assets/icons/nav${i + 1}.png',
                  label: _labels[i],
                  isSelected: selectedIndex == i,
                  onTap: () => onItemTap(i),
                ),
              ),
          ],
        ),
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
    super.key,
  });

  Color get _iconColor => isSelected ? _selectedColor : _unselectedColor;

  Widget _buildContent(BuildContext context, Color color) {
    return Column(
      key: ValueKey(color),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 24.w,
          height: 24.w,
          color: color,
        ),
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              label,
              style: TextStyle(
                color: color,
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              )
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: _buildContent(context, _iconColor),
          ),
        ),
      ),
    );
  }
}
