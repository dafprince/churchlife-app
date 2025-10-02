import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/features/onboarding/services/onboarding_service.dart';
// import 'package:mobile/features/users/presentation/pages/users_page.dart';
import 'package:mobile/public/presentation/Accueil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Naviguer vers la page principale après délai (ex: 3s)
    Future.delayed(Duration(seconds: 10), () async {
      // Vérifier si l'onboarding a été complété
      final hasCompleted = await OnboardingService.hasCompletedOnboarding();
      if (mounted) {
        if (hasCompleted) {
          // Déjà vu l'onboarding → AccueilPage
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Première fois → OnboardingScreen
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          'https://assets4.lottiefiles.com/packages/lf20_touohxv0.json',
        ),
      ),
    );
  }
}
