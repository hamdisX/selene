import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activités')),
      // Placeholder — Sprint Activities remplacera par la liste filtrée
      body: const Center(child: Text('Liste des activités — Sprint Activities')),
    );
  }
}

/// Écran détail d'une activité
class ActivityDetailScreen extends StatelessWidget {
  final String activityId;
  const ActivityDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activité')),
      body: Center(child: Text('Activité $activityId — Sprint Activities')),
    );
  }
}

/// Écran création d'activité
class CreateActivityScreen extends StatelessWidget {
  const CreateActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle activité')),
      body: const Center(child: Text('Créer activité — Sprint Activities')),
    );
  }
}
