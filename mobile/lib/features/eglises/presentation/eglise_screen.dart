import 'package:flutter/material.dart';
import 'package:mobile/features/eglises/presentation/EgliseDetailScreen.dart';

class EgliseScreen extends StatefulWidget {
  @override
  _EgliseScreenState createState() => _EgliseScreenState();
}

class _EgliseScreenState extends State<EgliseScreen> {
  // URLs corrigées et complètes
  final List<Map<String, String>> eglises = [
    {
      "nom": "Église Béthel",
      "image":
          "https://images.unsplash.com/photo-1465101046530-73398c28ca38?w=500",
    },
    {
      "nom": "Saint Clément",
      "image":
          "https://images.unsplash.com/photo-1446697861703-cd2c70a18eea?w=500",
    },
    {
      "nom": "Évangélique Lumière",
      "image":
          "https://images.unsplash.com/photo-1470770841072-f978cfd019d0?w=500",
    },
    {
      "nom": "Paroisse Espérance",
      "image":
          "https://images.unsplash.com/photo-1417021542247-8d428cbe1e61?w=500",
    },
    {
      "nom": "Temple Sion",
      "image":
          "https://images.unsplash.com/photo-1506744038136-4627b3a3c2b5?w=500",
    },
    {
      "nom": "Maison de Sion",
      "image":
          "https://images.unsplash.com/photo-1560216055-42861a07c6e8?w=500",
    },
    {
      "nom": "Église Réforme",
      "image":
          "https://images.unsplash.com/photo-1491336477066-31156b5e8caf?w=500",
    },
    {
      "nom": "Chapelle Saint-Paul",
      "image":
          "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=500",
    },
    {
      "nom": "Sanctuaire Lumière",
      "image":
          "https://images.unsplash.com/photo-1472220625704-91e1462799b2?w=500",
    },
    {
      "nom": "Centre Spirituel",
      "image":
          "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?w=500",
    },
    {
      "nom": "Temple de la Paix",
      "image":
          "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=500",
    },
    {
      "nom": "Église Nouvelle Vie",
      "image":
          "https://images.unsplash.com/photo-1523906630133-f6934a84c6e1?w=500",
    },
  ];

  int _selectedIndex = 0;

  // Widget pour créer l'effet wave/onde
  Widget _buildWaveShape() {
    return ClipPath(
      clipper: ChurchWaveClipper(),
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
          // SliverAppBar magnifique avec design personnalisé
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
            // FlexibleSpaceBar avec design spectaculaire
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Les Églises disponibles',
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
                  // Dégradé bleu ciel magnifique
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

                  // Image d'églises en arrière-plan
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.25,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=800', // Image de plusieurs églises/cathédrales
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

                  // Icône d'église stylisée avec informations
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
                            Icons.church,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Trouvez votre communauté spirituelle',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${eglises.length} églises disponibles',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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

          // Grille des églises améliorée
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final eglise = eglises[index];
                return GestureDetector(
                  onTap: () {
                    if (eglise['nom'] == 'Maison de Sion') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EgliseDetailScreen()),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Image de l'église
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              eglise["image"]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.shade300,
                                          Colors.grey.shade500,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.church,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF6E8EF5),
                                        ),
                                      ),
                                    );
                                  },
                            ),
                          ),
                        ),

                        // Overlay gradient pour le texte
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),

                        // Nom de l'église en bas
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  eglise["nom"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8,
                                        color: Colors.black,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Disponible',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Badge spécial pour "Maison de Sion"
                        if (eglise['nom'] == 'Maison de Sion')
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Actif',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: eglises.length),
            ),
          ),

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

// Classe pour créer l'effet wave/onde spécifique aux églises
class ChurchWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 25);

    // Première courbe douce
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 5,
      size.width * 0.5,
      size.height - 15,
    );

    // Deuxième courbe
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
