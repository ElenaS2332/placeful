import 'package:flutter/foundation.dart';
import 'package:placeful/common/domain/dtos/update_user_dto.dart';
import 'package:placeful/common/domain/dtos/user_dto.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_service.dart';

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel({required UserDto user}) {
    _originalUser = user;
    fullName = user.fullName;
    email = user.email;
    birthDate = user.birthDate;
  }

  final UserService userService = getIt<UserService>();

  late UserDto _originalUser;
  late String _fullName;
  late String _email;
  late DateTime _birthDate;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set birthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  String get fullName => _fullName;
  String get email => _email;
  DateTime get birthDate => _birthDate;

  Future<void> saveChanges() async {
    _isSaving = true;
    notifyListeners();

    final updatedUserDto = UpdateUserDto(
      firebaseUid: _originalUser.firebaseUid,
      email: _email,
      fullName: _fullName,
      birthDate: _birthDate,
    );

    await userService.updateUser(updatedUserDto);

    _isSaving = false;
    notifyListeners();
  }
}
