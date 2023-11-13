import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class LivroReservados extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> reservarLivro() async {
    final agora = Timestamp.now(); // Obtém a data e hora atuais

    final livro = {
      'titulo': 'Livro 1',
      'autor': 'Autor 1',
      'disponivel': false,
      'reservadoPor': user?.uid,
      'dataReserva':
          agora, // Define a data de reserva automaticamente como Timestamp
    };

    // Adiciona o livro ao Firestore
    await FirebaseFirestore.instance.collection('livros').add(livro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 177, 9, 243),
        title: Text('Livros Reservados'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text('Você não reservou nenhum livro.'),
            );
          }

          return ListView.builder(
            itemCount: livrosReservados.length,
            itemBuilder: (context, index) {
              final livroReservado = livrosReservados[index];
              final data = livroReservado.data() as Map<String, dynamic>;
              final titulo = data['titulo'] as String? ?? 'Título desconhecido';
              final autor = data['autor'] as String? ?? 'Autor desconhecido';
              final dataReserva = data['dataReserva'] as Timestamp?;

              String dataReservaFormatada = 'Data de Reserva Desconhecida';

              if (dataReserva != null) {
                final dateTime = dataReserva.toDate();
                dataReservaFormatada =
                    DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
              }

              return Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Título: $titulo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Autor: $autor',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email do Usuário: ${user?.email}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Data de Reserva: $dataReservaFormatada',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reservarLivro, // Chame a função para reservar o livro
        child: Icon(Icons.add),
      ),
    );
  }
}
