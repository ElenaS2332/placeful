import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/features/memories/screens/location_picker_screen.dart';
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
            TextField(
              readOnly: true,
              controller: vm.dateController,
              onTap: () => vm.pickDate(context),
              decoration: InputDecoration(
                hintText: "Select Date",
                filled: true,
                fillColor: Colors.white24,
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            TextField(
              //find a way to select image, open gallery or camera
              decoration: const InputDecoration(labelText: "Image URL"),
              // onChanged: vm.setImageUrl,
            ),
            TextField(
              readOnly: true,
              // controller: vm.locationController,
              onTap: () async {
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationPickerScreen(),
                  ),
                );
                if (selectedLocation != null) {
                  final locationToAdd = Location.fromDto(selectedLocation);
                  vm.setLocation(locationToAdd);
                }
              },
              decoration: const InputDecoration(
                labelText: "Location",
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
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
                ),
              ],
            ),
            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
