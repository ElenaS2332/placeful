import 'package:flutter/material.dart';

class AddMemoryScreen extends StatelessWidget {
  const AddMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String mockTitle = "Trip to Ohrid";
    final String mockDescription = "Had a great time by the lake!";
    final String mockLocation = "Ohrid, Macedonia";
    final String mockImage = "https://picsum.photos/400/200";

    return Scaffold(
      appBar: AppBar(title: const Text("Add Memory")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              initialValue: mockTitle,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: mockDescription,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(mockImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(mockLocation),
              subtitle: const Text("Lat: 41.123, Lng: 20.789"),
            ),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Memory"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Memory saved (mock)!")),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
