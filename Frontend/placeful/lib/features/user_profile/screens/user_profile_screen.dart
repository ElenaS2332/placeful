import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/common/domain/models/user_friendship.dart';
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
      create: (_) {
        final vm = UserProfileViewModel();
        vm.loadUserProfile();
        vm.loadFriendRequests();
        return vm;
      },
      child: const _UserProfileScreenBody(),
    );
  }
}

class _UserProfileScreenBody extends StatelessWidget {
  const _UserProfileScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserProfileViewModel>(context);
    final bgColor = const Color(0xFFF7F5FF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          if (vm.profileDto != null)
            IconButton(
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                size: 28,
                color: Colors.deepPurple,
              ),
              tooltip: "Friend Requests",
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddFriendScreen()),
                );
                await vm.loadFriendRequests();
                await vm.loadUserProfile();
              },
            ),
          if (vm.profileDto != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.deepPurple),
              tooltip: "Edit Profile",
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
                if (updated == true) await vm.loadUserProfile();
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.deepPurple),
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
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                )
                : vm.error != null
                ? Center(child: Text(vm.error!))
                : vm.profileDto == null
                ? const Center(child: Text("No profile found"))
                : _buildProfile(
                  context,
                  UserProfile.fromDto(vm.profileDto!),
                  vm,
                ),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    UserProfile profile,
    UserProfileViewModel vm,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child:
                      profile.fullName.isNotEmpty
                          ? Text(
                            profile.fullName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.deepPurple,
                            ),
                          )
                          : const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.deepPurple,
                          ),
                ),
                const SizedBox(height: 15),
                Text(
                  profile.fullName.isNotEmpty ? profile.fullName : "Guest User",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Text(
                  profile.email.isNotEmpty
                      ? profile.email
                      : "No email provided",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, size: 20, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      "${profile.birthDate.day}.${profile.birthDate.month}.${profile.birthDate.year}",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          Text(
            "Friends (${profile.friends?.length ?? 0})",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          const SizedBox(height: 10),
          profile.friends == null || profile.friends!.isEmpty
              ? Text(
                "No friends yet",
                style: GoogleFonts.poppins(color: Colors.grey),
              )
              : Column(
                children:
                    profile.friends!
                        .map((friend) => _friendTile(context, friend, vm))
                        .toList(),
              ),
          const SizedBox(height: 30),
          Text(
            "Friend Requests (${vm.friendRequestsCount})",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          const SizedBox(height: 10),
          vm.isLoadingRequests
              ? const Center(child: CircularProgressIndicator())
              : vm.friendRequests.isEmpty
              ? Text(
                "No friend requests.",
                style: GoogleFonts.poppins(color: Colors.grey),
              )
              : Column(
                children:
                    vm.friendRequests.map((UserFriendship req) {
                      final initiator = req.friendshipInitiator;
                      return ListTile(
                        title: Text(initiator?.fullName ?? ''),
                        trailing: TextButton(
                          onPressed: () async {
                            await vm.acceptFriendRequest(
                              req.friendshipInitiatorId ?? '',
                            );
                            await vm.loadUserProfile();
                            await vm.loadFriendRequests();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF8668FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Accept"),
                        ),
                      );
                    }).toList(),
              ),
          const SizedBox(height: 220),
          Center(
            child: TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text(
                          "Delete Account",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to permanently delete your account? "
                          "This action cannot be undone.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                );

                if (confirmed == true) {
                  await vm.deleteAccount();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Delete Profile"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _friendTile(
    BuildContext context,
    UserProfile friend,
    UserProfileViewModel vm,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF8668FF).withOpacity(0.2),
            child: Text(
              friend.fullName[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF8668FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.fullName,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                friend.email,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () async {
              await vm.removeFriend(friend.firebaseUid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Friend removed"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }
}
