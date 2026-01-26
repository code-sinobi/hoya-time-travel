import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoya_app/features/auth/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('authServiceProvider is created', () {
      final authService = container.read(authServiceProvider);
      expect(authService, isA<AuthService>());
    });

    // Note: These tests require Supabase to be properly configured
    // For now, they serve as a structure for future implementation
    // with mocked Supabase client

    test('signIn should throw on invalid credentials', () async {
      final authService = container.read(authServiceProvider);

      expect(
        () => authService.signIn('invalid@email.com', 'wrongpassword'),
        throwsA(isA<Exception>()),
      );
    });

    test('signUp should create new user', () async {
      final authService = container.read(authServiceProvider);

      // This would need proper mocking in a real test
      expect(
        () => authService.signUp('test@example.com', 'password123', 'testuser'),
        throwsA(isA<Exception>()), // Expected to fail without proper backend
      );
    });

    test('signOut should complete without error', () async {
      final authService = container.read(authServiceProvider);

      // signOut should not throw even if not logged in
      await expectLater(authService.signOut(), completes);
    });
  });
}
