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
      title: '1. My actions directly influence my outcomes.',
      sectionTitle: 'Do I Take Control?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'consistent',
      title: '2. Luck plays a larger role than effort',
      sectionTitle: 'Am I Consistent?',
      subtitle: 'Think about your recent habits and routines.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'failure',
      title: '3. I can change my situation through consistent action',
      sectionTitle: 'Do I Embrace Failure?',
      subtitle: 'How do you respond when things don\'t go as planned?',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'environment',
      title: '4. External forces determine most of what happens to me',
      sectionTitle: 'Is My Environment Supportive?',
      subtitle: 'Consider the spaces and people around you.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'track',
      title: '1. I can execute difficult tasks when necessary',
      sectionTitle: 'Can I Figure It Out?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'accountable',
      title: '2. I doubt my ability to follow through.',
      sectionTitle: 'Can I Figure It Out?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'feedback',
      title: '3. I can change my situation through consistent action',
      sectionTitle: 'Can I Figure It Out?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'identity',
      title: '4. I can handle setbacks and keep moving forward.',
      sectionTitle: 'Can I Figure It Out?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'deep_work',
      title: '1. I change my approach when results are poor',
      sectionTitle: 'Do I Prioritize Deep Work?',
      subtitle: 'Can you focus without distraction for long periods?',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'open_change',
      title: '2. I stick with methods even when they fail',
      sectionTitle: 'Am I Open to Change?',
      subtitle: 'This is your final calibration question.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'approach_change',
      title: '3. I adjust beliefs based on evidence',
      sectionTitle: 'Do I Prioritize Deep Work?',
      subtitle: 'Can you focus without distraction for long periods?',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'stick_methods',
      title: '4. I resist changing my views',
      sectionTitle: 'Am I Open to Change?',
      subtitle: 'This is your final calibration question.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'awareness',
      title: '1. I am aware of my daily behaviors',
      sectionTitle: 'Am I Self-Aware?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'decisions',
      title: '2. I understand why I make decisions',
      sectionTitle: 'Am I Self-Aware?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'reflect',
      title: '3. I act without reflecting',
      sectionTitle: 'Am I Self-Aware?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'patterns',
      title: '4. I notice patterns in my behavior',
      sectionTitle: 'Am I Self-Aware?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'follow_through',
      title: '1. I follow through consistently',
      sectionTitle: 'Do I Act?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'abandon_plans',
      title: '2. I abandon plans easily',
      sectionTitle: 'Do I Act?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'act_uncertain',
      title: '3. I act even when uncertain',
      sectionTitle: 'Do I Act?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'delay_action',
      title: '4. I delay taking action',
      sectionTitle: 'Do I Act?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'want_feedback',
      title: '1. I want accurate feedback, even if uncomfortable',
      sectionTitle: 'Do I Face Reality?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'avoid_contradiction',
      title: '2. I avoid information that contradicts me',
      sectionTitle: 'Do I Face Reality?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'confront_reality',
      title: '3. I confront reality directly',
      sectionTitle: 'Do I Face Reality?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'rationalize',
      title: '4. I rationalize poor results',
      sectionTitle: 'Do I Face Reality?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'letting_go',
      title: '1. Letting go and trusting the process is more effective than forcing outcomes',
      sectionTitle: 'Do I Avoid Action?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'trying_too_hard',
      title: '2. Trying too hard can block success',
      sectionTitle: 'Do I Avoid Action?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'stop_chasing',
      title: '3. Things come when you stop chasing them',
      sectionTitle: 'Do I Avoid Action?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'luck_major',
      title: '1. Luck plays a major role in success',
      sectionTitle: 'Do I Blame Outside?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'naturally_lucky',
      title: '2. Some people are naturally lucky',
      sectionTitle: 'Do I Blame Outside?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'right_place',
      title: '3. Success often depends on being in the right place at the right time',
      sectionTitle: 'Do I Blame Outside?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'thoughts_influence',
      title: '1. My thoughts influence reality in a direct way',
      sectionTitle: 'Do I Rely on Vibes?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'visualizing',
      title: '2. Visualizing outcomes helps bring them into existence',
      sectionTitle: 'Do I Rely on Vibes?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'energy_vibration',
      title: '3. Energy or vibration affects what happens to me',
      sectionTitle: 'Do I Rely on Vibes?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'trust_intuition',
      title: '1. I trust my intuition over data or evidence',
      sectionTitle: 'Do I Trust Feelings Over Facts?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'feelings_guide',
      title: '2. Feelings are a reliable guide to truth',
      sectionTitle: 'Do I Trust Feelings Over Facts?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
    Question(
      id: 'feels_right',
      title: '3. If something feels right, it usually is',
      sectionTitle: 'Do I Trust Feelings Over Facts?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      options: const ['Strong no', 'No', 'Neutral', 'Yes', 'Strong Yes'],
    ),
  ];

  late final List<QuestionPage> pages = [
    QuestionPage(
      title: 'Do I Take Control?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['control', 'consistent', 'failure', 'environment'],
    ),
    QuestionPage(
      title: 'Can I Figure It Out?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['track', 'accountable', 'feedback', 'identity'],
    ),
    QuestionPage(
      title: 'Do I Keep Going?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['deep_work', 'open_change', 'approach_change', 'stick_methods'],
    ),
    QuestionPage(
      title: 'Am I Self-Aware?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['awareness', 'decisions', 'reflect', 'patterns'],
    ),
    QuestionPage(
      title: 'Do I Act?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['follow_through', 'abandon_plans', 'act_uncertain', 'delay_action'],
    ),
    QuestionPage(
      title: 'Do I Face Reality?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['want_feedback', 'avoid_contradiction', 'confront_reality', 'rationalize'],
    ),
    QuestionPage(
      title: 'Do I Avoid Action?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['letting_go', 'trying_too_hard', 'stop_chasing'],
    ),
    QuestionPage(
      title: 'Do I Blame Outside?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['luck_major', 'naturally_lucky', 'right_place'],
    ),
    QuestionPage(
      title: 'Do I Rely on Vibes?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['thoughts_influence', 'visualizing', 'energy_vibration'],
    ),
    QuestionPage(
      title: 'Do I Trust Feelings Over Facts?',
      subtitle: 'Answer honestly. This calibrates your first experiment.',
      questionIds: const ['trust_intuition', 'feelings_guide', 'feels_right'],
    ),
  ];

  Question? getQuestion(String id) {
    try {
      return questions.firstWhere((q) => q.id == id);
    } on StateError {
      return null;
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void selectOption(String questionId, String option) {
    selectedOptions.assignAll({...selectedOptions, questionId: option});
  }

  void skip() {
    Get.offAllNamed(AppRoutes.game);
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
