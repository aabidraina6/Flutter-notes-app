import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinionguard/services/auth/bloc/auth_bloc.dart';
import 'package:opinionguard/services/auth/bloc/auth_event.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "we'he send you an Email verification. Please Open email",
            ),
            const Text(
              "if you have'nt recieved an email yet please press the button",
            ),
            TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailVerification());
                },
                child: const Text('Verify Email')),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Restart'),
            )
          ],
        ),
      ),
    );
  }
}
