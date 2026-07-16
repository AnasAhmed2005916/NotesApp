import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_state.dart';
import 'package:last_version/features/notes/screens/notes_editor_screen.dart';
import 'package:last_version/features/notes/widgets/custom_card_widget.dart';
import 'package:last_version/features/notes/widgets/custom_drawer.dart';
import 'package:last_version/features/notes/widgets/note_card_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NoteCubit>().listenToNotes(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text("my_notes".tr()),
        actions: [
          IconButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                context.read<NoteCubit>().orderByAlphabetical(user.uid);
              }
            },
            icon: const Icon(Icons.sort_by_alpha),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomCardWidget(user: user),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<NoteCubit, NotesState>(
                builder: (context, state) {
                  if (state is NotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NotesError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is NotesLoaded) {
                    if (state.notes.isEmpty) {
                      return Center(
                        child: Text(
                          "no_notes_yet".tr(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }

                    final notes = state.notes
                        .where((note) => !note.isArchived)
                        .toList();

                    notes.sort((a, b) {
                      if (a.isPinned == b.isPinned) {
                        return 0;
                      }
                      return a.isPinned ? -1 : 1;
                    });

                    return Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "search".tr(),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSubmitted: (value) {
                            context.read<NoteCubit>().searchNotes(value);
                          },
                        ),

                        const SizedBox(height: 15),

                        Expanded(
                          child: GridView.builder(
                            itemCount: notes.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) {
                              final note = notes[index];

                              return NoteCardWidget(
                                note: note,
                                onDelete: () {
                                  context.read<NoteCubit>().deleteNote(note.id);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
