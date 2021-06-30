import 'package:rxdart/rxdart.dart';

import '../building_blocks/application_service.dart';
import '../modules/user/model.dart';
import '../modules/user/repository.dart';
import 'authentication.dart';

class MyAccountService implements ApplicationService {
  final _myAccountSubject = BehaviorSubject<UserModel>();
  final AuthenticationService _authService;
  final UserRepository _userRepository;

  MyAccountService(this._authService, this._userRepository) {
    _myAccountSubject.addStream(_myAccountSnapshots.whereType<UserModel>());
  }

  UserModel? get myAccount => _myAccountSubject.valueOrNull;

  Stream<UserModel> get myAccountSnapshots => _myAccountSubject;

  Stream<UserModel?> get _myAccountSnapshots async* {
    final currentUser = _authService.currentUser;

    if (currentUser != null) {
      yield* _userRepository.getUser(currentUser.id);
    }
  }
}
