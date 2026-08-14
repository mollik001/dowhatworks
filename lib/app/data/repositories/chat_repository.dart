import '../../../core/network/api_client.dart';
import '../../../core/values/constants.dart';
import '../models/chat_models.dart';
import '../services/storage_service.dart';

class ChatRepository {
  String get _token => StorageService.getAccessToken() ?? '';

  /// POST /api/v1/chat/sessions/
  /// Body: { "title": "..." }
  Future<ChatSession> createSession({String title = 'New Conversation'}) async {
    print('[Chat] createSession → POST ${ApiConstants.chatSessions}');
    final response = await ApiClient.post(
      ApiConstants.chatSessions,
      body: {'title': title},
      token: _token,
    );
    print('[Chat] createSession response: $response');
    return ChatSession.fromJson(response);
  }

  /// POST /api/v1/chat/sessions/{session_id}/messages/
  /// Body: { "sender": "user", "text": "...", "is_proposal": false, "proposal_data": {} }
  /// Saves the user message to the session history.
  Future<ChatMessage> sendMessage({
    required int sessionId,
    required String text,
  }) async {
    final endpoint = ApiConstants.chatMessages(sessionId);
    print('[Chat] sendMessage → POST $endpoint');
    final response = await ApiClient.post(
      endpoint,
      body: {
        'sender': 'user',
        'text': text,
        'is_proposal': false,
        'proposal_data': {},
      },
      token: _token,
    );
    print('[Chat] sendMessage response: $response');
    return ChatMessage.fromJson(response);
  }

  /// POST /api/v1/chat/sessions/{session_id}/messages/
  /// Body: { "sender": "daniel", "text": "...", "is_proposal": ..., "proposal_data": ... }
  /// Persists Daniel's AI reply to the session history.
  Future<ChatMessage> saveDanielMessage({
    required int sessionId,
    required String text,
    bool isProposal = false,
    Map<String, dynamic>? proposalData,
  }) async {
    final endpoint = ApiConstants.chatMessages(sessionId);
    print('[Chat] saveDanielMessage → POST $endpoint');
    final response = await ApiClient.post(
      endpoint,
      body: {
        'sender': 'daniel',
        'text': text,
        'is_proposal': isProposal,
        'proposal_data': proposalData ?? {},
      },
      token: _token,
    );
    print('[Chat] saveDanielMessage response: $response');
    return ChatMessage.fromJson(response);
  }

  /// POST /api/v1/chat/sessions/{session_id}/ask/
  /// Body: { "text": "..." }
  /// Gets Daniel's AI reply.
  Future<ChatMessage> askDaniel({
    required int sessionId,
    required String text,
  }) async {
    final endpoint = ApiConstants.chatAsk(sessionId);
    print('[Chat] askDaniel → POST $endpoint');
    final response = await ApiClient.post(
      endpoint,
      body: {'text': text},
      token: _token,
    );
    print('[Chat] askDaniel response: $response');
    return ChatMessage(
      text: response['text'] as String? ?? '',
      isUser: false,
      isProposal: response['is_proposal'] as bool? ?? false,
      proposalData: response['proposal_data'] as Map<String, dynamic>?,
    );
  }

  /// GET /api/v1/chat/sessions/{session_id}/
  /// Fetches full session details including messages.
  Future<ChatSession> getSession(int sessionId) async {
    final endpoint = ApiConstants.chatSession(sessionId);
    print('[Chat] getSession → GET $endpoint');
    final response = await ApiClient.get(endpoint, token: _token);
    print('[Chat] getSession response: $response');
    final session = ChatSession.fromJson(response);
    print('[Chat] getSession parsed → id=${session.id}, messages=${session.messages.length}');
    for (final m in session.messages) {
      print('[Chat]   msg: isUser=${m.isUser} | text="${m.text}"');
    }
    return session;
  }

  /// GET /api/v1/chat/sessions/
  /// Returns the list of all past sessions.
  Future<List<ChatSession>> getSessions() async {
    print('[Chat] getSessions → GET ${ApiConstants.chatSessions}');
    final response = await ApiClient.get(ApiConstants.chatSessions, token: _token);
    print('[Chat] getSessions raw response keys: ${response.keys.toList()}');

    final rawList = response['data'] as List<dynamic>?
        ?? response['results'] as List<dynamic>?
        ?? <dynamic>[];
    print('[Chat] getSessions parsed ${rawList.length} sessions');
    final sessions = rawList
        .map((e) => ChatSession.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final s in sessions) {
      print('[Chat]   session id=${s.id} title="${s.title}" messages=${s.messages.length}');
    }
    return sessions;
  }
}
