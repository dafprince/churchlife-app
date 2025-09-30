// features/livres/presentation/livre_page_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/livres/presentation/widgets/LivreCardWidget.dart';
import '../../bloc/livre_bloc.dart';
import '../../bloc/livre_event.dart';
import '../../bloc/livre_state.dart';
import '../../data/models/livre_model.dart';

class LivrePageEnhanced extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryDescription;
  final String categoryImageUrl;

  const LivrePageEnhanced({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
  });

  @override
  State<LivrePageEnhanced> createState() => _LivrePageEnhancedState();
}

class _LivrePageEnhancedState extends State<LivrePageEnhanced> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<LivreBloc>().add(
      LoadLivresByCategoryEvent(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      ),
    );
  }

  Widget _buildWaveShape() {
    return ClipPath(
      clipper: BookWaveClipper(),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar magnifique
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: Color(0xFF87CEEB),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.categoryName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Dégradé magnifique
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                          Color(0xFF6E8EF5),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),

                  // Image de catégorie en arrière-plan
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.network(
                        widget.categoryImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade300,
                                Colors.blue.shade600,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Overlay pour lisibilité
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),

                  // Contenu central
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.menu_book,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.categoryDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Effet wave
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: _buildWaveShape(),
                  ),
                ],
              ),
            ),
          ),

          // Contenu avec BlocBuilder
          BlocBuilder<LivreBloc, LivreState>(
            builder: (context, state) {
              if (state is LivreLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6E8EF5)),
                  ),
                );
              } else if (state is LivreLoaded) {
                if (state.livres.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Aucun livre dans cette catégorie',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _buildLivresList(state.livres);
              } else if (state is LivreError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Erreur: ${state.message}')),
                );
              }
              return SliverFillRemaining(child: SizedBox.shrink());
            },
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
          if (idx == 0) Navigator.of(context).pop();
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Color(0xFF6E8EF5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: "Programmes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "Contact",
          ),
        ],
      ),
    );
  }

  Widget _buildLivresList(List<LivreModel> livres) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return LivreCardWidget(
            livre: livres[index],
            onTap: () {
              // Navigation vers PDF viewer
            },
          );
        }, childCount: livres.length),
      ),
    );
  }
}

class BookWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 5,
      size.width * 0.5,
      size.height - 15,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 35,
      size.width,
      size.height - 5,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
