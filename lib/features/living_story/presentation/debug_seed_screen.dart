import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DebugSeedScreen extends ConsumerStatefulWidget {
  const DebugSeedScreen({super.key});

  @override
  ConsumerState<DebugSeedScreen> createState() => _DebugSeedScreenState();
}

class _DebugSeedScreenState extends ConsumerState<DebugSeedScreen> {
  bool _isLoading = false;
  String _status = 'Ready';

  Future<void> _runSeed() async {
    setState(() => _isLoading = true);
    setState(() => _status = 'Seeding Founder Story...');

    try {
      // Mock seed operation
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _status = 'Success! Founder Story 1 seeded.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _status = 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DEBUG SEEDER')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(fontSize: 14),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _runSeed,
                    child: const Text('SEED FOUNDER STORY'),
                  ),
          ],
        ),
      ),
    );
  }
}
