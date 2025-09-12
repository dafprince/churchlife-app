import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';

/// Page pour ajouter un nouvel utilisateur
///
/// Cette page affiche un formulaire vide pour créer un user
class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // 1. Controllers pour gérer les champs de texte
  //    Pas de valeurs initiales car on crée un nouveau user
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // 2. Clé pour le formulaire (validation)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // 3. IMPORTANT : libérer les controllers
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  /// Méthode pour sauvegarder le nouvel utilisateur
  void _saveUser() {
    // 4. Vérifier que le formulaire est valide
    if (_formKey.currentState!.validate()) {
      // 5. Récupérer les valeurs des champs
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final age = int.parse(_ageController.text);

      // 6. Envoyer l'événement au BLoC pour créer l'utilisateur
      //    Pas d'ID car c'est une création
      context.read<UserBloc>().add(
        AddUserEvent(name: name, email: email, age: age),
      );

      // 7. Message de confirmation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Création en cours...')));

      // 8. Retourner à la page précédente
      Navigator.pop(context);
    }
  }

  /// Méthode pour réinitialiser le formulaire
  void _resetForm() {
    // 9. Vider tous les champs
    _nameController.clear();
    _emailController.clear();
    _ageController.clear();

    // 10. Réinitialiser les erreurs de validation
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 11. AppBar avec titre
      appBar: AppBar(
        title: Text('Ajouter un utilisateur'),
        backgroundColor: Colors.green,
      ),

      // 12. Corps : formulaire
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Lier le formulaire
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 13. Icône ou image (optionnel, pour le style)
                Icon(Icons.person_add, size: 80, color: Colors.green),
                SizedBox(height: 20),

                // 14. Champ NOM
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Entrez le nom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  // Validation du nom
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le nom est obligatoire';
                    }
                    if (value.trim().length < 2) {
                      return 'Le nom doit avoir au moins 2 caractères';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 15. Champ EMAIL
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'exemple@email.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // Validation de l'email
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'L\'email est obligatoire';
                    }
                    // Validation basique avec @ et .
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 16. Champ AGE
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    hintText: '25',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  keyboardType: TextInputType.number,
                  // Validation de l'âge
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'L\'âge est obligatoire';
                    }
                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Entrez un nombre valide';
                    }
                    if (age < 1 || age > 120) {
                      return 'L\'âge doit être entre 1 et 120';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),

                // 17. Boutons d'action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Bouton Réinitialiser
                    ElevatedButton.icon(
                      onPressed: _resetForm,
                      icon: Icon(Icons.clear),
                      label: Text('Effacer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),

                    // Bouton Ajouter
                    ElevatedButton.icon(
                      onPressed: _saveUser,
                      icon: Icon(Icons.add),
                      label: Text('Ajouter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                // 18. Note d'information (optionnel)
                SizedBox(height: 20),
                Text(
                  'Tous les champs sont obligatoires',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
