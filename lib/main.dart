import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/exercise_chart.dart';
import 'package:gym_log/main_controller.dart';
import 'package:gym_log/view_logs_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'utils/init.dart';
import 'utils/show_confirm_dialog.dart';

void main() async {
  await init();

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: ''),
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(useMaterial3: true),
      routes: {
        '/': (context) => const MainApp(),
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
  static final _controller = MainController();

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
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      bool isSure = await showConfirmDialog(
                        context,
                        'Tem certeza que deseja desconectar da sua conta?',
                        confirm: 'Sim, desconectar',
                      );

                      if (isSure) await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Desconectar'),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: const Text('Gym Log'),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await _controller.addExercise(context);
              setState(() {});
            },
          ),
          body: FutureBuilder(
            future: _controller.getExercises(),
            builder: (context, snapshot) {
              var exercises = snapshot.data;

              return Visibility(
                visible: snapshot.connectionState != ConnectionState.waiting,
                replacement: const SizedBox.shrink(),
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: exercises?.length ?? 0,
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
