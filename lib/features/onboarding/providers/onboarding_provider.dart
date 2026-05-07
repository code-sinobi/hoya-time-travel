import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/shared_preferences_provider.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool('onboarding_complete') ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('onboarding_complete', true);
    state = true;
  }
}
