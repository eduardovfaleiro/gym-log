import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/utils/init.dart';

import '../utils/run_fs.dart';

class CategoryRepository {
  final _categoryCollection =
      fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('categories');

  Future<void> add(String name) async {
    var countQuery = await _categoryCollection.orderBy('order', descending: true).limit(1).get();

    int currentMaxOrder = countQuery.docs.firstOrNull?.data()['order'] ?? 0;
    await runFs(() => _categoryCollection.add({'name': name, 'order': currentMaxOrder + 1}));
  }

  Future<void> delete(String name) async {
    var exercisesQuery = await fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .where('category', isEqualTo: name)
        .get();

    WriteBatch batch = fs.batch();

    for (var exerciseDoc in exercisesQuery.docs) {
      batch.delete(exerciseDoc.reference);
    }

    var categoryRef = await _categoryCollection
        .where('name', isEqualTo: name)
        .limit(1)
        .get()
        .then((categories) => categories.docs.first.reference);

    batch.delete(categoryRef);

    await runFs(() => batch.commit());
  }

  Future<List<String>> getAll() async {
    var categoriesQuery = await _categoryCollection.orderBy('order').get();
    List<String> categories = categoriesQuery.docs.map((category) => category.data()['name'] as String).toList();

    log('CategoryRepository.getAll()');

    return categories;
  }

  /// {..., 'nomeCategoria': order, ...}
  Future<void> updateOrder({required Map<String, int> orderedCategories}) async {
    WriteBatch batch = fs.batch();

    var categoriesQuery = await _categoryCollection.get();

    for (var categoryDoc in categoriesQuery.docs) {
      String categoryName = categoryDoc.data()['name'];

      batch.update(categoryDoc.reference, {'order': orderedCategories[categoryName]});
    }

    await batch.commit();
  }
}
