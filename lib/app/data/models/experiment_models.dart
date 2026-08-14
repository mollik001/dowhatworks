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
