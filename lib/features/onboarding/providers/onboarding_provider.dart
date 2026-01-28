import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/shared_preferences_provider.dart';

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
      return OnboardingNotifier(ref);
    });

class OnboardingNotifier extends StateNotifier<bool> {
  final Ref ref;

  OnboardingNotifier(this.ref) : super(false) {
    _init();
  }

  void _init() {
    final prefs = ref.read(sharedPreferencesProvider);
    state = prefs.getBool('onboarding_complete') ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('onboarding_complete', true);
    state = true;
  }
}
