import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/log.dart';
import 'package:gym_log/utils/init.dart';

class LogRepository {
  static final _exercisesCollection =
      fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises');

  static Future<List<Log>> getAll(String exercise) async {
    var logs = await _exercisesCollection.doc(exercise).collection('logs').get();
    print('');
    return logs.docs.map((log) => Log.fromFireStoreMap(log.data())).toList();
  }

  static Future<void> add(String exercise, Log log) async {
    await _exercisesCollection.doc(exercise).collection('logs').add(log.toMap());
  }
}
