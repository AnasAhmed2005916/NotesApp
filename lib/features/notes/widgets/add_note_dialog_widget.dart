import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/core/helpers/dialogs.dart';
import 'package:last_version/features/auth/widgets/custom_text_form_field.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/models/note_model.dart';
import 'package:last_version/features/notes/services/note_services.dart';

class AddNoteDialogWidget extends StatefulWidget {
  const AddNoteDialogWidget({super.key});

  @override
  State<AddNoteDialogWidget> createState() => _AddNoteDialogWidgetState();
}

class _AddNoteDialogWidgetState extends State<AddNoteDialogWidget> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Note"),

      content: Form(
        key: formKey,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            CustomTextFormField(
              controller: titleController,
              label: 'Title',

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter note title";
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            CustomTextFormField(
              controller: descriptionController,
              label: 'Description',

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter description";
                }
                return null;
              },
            ),
          ],
        ),
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
            if (formKey.currentState!.validate()) {
              bool result = await context.read<NoteCubit>().addNote(
                NoteModel(
                  id: '',
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  createdAt: DateTime.now(),
                ),
              );

              if (result) {
                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 300), () {
                  showSuccessDialog(context, 'Note Added Successfully');
                });
              } else {
                showErrorDialog(context, 'Failed To Add Note');
              }
            }
          },

          child: const Text("Save"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
