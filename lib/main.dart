// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinionguard/constants/routes.dart';
import 'package:opinionguard/services/auth/auth_services.dart';
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
      createOrUpdateNoteRoute: (context) {
        return const CreateUpdateNoteView();
      }
    },
  ));
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return (FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesWidget();
//               } else {
//                 return const EmailVerificationView();
//               }
//             } else {
//               return const LoginView();
//             }

//           default:
//             return const Center(child: (CircularProgressIndicator()));
//         }
//       },
//     ));
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing Bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(
              children: [
                Text('current value => ${state.value}'),
                Visibility(
                  visible: (state is CounterStateInvalidNumber),
                  child: Text('Invalid input : $invalidValue',
                      style: const TextStyle(
                        color: Colors.red,
                      )),
                ),
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: 'Enter a number here'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      },
                      child: const Text('+'),
                    )
                  ],
                )
              ],
            );
          },
          listener: (context, state) {
            _controller.clear();
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer != null) {
          emit(CounterStateValid(state.value + integer));
        } else {
          emit(CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ));
        }
      },
    );
    on<DecrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer != null) {
          emit(CounterStateValid(state.value - integer));
        } else {
          emit(CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ));
        }
      },
    );
  }
}
