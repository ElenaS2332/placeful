import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:placeful/features/memories/viewmodels/list_memories_viewmodel.dart';

class ListMemoriesScreen extends StatelessWidget {
  const ListMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListMemoriesViewModel()..fetchMemories(),
      child: const _ListMemoriesScreenBody(),
    );
  }
}

class _ListMemoriesScreenBody extends StatelessWidget {
  const _ListMemoriesScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ListMemoriesViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("All Memories")),
      body:
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: vm.memories.length,
                itemBuilder: (context, index) {
                  final memory = vm.memories[index];
                  return ListTile(
                    title: Text(memory.title),
                    subtitle: Text(memory.description),
                  );
                },
              ),
    );
  }
}
