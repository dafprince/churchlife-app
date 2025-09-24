import 'package:flutter/material.dart';
import 'package:mobile/features/eglises/presentation/EgliseDetailScreen.dart';

class EgliseScreen extends StatefulWidget {
  @override
  _EgliseScreenState createState() => _EgliseScreenState();
}

class _EgliseScreenState extends State<EgliseScreen> {
  final List<Map<String, String>> eglises = [
    {
      "nom": "Église Béthel",
      "image": "https://images.unsplash.com/photo-1465101046530-73398c28ca",
    },
    {
      "nom": "Saint Clément",
      "image": "https://images.unsplash.com/photo-1446697861703-cd2c70a18eea",
    },
    {
      "nom": "Évangélique Lumière",
      "image": "https://images.unsplash.com/photo-1470770841072-f978cfd019d",
    },
    {
      "nom": "Paroisse Espérance",
      "image": "https://images.unsplash.com/photo-1417021542247-8d428cbe1e61",
    },
    {
      "nom": "Temple Sion",
      "image": "https://images.unsplash.com/photo-1506744038136-4627b3a3c2b5",
    },
    {
      "nom": "Maison de Sion",
      "image": "https://images.unsplash.com/photo-1560216055-42861a07c6e8",
    },
    {
      "nom": "Église Réforme",
      "image": "https://images.unsplash.com/photo-1491336477066-31156b5e8caf",
    },
    {
      "nom": "Chapelle Saint-Paul",
      "image": "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    },
    {
      "nom": "Sanctuaire Lumière",
      "image": "https://images.unsplash.com/photo-1472220625704-91e1462799b2",
    },
    {
      "nom": "Centre Spirituel",
      "image": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
    },
    {
      "nom": "Temple de la Paix",
      "image": "https://images.unsplash.com/photo-1462331940025-496dfbfc7564",
    },
    {
      "nom": "Église Nouvelle Vie",
      "image": "https://images.unsplash.com/photo-1523906630133-f6934a84c6e1",
    },
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Color(0xFF6E8EF5),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Les Églises disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                ),
              ),
              background: ClipPath(
                clipper: ModernWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6E8EF5), Color(0xFF56C6FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1,
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

                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          image: DecorationImage(
                            image: NetworkImage(eglise["image"]!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 9,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 7,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(23),
                              bottomRight: Radius.circular(23),
                            ),
                          ),
                          child: Text(
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
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: eglises.length),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) {
          if (idx == 0) {
            Navigator.of(context).pop(); // Retour à l'accueil
          }
        },
        selectedItemColor: Colors.white54,
        unselectedItemColor: Colors.white54,
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

class ModernWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.45,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
