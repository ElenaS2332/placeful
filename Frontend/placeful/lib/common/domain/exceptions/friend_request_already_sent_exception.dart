class FriendRequestAlreadySentException implements Exception {
  FriendRequestAlreadySentException();

  @override
  String toString() {
    return 'You have already sent a friend request to this person.';
  }
}
