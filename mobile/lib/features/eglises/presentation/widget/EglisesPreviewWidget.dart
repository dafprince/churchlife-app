// features/eglises/presentation/widgets/eglises_preview_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/eglise_bloc.dart';
import '../../bloc/eglise_state.dart';
import '../../data/models/eglise_model.dart';
import '../eglise_screen.dart';

class EglisesPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EgliseBloc, EgliseState>(
      builder: (context, state) {
        if (state is EgliseLoading) {
          return Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF6E8EF5)),
            ),
          );
        } else if (state is EgliseLoaded) {
          // Prendre seulement les 4 premières églises
          final firstFourEglises = state.eglises.take(4).toList();
          return _buildEglisesGrid(context, firstFourEglises);
        } else if (state is EgliseError) {
          return Container(
            height: 200,
            child: Center(
              child: Text(
                'Erreur: ${state.message}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        return Container(height: 200); // État initial
      },
    );
  }

  Widget _buildEglisesGrid(BuildContext context, List<EgliseModel> eglises) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: eglises.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final eglise = eglises[index];
          return GestureDetector(
            onTap: () {
              // Navigation vers la page complète des églises
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => EgliseScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 9,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    // Image réelle de l'église
                    Image.network(
                      eglise.getImageUrl(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade500,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.church,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    // Overlay gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                    // Nom de l'église en haut
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: Text(
                        eglise.nom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Badge "Écouter" en bas
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Écouter',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
