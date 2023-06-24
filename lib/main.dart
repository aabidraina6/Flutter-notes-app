// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinionguard/constants/routes.dart';
import 'package:opinionguard/helpers/loading/loading_screen.dart';
import 'package:opinionguard/services/auth/bloc/auth_bloc.dart';
import 'package:opinionguard/services/auth/bloc/auth_event.dart';
import 'package:opinionguard/services/auth/bloc/auth_state.dart';
import 'package:opinionguard/services/auth/firebase_auth_provider.dart';
import 'package:opinionguard/views/login_view.dart';
import 'package:opinionguard/views/notes/create_update_note_view.dart';
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
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) {
        return const CreateUpdateNoteView();
      }
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        }else{
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesWidget();
        } else if (state is AuthStateNeedsVerification) {
          return const EmailVerificationView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
