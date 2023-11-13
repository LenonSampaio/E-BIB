import 'dart:ui';
import 'package:ebib/cad_livro.dart';
import 'package:ebib/manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Livros',
      home: UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<DocumentSnapshot> allBooks = [];

  Future<void> addDataReservaToExistingDocuments() async {
    final collectionReference = FirebaseFirestore.instance.collection('livros');

    try {
      final QuerySnapshot querySnapshot = await collectionReference.get();

      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;

        // Verifique se o campo "dataReserva" já existe no documento
        if (!data.containsKey('dataReserva')) {
          // Se não existir, adicione-o com um valor inicial, como null ou uma data padrão
          await documentSnapshot.reference.update({'dataReserva': null});
        }
      }

      print(
          'Campos "dataReserva" adicionados aos documentos existentes com sucesso.');
    } catch (e) {
      print('Erro ao adicionar campos "dataReserva": $e');
    }
  }

  void reservarLivro(String livroId) async {
    final user = FirebaseAuth.instance.currentUser;
    final livroRef =
        FirebaseFirestore.instance.collection('livros').doc(livroId);

    try {
      final agora = DateTime.now(); // Obtém a data e hora atuais

      await livroRef.update({
        'reservadoPor': user?.uid,
        'dataReserva': agora
            .toUtc()
            .toIso8601String(), // Define a data de reserva como a data e hora atuais
      });

      print('Livro reservado com sucesso.');

      // Você pode adicionar lógica adicional aqui, se necessário
    } catch (e) {
      print('Erro ao reservar livro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      30.0), // Ajuste o raio conforme necessário
                  bottomRight: Radius.circular(
                      30.0), // Ajuste o raio conforme necessário
                ),
              ),
              title: Text('Lista de Livros'),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Color.fromARGB(255, 143, 10, 177),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: LivroSearchDelegate(allBooks),
                    );
                  },
                ),
              ],
            )),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          child: Drawer(
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                String userEmailPart = '';

                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;
                  if (user != null && user.email != null) {
                    final emailParts = user.email!.split('@');
                    if (emailParts.length == 2) {
                      userEmailPart = emailParts[0];
                    }
                  }
                }

                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 143, 10, 177),
                      ),
                      child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          String userEmailPart = '';

                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            final User? user = snapshot.data;
                            if (user != null && user.email != null) {
                              final emailParts = user.email!.split('@');
                              if (emailParts.length == 2) {
                                userEmailPart =
                                    emailParts[0]; // Parte antes do "@"
                              }
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 50.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Bem-vindo, $userEmailPart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.add_alert),
                      iconColor: Colors.blueGrey,
                      minLeadingWidth: 10,
                      title: Text('Livros Reservados'),
                      onTap: () {
                        Navigator.pop(context); // Fecha o Drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LivroReservados(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add_box),
                      iconColor: Colors.blueGrey,
                      minLeadingWidth: 10,
                      title: Text('Adicionar Livros'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroLivroScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      iconColor: Colors.blueGrey,
                      minLeadingWidth: 10,
                      title: Text('Configurações'),
                      onTap: () {
                        // Navegue para a classe ManageScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageAccountScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: Stack(children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('livros').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              allBooks = snapshot.data!.docs;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 90.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: allBooks.length,
                itemBuilder: (context, index) {
                  final livro = allBooks[index];
                  final data = livro.data() as Map<String, dynamic>;

                  final title =
                      data['titulo'] as String? ?? 'Título desconhecido';
                  final author =
                      data['autor'] as String? ?? 'Autor desconhecido';

                  return Card(
                    elevation: 50.0,
                    shadowColor: Color.fromARGB(255, 182, 182, 182),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Autor: $author',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            reservarLivro(livro.id);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 170, 170, 170))),
                          child: Text('Reservar'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ]));
  }
}

class LivroSearchDelegate extends SearchDelegate<String> {
  final List<DocumentSnapshot> allBooks;

  LivroSearchDelegate(this.allBooks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchBooks(query);
    return buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  List<DocumentSnapshot> searchBooks(String query) {
    return allBooks.where((livro) {
      final data = livro.data() as Map<String, dynamic>;
      final title = data['titulo'] as String? ?? '';
      final author = data['autor'] as String? ?? '';
      return title.toLowerCase().contains(query.toLowerCase()) ||
          author.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Widget buildSearchResults(List<DocumentSnapshot> results) {
    if (results.isEmpty) {
      return Center(
        child: Text('Nenhum resultado encontrado.'),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final livro = results[index];
        final data = livro.data() as Map<String, dynamic>;

        final title = data['titulo'] as String? ?? 'Título desconhecido';
        final author = data['autor'] as String? ?? 'Autor desconhecido';

        return Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Autor: $author',
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        );
      },
    );
  }
}

//CLASSE PARA EXIBIR A RESERVA DE LIVROS.

class LivroReservados extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros Reservados'),
        backgroundColor: Color.fromARGB(255, 49, 49, 49),
      ),
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2), // Ajuste o nível de desfoque conforme necessário
            child: Container(
              color: Colors.black.withOpacity(
                  0.5), // Cor de fundo com transparência para suavizar o desfoque
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('livros')
                .where('reservadoPor', isEqualTo: user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final livrosReservados = snapshot.data!.docs;

              if (livrosReservados.isEmpty) {
                return Center(
                  child: Text(
                    'Você não reservou nenhum livro.',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemCount: livrosReservados.length,
                itemBuilder: (context, index) {
                  final livroReservado = livrosReservados[index];
                  final data = livroReservado.data() as Map<String, dynamic>;

                  final title =
                      data['titulo'] as String? ?? 'Título desconhecido';
                  final author =
                      data['autor'] as String? ?? 'Autor desconhecido';
                  final dataReserva = data['dataReserva'] as String? ??
                      'Data de Reserva Desconhecida';

                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Título: $title',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Autor: $author',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Data de Reserva: $dataReserva',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
