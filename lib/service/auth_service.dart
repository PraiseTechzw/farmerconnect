import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:farmer_connect/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:completer/completer.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseService _firebase = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        await _firebase.updateData('users', response.user!.id, data);
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

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
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

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile
      await userCredential.user?.updateDisplayName(fullName);

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'isPhoneVerified': false,
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
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
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Send phone verification code
  Future<String> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      final response = await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );
      return response.session?.id ?? '';
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
        // Update verification status
        await _firebase.updateData(
          'users',
          response.user!.id,
          {'is_phone_verified': true},
        );
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
} 