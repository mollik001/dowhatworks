import 'package:flutter/material.dart';

class Question {
  final String id;
  final String title;
  final String subtitle;
  final String? hint;
  final List<String>? options;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  Question({
    required this.id,
    required this.title,
    required this.subtitle,
    this.hint,
    this.options,
    this.keyboardType,
    this.controller,
  });
}
