import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/repositories/user_repository.dart';

Future<bool> deleteUser() async {
  if (fa.currentUser == null) {
    return false;
  }

  final userRepository = UserRepository(id: fa.currentUser!.uid);
  await userRepository.delete();
  await fa.currentUser!.delete();

  await GoogleSignIn().signOut();
  return true;
}
