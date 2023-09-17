import 'package:QuickNote/utilities/changeTheme.dart';
import 'package:flutter/material.dart';
import 'package:QuickNote/enums/menu_action.dart';
import 'package:QuickNote/constants/routes.dart';
import 'package:QuickNote/services/auth/auth_service.dart';
import 'package:QuickNote/services/cloud/cloud_note.dart';
import 'package:QuickNote/services/cloud/firestore_storage.dart';
import 'package:QuickNote/utilities/dialogs/logout_dialog.dart';
import 'package:QuickNote/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light
          ? Color(0XFFF4EFEA)
          : Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        backgroundColor: themeMode == ThemeMode.light
            ? Color(0XFFF4EFEA)
            : Color.fromARGB(255, 36, 36, 36),
        elevation: 1,
        title: const Text(
          'Your Notes',
          style: TextStyle(
            color: Color(0xFF7EABFF),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF7EABFF),
        ),
        actions: [
          PopupMenuButton<MenuAction>(itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log Out'),
              ),
              PopupMenuItem<MenuAction>(
                value: MenuAction.theme,
                child: Text('Dark Mode'),
              )
            ];
          }, onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
                      (_) {
                    return false;
                  });
                } else {
                  return;
                }
                break;
              case MenuAction.theme:
                // setState(() {
                //   themeMode = themeMode == ThemeMode.light
                //       ? ThemeMode.dark
                //       : ThemeMode.light;
                // });
                break;
            }
          })
        ],
      ),
      body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as List<CloudNote>;
                  return NotesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                            documentId: note.documentId);
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        },
        backgroundColor: const Color(0xFFBB95A1),
        child: const Icon(Icons.add), // Customize the button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
