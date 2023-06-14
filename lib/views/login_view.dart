// ignore_for_file: avoid_log

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: (Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                      await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/notes',
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  log(e.code);
                  if (e.code == 'user-not-found') {
                    log('user not found');
                  } else if (e.code == 'wrong-password') {
                    log('wrong password');
                    log(e.code);
                  }
                } catch (e) {
                  log("something bad happened");
                  log('e.runtimeType');
                }
              },
              child: const Text("Login")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/register',
                  (route) => false,
                );
              },
              child: const Text('Not Registered yet ? Register Here'))
        ],
      )),
    );
  }
}
