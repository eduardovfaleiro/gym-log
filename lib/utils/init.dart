import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

late FirebaseFirestore fs;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  fs = FirebaseFirestore.instance;

  await Hive.initFlutter();

  var box = await Hive.openBox('exercises');

  for (String exercise in box.values) {
    await Hive.openBox(exercise);
  }

  await Hive.openBox('config');
}
