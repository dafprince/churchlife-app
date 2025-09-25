import 'package:flutter/material.dart';

class EgliseDetailScreen extends StatefulWidget {
  @override
  State<EgliseDetailScreen> createState() => _EgliseDetailScreenState();
}

// Données fictives des prédications audio
final List<Map<String, String>> predications = [
  {
    "titre": "La Foi qui Déplace les Montagnes",
    "pasteur": "Pasteur Jean Kouadio",
    "duree": "45 min",
    "date": "20 Sept 2025",
    "image":
        "https://images.unsplash.com/photo-1465101046530-73398c28ca38?w=500",
    "description": "Une prédication puissante sur la foi authentique",
  },
  {
    "titre": "L'Amour de Dieu sans Limite",
    "pasteur": "Pasteur Marie Diallo",
    "duree": "38 min",
    "date": "17 Sept 2025",
    "image":
        "https://images.unsplash.com/photo-1446697861703-cd2c70a18eea?w=500",
    "description": "Découvrir l'amour inconditionnel du Père",
  },
  {
    "titre": "Marcher dans la Lumière",
    "pasteur": "Pasteur Paul Mensah",
    "duree": "42 min",
    "date": "13 Sept 2025",
    "image":
        "https://images.unsplash.com/photo-1470770841072-f978cfd019d0?w=500",
    "description": "Comment vivre selon les principes divins",
  },
  {
    "titre": "Le Feu de l'Esprit Saint",
    "pasteur": "Pasteur David Ouattara",
    "duree": "51 min",
    "date": "10 Sept 2025",
    "image":
        "https://images.unsplash.com/photo-1491336477066-31156b5e8caf?w=500",
    "description": "L'action transformatrice de l'Esprit",
  },
  {
    "titre": "Les Promesses de Dieu",
    "pasteur": "Pasteur Ruth Kone",
    "duree": "36 min",
    "date": "6 Sept 2025",
    "image":
        "https://images.unsplash.com/photo-1523906630133-f6934a84c6e1?w=500",
    "description": "S'approprier les promesses bibliques",
  },
];

class _EgliseDetailScreenState extends State<EgliseDetailScreen> {
  int _selectedIndex = 0;

  // Widget pour créer l'effet wave
  Widget _buildWaveShape() {
    return ClipPath(
      clipper: AudioWaveClipper(),
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
          // SliverAppBar magnifique pour les prédications
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
                'Maison de Sion',
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
                          Color(0xFF87CEEB), // Sky blue
                          Color(0xFF4682B4), // Steel blue
                          Color(0xFF6495ED), // Cornflower blue
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),

                  // Image de l'église en arrière-plan
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.network(
                        "https://images.unsplash.com/photo-1560216055-42861a07c6e8?w=500",
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
                          Colors.black.withOpacity(0.3),
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
                            Icons.headphones,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Prédications Audio',
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
                            '${predications.length} messages disponibles',
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

          // Section titre
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Icon(Icons.playlist_play, color: Color(0xFF6E8EF5), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Messages récents',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E8EF5),
                          ),
                        ),
                        Text(
                          'Écoutez les dernières prédications',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Liste des prédications
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final predication = predications[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.blue.shade50.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Image/Thumbnail de la prédication
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    predication["image"]!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Icon(
                                                Icons.headphones,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            ),
                                          );
                                        },
                                  ),
                                ),
                                // Bouton play overlay
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Color(0xFF6E8EF5),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 16),

                          // Informations de la prédication
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  predication["titre"]!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  predication["description"]!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      predication["pasteur"]!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          0xFF6E8EF5,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        predication["duree"]!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6E8EF5),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      predication["date"]!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Bouton options
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () {
                              // Options pour télécharger, partager, etc.
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: predications.length),
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

// Classe pour l'effet wave audio
class AudioWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);

    // Ondes multiples pour effet audio
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height,
      size.width * 0.4,
      size.height - 20,
    );

    path.quadraticBezierTo(
      size.width * 0.6,
      size.height - 40,
      size.width * 0.8,
      size.height - 10,
    );

    path.quadraticBezierTo(
      size.width * 0.9,
      size.height,
      size.width,
      size.height - 15,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
