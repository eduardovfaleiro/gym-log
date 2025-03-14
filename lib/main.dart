// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log/pages/authentication/login_page.dart';
import 'package:gym_log/util.dart';
import 'package:gym_log/utils/init_firestore.dart';
import 'package:gym_log/widgets/brightness_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'theme.dart';

const kMaxLengthWeight = 4;
const kMaxWeight = 9999.99;

const kMaxLengthReps = 4;
const kMaxReps = 9999;

const kMaxLengthNotes = 120;

late FirebaseFirestore fs;
late FirebaseAuth fa;
bool networkDisabled = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  fs = FirebaseFirestore.instance;
  fs.settings = const Settings(persistenceEnabled: true);

  // bool hasConnection = await hasInternetConnection();
  // if (hasConnection) {
  //   await fs.waitForPendingWrites();
  //   await fs.terminate();
  //   await fs.clearPersistence();

  //   fs.settings = const Settings(persistenceEnabled: true);
  // }

  fa = FirebaseAuth.instance;

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
    BrightnessController(
      child: Builder(
        builder: (context) {
          TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
          MaterialTheme theme = MaterialTheme(textTheme);

          final brightness = BrightnessManager.of(context).brightness;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            theme: brightness == Brightness.light ? theme.light() : theme.dark(),
            routes: {
              '/': (context) {
                return const MainApp();
              },
            },
          );
        },
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fa.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null || !snapshot.data!.emailVerified) {
          return const LoginPage();
        }

        return FutureBuilder(
          future: initFireStore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return const HomePage();
          },
        );
      },
    );
  }
}
