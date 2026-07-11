import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  final _formKey = GlobalKey<FormState>();
  File? file;
  getImage() async {
    final picker = ImagePicker();
    // final XFile? imagegallery = await picker.pickImage(
    //   source: ImageSource.gallery,
    // );
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      file = File(image.path);
    });
  }

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
          IconButton(onPressed: getImage, icon: const Icon(Icons.image)),
          IconButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

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
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (file != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
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
