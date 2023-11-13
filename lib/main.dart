import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebib/users_screen.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flip_card/flip_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDV9x2j0LZroW4iMPxjNmgxqNSmunIQUs8",
            appId: "1:405150164170:android:216019deda6d7a176f4033",
            messagingSenderId: "405150164170",
            projectId: "e-bib-5d3a4",
          ),
        )
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey, // Cor de fundo
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String errorText = '';

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = "Por favor, preencha todos os campos.";
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        errorText = "Por favor, insira um email válido.";
      });
      return;
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Login bem-sucedido, você pode navegar para outra tela aqui.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              UserScreen(), // Use o nome real da sua classe UsersScreen
        ),
      );
    } catch (error) {
      setState(() {
        errorText = "Erro ao fazer login. Verifique suas credenciais.";
      });
    }
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/logo2.jpeg"), // Substitua com o caminho correto para a sua imagem de fundo
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 20.0,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    Image.asset(
                      'assets/logo.png',
                      height: 130,
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Seu endereço de email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 32, 31, 32),
                        ),
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        hintText: 'Sua senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.lock,
                            color: Color.fromARGB(255, 32, 31, 32)),
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    AnimatedButton(
                      height: 50,
                      width: 150,
                      text: 'Entrar',
                      gradient:
                          LinearGradient(colors: [Colors.red, Colors.orange]),
                      selectedGradientColor: LinearGradient(
                          colors: [Colors.pinkAccent, Colors.purpleAccent]),
                      isReverse: true,
                      selectedTextColor:
                          const Color.fromARGB(255, 255, 255, 255),
                      transitionType: TransitionType.LEFT_TO_RIGHT,
                      backgroundColor: Colors.black,
                      borderColor: Colors.white,
                      borderRadius: 50,
                      borderWidth: 2,
                      onPress: _login,
                    ),
                    if (errorText.isNotEmpty)
                      Text(
                        errorText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
