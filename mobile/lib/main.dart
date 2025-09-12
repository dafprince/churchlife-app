import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audios/bloc/audio_bloc.dart';
import 'package:mobile/features/audios/data/datasources/audio_api_service.dart';
import 'package:mobile/features/audios/data/repositories/audio_repository.dart';
import 'package:mobile/features/categories/bloc/category_bloc.dart';
import 'package:mobile/features/categories/data/datasources/category_api_service.dart';
import 'package:mobile/features/categories/data/repositories/category_repository.dart';
import 'package:mobile/features/livres/bloc/livre_bloc.dart';
import 'package:mobile/features/livres/data/datasources/LivreApiService.dart';
import 'package:mobile/features/livres/data/repositories/LivreRepositorie.dart';
import 'package:mobile/features/users/bloc/user_bloc.dart';
import 'package:mobile/features/users/bloc/user_event.dart';
import 'package:mobile/features/users/data/repositories/UserRepository.dart';
import 'package:mobile/features/users/presentation/pages/users_page.dart';
import 'features/users/data/datasources/UserApiService.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // nécessaire avant async dans main
  /**
 * CECI PERMET DE TESTER SI LAPI MARCHE ET MONTRE SUR LA CONSOLE LAFFICHAGE DES USER DEPUIS LE BACKEND
 *  final userService = UserApiService();

  try {
    // 🔥 Appel API pour récupérer les users
    List<User> users = await userService.getUsers();

    // Affiche les utilisateurs dans la console
    for (var user in users) {
      print(user); // grâce au toString()
    }
  } catch (e) {
    print("Erreur: $e");
  }
 */

  runApp(
    // CHANGEZ BlocProvider en MultiBlocProvider pour avoir plusieurs blocs
    MultiBlocProvider(
      providers: [
        // Bloc des utilisateurs (existant)
        BlocProvider(
          create: (_) =>
              UserBloc(UserRepository(UserApiService()))..add(LoadUsersEvent()),
        ),
        // AJOUTEZ le Bloc des catégories
        BlocProvider(
          create: (_) => CategoryBloc(CategoryRepository(CategoryApiService())),
        ),
        // NOUVEAU : BLoC des livres
        BlocProvider(
          create: (_) => LivreBloc(LivreRepository(LivreApiService())),
        ),
        // NOUVEAU : BLoC des audios
        BlocProvider(
          create: (_) => AudioBloc(AudioRepository(AudioApiService())),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChurchLife',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UserPage(), // 👈 on démarre directement sur UserPage
    );
  }
}
