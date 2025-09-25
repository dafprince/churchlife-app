// features/annonces/presentation/widgets/annonces_section_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/annonce_bloc.dart';
import '../bloc/annonce_state.dart';
import '../data/models/annonce_model.dart';

class AnnoncesSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Nos annonces',
            style: TextStyle(
              color: Color(0xFF536DFE),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<AnnonceBloc, AnnonceState>(
          builder: (context, state) {
            if (state is AnnonceLoading) {
              return Container(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF536DFE)),
                ),
              );
            } else if (state is AnnonceLoaded) {
              return _buildAnnoncesPageView(state.annonces);
            } else if (state is AnnonceError) {
              return Container(
                height: 180,
                child: Center(
                  child: Text(
                    'Erreur: ${state.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return Container(height: 180); // État initial
          },
        ),
      ],
    );
  }

  Widget _buildAnnoncesPageView(List<AnnonceModel> annonces) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: PageController(),
        itemCount: annonces.length,
        itemBuilder: (context, index) {
          final annonce = annonces[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 6),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  children: [
                    // Image réelle de l'annonce
                    Image.network(
                      annonce.getImageUrl(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    // Overlay avec le texte réel
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          color: Colors.black45,
                        ),
                        child: Text(
                          annonce.texte, // 🎯 Texte réel de l'annonce
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
