import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:susu/provider/provider.dart';
import 'package:susu/models/transaction.dart';
import 'package:susu/services/paystack_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final String _reference;
  late final String _email;

  @override
  void initState() {
    super.initState();
    _reference = PaystackService.generateReference();
    _email = FirebaseAuth.instance.currentUser?.email ?? 'customer@susuplus.com';
  }

  Future<void> _startPayment() async {
    final amountInPesewas = (widget.amount * 100).round();

    try {
      await _createPendingOrder(amountInPesewas);

      final authUrl = await PaystackService.initializeTransaction(
        email: _email,
        amountInPesewas: amountInPesewas,
        reference: _reference,
      );

      if (authUrl == null) {
        if (mounted) _showError('Failed to initialize payment. Please try again.');
        return;
      }

      if (!mounted) return;

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(authUrl));

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Payment', style: TextStyle(color: Colors.black87)),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            body: WebViewWidget(controller: controller),
          ),
        ),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final result = await PaystackService.verifyTransaction(reference: _reference);
      final success = result != null && result['status'] == 'success';

      if (success) {
        await FirebaseFirestore.instance.collection('orders').doc(_reference).update({
          'status': 'paid',
          'paidAt': FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseFirestore.instance.collection('orders').doc(_reference).update({
          'status': 'failed',
        });
      }

      if (!mounted) return;

      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) rootNav.pop();

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PaymentStatusDialog(success: success),
      );

      if (!mounted) return;

      if (success) {
        context.read<TransactionsProvider>().addTransaction(
          Transaction(
            id: _reference,
            title: 'Money added',
            amount: widget.amount,
            date: DateTime.now(),
          ),
        );
      }

      context.go('/homepage');
    } on PaystackException catch (e) {
      if (mounted) _showError(e.message);
    } catch (e) {
      if (mounted) _showError('Something went wrong. Please try again.');
    }
  }

  Future<void> _createPendingOrder(int amountInPesewas) async {
    await FirebaseFirestore.instance.collection('orders').doc(_reference).set({
      'reference': _reference,
      'email': _email,
      'amount': amountInPesewas,
      'currency': 'GHS',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add Money',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            Text(
              '₵${widget.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'You are about to add this amount to your wallet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6FD9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: _startPayment,
                child: const Text(
                  'Confirm & Pay',
                  style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _PaymentStatusDialog extends StatefulWidget {
  final bool success;
  const _PaymentStatusDialog({required this.success});

  @override
  State<_PaymentStatusDialog> createState() => _PaymentStatusDialogState();
}

class _PaymentStatusDialogState extends State<_PaymentStatusDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final navigator = Navigator.of(context, rootNavigator: true);
        if (navigator.canPop()) navigator.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: SizedBox(
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              if (widget.success) ...[
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (_, scale, __) => Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF22C55E)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your money has been added.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ] else ...[
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
