import 'package:flutter/material.dart';
import 'package:last_version/notes/models/note_model.dart';
import 'package:last_version/notes/screens/notes_editor_screen.dart';
import 'package:share_plus/share_plus.dart';

class NotesDetailsScreen extends StatelessWidget {
  const NotesDetailsScreen({super.key, required this.note});
  final NoteModel note;

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(note.description, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
