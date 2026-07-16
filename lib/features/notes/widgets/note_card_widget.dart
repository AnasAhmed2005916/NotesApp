import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/core/helpers/dialogs.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/models/note_model.dart';
import 'package:last_version/features/notes/screens/notes_details_screen.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({super.key, required this.note, required this.onDelete});

  final NoteModel note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotesDetailsScreen(noteId: note.id),
          ),
        );
      },
      onLongPress: () {
        showDeleteAndUpdateDialog(
          context,
          "delete_note_confirmation".tr(),
          onDelete,
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title + Pin
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),

                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    onPressed: () {
                      context.read<NoteCubit>().togglePin(note);
                    },
                    icon: Icon(
                      note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Description
              Expanded(
                child: Text(
                  note.description,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ),

              const Divider(),

              /// Bottom Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    splashRadius: 22,
                    onPressed: () {
                      context.read<NoteCubit>().toggleFavorite(note);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        note.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey(note.isFavorite),
                        color: note.isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),

                  IconButton(
                    splashRadius: 22,
                    onPressed: () {
                      context.read<NoteCubit>().toggleArchive(note);
                    },
                    icon: Icon(
                      note.isArchived
                          ? Icons.unarchive
                          : Icons.archive_outlined,
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
