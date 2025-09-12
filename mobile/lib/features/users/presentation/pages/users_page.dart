import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audios/bloc/audio_bloc.dart';
import 'package:mobile/features/audios/presentation/audio_page.dart';
import 'package:mobile/features/categories/bloc/category_bloc.dart';
import 'package:mobile/features/categories/presentation/pages/category_page.dart';
import 'package:mobile/features/users/bloc/user_event.dart';
import 'package:mobile/features/users/bloc/user_state.dart';
import 'package:mobile/features/users/presentation/add_user_page.dart';
import '../../bloc/user_bloc.dart';
import '../../data/models/User.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'edit_user_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  /// Méthode pour afficher une popup de confirmation avant suppression
  ///
  /// [user] : l'utilisateur à supprimer
  ///
  /// Pourquoi une confirmation ?
  /// - Éviter les suppressions accidentelles
  /// - Bonne pratique UX
  Future<void> _confirmDelete(User user) async {
    // 1. Afficher une boîte de dialogue de confirmation
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          // On affiche le nom de l'utilisateur pour être clair
          content: Text('Voulez-vous vraiment supprimer ${user.name} ?'),
          actions: [
            // Bouton Annuler - retourne false
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Annuler'),
            ),
            // Bouton Supprimer - retourne true
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // 2. Si l'utilisateur a confirmé (true), on lance la suppression
    if (confirm == true) {
      // On envoie l'événement de suppression au BLoC
      // Le BLoC va appeler le repository → API → Backend
      context.read<UserBloc>().add(DeleteUserEvent(user.id));

      // Message de feedback (optionnel)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Suppression de ${user.name} en cours...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  IO.Socket? socket;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Connexion Socket.IO
    socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.onConnect((_) => print('Connecté au WebSocket'));

    // Écoute suppression d'un user
    socket!.on('user_deleted', (userId) {
      print('Utilisateur supprimé: $userId');
      // relancer la requête pour mettre à jour la liste
      context.read<UserBloc>().add(LoadUsersEvent());
    });
    socket!.on('user_added', (userData) {
      print('Utilisateur ajouté: $userData');
      context.read<UserBloc>().add(LoadUsersEvent());
    });
    socket!.on('user_updated', (userData) {
      print('Utilisateur modifié: $userData');
      context.read<UserBloc>().add(LoadUsersEvent());
    });
    // Charger la liste au démarrage
    context.read<UserBloc>().add(LoadUsersEvent());
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des utilisateurs")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final users = state.users;
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 colonnes
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final u = users[index];
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text('Nom : ${u.name}', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 5),
                        Text(
                          'Email : ${u.email}',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Age : ${u.age} ans',
                          style: TextStyle(fontSize: 14),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _confirmDelete(u);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.all(8),
                                ),
                                child: Text(
                                  'Supprimer',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigation vers EditUserPage
                                  // On passe l'utilisateur actuel (u) à la page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditUserPage(user: u),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.all(8),
                                ),
                                child: Text(
                                  'Modifier',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Erreur : ${state.message}'));
          }
          return SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Actions pour chaque bouton
          if (index == 0) {
            // Bouton Audios
            print('Audios cliqué');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AudioBloc>(),
                  child: const AudioPage(),
                ),
              ),
            );
          } else if (index == 1) {
            // MODIFIER ICI : Bouton Ajouter
            // Navigation vers la page d'ajout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<UserBloc>(), // 🔑 réutiliser le même bloc
                  child: const AddUserPage(),
                ),
              ),
            );
          } else if (index == 2) {
            // Bouton Mes téléchargements
            print('Mes téléchargements cliqué');
          } else if (index == 3) {
            print('bible');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context
                      .read<CategoryBloc>(), // 🔑 réutiliser le même bloc
                  child: const CategoryPage(),
                ),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            label: 'Audios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 30),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'téléchargements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bibliothèque',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
