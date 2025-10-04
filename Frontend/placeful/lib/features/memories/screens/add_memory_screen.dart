import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/add_memory_viewmodel.dart';

class AddMemoryScreen extends StatelessWidget {
  const AddMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMemoryViewModel(),
      child: const _AddMemoryScreenBody(),
    );
  }
}

class _AddMemoryScreenBody extends StatelessWidget {
  const _AddMemoryScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddMemoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Memory")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: vm.setTitle,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: vm.setDescription,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  vm.isLoading
                      ? null
                      : () async {
                        final success = await vm.addMemory();
                        if (success) Navigator.pop(context);
                      },
              child:
                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Add Memory"),
            ),
            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
