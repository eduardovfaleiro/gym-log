import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/entities/category.dart';
import 'package:gym_log/utils/current_user_doc_mixin.dart';
import 'package:gym_log/utils/get_new_order.dart';

import '../utils/generate_id.dart';
import '../utils/run_fs.dart';

class CategoryRepository with CurrentUserDoc {
  Future<bool> exists(String name) async {
    final userDoc = await getUserDoc();
    var categories = await userDoc.get('categories');

    return categories.any((category) => category['name'] == name);
  }

  Future<void> add(String name) async {
    log('CategoryRepository.add()');
    final userDoc = await getUserDoc();

    var categories = await userDoc.get('categories');
    int newOrder = getNewOrder(categories);

    await runFs(
      () {
        userDoc.reference.update({
          'categories': FieldValue.arrayUnion([
            {'id': generateId(), 'name': name, 'order': newOrder}
          ]),
        });
      },
    );
  }

  Future<void> delete(Category category) async {
    final userDoc = await getUserDoc();

    await runFs(
      () => userDoc.reference.update({
        'categories': FieldValue.arrayRemove([category.toMap()])
      }),
    );
  }

  Future<List<Category>> getAll() async {
    log('CategoryRepository.getAll()');

    final userDoc = await getUserDoc();

    var categories = List.from(await userDoc.get('categories'));
    categories.sort((a, b) => a['order'].compareTo(b['order']));

    return List.from(categories.map((category) => Category.fromMap(category)));
  }

  // TODO(testar bem enquanto usa outro dispositivo)
  /// {..., 'idCategoria': order, ...}
  Future<void> updateOrder({required Map<String, int> orderedCategories}) async {
    final userDoc = await getUserDoc();

    var categories = await userDoc.get('categories');

    var categoriesUpdatedOrder = categories.map((category) {
      category['order'] = orderedCategories[category['id']];
      return category;
    });

    await runFs(() => userDoc.reference.update({'categories': categoriesUpdatedOrder}));
  }
}

// class CategoryRepository {
//   final _categoryCollection = fs.collection('users').doc(fa.currentUser!.uid).collection('categories');

//   Future<bool> exists(String name) async {
//     var categoriesQuery = await _categoryCollection.where('name', isEqualTo: name).limit(1).get();
//     return categoriesQuery.docs.isNotEmpty;
//   }

//   Future<void> add(String name) async {
//     var countQuery = await _categoryCollection.orderBy('order', descending: true).limit(1).get();

//     int currentMaxOrder = countQuery.docs.firstOrNull?.data()['order'] ?? 0;
//     await runFs(() => _categoryCollection.add({'name': name, 'order': currentMaxOrder + 1}));
//   }

//   Future<void> delete(String name) async {
//     var exercisesQuery = await fs
//         .collection('users')
//         .doc(fa.currentUser!.uid)
//         .collection('exercises')
//         .where('category', isEqualTo: name)
//         .get();

//     WriteBatch batch = fs.batch();

//     for (var exerciseDoc in exercisesQuery.docs) {
//       batch.delete(exerciseDoc.reference);
//     }

//     var categoryRef = await _categoryCollection
//         .where('name', isEqualTo: name)
//         .limit(1)
//         .get()
//         .then((categories) => categories.docs.first.reference);

//     batch.delete(categoryRef);

//     await runFs(() => batch.commit());
//   }

//   Future<List<String>> getAll() async {
//     var categoriesQuery = await _categoryCollection.orderBy('order').get();
//     List<String> categories = categoriesQuery.docs.map((category) => category.data()['name'] as String).toList();

//     log('CategoryRepository.getAll()');

//     return categories;
//   }

//   /// {..., 'nomeCategoria': order, ...}
//   Future<void> updateOrder({required Map<String, int> orderedCategories}) async {
//     WriteBatch batch = fs.batch();

//     var categoriesQuery = await _categoryCollection.get();

//     for (var categoryDoc in categoriesQuery.docs) {
//       String categoryName = categoryDoc.data()['name'];

//       batch.update(categoryDoc.reference, {'order': orderedCategories[categoryName]});
//     }

//     await runFs(() => batch.commit());
//   }
// }
