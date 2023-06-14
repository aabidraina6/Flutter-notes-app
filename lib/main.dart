// ignore_for_file: avoid_print

import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:opinionguard/views/login_view.dart';
import 'package:opinionguard/views/register_view.dart';
import 'package:opinionguard/views/verify_email_view.dart';

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
      '/login':(context) {
       return const LoginView();
      },
      '/register' : (context){
        return const RegisterView();
      }
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = (FirebaseAuth.instance.currentUser);
              if(user != null){
                if(user.emailVerified){
                  print('Email Verified');
                }else{
                  return const EmailVerificationView();
                }
              }else{
                return const LoginView();
              }
              return const Text('Done');
              // if (user?.emailVerified == true) {
              //   print('you are verified user');
              // } else {
              //   print('please verify yourself');
              //  return const EmailVerificationView();
              // }
              // return const Text('Done');
              return const LoginView();
            default:
              return const Center(child: ( CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}


