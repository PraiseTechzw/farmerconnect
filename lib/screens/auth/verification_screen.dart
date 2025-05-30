import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:farmer_connect/service/auth_service.dart';
import 'package:farmer_connect/screens/home/home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.verifyPhoneNumber(
        verificationId: widget.verificationId,
        smsCode: _codeController.text,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);

    try {
      await _authService.resendVerificationCode(widget.phoneNumber);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code resent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.verified_user,
                    size: 80,
                    color: Colors.green.shade700,
                  )
                      .animate()
                      .scale(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(),
                  const SizedBox(height: 24),
                  Text(
                    'Verify Your Phone',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 16),
                  Text(
                    'Enter the 6-digit code sent to\n${widget.phoneNumber}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 400))
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
                      hintText: 'Enter 6-digit code',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.green.shade700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green.shade700,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the verification code';
                      }
                      if (value.length != 6) {
                        return 'Code must be 6 digits';
                      }
                      return null;
                    },
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 600))
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 800))
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isResending ? null : _resendCode,
                    child: _isResending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Resend Code',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 1000))
                      .slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 