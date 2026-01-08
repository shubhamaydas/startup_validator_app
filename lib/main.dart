import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    // For web, you need to provide options
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBm6boo9eQ4c0RWCLJ4EObJJHl4_CcIRjc',
          authDomain: 'fir-validator-app.firebaseapp.com',
          projectId: 'firebase-validator-app',
          storageBucket: 'firebase-validator-app.firebasestorage.app',
          messagingSenderId: '396448555814',
          appId: '1:396448555814:web:35f22f98e00eb3573517e7',
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        title: 'Startup Validator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF16A085),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF16A085),
            secondary: const Color(0xFFE67E22),
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
