import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeful/features/user_profile/view_models/edit_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.deepPurple),
    filled: true,
    fillColor: Colors.deepPurple.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();
    final bgColor = const Color(0xFFF7F5FF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.deepPurple,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.deepPurple),
            tooltip: "Save Profile",
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: viewModel.fullName)
                ..selection = TextSelection.collapsed(
                  offset: viewModel.fullName.length,
                ),
              decoration: _inputDeco('Full Name'),
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (value) => viewModel.fullName = value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: viewModel.email)
                ..selection = TextSelection.collapsed(
                  offset: viewModel.email.length,
                ),
              decoration: _inputDeco('Email'),
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (value) => viewModel.email = value,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Birthdate:',
                  style: GoogleFonts.poppins(color: Colors.deepPurple),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: viewModel.birthDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) viewModel.birthDate = pickedDate;
                  },
                  child: Text(
                    '${viewModel.birthDate.day}/${viewModel.birthDate.month}/${viewModel.birthDate.year}',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
