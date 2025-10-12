import 'package:flutter/material.dart';
import 'package:placeful/common/domain/models/user_friendship.dart';
import 'package:placeful/common/domain/models/user_profile.dart';
import 'package:placeful/features/friends/viewmodels/add_friend_viewmodel.dart';
import 'package:provider/provider.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  void _dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Friend Request"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friendNameController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => AddFriendViewModel(),
      child: Consumer<AddFriendViewModel>(
        builder: (context, viewModel, _) {
          return GestureDetector(
            onTap: () => _dismissKeyboard(context),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter your friend's username",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: friendNameController,
                        onChanged: viewModel.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "Friend's username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Search results
                      if (viewModel.isSearching)
                        const Center(child: CircularProgressIndicator())
                      else if (viewModel.searchResults.isNotEmpty)
                        ...viewModel.searchResults.map((UserProfile user) {
                          final isPending = viewModel.isRequestPending(
                            user.firebaseUid,
                          );
                          return ListTile(
                            title: Text(user.fullName),
                            trailing: ElevatedButton(
                              onPressed:
                                  isPending
                                      ? null
                                      : () async {
                                        try {
                                          await viewModel.addFriend(
                                            user.firebaseUid,
                                          );
                                          friendNameController.clear();
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          _showErrorDialog(
                                            context,
                                            e.toString(),
                                          );
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isPending
                                        ? Colors.grey
                                        : const Color(0xFF8668FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                isPending ? "Requested" : "Add",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),

                      const SizedBox(height: 20),
                      const Divider(),
                      Text(
                        "Friend Requests",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Friend requests
                      if (viewModel.isLoadingRequests)
                        const Center(child: CircularProgressIndicator())
                      else if (viewModel.friendRequests.isEmpty)
                        const Text("No friend requests.")
                      else
                        ...viewModel.friendRequests.map((UserFriendship user) {
                          final initiator = user.friendshipInitiator;
                          return ListTile(
                            title: Text(initiator?.fullName ?? ''),
                            trailing: ElevatedButton(
                              onPressed:
                                  () => viewModel.acceptFriendRequest(
                                    user.friendshipInitiatorId ?? '',
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
