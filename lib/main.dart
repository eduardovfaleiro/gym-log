import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log/pages/exercise_chart_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'repositories/exercise_repository.dart';
import 'utils/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  fs = FirebaseFirestore.instance;

  await Hive.initFlutter();

  var box = await Hive.openBox('exercises');

  for (String exercise in box.values) {
    await Hive.openBox(exercise);
  }

  await Hive.openBox('config');
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(
      clientId: 'YOUR_WEBCLIENT_ID',
    ),
  ]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(useMaterial3: true),
      // builder: (context, child) => PopScope(canPop: false, onPopInvokedWithResult: (didPop, result) {}, child: child!),
      routes: {
        '/': (context) {
          return const MainApp();
        },
        '/profile': (context) => ProfileScreen(
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/');
                }),
              ],
            ),
        '/verify-email': (context) {
          return EmailVerificationScreen(
            actions: [
              EmailVerifiedAction(() {
                Navigator.pushReplacementNamed(context, '/');
              }),
              AuthCancelledAction((context) {
                FirebaseUIAuth.signOut(context: context);
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
          );
        },
      },
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> _addExercise(BuildContext context) async {
    var exerciseController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar exercício'),
          content: TextField(
            controller: exerciseController,
            decoration: const InputDecoration(labelText: 'Nome'),
            maxLength: 50,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  ExerciseRepository.add(exerciseController.text);
                  Navigator.pop(context);
                },
                child: const Text('Ok')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction((context, state) {
                final user = switch (state) {
                  SignedIn(user: final user) => user,
                  CredentialLinked(user: final user) => user,
                  UserCreated(credential: final cred) => cred.user,
                  _ => null,
                };

                switch (user) {
                  case User(emailVerified: true):
                    Navigator.pushReplacementNamed(context, '/');
                  case User(emailVerified: false, email: final String _):
                    Navigator.pushNamed(context, '/verify-email');
                }
              }),
            ],
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gym Log'),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .5),
                  child: TextButton.icon(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/profile');
                    },
                    label: Text(
                      FirebaseAuth.instance.currentUser?.email.toString() ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await _addExercise(context);
              setState(() {});
            },
          ),
          body: FutureBuilder(
            future: ExerciseRepository.getAll(),
            builder: (context, snapshot) {
              var exercises = snapshot.data;

              return Visibility(
                visible: snapshot.connectionState != ConnectionState.waiting,
                replacement: const SizedBox.shrink(),
                child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: exercises?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return const Divider(height: 0);
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseChart(title: exercises[index]),
                            ),
                          );
                        },
                        visualDensity: VisualDensity.comfortable,
                        title: Text(
                          exercises![index],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      );
                    }),
              );
            },
          ),
        );
      },
    );
  }
}
