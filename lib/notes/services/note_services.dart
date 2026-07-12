import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addNote(NoteModel note) async {
    try {
      await _firestore.collection('notes').add(note.toJson());

      return true;
    } catch (e) {
      print("ADD NOTE ERROR = $e");

      return false;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();

      return true;
    } catch (e) {
      print("DELETE NOTE ERROR = $e");

      return false;
    }
  }

  Future<bool> updateNote(NoteModel note) async {
    try {
      await _firestore.collection('notes').doc(note.id).update(note.toJson());

      return true;
    } catch (e) {
      print("UPDATE NOTE ERROR = $e");
      return false;
    }
  }

  Future<List<NoteModel>> searchNotes(String title) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('title', isEqualTo: title)
          .get();

      final notes = snapshot.docs.map((doc) {
        return NoteModel.fromJson(doc.data(), doc.id);
      }).toList();
      return notes;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteAllNotes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> orderByAlphabetical(
    String userId,
  ) async {
    QuerySnapshot<Map<String, dynamic>> notes = await FirebaseFirestore.instance
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('title')
        .get();

    return notes;
  }

  Future<void> toggleFavorite(String noteId, bool isFavorite) async {
    await _firestore.collection('notes').doc(noteId).update({
      'isFavorite': isFavorite,
    });
  }

  Future<void> toggleArchiver(String noteId, bool isArchived) async {
    await _firestore.collection('notes').doc(noteId).update({
      'isArchived': isArchived,
    });
  }

  Future<void> togglePin(String noteId, bool isPinned) async {
    await _firestore.collection('notes').doc(noteId).update({
      'isPinned': isPinned,
    });
  }

  // Future<List<QueryDocumentSnapshot>> getData() async {
  //   QuerySnapshot querySnapshot = await _firestore.collection('notes').get();
  //   return querySnapshot.docs;
  // }
}
