// features/categories/presentation/widgets/categories_library_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/livres/bloc/livre_bloc.dart';
import 'package:mobile/features/livres/presentation/Screen/livre_page_enhanced.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_state.dart';
import '../../data/models/category_model.dart';

class CategoriesLibrarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return _buildLoadingState();
        } else if (state is CategoryLoaded) {
          return _buildCategoriesList(context, state.categories);
        } else if (state is CategoryError) {
          return _buildErrorState(state.message);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF6E8EF5)),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        child: Center(
          child: Text('Erreur: $message', style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<CategoryModel> categories,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final categorie = categories[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      categorie.getImageUrl(), // ✅ Vraie image depuis backend
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.book, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  categorie.nom, // ✅ Vrai nom depuis backend
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.blue.shade800,
                  ),
                ),
                subtitle: Text(
                  categorie.description, // ✅ Vraie description depuis backend
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF6E8EF5),
                  size: 16,
                ),
                onTap: () {
                  // Navigation vers les livres de cette catégorie
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<LivreBloc>(),
                        child: LivrePageEnhanced(
                          categoryId: categorie.id,
                          categoryName: categorie.nom,
                          categoryDescription:
                              categorie.description, // ✅ Ajouter
                          categoryImageUrl: categorie
                              .getImageUrl(), // ✅ Ajouter
                        ),
                      ),
                    ),
                  );
                  print('Tapped on: ${categorie.nom}');
                },
              ),
            ),
          ),
        );
      }, childCount: categories.length),
    );
  }
}
