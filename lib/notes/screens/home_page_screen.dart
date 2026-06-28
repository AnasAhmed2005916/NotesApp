import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:last_version/core/helpers/cubits/theme_cubit/theme_cubit.dart';
import 'package:last_version/notes/cubits/note_cubit/note_cubit.dart';
import 'package:last_version/notes/cubits/note_cubit/note_state.dart';
import 'package:last_version/auth/screens/login_screen.dart';
import 'package:last_version/notes/screens/notes_editor_screen.dart';
import 'package:last_version/notes/widgets/custom_card_widget.dart';
import 'package:last_version/notes/widgets/note_card_widget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final SearchController = TextEditingController();
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
    final state = context.watch<NoteCubit>().state;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,

        title: const Text(
          "My Notes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: const Icon(Icons.dark_mode),
          ),
          if (state is NotesLoaded && state.notes.isNotEmpty)
            IconButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete All Notes'),
                      content: const Text(
                        "Are you sure you want to delete all notes?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (result == true) {
                  context.read<NoteCubit>().deleteAllNotes();
                }
              },
              icon: Icon(Icons.delete_forever),
              color: Colors.red,
            ),
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();

              await googleSignIn.disconnect();

              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            CustomCardWidget(user: user),

            SizedBox(height: 20),
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
                      return const Center(
                        child: Text(
                          "No Notes Yet",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Search by title...",
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
                            itemCount: state.notes.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) {
                              final note = state.notes[index];

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
            MaterialPageRoute(builder: (_) => NoteEditorScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
