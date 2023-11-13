import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroLivroScreen extends StatefulWidget {
  @override
  _CadastroLivroScreenState createState() => _CadastroLivroScreenState();
}

class _CadastroLivroScreenState extends State<CadastroLivroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  String _livroCadastrado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
          ),
          title: Text('Cadastro de Livros'),
          centerTitle: true,
          elevation: 20.0,
          backgroundColor: Color.fromARGB(255, 143, 10, 177),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundo_user.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300.0, // Largura desejada
            height: 300.0, // Altura desejada
            child: Card(
              elevation: 10.0,
              color: Colors.white
                  .withOpacity(0.8), // Defina a cor com transparência
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration:
                            InputDecoration(labelText: 'Título do Livro'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o título do livro.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _autorController,
                        decoration:
                            InputDecoration(labelText: 'Autor do Livro'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do autor.';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection('livros')
                                .add({
                              'titulo': _tituloController.text,
                              'autor': _autorController.text,
                            }).then((value) {
                              setState(() {
                                _livroCadastrado =
                                    'Livro cadastrado com sucesso:\nTítulo: ${_tituloController.text}\nAutor: ${_autorController.text}';
                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao cadastrar o livro.'),
                                ),
                              );
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 143, 10, 177)
                              // Change this color to your desired color
                              ),
                        ),
                        child: Text('Cadastrar Livro'),
                      ),
                      if (_livroCadastrado.isNotEmpty)
                        Card(
                          shape: Border(
                              top: BorderSide(
                                  color: Color.fromARGB(255, 255, 0, 0))),
                          elevation: 80.0,
                          color: Colors.white.withOpacity(
                              0.8), // Defina a cor com transparência
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              '$_livroCadastrado',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
