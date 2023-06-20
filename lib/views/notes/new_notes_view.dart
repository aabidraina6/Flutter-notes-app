import 'package:flutter/material.dart';

class NewnoteView extends StatefulWidget {
  const NewnoteView({super.key});

  @override
  State<NewnoteView> createState() => _NewnoteViewState();
}

class _NewnoteViewState extends State<NewnoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: const Text('write your  new note here...'),
    );
  }
}
