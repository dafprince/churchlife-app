import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/category_event.dart';
import '../../presentation/widgets/categories_library_section.dart';

class PenseeDuJourWidget extends StatefulWidget {
  @override
  _PenseeDuJourWidgetState createState() => _PenseeDuJourWidgetState();
}

class _PenseeDuJourWidgetState extends State<PenseeDuJourWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;

  final String penseeComplete = """
"Si vous aviez de la foi comme un grain de sénevé, vous diriez à cette montagne: Transporte-toi d'ici là, et elle se transporterait; rien ne vous serait impossible." - Matthieu 17:20

La foi n'est pas une force magique, mais une confiance profonde en Dieu. Même petite comme un grain de moutarde, elle peut accomplir des merveilles. Aujourd'hui, abandonnons nos doutes et embrassons cette confiance divine.

Dans nos moments de découragement, souvenons-nous que Dieu est fidèle. Il connaît nos besoins avant même que nous les exprimions. Sa grâce suffit, et sa force s'accomplit dans notre faiblesse.

Prions pour que notre foi grandisse chaque jour, non par nos efforts, mais par la révélation de l'amour inconditionnel de notre Père céleste. Car c'est dans cette intimité avec Lui que naissent les miracles.
  """;

  @override
  void initState() {
    super.initState();
    // Charger les catégories au démarrage
    context.read<CategoryBloc>().add(LoadCategoriesEvent());

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Widget pour créer l'effet wave/onde
  Widget _buildWaveShape() {
    return ClipPath(
      clipper: WaveClipper(),
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

  // Widget séparé pour la pensée du jour
  Widget _buildPenseeDuJour() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF8DC), Color(0xFFF5DEB3), Color(0xFFDEB887)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD2691E), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFCD853F).withOpacity(0.3),
                width: 2,
              ),
            ),
            margin: EdgeInsets.all(8),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: Color(0xFF8B4513),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Pensée du Jour',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513),
                        fontFamily: 'Serif',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFF8B4513),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '30 Septembre 2025',
                      style: TextStyle(
                        color: Color(0xFF8B4513),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'La Foi qui Déplace les Montagnes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF654321),
                    fontFamily: 'Serif',
                  ),
                ),
                SizedBox(height: 20),
                Icon(Icons.format_quote, color: Color(0xFFCD853F), size: 32),
                SizedBox(height: 16),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    isExpanded
                        ? penseeComplete
                        : penseeComplete.substring(0, 200) + "...",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF654321),
                      fontFamily: 'Serif',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      if (isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    });
                  },
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                  label: Text(
                    isExpanded ? 'Réduire' : 'Lire la suite',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCD853F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                if (isExpanded) ...[
                  SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFCD853F),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Text(
                        '"Car nous marchons par la foi et non par la vue." - 2 Corinthiens 5:7',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B4513),
                          fontFamily: 'Serif',
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar personnalisé avec header magnifique
          SliverAppBar(
            pinned: true, // Reste fixe en haut
            expandedHeight: 320, // Grand header
            backgroundColor: Color(0xFF87CEEB), // Bleu ciel
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // FlexibleSpaceBar avec design personnalisé
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Ma bibliothèque',
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
              // Background magnifique avec dégradé + image + wave
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Dégradé bleu ciel
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF87CEEB), // Sky blue
                          Color(0xFF4682B4), // Steel blue
                          Color(0xFF6495ED), // Cornflower blue
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),

                  // Image de bibliothèque en arrière-plan
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800',
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

                  // Overlay pour améliorer la lisibilité
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),

                  // Icône de bibliothèque stylisée
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
                            Icons.library_books,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Découvrez notre collection',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Effet wave en bas du header
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

          // Pensée du jour qui glisse sous l'AppBar
          SliverToBoxAdapter(child: _buildPenseeDuJour()),

          // Titre de section qui glisse sous l'AppBar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Icon(Icons.explore, color: Color(0xFF6E8EF5), size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Découvrez et soyez curieux',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E8EF5),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ SECTION MODIFIÉE : Vraies catégories depuis le backend
          CategoriesLibrarySection(),

          // Espacement en bas
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
          if (idx == 0) {
            Navigator.of(context).pop();
          }
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
}

// Classe pour créer l'effet wave/onde
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);

    // Première courbe
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 20,
    );

    // Deuxième courbe
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 10,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
