import 'package:flutter/material.dart';

class OffrandesSectionWidget extends StatefulWidget {
  @override
  _OffrandesSectionWidgetState createState() => _OffrandesSectionWidgetState();
}

class _OffrandesSectionWidgetState extends State<OffrandesSectionWidget> {
  String? selectedEgliseId;
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController montantController = TextEditingController();

  // Liste fictive d'églises
  final List<Map<String, String>> eglises = [
    {'id': '1', 'nom': 'Église Centrale', 'imagePath': 'assets/eglise1.jpg'},
    {
      'id': '2',
      'nom': 'Église Sainte-Marie',
      'imagePath': 'assets/eglise2.jpg',
    },
    {
      'id': '3',
      'nom': 'Église Saint-Pierre',
      'imagePath': 'assets/eglise3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Offrandes",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.blue[300]),
        ),
        SizedBox(height: 12),
        // Liste des églises en horizontal
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: eglises.length,
            itemBuilder: (context, index) {
              final eglise = eglises[index];
              return EgliseOffrandeCard(
                egliseNom: eglise['nom']!,
                imagePath: eglise['imagePath']!,
                isSelected: selectedEgliseId == eglise['id'],
                onTap: () {
                  setState(() {
                    selectedEgliseId = eglise['id'];
                  });
                },
              );
            },
          ),
        ),
        SizedBox(height: 20),
        OffrandeFormWidget(
          numeroController: numeroController,
          montantController: montantController,
          onSubmit: () {
            if (selectedEgliseId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Veuillez choisir une église')),
              );
              return;
            }
            if (numeroController.text.isEmpty ||
                montantController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Veuillez remplir tous les champs')),
              );
              return;
            }
            // Pour l'instant message fictif
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Offrande envoyée avec succès!')),
            );
            // Réinitialiser
            numeroController.clear();
            montantController.clear();
            setState(() {
              selectedEgliseId = null;
            });
          },
        ),
      ],
    );
  }
}

class EgliseOffrandeCard extends StatelessWidget {
  final String egliseNom;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const EgliseOffrandeCard({
    required this.egliseNom,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(8),
        child: Text(
          egliseNom,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.black45,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class OffrandeFormWidget extends StatelessWidget {
  final TextEditingController numeroController;
  final TextEditingController montantController;
  final VoidCallback onSubmit;

  const OffrandeFormWidget({
    required this.numeroController,
    required this.montantController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: numeroController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Numéro',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          controller: montantController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Montant',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text('Payer l\'offrande'),
        ),
      ],
    );
  }
}
