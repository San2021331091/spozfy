import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spozfy/models/comment_model.dart';



class CommentsSection extends StatefulWidget {
  final int channelId;
  const CommentsSection({super.key, required this.channelId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  static const _accent = Color(0xFFE53935);

  final _nameCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  final _commentFocus = FocusNode();

  List<CommentModel> _comments = [];
  String? _editingId; // non-null while editing an existing comment
  bool _loaded = false;

  String get _commentsKey => 'channel_comments_${widget.channelId}';
  static const _nameKey = 'comment_user_name';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _commentCtrl.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    // Remember the last name the user typed across channels.
    _nameCtrl.text = prefs.getString(_nameKey) ?? '';

    final raw = prefs.getString(_commentsKey);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List)
          .map((e) => CommentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      // Newest first.
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _comments = list;
    }
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _commentsKey,
      jsonEncode(_comments.map((e) => e.toJson()).toList()),
    );
    await prefs.setString(_nameKey, _nameCtrl.text.trim());
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingId != null) {
        final idx = _comments.indexWhere((c) => c.id == _editingId);
        if (idx != -1) {
          _comments[idx]
            ..name = name.isEmpty ? 'Guest' : name
            ..text = text;
        }
        _editingId = null;
      } else {
        _comments.insert(
          0,
          CommentModel(
            id: '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}',
            name: name.isEmpty ? 'Guest' : name,
            text: text,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    });

    _commentCtrl.clear();
    _commentFocus.unfocus();
    _persist();
  }

  void _startEdit(CommentModel c) {
    setState(() => _editingId = c.id);
    _nameCtrl.text = c.name;
    _commentCtrl.text = c.text;
    _commentFocus.requestFocus();
  }

  void _cancelEdit() {
    setState(() => _editingId = null);
    _commentCtrl.clear();
    _commentFocus.unfocus();
  }

  Future<void> _delete(CommentModel c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('Delete comment?',
            style: GoogleFonts.poppins(color: Colors.white)),
        content: Text('This can’t be undone.',
            style: GoogleFonts.poppins(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: _accent)),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        _comments.removeWhere((e) => e.id == c.id);
        if (_editingId == c.id) _cancelEdit();
      });
      _persist();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final editing = _editingId != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.forum_outlined, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text(
                'Comments (${_comments.length})',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Input card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: editing ? _accent.withValues(alpha: 0.6) : Colors.white12,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _nameCtrl,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    hint: 'Your name',
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentCtrl,
                  focusNode: _commentFocus,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: _fieldDecoration(
                    hint: editing ? 'Edit your comment…' : 'Write a comment…',
                    icon: Icons.chat_bubble_outline,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (editing)
                      TextButton(
                        onPressed: _cancelEdit,
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(color: Colors.white70)),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(editing ? Icons.check : Icons.send, size: 16),
                      label: Text(editing ? 'Update' : 'Post',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (_comments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No comments yet. Be the first!',
                  style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white10, height: 20),
              itemBuilder: (_, i) => _CommentTile(
                comment: _comments[i],
                onEdit: () => _startEdit(_comments[i]),
                onDelete: () => _delete(_comments[i]),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white38, size: 20),
      isDense: true,
      filled: true,
      fillColor: Colors.black26,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _accent, width: 1.2),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _CommentTile({
    required this.comment,
    required this.onEdit,
    required this.onDelete,
  });

  String _timeAgo(int ms) {
    final diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(ms));
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UserAvatar(name: comment.name),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      comment.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _timeAgo(comment.createdAt),
                    style: GoogleFonts.poppins(
                        color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                comment.text,
                style: GoogleFonts.poppins(
                    color: Colors.white70, fontSize: 13, height: 1.35),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          color: const Color(0xFF1E1E1E),
          icon: const Icon(Icons.more_vert, color: Colors.white38, size: 20),
          onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text('Edit', style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline,
                      color: Color(0xFFE53935), size: 18),
                  const SizedBox(width: 8),
                  Text('Delete',
                      style: GoogleFonts.poppins(color: const Color(0xFFE53935))),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom user icon: a colored circle with the user's initials,
/// where the color is derived deterministically from the name.
class _UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  const _UserAvatar({required this.name}) : size = 38;

  static const _palette = [
    Color(0xFFE57373), Color(0xFF64B5F6), Color(0xFF81C784),
    Color(0xFFFFB74D), Color(0xFFBA68C8), Color(0xFF4DB6AC),
    Color(0xFFF06292), Color(0xFF7986CB),
  ];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  Color get _color {
    if (name.trim().isEmpty) return _palette.first;
    final hash = name.codeUnits.fold<int>(0, (p, c) => p + c);
    return _palette[hash % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.65)],
        ),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}