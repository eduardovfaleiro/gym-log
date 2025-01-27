import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/result.dart';
import 'package:gym_log/utils/show_error.dart';

class GoogleSignInService {
  Future<Result<bool>> signIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await fa.signInWithCredential(credential);
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        return const Result(
          false,
          'Não foi possível estabelecer conexão com o servidor. '
          'Por favor, cheque sua conexão e tente novamente.',
        );
      }
    } on AssertionError catch (e) {
      if ((e).message == 'At least one of ID token and access token is required') {
        return const Result(false);
      }

      rethrow;
    }
    return const Result(true);
  }
}
