import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Séléné',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Trouve ton partenaire sportif',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              // Placeholder — Sprint Auth remplacera par le formulaire téléphone + OTP
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Continuer avec mon numéro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Écran saisie du numéro de téléphone — Sprint Auth
class AuthPhoneScreen extends StatelessWidget {
  const AuthPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon numéro')),
      body: const Center(child: Text('Sprint Auth — saisie téléphone')),
    );
  }
}

/// Écran saisie du code OTP — Sprint Auth
class AuthOtpScreen extends StatelessWidget {
  const AuthOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code de vérification')),
      body: const Center(child: Text('Sprint Auth — saisie OTP')),
    );
  }
}
