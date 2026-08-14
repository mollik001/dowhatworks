import 'package:dowhatworks/app/data/models/chat_models.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/modules/daniel/controllers/daniel_controller.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DanielView extends GetView<DanielController> {
  const DanielView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.inChat
        ? _ChatScreen(controller: controller)
        : _LandingScreen(controller: controller));
  }
}

// =============================================================================
// LANDING SCREEN
// =============================================================================

class _LandingScreen extends StatelessWidget {
  final DanielController controller;
  const _LandingScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(controller: controller, showHistory: true),
        _Divider(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                Center(
                  child: Image.asset('assets/icons/ai.png', width: 64.w, height: 64.w),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Unlock your potential',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 31.sp,
                    height: 1.5,
                    letterSpacing: -0.77,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'State a belief, a problem, or a habit you\'d like to optimize. Daniel turns it into a testable experiment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.625,
                  ),
                ),
                SizedBox(height: 32.h),
                _SuggestionsGrid(controller: controller),
                SizedBox(height: 24.h),
                _InputBar(controller: controller, onSend: () {
                  final text = controller.messageController.text.trim();
                  if (text.isNotEmpty) controller.startChat(text);
                }),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CHAT SCREEN
// =============================================================================

class _ChatScreen extends StatelessWidget {
  final DanielController controller;
  const _ChatScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(controller: controller, showHistory: true, showBack: true),
        _Divider(),
        Expanded(
          child: Obx(() {
            final msgs = controller.messages;
            return ListView.builder(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: msgs.length + (controller.isSending.value ? 1 : 0),
              itemBuilder: (context, index) {
                // Typing indicator at the end
                if (index == msgs.length) return _TypingIndicator();
                return _MessageBubble(message: msgs[index]);
              },
            );
          }),
        ),
        _InputBar(
          controller: controller,
          onSend: controller.sendMessage,
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 8.h : 16.h),
      ],
    );
  }
}

// =============================================================================
// MESSAGE BUBBLE
// =============================================================================

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28.w,
              height: 28.w,
              margin: EdgeInsets.only(right: 8.w),
              child: Image.asset('assets/icons/ai.png'),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Main message bubble
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF843D23).withValues(alpha: 0.35)
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                      bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                    ),
                    border: Border.all(
                      color: isUser
                          ? const Color(0xFF843D23).withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.06),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white
                          .withValues(alpha: isUser ? 0.95 : 0.85),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 1.6,
                    ),
                  ),
                ),

                // Proposal card — shown below Daniel's message when isProposal
                if (!isUser &&
                    message.isProposal &&
                    message.proposalData != null &&
                    message.proposalData!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  _ProposalCard(proposalData: message.proposalData!),
                ],
              ],
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            Obx(() => Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3A1E14),
                    border:
                        Border.all(color: const Color(0xFF843D23), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      UserService.to.initial,
                      style: TextStyle(
                        color: const Color(0xFFFF8A5B),
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// PROPOSAL CARD
// =============================================================================

class _ProposalCard extends StatelessWidget {
  final Map<String, dynamic> proposalData;
  const _ProposalCard({required this.proposalData});

  @override
  Widget build(BuildContext context) {
    final hypothesis = proposalData['hypothesis'] as String? ?? '';
    final action = proposalData['action'] as String? ?? '';
    final metric = proposalData['metric'] as String? ?? '';
    final duration = proposalData['duration'] as String? ?? '';
    final durationLabel =
        duration.isNotEmpty ? (duration.contains('day') ? duration : '$duration days') : '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C1612),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF154231), width: 1),
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Image.asset('assets/icons/ai.png', width: 16.w, height: 16.w),
              SizedBox(width: 6.w),
              Text(
                'Experiment Proposal',
                style: TextStyle(
                  color: const Color(0xFF6EE7B7),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          _ProposalRow(label: 'HYPOTHESIS', value: hypothesis),
          _ProposalRow(label: 'ACTION', value: action),
          _ProposalRow(label: 'METRIC', value: metric),
          if (durationLabel.isNotEmpty)
            _ProposalRow(label: 'DURATION', value: durationLabel),

          SizedBox(height: 12.h),

          // Convert button — wraps content, not full width
          GestureDetector(
            onTap: () => Get.toNamed(
              AppRoutes.customProtocol,
              arguments: {
                'hypothesis': hypothesis,
                'action': action,
                'metric': metric,
                'duration': duration,
              },
            ),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.science_outlined,
                      color: Colors.black, size: 14.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Convert to Experiment',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProposalRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProposalRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label  ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              fontSize: 9.sp,
              letterSpacing: 0.5,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 11.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TYPING INDICATOR
// =============================================================================

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            margin: EdgeInsets.only(right: 8.w),
            child: Image.asset('assets/icons/ai.png'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
            ),
            child: Row(
              children: [
                _Dot(delay: 0),
                SizedBox(width: 4.w),
                _Dot(delay: 150),
                SizedBox(width: 4.w),
                _Dot(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = Tween(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _anim.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 6.w,
        height: 6.w,
        decoration: const BoxDecoration(
          color: Color(0xFFFF8A5B),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// =============================================================================
// SUGGESTIONS GRID
// =============================================================================

class _SuggestionsGrid extends StatelessWidget {
  final DanielController controller;
  const _SuggestionsGrid({required this.controller});

  static const _suggestions = [
    'I believe I work better at night.',
    'Testing my morning coffee routine..',
    "I'm procrastinating on my project.",
    'Is my diet affecting my focus?',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _suggestions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => controller.useSuggestion(_suggestions[index]),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
            ),
            padding: EdgeInsets.all(12.w),
            child: Text(
              _suggestions[index],
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 1.375,
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// INPUT BAR
// =============================================================================

class _InputBar extends StatelessWidget {
  final DanielController controller;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    hintText: 'Type a belief or habit...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(() {
                final loading = controller.isSending.value || controller.isCreatingSession.value;
                return GestureDetector(
                  onTap: loading ? null : onSend,
                  child: Container(
                    width: 41.w,
                    height: 41.h,
                    decoration: BoxDecoration(
                      color: loading ? Colors.white.withValues(alpha: 0.4) : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: loading
                        ? Center(
                            child: SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Icon(Icons.arrow_upward_rounded, color: Colors.black, size: 20.sp),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _Header extends StatelessWidget {
  final DanielController controller;
  final bool showHistory;
  final bool showBack;

  const _Header({
    required this.controller,
    this.showHistory = false,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: controller.backToLanding,
              child: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Icon(Icons.arrow_back_ios_new,
                    color: Colors.white.withValues(alpha: 0.7), size: 18.sp),
              ),
            ),
          Image.asset('assets/icons/top_logo.png', width: 32.w, height: 32.w),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daniel',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
              Text(
                'AI Coach',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  height: 1.5,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (showHistory)
            GestureDetector(
              onTap: () => _showSessionsSheet(context, controller),
              child: Icon(Icons.history_rounded,
                  color: Colors.white.withValues(alpha: 0.5), size: 22.sp),
            ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profile),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF843D23), width: 1.5),
                color: const Color(0xFF3A1E14),
              ),
              child: Center(
                child: Obx(() => Text(
                  UserService.to.initial,
                  style: TextStyle(
                    color: const Color(0xFFFF8A5B),
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSessionsSheet(BuildContext context, DanielController ctrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F0F0F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => _SessionsSheet(controller: ctrl),
    );
  }
}

// =============================================================================
// SESSIONS HISTORY BOTTOM SHEET
// =============================================================================

class _SessionsSheet extends StatelessWidget {
  final DanielController controller;
  const _SessionsSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Past Conversations',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  controller.backToLanding();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '+ New chat',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.isLoadingSessions.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: const CircularProgressIndicator(
                    color: Color(0xFFFF8A5B), strokeWidth: 2,
                  ),
                ),
              );
            }
            if (controller.sessions.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text(
                    'No conversations yet',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              );
            }
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 320.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.sessions.length,
                separatorBuilder: (_, __) => Divider(
                  color: Colors.white.withValues(alpha: 0.06),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final session = controller.sessions[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                    leading: Icon(Icons.chat_bubble_outline_rounded,
                        color: const Color(0xFFFF8A5B), size: 18.sp),
                    title: Text(
                      session.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 13.sp,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(session.updatedAt),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 11.sp,
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      controller.openSession(session);
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
        height: 1,
      ),
    );
  }
}
