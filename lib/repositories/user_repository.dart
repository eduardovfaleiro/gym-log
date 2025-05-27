import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/run_fs.dart';

class UserRepository {
  final String id;

  UserRepository({required this.id});

  Future<void> deleteOnlyWithNetwork() async {
    final userDoc = fs.collection('users').doc(id);

    final exercises = await userDoc
        .collection('exercises')
        .get(const GetOptions(source: Source.server));
    final exercisesSelection = await userDoc
        .collection('exercisesSelection')
        .get(const GetOptions(source: Source.server));
    final categories = await userDoc
        .collection('categories')
        .get(const GetOptions(source: Source.server));

    int operations = exercises.docs.length +
        exercisesSelection.docs.length +
        categories.docs.length;

    const operationsAllowedPerBatch = 500;

    int numberOfBatches = (operations / operationsAllowedPerBatch).ceil();
    List<WriteBatch> batchesToCommit = [];

    // TODO(caso aconteça um milagre do acaso e alguém conseguir bugar isso aqui
    // por causa de conexão à internet, eu faço um sistema melhor. Entretanto, é mais fácil o Sol explodir
    // amanhã do que isso vir a acontecer.)
    for (int i = 0; i < numberOfBatches; i++) {
      final batch = fs.batch();

      _deleteDocsWithBatch(batch, exercises.docs);
      _deleteDocsWithBatch(batch, exercisesSelection.docs);
      _deleteDocsWithBatch(batch, categories.docs);

      batchesToCommit.add(batch);
    }

    for (var batch in batchesToCommit) {
      await runFsOnlyOnline(() => batch.commit());
    }
  }

  void _deleteDocsWithBatch(WriteBatch batch,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    for (var doc in docs) {
      batch.delete(doc.reference);
    }
  }
}
