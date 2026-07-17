import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:susu/provider/provider.dart';
import 'package:susu/models/transaction.dart';
import 'package:susu/services/paystack_service.dart';
import 'package:susu/widgets/custom_row.dart';
import 'package:susu/core/notifier.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool _recurring = false;
  String _frequency = 'Monthly';
  final _amountController = TextEditingController(text: '1.00');
  final _toController = TextEditingController();
  final _fromController = TextEditingController();

  static const _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String get _date {
    final now = DateTime.now();
    return '${_months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _toController.dispose();
    _fromController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          onPressed: () => context.go('/homepage'),
        ),
        title: const Text(
          'Transfer',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _section(
              child: _amountField(),
            ),
            const SizedBox(height: 12),
            _section(
              child: _recurringRow(),
            ),
            const SizedBox(height: 12),
            _section(
              child: Column(
                children: [
                  _toRow(),
                  if (_transferTo == 'number') const Divider(height: 1, indent: 0),
                  _fromRow(),
                  const Divider(height: 1, indent: 0),
                  _dateRow(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _disclaimer(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _continueButton(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _section({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }

  Widget _amountField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            'Amount',
            style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: _amountController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32, color: Colors.black87, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '₵0.00',
                    hintStyle: TextStyle(fontSize: 28, color: Colors.black.withValues(alpha: 0.15), fontWeight: FontWeight.w600),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recurringRow() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: CustomRow(
            label: 'Recurring',
            trailing: Switch(
              value: _recurring,
              activeThumbColor: const Color(0xFF1E6FD9),
              activeTrackColor: const Color(0xFF1E6FD9).withValues(alpha: 0.4),
              onChanged: (v) => setState(() => _recurring = v),
            ),
          ),
        ),
        if (_recurring) ...[
          const Divider(height: 1, indent: 0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Frequency', style: TextStyle(fontSize: 16, color: Colors.black87)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: DropdownButton<String>(
                    value: _frequency,
                    underline: const SizedBox(),
                    items: _frequencies.map((f) => DropdownMenuItem(
                      value: f,
                      child: Text(f, style: const TextStyle(fontSize: 14)),
                    )).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _frequency = v);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _accountField({required String label, required TextEditingController controller}) {
    return CustomRow(
      label: label,
      trailing: SizedBox(
        width: 200,
        height: 36,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter number',
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  String _transferTo = 'number';

  Widget _toRow() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transfer to', style: TextStyle(fontSize: 16, color: Colors.black87)),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _transferTo = 'number'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _transferTo == 'number' ? const Color(0xFF1E6FD9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Number',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _transferTo == 'number' ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _transferTo = 'account'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _transferTo == 'account' ? const Color(0xFF1E6FD9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Your account',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _transferTo == 'account' ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_transferTo == 'number')
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: _toController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
      ],
    );
  }

  Widget _fromRow() => _accountField(label: 'Transfer from', controller: _fromController);

  Widget _dateRow() {
    return CustomRow(
      label: 'Date',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _date,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Disclaimer: By proceeding with this transaction, you confirm that you have verified the recipients account number, phone number, and/or card details are accurate and belong to the intended recipient. We are not responsible for funds sent to an incorrect or unintended recipient due to inaccurate details entered by the sender. Transactions to a wrong number or card may be irreversible and are not guaranteed to be refunded. Please review all details carefully before confirming payment.',
          style: TextStyle(fontSize: 12, color: Colors.black45, height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          'You agree to release us SusuPlus of any liability',
          style: TextStyle(fontSize: 12, color: Colors.black45, height: 1.5),
        ),
      ],
    );
  }

  Widget _continueButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E6FD9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        onPressed: _handlePayment,
        child: const Text(
          'Continue',
          style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    final reference = PaystackService.generateReference();
    final email = FirebaseAuth.instance.currentUser?.email ?? 'customer@susuplus.com';
    final amountInPesewas = (amount * 100).round();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not authenticated.')));
        return;
      }

      await FirebaseFirestore.instance.collection('orders').doc(reference).set({
        'reference': reference,
        'uid': user.uid,
        'email': email,
        'amount': amountInPesewas,
        'currency': 'GHS',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final authUrl = await PaystackService.initializeTransaction(
        email: email,
        amountInPesewas: amountInPesewas,
        reference: reference,
      );

      if (!mounted) return;

      if (authUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize payment. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(authUrl));

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Payment', style: TextStyle(color: Colors.black87)),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => context.pop(),
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

      final result = await PaystackService.verifyTransaction(reference: reference);
      final success = result != null && result['status'] == 'success';

      if (success) {
        await FirebaseFirestore.instance.collection('orders').doc(reference).update({
          'status': 'paid',
          'paidAt': FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseFirestore.instance.collection('orders').doc(reference).update({
          'status': 'failed',
        });
      }

      if (!mounted) return;

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PaymentStatusDialog(success: success),
      );

      if (!mounted) return;

      if (success) {
        context.read<TransactionsProvider>().addTransaction(
          Transaction(
            id: reference,
            title: 'Money added',
            amount: amount,
            date: DateTime.now(),
          ),
        );
      }

      selectedPage.value = 0;
      context.go('/homepage');
    } on PaystackException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red.shade600),
        );
      }
    } catch (e, st) {
      debugPrint('Payment error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
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
