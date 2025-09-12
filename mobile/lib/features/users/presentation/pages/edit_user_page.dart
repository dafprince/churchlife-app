import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_bloc.dart';
import '../../bloc/user_event.dart';
import '../../data/models/User.dart';

/// Page pour modifier un utilisateur
///
/// Cette page reçoit un User existant et permet de modifier ses infos
class EditUserPage extends StatefulWidget {
  // L'utilisateur à modifier (on le passe depuis la liste)
  final User user;

  // Constructeur : on doit obligatoirement passer un User
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  // 1. Controllers pour gérer les champs de texte
  //    late = initialisé plus tard dans initState
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;

  // 2. Clé pour le formulaire (pour la validation)
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 3. On initialise les controllers avec les valeurs actuelles de l'utilisateur
    //    widget.user = l'utilisateur passé au constructeur
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  void dispose() {
    // 4. IMPORTANT : toujours libérer les controllers pour éviter les fuites mémoire
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  /// Méthode pour sauvegarder les modifications
  void _saveChanges() {
    // 5. Vérifier que le formulaire est valide
    if (_formKey.currentState!.validate()) {
      // 6. Créer un User avec les nouvelles valeurs
      //    On garde le même ID mais on change les autres champs
      final updatedUser = User(
        id: widget.user.id, // IMPORTANT : garder le même ID
        name: _nameController.text.trim(), // trim() enlève les espaces
        email: _emailController.text.trim(),
        age: int.parse(_ageController.text), // Convertir en nombre
      );

      // 7. Envoyer l'événement au BLoC pour modifier
      context.read<UserBloc>().add(UpdateUserEvent(updatedUser));

      // 8. Message de confirmation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Modification en cours...')));

      // 9. Retourner à la page précédente
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 10. AppBar avec titre
      appBar: AppBar(
        title: Text('Modifier ${widget.user.name}'),
        backgroundColor: Colors.orange,
      ),

      // 11. Corps de la page : le formulaire
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Lier le formulaire à sa clé
          child: Column(
            children: [
              // 12. Champ NOM
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                // Validation : le nom ne doit pas être vide
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est obligatoire';
                  }
                  return null; // null = pas d'erreur
                },
              ),
              SizedBox(height: 16),

              // 13. Champ EMAIL
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                // Validation basique de l'email
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'email est obligatoire';
                  }
                  // Vérification simple avec @
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // 14. Champ AGE
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number, // Clavier numérique
                // Validation de l'âge
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'âge est obligatoire';
                  }
                  // Vérifier que c'est un nombre
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Age invalide (1-120)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              // 15. Boutons Annuler / Sauvegarder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Bouton Annuler
                  ElevatedButton(
                    onPressed: () {
                      // Retour sans sauvegarder
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: Text('Annuler'),
                  ),

                  // Bouton Sauvegarder
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: Text('Sauvegarder'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
