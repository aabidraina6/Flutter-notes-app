import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinionguard/services/auth/auth_services.dart';
import 'package:opinionguard/services/auth/bloc/auth_event.dart';
import 'package:opinionguard/services/cloud/cloud_note.dart';
import 'package:opinionguard/services/cloud/firebase_cloud_storage.dart';
import 'package:opinionguard/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
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
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                    
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
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) async {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
