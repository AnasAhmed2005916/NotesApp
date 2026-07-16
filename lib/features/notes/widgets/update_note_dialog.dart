import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/models/note_model.dart';
import 'package:last_version/features/notes/services/note_services.dart';


class UpdateNoteDialogWidget extends StatefulWidget {
  final NoteModel note;

  const UpdateNoteDialogWidget({super.key, required this.note});

  @override
  State<UpdateNoteDialogWidget> createState() => _UpdateNoteDialogWidgetState();
}

class _UpdateNoteDialogWidgetState extends State<UpdateNoteDialogWidget> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final NoteService noteService = NoteService();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Note"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController),
          const SizedBox(height: 10),
          TextField(controller: descriptionController),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            context.read<NoteCubit>().updateNote(
              NoteModel(
                id: widget.note.id,
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                userId: widget.note.userId,
                createdAt: widget.note.createdAt,
              ),
            );

            Navigator.pop(context);
          },
          child: const Text("Update"),
        ),
      ],
    );
  }
}
