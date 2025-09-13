import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/livres/presentation/widgets/pdf_viewer_page.dart'
    show PDFViewerPage, PDFViewerPdfx;
import '../bloc/livre_bloc.dart';
import '../bloc/livre_event.dart';
import '../bloc/livre_state.dart';
import '../data/models/livre_model.dart';

class LivrePage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const LivrePage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<LivrePage> createState() => _LivrePageState();
}

class _LivrePageState extends State<LivrePage> {
  @override
  void initState() {
    super.initState();
    // Déclencher le chargement des livres au démarrage
    context.read<LivreBloc>().add(
      LoadLivresByCategoryEvent(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      ),
    );
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
                        "📚 ${widget.categoryName}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Équilibrer le centrage
                  ],
                ),
              ),

              // Contenu principal avec BlocBuilder
              Expanded(
                child: BlocBuilder<LivreBloc, LivreState>(
                  builder: (context, state) {
                    if (state is LivreLoading) {
                      // Affichage du loading
                      return Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is LivreLoaded) {
                      // Vérifier si la liste est vide
                      if (state.livres.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 80,
                                color: Colors.white70,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Aucun livre dans cette catégorie',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Affichage de la liste des livres
                      return _buildLivresList(state.livres);
                    } else if (state is LivreError) {
                      // Affichage de l'erreur
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Erreur : ${state.message}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => context.read<LivreBloc>().add(
                                LoadLivresByCategoryEvent(
                                  categoryId: widget.categoryId,
                                  categoryName: widget.categoryName,
                                ),
                              ),
                              child: Text('Réessayer'),
                            ),
                          ],
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

  // Méthode pour construire la liste des livres
  Widget _buildLivresList(List<LivreModel> livres) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: livres.length,
      itemBuilder: (context, index) {
        return _buildLivreCard(livres[index]);
      },
    );
  }

  // Card pour chaque livre (version simple pour commencer)
  Widget _buildLivreCard(LivreModel livre) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Image.network(
          livre.getImageUrl(),
          width: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.book, size: 60),
        ),
        title: Text(livre.titre),
        subtitle: Text('Par ${livre.auteur}'),
        trailing: Icon(Icons.arrow_forward_ios),
        //  print('URL PDF: ${livre.getPdfUrl()}');
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPdfx(
                pdfUrl: livre.getPdfUrl(),
                bookTitle: livre.titre,
                author: livre.auteur,
              ),
            ),
          );
        },
      ),
    );
  }
}
