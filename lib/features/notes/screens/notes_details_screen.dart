import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_state.dart';
import 'package:last_version/features/notes/screens/notes_editor_screen.dart';
import 'package:share_plus/share_plus.dart';

class NotesDetailsScreen extends StatelessWidget {
  const NotesDetailsScreen({super.key, required this.noteId});
  final String noteId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NotesState>(
      builder: (context, state) {
        if (state is NotesLoaded) {
          final note = state.notes.firstWhere((e) => e.id == noteId);
          return Scaffold(
            appBar: AppBar(
              title: Text(note.title, style: const TextStyle(fontSize: 18)),
              actions: [
                IconButton(
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(text: '${note.title}\n\n${note.description}'),
                    );
                  },
                  icon: const Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteEditorScreen(note: note),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  note.description,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
