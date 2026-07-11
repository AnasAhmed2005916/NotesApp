import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/core/helpers/dialogs.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/models/note_model.dart';
import 'package:last_version/notes/screens/notes_details_screen.dart';

class NoteCardWidget extends StatelessWidget {
  final NoteModel note;
  const NoteCardWidget({super.key, required this.note, required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDeleteAndUpdateDialog(
          context,
          'Are you sure to remove this Note ?',
          onDelete,
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NotesDetailsScreen(note: note)),
        );
      },
      child: Card(
        // color: Colors.amber.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        child: Padding(
          padding: EdgeInsets.all(12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(note.title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                note.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<NoteCubit>().toggleFavorite(note);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        note.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey(note.isFavorite),
                        color: note.isFavorite ? Colors.red : null,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      context.read<NoteCubit>().toggleArchive(note);
                    },
                    icon: Icon(
                      note.isArchived ? Icons.unarchive : Icons.archive,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
