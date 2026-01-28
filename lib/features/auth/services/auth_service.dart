import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService();
}

@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}

class AuthService {
  final GoTrueClient _auth = Supabase.instance.client.auth;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password, String username) async {
    await _auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'avatar_url': 'https://api.dicebear.com/7.x/bottts/png?seed=$username',
      },
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
