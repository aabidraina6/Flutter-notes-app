// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinionguard/services/auth/auth_exceptions.dart';
import 'package:opinionguard/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email, _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Enter your email and password to register a new account'),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(hintText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autofocus: true,
                  autocorrect: false,
                ),
                TextField(
                  controller: _password,
                  decoration:
                      const InputDecoration(hintText: 'Enter your password'),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            context.read<AuthBloc>().add(AuthEventRegister(
                                  email,
                                  password,
                                ));
                          },
                          child: const Text("Register")),
                      TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(const AuthEventLogOut());
                          },
                          child: const Text('Go to Login  page'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
