class Experiment {
  final int id;
  final String hypothesis;
  final String action;
  final String metric;
  final int durationDays;
  final String? status;
  final String? startDate;
  final List<ExperimentLog> logs;
  final DateTime? createdAt;

  Experiment({
    required this.id,
    required this.hypothesis,
    required this.action,
    required this.metric,
    required this.durationDays,
    this.status,
    this.startDate,
    this.logs = const [],
    this.createdAt,
  });

  bool get isActive => status == 'active';
  bool get isQueued => status == 'queued';

  /// Number of calendar days elapsed since start_date (capped at durationDays)
  int get elapsedDays {
    if (startDate == null) return 0;
    final start = DateTime.tryParse(startDate!);
    if (start == null) return 0;
    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(DateTime(start.year, start.month, start.day))
        .inDays + 1;
    return diff.clamp(0, durationDays);
  }

  /// Number of logs that have been completed (not pending)
  int get completedLogsCount =>
      logs.where((l) => l.completed != 'pending').length;

  factory Experiment.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['logs'] as List<dynamic>? ?? [];
    return Experiment(
      id: json['id'] as int,
      hypothesis: json['hypothesis'] as String? ?? '',
      action: json['action'] as String? ?? '',
      metric: json['metric'] as String? ?? '',
      durationDays: json['duration_days'] as int? ?? 7,
      status: json['status'] as String?,
      startDate: json['start_date'] as String?,
      logs: rawLogs
          .map((l) => ExperimentLog.fromJson(l as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

class ExperimentLog {
  final int id;
  final String date;
  final String completed; // "pending", "yes", "no"
  final double metricValue;
  final String notes;
  final String dailyObservation;
  final String aiSuggestion;
  final DateTime? createdAt;

  ExperimentLog({
    required this.id,
    required this.date,
    required this.completed,
    required this.metricValue,
    required this.notes,
    required this.dailyObservation,
    required this.aiSuggestion,
    this.createdAt,
  });

  factory ExperimentLog.fromJson(Map<String, dynamic> json) {
    return ExperimentLog(
      id: json['id'] as int,
      date: json['date'] as String? ?? '',
      completed: json['completed'] as String? ?? 'pending',
      metricValue: (json['metric_value'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
      dailyObservation: json['daily_observation'] as String? ?? '',
      aiSuggestion: json['ai_suggestion'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

class ExperimentDetail {
  final int id;
  final String hypothesis;
  final String action;
  final String metric;
  final int durationDays;
  final String? status;
  final String? startDate;
  final List<ExperimentLog> logs;
  final String? aiAnalysis;
  final DateTime? createdAt;

  ExperimentDetail({
    required this.id,
    required this.hypothesis,
    required this.action,
    required this.metric,
    required this.durationDays,
    this.status,
    this.startDate,
    required this.logs,
    this.aiAnalysis,
    this.createdAt,
  });

  bool get isActive => status == 'active';

  /// Number of calendar days elapsed since start_date (capped at durationDays)
  int get elapsedDays {
    if (startDate == null) return 0;
    final start = DateTime.tryParse(startDate!);
    if (start == null) return 0;
    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(DateTime(start.year, start.month, start.day))
        .inDays + 1;
    return diff.clamp(0, durationDays);
  }

  /// How many logs are completed (not pending)
  int get completedLogs =>
      logs.where((l) => l.completed != 'pending').length;

  /// Average metric value across all logs that have a value
  double get avgMetricValue {
    if (logs.isEmpty) return 0;
    final total = logs.fold<double>(0, (sum, l) => sum + l.metricValue);
    return total / logs.length;
  }

  factory ExperimentDetail.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['logs'] as List<dynamic>? ?? [];
    return ExperimentDetail(
      id: json['id'] as int,
      hypothesis: json['hypothesis'] as String? ?? '',
      action: json['action'] as String? ?? '',
      metric: json['metric'] as String? ?? '',
      durationDays: json['duration_days'] as int? ?? 7,
      status: json['status'] as String?,
      startDate: json['start_date'] as String?,
      logs: rawLogs
          .map((l) => ExperimentLog.fromJson(l as Map<String, dynamic>))
          .toList(),
      aiAnalysis: json['ai_analysis'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

class TemplateMetric {
  final String id;
  final String label;
  final String type;

  TemplateMetric({
    required this.id,
    required this.label,
    required this.type,
  });

  factory TemplateMetric.fromJson(Map<String, dynamic> json) {
    return TemplateMetric(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

class ExperimentTemplate {
  final String id;
  final String title;
  final String category;
  final int durationDays;
  final String hypothesis;
  final String action;
  final List<TemplateMetric> metrics;

  ExperimentTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.durationDays,
    required this.hypothesis,
    required this.action,
    required this.metrics,
  });

  factory ExperimentTemplate.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'] as List<dynamic>? ?? [];
    return ExperimentTemplate(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      durationDays: json['duration_days'] as int? ?? 7,
      hypothesis: json['hypothesis'] as String? ?? '',
      action: json['action'] as String? ?? '',
      metrics: rawMetrics
          .map((m) => TemplateMetric.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}


class BaselineEntry {
  final int id;
  final double attentionScore;
  final int capacityScore;
  final double controlScore;
  final double enduranceScore;
  final DateTime createdAt;

  BaselineEntry({
    required this.id,
    required this.attentionScore,
    required this.capacityScore,
    required this.controlScore,
    required this.enduranceScore,
    required this.createdAt,
  });

  factory BaselineEntry.fromJson(Map<String, dynamic> json) {
    return BaselineEntry(
      id: json['id'] as int,
      attentionScore: (json['attention_score'] as num?)?.toDouble() ?? 0.0,
      capacityScore: (json['capacity_score'] as num?)?.toInt() ?? 0,
      controlScore: (json['control_score'] as num?)?.toDouble() ?? 0.0,
      enduranceScore: (json['endurance_score'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}


class OnboardingData {
  final Map<String, int> answers;

  OnboardingData({required this.answers});

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    final raw = json['answers'] as Map<String, dynamic>? ?? {};
    return OnboardingData(
      answers: raw.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }

  /// The 10 belief sections from the questionnaire, each with its question keys
  static const List<({String label, List<String> keys})> sections = [
    (label: 'Take Control',  keys: ['control', 'consistent', 'failure', 'environment']),
    (label: 'Figure It Out', keys: ['track', 'accountable', 'feedback', 'identity']),
    (label: 'Keep Going',    keys: ['deep_work', 'open_change', 'approach_change', 'stick_methods']),
    (label: 'Self-Aware',    keys: ['awareness', 'decisions', 'reflect', 'patterns']),
    (label: 'Do I Act',      keys: ['follow_through', 'abandon_plans', 'act_uncertain', 'delay_action']),
    (label: 'Face Reality',  keys: ['want_feedback', 'avoid_contradiction', 'confront_reality', 'rationalize']),
    (label: 'Avoid Action',  keys: ['letting_go', 'trying_too_hard', 'stop_chasing']),
    (label: 'Blame Outside', keys: ['luck_major', 'naturally_lucky', 'right_place']),
    (label: 'Rely on Vibes', keys: ['thoughts_influence', 'visualizing', 'energy_vibration']),
    (label: 'Trust Feelings',keys: ['trust_intuition', 'feelings_guide', 'feels_right']),
  ];

  /// Returns a 0.0–1.0 score per section (average answer / 4)
  List<double> get sectionScores {
    return sections.map((s) {
      final vals = s.keys
          .map((k) => answers[k] ?? 0)
          .toList();
      if (vals.isEmpty) return 0.0;
      return vals.reduce((a, b) => a + b) / (vals.length * 4.0);
    }).toList();
  }
}
