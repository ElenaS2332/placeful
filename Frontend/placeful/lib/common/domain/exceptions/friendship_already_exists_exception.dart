class FriendshipAlreadyExistsException implements Exception {
  FriendshipAlreadyExistsException();

  @override
  String toString() {
    return 'You are already friends with this person.';
  }
}
