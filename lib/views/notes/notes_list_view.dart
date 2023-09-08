import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_services.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          tileColor: Color.fromARGB(255, 228, 245, 254),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            // color: Colors.blueGrey,
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
