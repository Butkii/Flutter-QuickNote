import 'package:flutter/material.dart';
import 'package:QuickNote/services/cloud/cloud_note.dart';
import 'package:QuickNote/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final List<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5.0,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 145, 157, 179),
                  offset: Offset(1, 1),
                  blurRadius: 1.0,
                )
              ],
              color: const Color(0XFFF4EFEA)),
          child: ListTile(
            onTap: () {
              onTap(note);
            },
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
            tileColor: const Color(0XFFF4EFEA),
            style: ListTileStyle.list,
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
          ),
        );
      },
    );
  }
}
