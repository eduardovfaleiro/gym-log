import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: unused_import
import '../entities/exercise.dart';
import 'init.dart';

Future<void> initFireStore() async {
  var exercisesSelectionCollection =
      fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercisesSelection');

  var snapshot = await exercisesSelectionCollection.get();
  if (snapshot.docs.isNotEmpty) return;

  final Map<String, List<String>> exercises = {
    'abs': [
      'Abdominal',
      'Abdominal com peso',
      'Prancha',
      'Elevação de pernas',
      'Prancha lateral',
      'Abdominal bicicleta',
      'Russian twist',
      'Ab wheel rollout',
    ],
    'chest': [
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
    'back': [
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
    'legs': [
      'Agachamento livre',
      'Agachamento no smith',
      'Agachamento búlgaro',
      'Hack squat',
      // 'Agachamento frontal',
      // 'Agachamento sumô',
      'Passada com barra',
      'Passada com halteres',
      'Leg press',
      'Cadeira extensora',
      'Cadeira flexora',
      'Mesa flexora',
      'Levantamento romeno',
      'Stiff',
      // 'Cadeira adutora',
      // 'Cadeira abdutora',
      // 'Elevação pélvica',
      'Panturrilha sentado',
      'Panturrilha em pé',
    ],
    'shoulders': [
      'Desenvolvimento',
      'Desenvolvimento no smith',
      'Elevação lateral com halteres',
      'Elevação lateral na polia',
      'Elevação frontal',
      'Remada alta',
      'Face pull',
      'Crucifixo invertido',
    ],
    'triceps': [
      'Tríceps testa com halter',
      'Tríceps testa com barra',
      'Tríceps pulley',
      'Tríceps coice',
      'Paralelas',
      'Supino fechado',
      'Extensão de tríceps acima da cabeça',
    ],
    'biceps': [
      'Rosca direta com barra',
      'Rosca direta com halteres',
      'Rosca alternada',
      'Rosca martelo',
      'Rosca concentrada',
      'Rosca scott',
      'Rosca inclinada com halteres',
    ],
    'forearms': [
      'Rosca inversa com barra',
      'Rosca inversa na polia',
      'Rosca de punho com barra',
      'Rosca de punho com halter',
      "Farmer's walk",
      'Rolamento de corda',
      'Hand grip',
    ],
  };

  WriteBatch batch = fs.batch();

  for (String category in exercises.keys) {
    for (String exercise in exercises[category]!) {
      var doc =
          fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercisesSelection').doc();

      batch.set(doc, {'name': exercise, 'category': category, 'dateTime': DateTime.now()});
    }
  }

  await batch.commit();
}
