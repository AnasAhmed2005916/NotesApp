import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/models/note_model.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});
  final NoteModel? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descriptionController.text = widget.note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();
              if (title.isEmpty || description.isEmpty) {
                return;
              }
              if (widget.note == null) {
                final note = NoteModel(
                  id: '',
                  title: title,
                  description: description,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  createdAt: DateTime.now(),
                );
                final success = await context.read<NoteCubit>().addNote(note);

                if (success && mounted) {
                  Navigator.pop(context);
                }
              } else {
                final updatedNote = NoteModel(
                  id: widget.note!.id,
                  title: title,
                  description: description,
                  userId: widget.note!.userId,
                  createdAt: widget.note!.createdAt,
                );
                await context.read<NoteCubit>().updateNote(updatedNote);

                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                expands: true,
                maxLines: null,
                minLines: null,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "Note",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
