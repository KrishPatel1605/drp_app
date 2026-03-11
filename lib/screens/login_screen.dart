import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'project_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  void login() {

    if (_formKey.currentState!.validate()) {

      final auth = Provider.of<AuthProvider>(context, listen: false);

      final result = auth.login(email, password);

      if (result == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProjectListScreen(),
          ),
        );
      } else {
        setState(() {
          error = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                validator: Validators.email,
                onChanged: (v) => email = v,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: Validators.password,
                onChanged: (v) => password = v,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),

              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red))

            ],
          ),
        ),
      ),
    );
  }
}