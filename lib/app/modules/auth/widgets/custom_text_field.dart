import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String iconPath;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.iconPath,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF5A5A5A)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Image.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.text,
              obscureText: isPassword,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: const Color(0xFF888888),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
