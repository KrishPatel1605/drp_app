import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/dpr_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DPRProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DPR App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}