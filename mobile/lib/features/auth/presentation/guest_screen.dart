import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../providers/auth_provider.dart';

class GuestScreen extends ConsumerStatefulWidget {
  const GuestScreen({super.key});

  @override
  ConsumerState<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends ConsumerState<GuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  int _age = 25;
  String _genre = 'homme';
  bool _loading = false;
  String? _error;

  static const _genres = [
    ('homme', 'Homme'),
    ('femme', 'Femme'),
    ('autre', 'Autre'),
  ];

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).setupGuest(
            pseudo: _pseudoController.text.trim(),
            age: _age,
            genre: _genre,
          );
      ref.read(authStateProvider.notifier).markProfileComplete();
      // Le router redirigera vers /map automatiquement
    } catch (e) {
      setState(() => _error = _mapError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('409') || msg.contains('conflit') || msg.contains('pris')) {
      return 'Ce pseudo est déjà utilisé. Choisis-en un autre.';
    }
    return 'Une erreur est survenue. Réessaie.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ton profil'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quelques infos pour commencer',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Elles aident tes futurs partenaires sportifs à te trouver.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Pseudo
                TextFormField(
                  controller: _pseudoController,
                  decoration: const InputDecoration(
                    labelText: 'Pseudo',
                    hintText: 'Ex. : SportiF42',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Pseudo requis';
                    if (v.trim().length < 2) return 'Minimum 2 caractères';
                    if (v.trim().length > 30) return 'Maximum 30 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Âge
                Text('Âge : $_age ans',
                    style: Theme.of(context).textTheme.bodyLarge),
                Slider(
                  value: _age.toDouble(),
                  min: 18,
                  max: 80,
                  divisions: 62,
                  label: '$_age ans',
                  onChanged: (v) => setState(() => _age = v.round()),
                ),
                const SizedBox(height: 24),

                // Genre
                Text('Genre', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: _genres
                      .map((g) => ButtonSegment(value: g.$1, label: Text(g.$2)))
                      .toList(),
                  selected: {_genre},
                  onSelectionChanged: (s) => setState(() => _genre = s.first),
                ),
                const SizedBox(height: 32),

                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                ],

                FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Commencer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
