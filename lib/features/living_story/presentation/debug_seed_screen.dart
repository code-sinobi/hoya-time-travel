import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/seeding_service.dart';

class DebugSeedScreen extends ConsumerStatefulWidget {
  const DebugSeedScreen({super.key});

  @override
  ConsumerState<DebugSeedScreen> createState() => _DebugSeedScreenState();
}

class _DebugSeedScreenState extends ConsumerState<DebugSeedScreen> {
  bool _isLoading = false;
  String _status = 'Ready to Seed';

  Future<void> _runSeed() async {
    setState(() {
      _isLoading = true;
      _status = 'Seeding data...';
    });

    try {
      await ref.read(seedingServiceProvider).seedFounderStory();
      if (mounted) setState(() => _status = 'Success! Founder Story 1 seeded.');
    } on Object catch (e) {
      if (mounted) setState(() => _status = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Seeder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _runSeed,
                icon: const Icon(Icons.publish),
                label: const Text('Seed Founder Story 1'),
              ),
          ],
        ),
      ),
    );
  }
}
