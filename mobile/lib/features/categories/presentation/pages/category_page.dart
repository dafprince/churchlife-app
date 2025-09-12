import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/categories/presentation/widgets/CategoryCard.dart';
import 'package:mobile/features/livres/bloc/livre_bloc.dart';
import 'package:mobile/features/livres/presentation/livre_page.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_event.dart';
import '../../bloc/category_state.dart';
import '../../data/models/category_model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    // Charger les catégories au démarrage de la page
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête (même que votre design)
              // En-tête avec bouton retour
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "📚 Catégories de Livres",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Espace pour équilibrer le centrage
                  ],
                ),
              ),

              // Contenu principal avec BlocBuilder
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      // Affichage du loading
                      return Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is CategoryLoaded) {
                      // Affichage des catégories
                      return _buildCategoryGrid(state.categories);
                    } else if (state is CategoryError) {
                      // Affichage de l'erreur
                      return Center(
                        child: Text(
                          'Erreur : ${state.message}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour construire la grille des catégories
  Widget _buildCategoryGrid(List<CategoryModel> categories) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: categories[index],
            onTap: () => _onCategoryTap(context, categories[index]),
          );
        },
      ),
    );
  }

  // Fonction pour déterminer le nombre de colonnes
  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  // Action quand on clique sur une catégorie
  void _onCategoryTap(BuildContext context, CategoryModel category) {
    // Navigation vers la page des livres de cette catégorie
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LivreBloc>(), // Réutiliser le LivreBloc
          child: LivrePage(categoryId: category.id, categoryName: category.nom),
        ),
      ),
    );

    /**
    *  ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(content: Text("Catégorie sélectionnée: ${category.nom}")),
    );
    */
  }
}
