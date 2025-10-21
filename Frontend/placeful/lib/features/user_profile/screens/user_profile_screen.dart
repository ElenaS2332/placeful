import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/features/authentication/login_screen.dart';
import 'package:placeful/features/friends/screens/add_friend_screen.dart';
import 'package:placeful/features/memories/screens/memory_map_screen.dart';
import 'package:placeful/features/user_profile/screens/edit_profile_screen.dart';
import 'package:placeful/features/user_profile/view_models/edit_profile_viewmodel.dart';
import 'package:placeful/features/user_profile/view_models/user_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel()..loadUserProfile(),
      child: const _UserProfileScreenBody(),
    );
  }
}

class _UserProfileScreenBody extends StatelessWidget {
  const _UserProfileScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MemoryMapScreen()),
            );
          },
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (vm.profileDto != null)
            TextButton(
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider(
                          create:
                              (_) => EditProfileViewModel(user: vm.profileDto!),
                          child: const EditProfileScreen(),
                        ),
                  ),
                );

                if (updated == true) {
                  await vm.loadUserProfile();
                }
              },

              child: const Text('Edit Profile'),
            ),

          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await vm.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                ? Center(child: Text(vm.error!))
                : vm.profileDto == null
                ? const Center(child: Text("No profile found"))
                : _buildProfile(context, UserProfile.fromDto(vm.profileDto!)),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFF8668FF),
            child:
                profile.fullName.isNotEmpty
                    ? Text(
                      profile.fullName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    )
                    : const Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            profile.fullName.isNotEmpty ? profile.fullName : "Guest User",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            profile.email.isNotEmpty ? profile.email : "No email provided",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cake, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "Born: ${profile.birthDate.day}.${profile.birthDate.month}.${profile.birthDate.year}",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          const Divider(height: 40),
          Text(
            "Friends (${profile.friends?.length ?? 0})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          profile.friends == null || profile.friends!.isEmpty
              ? const Text(
                "No friends yet",
                style: TextStyle(color: Colors.grey),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: profile.friends?.length,
                itemBuilder: (_, index) {
                  final friend = profile.friends?[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF8668FF,
                        ).withValues(alpha: 0.2),
                        child: Text(
                          friend?.fullName[0].toUpperCase() ?? '',
                          style: const TextStyle(
                            color: Color(0xFF8668FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(friend?.fullName ?? ''),
                      subtitle: Text(friend?.email ?? ''),
                    ),
                  );
                },
              ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddFriendScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8668FF),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Add Friends',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
