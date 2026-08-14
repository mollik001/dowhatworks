class ChatMessage {
  final String? id;
  final String text;
  final bool isUser; // true = sent by user, false = Daniel's reply
  final bool isProposal;
  final Map<String, dynamic>? proposalData;

  ChatMessage({
    this.id,
    required this.text,
    required this.isUser,
    this.isProposal = false,
    this.proposalData,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // API returns "sender": "user" or "sender": "daniel"
    final sender = json['sender'] as String? ?? '';
    return ChatMessage(
      id: json['id'] as String?,
      text: json['text'] as String? ?? '',
      isUser: sender == 'user',
      isProposal: json['is_proposal'] as bool? ?? false,
      proposalData: json['proposal_data'] as Map<String, dynamic>?,
    );
  }

  // Used to build an optimistic user bubble before the API responds
  factory ChatMessage.userMessage(String text) {
    return ChatMessage(text: text, isUser: true);
  }
}

class ChatSession {
  final int id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'] as List<dynamic>? ?? [];
    return ChatSession(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Conversation',
      messages: rawMessages
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
