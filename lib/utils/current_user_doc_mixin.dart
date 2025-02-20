import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';

mixin CurrentUserDoc {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() async {
    return fs.collection('users').doc(fa.currentUser!.uid).get();
  }
}
