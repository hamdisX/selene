import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/network_providers.dart';
import '../data/auth_repository.dart';
import '../providers/auth_provider.dart';
import '../../../core/providers/auth_state_provider.dart';

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
              FilledButton(
                onPressed: () => context.push('/auth/phone'),
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

class AuthPhoneScreen extends ConsumerStatefulWidget {
  const AuthPhoneScreen({super.key});

  @override
  ConsumerState<AuthPhoneScreen> createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends ConsumerState<AuthPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).sendOtp(_phoneController.text.trim());
      if (mounted) context.push('/auth/otp', extra: _phoneController.text.trim());
    } catch (e) {
      setState(() => _error = _mapError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('429') || msg.contains('too many')) {
      return 'Trop de tentatives. Réessayez dans quelques minutes.';
    }
    return 'Une erreur est survenue. Vérifiez votre connexion.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon numéro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entre ton numéro de téléphone',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Nous t\'enverrons un code de vérification par SMS.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    hintText: '+33 6 12 34 56 78',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Numéro requis';
                    if (!RegExp(r'^\+\d{8,15}$').hasMatch(v.trim())) {
                      return 'Format invalide — ex. : +33612345678';
                    }
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _sendOtp,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Recevoir le code'),
                ),
                if (isDevelopment) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Mode dev — le code apparaît dans les logs backend.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.orange),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
