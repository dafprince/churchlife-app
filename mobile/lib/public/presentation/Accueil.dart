import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/annonce/presentation/annonce_screen.dart';
import 'package:mobile/features/annonce/bloc/annonce_bloc.dart';
import 'package:mobile/features/annonce/bloc/annonce_event.dart';
import 'package:mobile/features/categories/presentation/pages/homeLibrary.dart';
import 'package:mobile/features/categories/presentation/widgets/categories_preview_widget.dart';
import 'package:mobile/features/eglises/presentation/eglise_screen.dart';
import 'package:mobile/features/eglises/presentation/widget/EglisesPreviewWidget.dart';
import 'package:mobile/features/eglises/bloc/eglise_bloc.dart';
import 'package:mobile/features/eglises/bloc/eglise_event.dart';

import 'package:mobile/features/categories/bloc/category_bloc.dart';
import 'package:mobile/features/categories/bloc/category_event.dart';
import 'package:mobile/features/offrande/presentation/DonationSectionWidget.dart';
// Ajoute les imports nécessaires pour la navigation bibliothèque complète

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Charger les annonces au démarrage
    context.read<AnnonceBloc>().add(LoadAnnoncesEvent());
    // Charger les églises au démarrage
    context.read<EgliseBloc>().add(LoadEglisesEvent());
    // Charger les catégories de livres/bibliothèque au démarrage
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildCircleIconButton(IconData icon, {Color color = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6E8EF5),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF6E8EF5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: "Nos programmes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "Contact",
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 240,
            backgroundColor: const Color(0xFF6E8EF5),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final collapsedHeight =
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                final progress =
                    ((top - collapsedHeight) / (240 - collapsedHeight))
                        .clamp(0, 1)
                        .toDouble();
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipPath(
                      clipper: TopWaveClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6E8EF5),
                              const Color(0xFF56C6FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: progress,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 18,
                          right: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCircleIconButton(Icons.menu),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.account_balance,
                                  color: Colors.white,
                                  size: 36,
                                ),
                                const Text(
                                  'ChurchLife',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            _buildCircleIconButton(Icons.notifications),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 1 - progress,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          left: 10,
                          right: 10,
                        ),
                        color: const Color(0xFF6E8EF5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCircleIconButton(Icons.menu),
                            const Text(
                              'ChurchLife',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            _buildCircleIconButton(Icons.notifications),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Widget des annonces avec données réelles du backend
                    AnnoncesSectionWidget(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => EgliseScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF4FB),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.headphones_rounded,
                                color: Color(0xFF6E8EF5),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'Écouter les prédications\nde différentes églises',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF6E8EF5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    EglisesPreviewWidget(),
                    const SizedBox(height: 25),
                    _buildBibliothequeSection(),
                    const SizedBox(height: 50),
                    //======
                    DonationSectionWidget(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBibliothequeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF4FB),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF6E8EF5),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Notre bibliothèque',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Voici le widget preview dynamique des catégories VRAIES
          CategoriesPreviewWidget(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO : Navigation vers la page bibliothèque complète
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PenseeDuJourWidget()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E8EF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Découvrez la bibliothèque',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * .8);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * .6,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
