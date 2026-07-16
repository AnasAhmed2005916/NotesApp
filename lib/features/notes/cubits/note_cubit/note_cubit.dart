import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_version/features/notes/cubits/note_cubit/note_state.dart';
import 'package:last_version/features/notes/models/note_model.dart';
import 'package:last_version/features/notes/services/note_services.dart';

class NoteCubit extends Cubit<NotesState> {
  final NoteService noteService;
  NoteCubit({required this.noteService}) : super(NotesInitial());
  StreamSubscription? _notesSubscription;
  void listenToNotes(String userId) {
    emit(NotesLoading());
    _notesSubscription?.cancel();
    _notesSubscription = FirebaseFirestore.instance
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            final notes = snapshot.docs.map((doc) {
              return NoteModel.fromJson(doc.data(), doc.id);
            }).toList();

            emit(NotesLoaded(notes));
          },
          onError: (e) {
            emit(NotesError(e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  Future<void> deleteNote(String id) async {
    try {
      await noteService.deleteNote(id);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(NoteModel noteModel) async {
    try {
      await noteService.updateNote(noteModel);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<bool> addNote(NoteModel noteModel) async {
    try {
      await noteService.addNote(noteModel);
      return true;
    } catch (e) {
      emit(NotesError(e.toString()));
      return false;
    }
  }

  Future<void> searchNotes(String title) async {
    emit(NotesLoading());

    try {
      final notes = await noteService.searchNotes(title);

      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteAllNotes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      await noteService.deleteAllNotes(user.uid);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> orderByAlphabetical(String userId) async {
    try {
      final snapshot = await noteService.orderByAlphabetical(userId);
      final notes = snapshot.docs.map((doc) {
        return NoteModel.fromJson(doc.data(), doc.id);
      }).toList();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(NoteModel note) async {
    try {
      await noteService.toggleFavorite(note.id, !note.isFavorite);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> toggleArchive(NoteModel note) async {
    try {
      await noteService.toggleArchiver(note.id, !note.isArchived);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> togglePin(NoteModel note) async {
    try {
      await noteService.togglePin(note.id, !note.isPinned);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
