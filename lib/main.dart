// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:opinionguard/views/login_view.dart';
import 'package:opinionguard/views/register_view.dart';
import 'package:opinionguard/views/verify_email_view.dart';
import 'dart:developer' show log;

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) {
        return const LoginView();
      },
      '/register': (context) {
        return const RegisterView();
      }
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return (FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = (FirebaseAuth.instance.currentUser);
            if (user != null) {
              if (user.emailVerified) {
                return const NotesWidget();
              } else {
                return const EmailVerificationView();
              }
            } else {
              return const LoginView();
            }
          // if (user?.emailVerified == true) {
          //   print('you are verified user');
          // } else {
          //   print('please verify yourself');
          //  return const EmailVerificationView();
          // }
          // return const Text('Done');
          default:
            return const Center(child: (CircularProgressIndicator()));
        }
      },
    ));
  }
}

enum MenuAction { logout }

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return (const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log Out'))
              ]);
            },
          )
        ],
      ),
      body: const Center(child: Text('Hello World')),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are You sure you want to logout'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
