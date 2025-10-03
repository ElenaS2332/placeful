import 'package:flutter/material.dart';

class ListMemoriesScreen extends StatelessWidget {
  const ListMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Memories")),
      body: const Center(child: Text("Pinterest-style board of memories")),
    );
  }
}
