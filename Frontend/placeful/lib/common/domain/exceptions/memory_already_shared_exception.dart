class MemoryAlreadySharedException implements Exception {
  MemoryAlreadySharedException();

  @override
  String toString() {
    return 'This memory has already been shared with the selected friend.';
  }
}
