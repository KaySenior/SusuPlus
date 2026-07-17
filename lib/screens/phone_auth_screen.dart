import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:susu/services/auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool _isSignUp = true;

  // Sign Up fields
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;
  String _sanitizedPhone = '';

  // Sign In fields
  final _loginPhoneController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool _loginLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _loginPhoneController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  String _sanitize(String raw) {
    String digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.startsWith('0')) digits = digits.substring(1);
    if (!digits.startsWith('233')) digits = '233$digits';
    return '+$digits';
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // ----- Sign Up (OTP flow) -----

  Future<void> _sendOTP() async {
    final raw = _phoneController.text.trim();
    if (raw.isEmpty) return;

    _sanitizedPhone = _sanitize(raw);

    setState(() => _loading = true);

    try {
      await AuthService.sendOTP(
        phoneNumber: _sanitizedPhone,
        onCodeSent: (verificationId) {
          if (mounted) setState(() { _otpSent = true; _loading = false; });
        },
        onError: (error) {
          debugPrint('Phone auth onError: $error');
          if (mounted) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
        onAutoVerified: () {
          if (mounted) _goToPasswordSetup();
        },
      );
    } catch (e, st) {
      debugPrint('Phone auth exception: $e\n$st');
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: $e')),
        );
      }
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) return;

    setState(() => _loading = true);

    try {
      final user = await AuthService.verifyOTP(otp);
      if (user != null && mounted) {
        _goToPasswordSetup();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification failed. Please request a new code.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToPasswordSetup() {
    context.push('/password-setup', extra: _sanitizedPhone);
  }

  // ----- Sign In (Phone + Password) -----

  Future<void> _signInWithPassword() async {
    final raw = _loginPhoneController.text.trim();
    final password = _loginPasswordController.text.trim();
    if (raw.isEmpty || password.isEmpty) return;

    final phone = _sanitize(raw);

    setState(() => _loginLoading = true);

    try {
      final doc = await FirebaseFirestore.instance.collection('phones').doc(phone).get();
      if (!doc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No account found with this phone number.')),
          );
        }
        return;
      }

      final storedHash = doc.data()?['passwordHash'] as String?;
      if (storedHash == null || storedHash != _hashPassword(password)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password.')),
          );
        }
        return;
      }

      // Password matches — trigger OTP to authenticate
      await AuthService.sendOTP(
        phoneNumber: phone,
        onCodeSent: (verificationId) {
          if (mounted) {
            _showOtpDialog(phone, verificationId);
          }
        },
        onError: (error) {
          debugPrint('Login OTP error: $error');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
        onAutoVerified: () {
          if (mounted) context.go('/homepage');
        },
      );
    } catch (e) {
      debugPrint('Sign in error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loginLoading = false);
    }
  }

  void _showOtpDialog(String phone, String verificationId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _OtpDialog(
        verificationId: verificationId,
        onVerified: () {
          Navigator.of(ctx).pop();
          context.go('/homepage');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Phone Sign In'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isSignUp = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isSignUp ? const Color(0xFF1E6FD9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Sign Up', style: TextStyle(
                          color: _isSignUp ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isSignUp = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isSignUp ? const Color(0xFF1E6FD9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Sign In', style: TextStyle(
                          color: !_isSignUp ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_isSignUp) _buildSignUp(),
            if (!_isSignUp) _buildSignIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp() {
    if (!_otpSent) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter your phone number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text("We'll send you a verification code", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Center(child: SvgPicture.string(_phoneSvg, height: 80)),
          const SizedBox(height: 24),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '+233 55 555 5555',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: _loading ? null : _sendOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6FD9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Send OTP'),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter verification code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        const Text("Enter the 6-digit code sent to your phone", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          buildCounter: (_, {required currentLength, required isFocused, required maxLength}) => null,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '000000',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: _loading ? null : _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6FD9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Verify'),
          ),
        ),
      ],
    );
  }

  Widget _buildSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sign in with your phone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        const Text("Enter your phone number and password", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        Center(child: SvgPicture.string(_phoneSvg, height: 80)),
        const SizedBox(height: 24),
        TextField(
          controller: _loginPhoneController,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '+233 55 555 5555',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _loginPasswordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: _loginLoading ? null : _signInWithPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6FD9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: _loginLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Sign In'),
          ),
        ),
      ],
    );
  }
}

const _phoneSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <rect x="30" y="8" width="40" height="84" rx="8" ry="8" fill="#1E6FD9" opacity="0.15"/>
  <rect x="33" y="12" width="34" height="74" rx="6" ry="6" fill="#1E6FD9" opacity="0.3"/>
  <rect x="36" y="16" width="28" height="4" rx="2" fill="#1E6FD9" opacity="0.5"/>
  <rect x="42" y="44" width="16" height="2" rx="1" fill="#1E6FD9" opacity="0.4"/>
  <rect x="42" y="50" width="16" height="2" rx="1" fill="#1E6FD9" opacity="0.4"/>
  <rect x="42" y="56" width="12" height="2" rx="1" fill="#1E6FD9" opacity="0.4"/>
  <circle cx="50" cy="76" r="3" fill="#1E6FD9" opacity="0.5"/>
  <g transform="translate(62, 26)">
    <circle cx="8" cy="8" r="8" fill="#1E6FD9"/>
    <path d="M3,8 L13,8" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
    <path d="M8,3 L8,13" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
  </g>
</svg>''';

class _OtpDialog extends StatefulWidget {
  final String verificationId;
  final VoidCallback onVerified;

  const _OtpDialog({
    required this.verificationId,
    required this.onVerified,
  });

  @override
  State<_OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<_OtpDialog> {
  final _pinControllers = List.generate(6, (_) => TextEditingController());
  final _pinFocusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  int _resendSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendSeconds = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        }
      });
      if (_resendSeconds == 0) {
        if (mounted) setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _pinFocusNodes[index + 1].requestFocus();
      } else {
        _pinFocusNodes[index].unfocus();
        _verifyOtp();
      }
    }
  }

  String get _otp =>
      _pinControllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final otp = _otp;
    if (otp.length != 6) return;

    setState(() => _loading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await AuthService.signInWithCredential(credential);
      widget.onVerified();
    } catch (e) {
    for (final c in _pinControllers) {
      c.clear();
    }
      _pinFocusNodes[0].requestFocus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed. Try again.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1E6FD9).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smartphone_outlined, color: Color(0xFF1E6FD9), size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter verification code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the 6-digit code sent to your phone',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => _buildPinBox(i)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6FD9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Verify', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive code? ", style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: _canResend ? () {} : null,
                  child: Text(
                    _canResend ? 'Resend' : 'Resend in ${_resendSeconds}s',
                    style: TextStyle(
                      color: _canResend ? const Color(0xFF1E6FD9) : Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinBox(int index) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: _pinControllers[index],
        focusNode: _pinFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        buildCounter: (_, {required currentLength, required isFocused, required maxLength}) => null,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1E6FD9)),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFF1E6FD9).withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF1E6FD9), width: 2),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (v) => _onDigitChanged(index, v),
        onTapOutside: (_) {},
      ),
    );
  }
}
