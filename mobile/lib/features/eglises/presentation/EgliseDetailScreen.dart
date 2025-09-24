import 'package:flutter/material.dart';

class EgliseDetailScreen extends StatefulWidget {
  @override
  State<EgliseDetailScreen> createState() => _EgliseDetailScreenState();
}

// ✅ URLs d'images corrigées et complètes
final List<Map<String, String>> audios = [
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
    "nom": "Évangélique feu",
    "image":
        "https://images.unsplash.com/photo-1470770841072-f978cfd019d0?w=500",
  },
  {
    "nom": "Évangélique de tonneres",
    "image":
        "https://images.unsplash.com/photo-1470770841072-f978cfd019d0?w=500",
  },
  {
    "nom": "Évangélique Eclairs",
    "image":
        "https://images.unsplash.com/photo-1470770841072-f978cfd019d0?w=500",
  },
  // ... autres entrées avec URLs complètes
];

class _EgliseDetailScreenState extends State<EgliseDetailScreen> {
  int _selectedIndex = 0; // ✅ Variable déplacée dans le State

  @override
  Widget build(BuildContext context) {
    print("Building EgliseDetailScreen");
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: const Color(0xFF6E8EF5),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Eglise One',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // ✅ Gestion d'erreur ajoutée
                  Image.network(
                    "https://images.unsplash.com/photo-1560216055-42861a07c6e8?w=500",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final audio = audios[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 200, // ✅ Hauteur définie
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 9,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          // ✅ Gestion d'erreur pour chaque image
                          child: Image.network(
                            audio["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.church,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
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
                            audio["nom"]!,
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
              }, childCount: audios.length),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) {
          setState(() {
            _selectedIndex = idx; // ✅ Mise à jour du state
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
