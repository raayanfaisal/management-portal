// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';

// import '../building_blocks/application_service.dart';
// import '../services/authentication.dart';
// import '../modules/user/module.dart';

// class RegistrationService implements ApplicationService {
//   final _storage = FirebaseStorage.instance;

//   final AuthenticationService _authService;
//   final UserRepository _userRepo;

//   RegistrationService(this._authService, this._userRepo);

//   Future<void> createAccount(
//     String email,
//     String password,
//     String name,
//     Uint8List? image,
//   ) async {
//     final userCred =
//     await _authService.createAccountWithEmailAndPassword(email, password);

//     if (image != null) {
//       final imageUrl = await _uploadUserProfileImage(userCred.id, image);
//    await _userRepo.createUser(userCred.id, name, email, imageUrl: imageUrl);
//     } else {
//       await _userRepo.createUser(userCred.id, name, email);
//     }
//   }

//   Future<Uri> _uploadUserProfileImage(String userId, Uint8List image) async {
//     final uploadTaskSnapshot = await _storage
//         .ref('portal/users/profile_picture/$userId')
//         .putData(image);

//     return uploadTaskSnapshot.ref.getDownloadURL().then(Uri.parse);
//   }
// }

// class RegistrationError implements Exception {
//   final String message;

//   const RegistrationError(this.message);
// }
