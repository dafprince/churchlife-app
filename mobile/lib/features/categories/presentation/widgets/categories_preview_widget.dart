import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/livres/bloc/livre_bloc.dart';
import 'package:mobile/features/livres/presentation/Screen/livre_page_enhanced.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_state.dart';
import '../../data/models/category_model.dart';
import '../../../eglises/presentation/widget/NetworkImageWithPlaceholder.dart';

class CategoriesPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Container(
            height: 210,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF6E8EF5)),
            ),
          );
        } else if (state is CategoryLoaded) {
          final firstFour = state.categories.take(4).toList();
          return _buildCategoryRow(context, firstFour);
        } else if (state is CategoryError) {
          return Container(
            height: 210,
            child: Center(
              child: Text(
                'Erreur : ${state.message}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        return Container(height: 210); // état initial
      },
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    List<CategoryModel> categories,
  ) {
    return SizedBox(
      height: 200, // Hauteur totale du conteneur
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image avec Expanded - prend l'espace disponible
                Expanded(
                  child: Stack(
                    children: [
                      NetworkImageWithPlaceholder(
                        imageUrl: cat.getImageUrl(),
                        width: 140,
                        height: double
                            .infinity, // Prend toute la hauteur disponible
                        borderRadius: 22,
                      ),
                      Container(
                        width: 140,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            cat.nom,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Espacement fixe
                const SizedBox(height: 8),

                // Bouton avec taille fixe - ne prend que l'espace nécessaire
                SizedBox(
                  height: 36,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<LivreBloc>(),
                              child: LivrePageEnhanced(
                                categoryId: cat.id,
                                categoryName: cat.nom,
                                categoryDescription:
                                    cat.description, // ✅ Ajouter
                                categoryImageUrl: cat
                                    .getImageUrl(), // ✅ Ajouter
                              ),
                            ),
                          ),
                        );
                        // TODO: navigation category
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E8EF5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text(
                        'Explorer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                // Espacement en bas pour éviter que le bouton touche le bord
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
