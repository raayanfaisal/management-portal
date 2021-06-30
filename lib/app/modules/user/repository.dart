import '../../building_blocks/repository.dart';
import 'model.dart';

class UserRepository implements Repository {
  Stream<Iterable<UserModel>> getUsers() {
    throw UnimplementedError();
  }

  Stream<UserModel> getUser(String id) {
    throw UnimplementedError();
  }
}
