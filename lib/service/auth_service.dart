import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:farmer_connect/service/firebase_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseService _firebase = FirebaseService();

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Sign up with Supabase
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );

      if (response.user != null) {
        // Create user profile in Firebase
        await _firebase.addData('users', {
          'uid': response.user!.id,
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    // Update in Supabase
    await _supabase.auth.updateUser(
      UserAttributes(data: data),
    );

    // Update in Firebase
    await _firebase.updateData('users', userId, data);
  }
} 