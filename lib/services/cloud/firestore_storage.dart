import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QuickNote/services/cloud/cloud_note.dart';
import 'package:QuickNote/services/cloud/cloud_constants.dart';
import 'package:QuickNote/services/cloud/cloud_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
    required String title,
  }) async {
    try {
      await notes
          .doc(documentId)
          .update({textFieldName: text, titleFieldName: title});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<List<CloudNote>> allNotes({required String ownerUserId}) {
    var allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudNote.fromSnapshot(doc)).toList());
    // final retList = allNotes.toList();
    return allNotes;
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
      titleFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  getUser({required String email}) {}
}
