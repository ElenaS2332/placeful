import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeful/features/friends/viewmodels/select_friend_viewmodel.dart';
import 'package:provider/provider.dart';

class SelectFriendScreen extends StatelessWidget {
  const SelectFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectFriendViewModel()..loadFriends(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select a Friend',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<SelectFriendViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.error != null) {
              return Center(child: Text(vm.error!));
            }

            if (vm.friends.isEmpty) {
              return const Center(child: Text('No friends found.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.friends.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final friend = vm.friends[index];
                return ListTile(
                  title: Text(friend.fullName),
                  subtitle: Text(friend.email),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF8668FF),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context, friend),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
