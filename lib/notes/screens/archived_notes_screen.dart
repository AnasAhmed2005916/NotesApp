import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/cubits/note_cubit/note_state.dart';
import 'package:last_version/notes/widgets/note_card_widget.dart';

class ArchivedNotesScreen extends StatelessWidget {
  const ArchivedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archived Notes')),
      body: BlocBuilder<NoteCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            final archivedNotes = state.notes
                .where((note) => note.isArchived)
                .toList();

            if (archivedNotes.isEmpty) {
              return Center(
                child: Text(
                  'No Arvhived Notes yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              );
            }
            return GridView.builder(
              itemCount: archivedNotes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final note = archivedNotes[index];

                return NoteCardWidget(
                  note: note,
                  onDelete: () {
                    context.read<NoteCubit>().deleteNote(note.id);
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
