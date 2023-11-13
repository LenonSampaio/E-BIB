import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  User? _user; // Variável para armazenar o usuário autenticado

  // Função para atualizar as informações de login
  void _updateAccountInfo() {
    // Implemente a lógica para atualizar as informações de login aqui.
    // Isso pode envolver o uso do Firebase Authentication ou outro método de autenticação.
    // Certifique-se de validar e verificar os dados fornecidos pelo usuário antes de atualizar as informações.
    // Após a atualização, você pode exibir um feedback ao usuário, como um SnackBar.
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser; // Obtém o usuário autenticado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 60, // Tamanho da foto de perfil
                backgroundImage: NetworkImage(_user?.photoURL ?? ''),
                backgroundColor: Color.fromARGB(
                    0, 255, 0, 0), // Define a cor de fundo transparente
              ),
              SizedBox(height: 16.0),
              Text(
                'Nome de Usuário:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Novo nome de usuário',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Endereço de E-mail:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                _user?.email ?? 'Email desconhecido',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Senha:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Nova senha',
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _updateAccountInfo,
                child: Text('Atualizar Informações de Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
