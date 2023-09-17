import 'package:flutter/material.dart';
import 'package:QuickNote/constants/routes.dart';
import 'package:QuickNote/services/auth/auth_service.dart';
import 'package:QuickNote/views/login_view.dart';
import 'package:QuickNote/views/notes/create_update_note_view.dart';
import 'package:QuickNote/views/notes/notes_view.dart';
import 'package:QuickNote/views/register_view.dart';
import 'package:QuickNote/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    home: const HomePage(),
    routes: {
      loginRoute: ((context) {
        return const LoginView();
      }),
      registerRoute: ((context) {
        return const RegisterView();
      }),
      notesRoute: ((context) {
        return const NotesView();
      }),
      verifyEmailRoute: ((context) {
        return const VerifyEmailView();
      }),
      createOrUpdateNoteRoute: ((context) {
        return const CreateUpdateNoteView();
      }),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
