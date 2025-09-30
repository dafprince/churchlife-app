// features/donations/presentation/widgets/donation_section_widget.dart
import 'package:flutter/material.dart';

// Données fictives pour les dons
final List<Map<String, dynamic>> donsFictifs = [
  {
    "id": "1",
    "titre": "Construction Nouveau Temple",
    "description":
        "Aidez-nous à construire un nouveau lieu de culte pour accueillir plus de fidèles",
    "image":
        "https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=500",
    "objectif": 50000.0,
    "collecte": 32500.0,
  },
  {
    "id": "2",
    "titre": "Aide aux Orphelins",
    "description":
        "Soutenez notre orphelinat et offrez un avenir meilleur aux enfants",
    "image":
        "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=500",
    "objectif": 20000.0,
    "collecte": 15800.0,
  },
  {
    "id": "3",
    "titre": "Évangélisation Rurale",
    "description":
        "Financez nos missions d'évangélisation dans les zones rurales",
    "image":
        "https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=500",
    "objectif": 15000.0,
    "collecte": 8200.0,
  },
  {
    "id": "4",
    "titre": "Fournitures Scolaires",
    "description": "Offrez des fournitures scolaires aux enfants défavorisés",
    "image":
        "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=500",
    "objectif": 10000.0,
    "collecte": 6500.0,
  },
];

// Données fictives pour les églises (offrandes)
final List<Map<String, String>> eglisesFictives = [
  {
    "id": "1",
    "nom": "Église Béthel",
    "image":
        "https://images.unsplash.com/photo-1465101046530-73398c28ca38?w=500",
  },
  {
    "id": "2",
    "nom": "Maison de Sion",
    "image": "https://images.unsplash.com/photo-1560216055-42861a07c6e8?w=500",
  },
  {
    "id": "3",
    "nom": "Temple de la Paix",
    "image":
        "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=500",
  },
  {
    "id": "4",
    "nom": "Philadelphie",
    "image":
        "https://images.unsplash.com/photo-1472220625704-91e1462799b2?w=500",
  },
];

class DonationSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Offrandes
        _buildOffradeSection(context),

        SizedBox(height: 30),

        // Section Dons
        _buildDonsSection(context),
      ],
    );
  }

  Widget _buildOffradeSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête section offrandes
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.church, color: Colors.white, size: 28),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offrandes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Soutenez votre église',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Liste horizontale des églises
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: eglisesFictives.length,
              separatorBuilder: (context, index) => SizedBox(width: 12),
              itemBuilder: (context, index) {
                final eglise = eglisesFictives[index];
                return _buildEgliseCard(context, eglise);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEgliseCard(BuildContext context, Map<String, String> eglise) {
    return GestureDetector(
      onTap: () {
        // TODO: Ouvrir formulaire offrande
        _showOffradeDialog(context, eglise);
      },
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                eglise["image"]!,
                height: 85,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 85,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.church, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      eglise["nom"]!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF667eea),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonsSection(BuildContext context) {
    return Column(
      children: [
        // En-tête section dons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFEEF4FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.volunteer_activism,
                  color: Color(0xFF6E8EF5),
                  size: 26,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes à soutenir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      'Faites une différence aujourd\'hui',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Grille des 4 premiers dons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final don = donsFictifs[index];
              return _buildDonCard(context, don);
            },
          ),
        ),

        SizedBox(height: 16),

        // Bouton voir plus
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigation vers page complète des dons
              },
              icon: Icon(Icons.explore, color: Colors.white),
              label: Text(
                'Découvrir d\'autres causes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6E8EF5),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonCard(BuildContext context, Map<String, dynamic> don) {
    final pourcentage = ((don["collecte"] / don["objectif"]) * 100).round();

    return GestureDetector(
      onTap: () {
        // TODO: Ouvrir détail du don
        _showDonDialog(context, don);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                don["image"],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.favorite, size: 40, color: Colors.grey),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      don["titre"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    // Barre de progression
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: don["collecte"] / don["objectif"],
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF6E8EF5),
                            ),
                            minHeight: 6,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '$pourcentage% · ${don["collecte"].toInt()} FCFA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6E8EF5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOffradeDialog(BuildContext context, Map<String, String> eglise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Offrande à ${eglise["nom"]}'),
        content: Text('Formulaire d\'offrande à implémenter avec Wave'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showDonDialog(BuildContext context, Map<String, dynamic> don) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(don["titre"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(don["description"]),
            SizedBox(height: 16),
            Text('Formulaire de don à implémenter avec Wave'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
