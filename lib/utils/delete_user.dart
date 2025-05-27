// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/repositories/user_repository.dart';
import 'package:gym_log/utils/run_fs.dart';
import 'package:gym_log/utils/show_error.dart';

Future<bool> deleteUser(BuildContext context) async {
  if (fa.currentUser == null) {
    throw Exception('User is not logged in');
  }

  try {
    final userRepository = UserRepository(id: fa.currentUser!.uid);
    await userRepository.deleteOnlyWithNetwork();
    await fa.currentUser!.delete();

    await GoogleSignIn().signOut();
    return true;
  } catch (e) {
    if (e is! FirebaseAuthException &&
        e is! NoNetworkException &&
        e is! FirebaseException) {
      throw Exception('Unknown error occurred when deleting user');
    }
    if (e is FirebaseException && e.code == 'unavailable') {
      _showNetworkError(context);
    } else if (e is NoNetworkException) {
      _showNetworkError(context);
    } else if (e is FirebaseAuthException &&
        e.code == 'network-request-failed') {
      _showNetworkError(context);
    }

    return false;
  }
}

void _showNetworkError(BuildContext context) {
  showError(
    context,
    content: 'Não foi possível estabelecer conexão com o servidor. '
        'Por favor, cheque sua conexão e tente novamente.',
  );
}
