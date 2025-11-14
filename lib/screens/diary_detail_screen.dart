import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiaryDetailScreen extends StatefulWidget {
  final String noteId;

  const DiaryDetailScreen({super.key, required this.noteId});

  @override
  DiaryDetailScreenState createState() => DiaryDetailScreenState();
}

class DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Timer? _debounce;
  late Future<DocumentSnapshot> _noteFuture;

  @override
  void initState() {
    super.initState();
    _noteFuture = FirebaseFirestore.instance.collection('notes').doc(widget.noteId).get();
    _noteFuture.then((snapshot) {
      if (snapshot.exists) {
        final noteData = snapshot.data() as Map<String, dynamic>;
        _titleController.text = noteData['title'] ?? '';
        _contentController.text = noteData['content'] ?? '';

        _titleController.addListener(_onTextChanged);
        _contentController.addListener(_onTextChanged);
      }
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _saveNote();
    });
  }

  Future<void> _saveNote() async {
    await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).update({
      'title': _titleController.text,
      'content': _contentController.text,
      'timestamp': FieldValue.serverTimestamp(), 
    });
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry?'),
        content: const Text('Are you sure you want to delete this diary entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).delete();
      if(mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteNote,
            tooltip: 'Delete Entry',
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _noteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Note not found.'));
          }

          final noteData = snapshot.data!.data() as Map<String, dynamic>;
          final timestamp = noteData['timestamp'] as Timestamp?;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timestamp != null
                      ? 'Last updated ${timeago.format(timestamp.toDate())}'
                      : 'No date',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write something...',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
