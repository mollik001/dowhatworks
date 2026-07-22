import 'package:flutter/material.dart';

class QuestionPage {
  final String title;
  final String subtitle;
  final List<String> questionIds;

  const QuestionPage({
    required this.title,
    required this.subtitle,
    required this.questionIds,
  });
}

class Question {
  final String id;
  final String title;
  final String? sectionTitle;
  final String subtitle;
  final String? hint;
  final List<String>? options;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  Question({
    required this.id,
    required this.title,
    this.sectionTitle,
    required this.subtitle,
    this.hint,
    this.options,
    this.keyboardType,
    this.controller,
  });
}
