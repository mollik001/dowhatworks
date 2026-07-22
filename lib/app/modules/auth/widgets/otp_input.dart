import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpInput extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpInput({
    super.key,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<String> _previousValues = List.generate(6, (_) => '');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          width: 48.w,
          height: 56.h,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF5A5A5A)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: widget.controllers[index],
            focusNode: widget.focusNodes[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 5) {
                widget.focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && _previousValues[index].isNotEmpty && index > 0) {
                widget.focusNodes[index - 1].requestFocus();
              }
              _previousValues[index] = value;
            },
          ),
        );
      }),
    );
  }
}
