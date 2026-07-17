import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:susu/services/auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  static const _phoneSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
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
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    setState(() => _loading = true);

    try {
      await AuthService.sendOTP(
        phoneNumber: '+233$phone',
        onCodeSent: (verificationId) {
          if (mounted) {
            setState(() {
              _otpSent = true;
              _loading = false;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
        onAutoVerified: () {
          if (mounted) {
            context.go('/homepage');
          }
        },
      );
    } catch (e) {
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
        context.go('/homepage');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_otpSent) ...[
              const Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                "We'll send you a verification code",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Center(
                child: SvgPicture.string(
                  _phoneSvg,
                  height: 80,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '+233 55 555 5555',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6FD9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Send OTP'),
                ),
              ),
            ] else ...[
              const Text(
                'Enter verification code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the 6-digit code sent to your phone",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '000000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6FD9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Verify'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
