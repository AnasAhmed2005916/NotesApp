import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/cubits/note_cubit/note_state.dart';
import 'package:last_version/notes/widgets/note_card_widget.dart';

class FavoirteNotesScreen extends StatelessWidget {
  const FavoirteNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Notes')),
      body: SafeArea(
        child: BlocBuilder<NoteCubit, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotesError) {
              return Center(child: Text(state.message));
            }

            if (state is NotesLoaded) {
              final favoriteNotes = state.notes
                  .where((note) => note.isFavorite)
                  .toList();

              if (favoriteNotes.isEmpty) {
                return const Center(child: Text('No Favorite Notes'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteNotes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final note = favoriteNotes[index];

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
      ),
    );
  }
}
