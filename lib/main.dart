import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log/utils/init_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'pages/exercises_page.dart';
import 'utils/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  fs = FirebaseFirestore.instance;

  await Hive.initFlutter();
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
  final List<String> _sections = ['Pernas', 'Peito', 'Costas', 'Ombro', 'Bíceps', 'Tríceps', 'Antebraço', 'Abdômen'];

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

        initFireStore();

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
          body: ListView.separated(
            physics: const ClampingScrollPhysics(),
            itemCount: _sections.length,
            separatorBuilder: (context, index) {
              return const Divider(height: 0);
            },
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExercisesPage(section: _sections[index]),
                    ),
                  );
                },
                visualDensity: VisualDensity.comfortable,
                title: Text(_sections[index]),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
              );
            },
          ),
        );
      },
    );
  }
}
