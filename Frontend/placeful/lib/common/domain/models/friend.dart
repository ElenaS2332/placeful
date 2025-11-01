import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

@JsonSerializable()
class Friend {
  final String id;
  final String fullName;
  final String email;
  final DateTime? birthDate;
  final String? firebaseUid;

  const Friend({
    required this.id,
    required this.fullName,
    required this.email,
    this.birthDate,
    this.firebaseUid,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
