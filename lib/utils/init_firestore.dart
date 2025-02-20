import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';

const _categoryAndExercises = [
  {
    'category': 'Peito',
    'exercises': [
      'Supino reto com barra',
      'Supino inclinado com barra',
      'Supino declinado com barra',
      'Supino reto com halteres',
      'Supino inclinado com halteres',
      'Crossover na polia',
      'Crucifixo reto com halteres',
      'Crucifixo inclinado com halteres',
      'Chest press na máquina',
      'Flexão',
      'Paralelas',
      'Pullover com halter',
    ],
  },
  {
    'category': 'Costas',
    'exercises': [
      'Levantamento terra',
      'Barra fixa pronada / Pull up',
      'Barra fixa supinada / Chin up',
      'Pulldown',
      'Remada curvada com barra',
      'Remada curvada com halteres',
      'Remada unilateral com halter',
      'Remada baixa',
      'Remada cavalinho',
      'Pullover na polia',
      'Pullover com halter',
      'Face pull',
      'Encolhimento',
    ],
  },
  {
    'category': 'Pernas',
    'exercises': [
      'Agachamento livre',
      'Agachamento no smith',
      'Agachamento búlgaro',
      'Hack squat',
      'Passada com barra',
      'Passada com halteres',
      'Leg press',
      'Cadeira extensora',
      'Cadeira flexora',
      'Mesa flexora',
      'Levantamento romeno',
      'Stiff',
      'Panturrilha sentado',
      'Panturrilha em pé',
    ],
  },
  {
    'category': 'Ombro',
    'exercises': [
      'Desenvolvimento',
      'Desenvolvimento no smith',
      'Elevação lateral com halteres',
      'Elevação lateral na polia',
      'Elevação frontal',
      'Remada alta',
      'Face pull',
      'Crucifixo invertido',
    ],
  },
  {
    'category': 'Tríceps',
    'exercises': [
      'Tríceps testa com halter',
      'Tríceps testa com barra',
      'Tríceps pulley',
      'Tríceps coice',
      'Paralelas',
      'Supino fechado',
      'Extensão de tríceps acima da cabeça',
    ],
  },
  {
    'category': 'Bíceps',
    'exercises': [
      'Rosca direta com barra',
      'Rosca direta com halteres',
      'Rosca alternada',
      'Rosca martelo',
      'Rosca concentrada',
      'Rosca scott',
      'Rosca inclinada com halteres',
    ],
  },
  {
    'category': 'Antebraço',
    'exercises': [
      'Rosca inversa com barra',
      'Rosca inversa na polia',
      'Rosca de punho com barra',
      'Rosca de punho com halter',
      "Farmer's walk",
      'Rolamento de corda',
      'Hand grip',
    ],
  },
  {
    'category': 'Abdômen',
    'exercises': [
      'Abdominal',
      'Abdominal com peso',
      'Prancha',
      'Elevação de pernas',
      'Prancha lateral',
      'Abdominal bicicleta',
      'Russian twist',
      'Ab wheel rollout',
    ],
  },
];

Future<void> initFireStore() async {
  var userCollection = fs.collection('users').doc(fa.currentUser!.uid);

  await userCollection.set({'categories': [], 'exercises': []});

  // // Serve para sincronizar os dados
  // var exercisesQuery = await userCollection.collection('exercises').get();
  // for (var exerciseDoc in exercisesQuery.docs) {
  //   exerciseDoc.reference.collection('logs').get();
  // }

  var exercisesSelectionCollection = userCollection.collection('exercisesSelection');
  var categoriesCollection = userCollection.collection('categories');

  var exerciseSelectionSnapshot = await exercisesSelectionCollection.get();
  var categoriesSnapshot = await categoriesCollection.get();

  if (exerciseSelectionSnapshot.docs.isNotEmpty || categoriesSnapshot.docs.isNotEmpty) {
    // await fs.disableNetwork();
    // networkDisabled = true;
    return;
  }

  WriteBatch batch = fs.batch();

  for (int order = 0; order < _categoryAndExercises.length; order++) {
    var map = _categoryAndExercises[order];

    String category = map['category'] as String;
    var exercises = map['exercises'] as List<String>;

    var categoryRef = categoriesCollection.doc();
    batch.set(categoryRef, {'name': category, 'order': order});

    for (String exercise in exercises) {
      var exerciseDoc = fs.collection('users').doc(fa.currentUser!.uid).collection('exercisesSelection').doc();

      batch.set(exerciseDoc, {'name': exercise, 'category': category, 'dateTime': DateTime.now()});
    }
  }

  await batch.commit();
  // await fs.disableNetwork();
  // networkDisabled = true;
}
