// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:opinionguard/constants/routes.dart';
import 'package:opinionguard/services/auth/auth_services.dart';
import 'package:opinionguard/views/login_view.dart';
import 'package:opinionguard/views/notes/new_notes_view.dart';
import 'package:opinionguard/views/register_view.dart';
import 'package:opinionguard/views/verify_email_view.dart';
import 'views/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) {
        return const LoginView();
      },
      registerRoute: (context) {
        return const RegisterView();
      },
      notesRoute: (context) {
        return const NotesWidget();
      },
      verifyEmailView: (context) {
        return const EmailVerificationView();
      },
      newNotesRoute :(context) {
        return const NewnoteView();
      }
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return (FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesWidget();
              } else {
                return const EmailVerificationView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Center(child: (CircularProgressIndicator()));
        }
      },
    ));
  }
}
