import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_models.dart';
import '../../../data/repositories/chat_repository.dart';

class DanielController extends GetxController {
  final _repo = ChatRepository();

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final currentSession = Rxn<ChatSession>();
  final messages = <ChatMessage>[].obs;
  final sessions = <ChatSession>[].obs;

  final isCreatingSession = false.obs;
  final isSending = false.obs;
  final isLoadingSessions = false.obs;

  bool get inChat => currentSession.value != null;

  @override
  void onInit() {
    super.onInit();
    print('[Daniel] onInit → loading sessions');
    _loadSessionsAndOpenLast();
  }

  Future<void> _loadSessionsAndOpenLast() async {
    isLoadingSessions.value = true;
    try {
      final result = await _repo.getSessions();
      sessions.value = result;
      print('[Daniel] loadSessions got ${result.length} sessions');

      // Auto-open the most recent session
      if (result.isNotEmpty) {
        await openSession(result.first);
      }
    } catch (e) {
      print('[Daniel] loadSessions ERROR: $e');
    } finally {
      isLoadingSessions.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> startChat(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    print('[Daniel] startChat: "$trimmed"');
    messageController.clear();
    isCreatingSession.value = true;

    try {
      // Use the first message as the session title (truncated to 60 chars)
      final title = trimmed.length > 60 ? '${trimmed.substring(0, 60)}...' : trimmed;
      final session = await _repo.createSession(title: title);
      print('[Daniel] Session created: id=${session.id} title="$title"');
      currentSession.value = session;
      messages.clear();
      messages.add(ChatMessage.userMessage(trimmed));
      _scrollToBottom();
      await _sendToSession(trimmed);
    } catch (e) {
      print('[Daniel] startChat ERROR: $e');
      Get.snackbar('Error', e.toString(),
          backgroundColor: const Color(0xFF1A1A1A),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      currentSession.value = null;
      messages.clear();
    } finally {
      isCreatingSession.value = false;
    }
  }

  Future<void> sendMessage() async {
    final trimmed = messageController.text.trim();
    if (trimmed.isEmpty || isSending.value) return;
    if (currentSession.value == null) {
      await startChat(trimmed);
      return;
    }
    print('[Daniel] sendMessage in session id=${currentSession.value!.id}: "$trimmed"');
    messageController.clear();
    messages.add(ChatMessage.userMessage(trimmed));
    _scrollToBottom();
    await _sendToSession(trimmed);
  }

  Future<void> _sendToSession(String text) async {
    isSending.value = true;
    final sessionId = currentSession.value!.id;
    print('[Daniel] _sendToSession: sessionId=$sessionId text="$text"');
    try {
      // Step 1: Save the user message via POST /messages/
      final saved = await _repo.sendMessage(sessionId: sessionId, text: text);
      print('[Daniel] User message saved: id=${saved.id}');

      // Step 2: Get Daniel's AI reply via POST /ask/
      print('[Daniel] Asking Daniel for reply...');
      final reply = await _repo.askDaniel(sessionId: sessionId, text: text);
      print('[Daniel] Daniel replied: "${reply.text}" isProposal=${reply.isProposal}');

      // Step 3: Persist Daniel's reply via POST /messages/ so it appears in session history
      print('[Daniel] Saving Daniel reply to session history...');
      final savedReply = await _repo.saveDanielMessage(
        sessionId: sessionId,
        text: reply.text,
        isProposal: reply.isProposal,
        proposalData: reply.proposalData,
      );
      print('[Daniel] Daniel reply saved: id=${savedReply.id}');

      // Use the saved reply (has a proper server-assigned id) for the local list
      messages.add(savedReply);
      _scrollToBottom();
      loadSessions();
    } catch (e) {
      print('[Daniel] _sendToSession ERROR: $e');
      Get.snackbar('Error', e.toString(),
          backgroundColor: const Color(0xFF1A1A1A),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> loadSessions() async {
    isLoadingSessions.value = true;
    print('[Daniel] loadSessions...');
    try {
      final result = await _repo.getSessions();
      print('[Daniel] loadSessions got ${result.length} sessions');
      sessions.value = result;
    } catch (e) {
      print('[Daniel] loadSessions ERROR: $e');
    } finally {
      isLoadingSessions.value = false;
    }
  }

  Future<void> openSession(ChatSession session) async {
    print('[Daniel] openSession: id=${session.id} localMessages=${session.messages.length}');
    currentSession.value = session;
    messages.assignAll(session.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Fetch full session via GET /sessions/{id}/
    try {
      final full = await _repo.getSession(session.id);
      print('[Daniel] openSession fetched: ${full.messages.length} messages');
      currentSession.value = full;
      messages.assignAll(full.messages);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      print('[Daniel] openSession fetch ERROR: $e');
    }
  }

  void backToLanding() {
    print('[Daniel] backToLanding');
    currentSession.value = null;
    messages.clear();
    messageController.clear();
    loadSessions();
  }

  void useSuggestion(String text) {
    messageController.text = text;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
