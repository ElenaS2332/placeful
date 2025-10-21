import 'package:flutter/material.dart';
import 'package:placeful/features/user_profile/view_models/edit_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Full name'),
              controller: TextEditingController(text: viewModel.fullName)
                ..selection = TextSelection.collapsed(
                  offset: viewModel.fullName.length,
                ),
              onChanged: (value) => viewModel.fullName = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: viewModel.email)
                ..selection = TextSelection.collapsed(
                  offset: viewModel.email.length,
                ),
              onChanged: (value) => viewModel.email = value,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Birthdate:'),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: viewModel.birthDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      viewModel.birthDate = pickedDate;
                    }
                  },
                  child: Text(
                    '${viewModel.birthDate.day}/${viewModel.birthDate.month}/${viewModel.birthDate.year}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed:
                  viewModel.isSaving
                      ? null
                      : () async {
                        await viewModel.saveChanges();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully'),
                            ),
                          );
                          Navigator.pop(context, true);
                        }
                      },
              child:
                  viewModel.isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
