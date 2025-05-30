import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:farmer_connect/service/firebase_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseService _firebase = FirebaseService();

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      return await _firebase.getData('users', userId);
    } catch (e) {
      rethrow;
    }
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Create user with email and password
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );

      if (response.user != null) {
        // Store additional user data
        final data = {
          'full_name': fullName,
          'email': email,
          'phone_number': phoneNumber,
          'is_phone_verified': false,
          'created_at': DateTime.now().toIso8601String(),
        };
        // Create the document with user ID
        await _firebase.addDataWithId('users', response.user!.id, data);
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
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Send phone verification code
  Future<String> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );
      return phoneNumber; // Return the phone number as verification ID
    } catch (e) {
      rethrow;
    }
  }

  // Verify phone number with SMS code
  Future<void> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: verificationId,
        token: smsCode,
        type: OtpType.sms,
      );

      if (response.user != null) {
        // Create user document in Firestore
        final userData = {
          'full_name': response.user!.userMetadata?['full_name'] ?? '',
          'email': response.user!.email ?? '',
          'phone_number': verificationId,
          'is_phone_verified': true,
          'created_at': DateTime.now().toIso8601String(),
        };
        
        // Create the document with user ID
        await _firebase.addDataWithId('users', response.user!.id, userData);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Resend verification code
  Future<void> resendVerificationCode(String phoneNumber) async {
    try {
      await sendPhoneVerificationCode(phoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  // Check if user's phone is verified
  Future<bool> isPhoneVerified() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final data = await _firebase.getData('users', user.id);
        return data?['is_phone_verified'] ?? false;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

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