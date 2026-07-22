import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import '../models/question_model.dart';

class QuestionnaireController extends GetxController {
  final currentPage = 0.obs;
  final PageController pageController = PageController();
  final selectedOptions = <String, String>{}.obs;

  late final List<Question> questions = [
    Question(
      id: 'control',
      title: 'Do I Take Control?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'consistent',
      title: 'Am I Consistent?',
      subtitle: 'Think about your recent habits and routines.',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'failure',
      title: 'Do I Embrace Failure?',
      subtitle: 'How do you respond when things don\'t go as planned?',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'environment',
      title: 'Is My Environment Supportive?',
      subtitle: 'Consider the spaces and people around you.',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'track',
      title: 'Do I Track Progress?',
      subtitle: 'Do you measure and review your outcomes?',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'accountable',
      title: 'Am I Accountable?',
      subtitle: 'Do you own your results without blaming external factors?',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'feedback',
      title: 'Do I Value Feedback?',
      subtitle: 'How do you react to constructive criticism?',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'identity',
      title: 'Is My Identity Aligned?',
      subtitle: 'Do your actions reflect who you want to become?',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'deep_work',
      title: 'Do I Prioritize Deep Work?',
      subtitle: 'Can you focus without distraction for long periods?',
      options: ['Yes', 'No', 'Sometimes'],
    ),
    Question(
      id: 'open_change',
      title: 'Am I Open to Change?',
      subtitle: 'This is your final calibration question.',
      options: ['Yes', 'No', 'Sometimes'],
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < questions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void selectOption(String questionId, String option) {
    selectedOptions[questionId] = option;
  }

  void skip() {
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    pageController.dispose();
    for (final q in questions) {
      q.controller?.dispose();
    }
    super.onClose();
  }
}
