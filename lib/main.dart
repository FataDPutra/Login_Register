import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register/controllers/auth_firebase_provider.dart';
import 'package:login_register/firebase_options.dart';
import 'package:login_register/views/register_page.dart';
import 'package:provider/provider.dart';

void main() {
  initFirebase();
}

Future initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthFirebaseProvider(),
        ),
      ],
      child:
          const MaterialApp(debugShowCheckedModeBanner: false, home: RegisterPage()),
    );
  }
}
