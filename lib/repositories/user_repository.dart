import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/run_fs.dart';

class UserRepository {
  final String id;

  UserRepository({required this.id});

  Future<void> delete() async {
    final snapshot = await fs.collection(id).getX();
    final batch = fs.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await runFs(() => batch.commit());
  }
}
