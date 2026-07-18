import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:susu/provider/provider.dart';
import 'package:susu/models/transaction.dart';
import 'package:susu/services/paystack_service.dart';
import 'package:susu/core/notifier.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool _isAddMoney = true;

  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  String _provider = 'MTN';
  bool _loading = false;

  static const _providers = ['MTN', 'Vodafone', 'AirtelTigo'];
  static const _providerCodes = {
    'MTN': 'MTN',
    'Vodafone': 'VOD',
    'AirtelTigo': 'TGO',
  };

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<TransactionsProvider>().balance;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            _modeToggle(),
            const SizedBox(height: 16),
            _section(child: _amountField()),
            const SizedBox(height: 12),
            if (!_isAddMoney) ...[
              _section(child: _balanceRow(balance)),
              const SizedBox(height: 12),
              _section(child: _phoneField()),
              const SizedBox(height: 12),
              _section(child: _providerField()),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _disclaimer(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _actionButton(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _modeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8EDF5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isAddMoney = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isAddMoney ? const Color(0xFF1E6FD9) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Add Money',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _isAddMoney ? Colors.white : const Color(0xFF1E6FD9),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isAddMoney = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_isAddMoney ? const Color(0xFF1E6FD9) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Send Money',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: !_isAddMoney ? Colors.white : const Color(0xFF1E6FD9),
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _balanceRow(double balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Text('Available Balance', style: TextStyle(fontSize: 15, color: Colors.black87)),
          const Spacer(),
          Text(
            'GH¢${balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: balance > 0 ? const Color(0xFF22C55E) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Destination Phone Number',
          hintText: '0555555555',
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E6FD9), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _providerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Provider', style: TextStyle(fontSize: 15, color: Colors.black87)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: DropdownButton<String>(
              value: _provider,
              underline: const SizedBox(),
              items: _providers
                  .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 14))))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _provider = v);
              },
            ),
          ),
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

  Widget _actionButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E6FD9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        onPressed: _loading ? null : _handleAction,
        child: _loading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
                _isAddMoney ? 'Add Money' : 'Send Money',
                style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Future<void> _handleAction() async {
    if (_isAddMoney) {
      await _handleAddMoney();
    } else {
      await _handleSendMoney();
    }
  }

  Future<void> _handleAddMoney() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      _showError('Please enter a valid amount.');
      return;
    }

    final reference = PaystackService.generateReference();
    final email = FirebaseAuth.instance.currentUser?.email ?? 'customer@susuplus.com';
    final amountInPesewas = (amount * 100).round();

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) _showError('Not authenticated.');
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
        _showError('Failed to initialize payment. Please try again.');
        return;
      }

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

      final result = await PaystackService.verifyTransaction(reference: reference);
      final success = result != null && result['status'] == 'success';

      if (!mounted) return;

      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) rootNav.pop();

      if (result != null && success) {
        final paidEmail = result['customer']?['email'] as String? ?? email;
        final paidAmountPesewas = result['amount'] as int? ?? amountInPesewas;
        final paidAmount = paidAmountPesewas / 100;

        await FirebaseFirestore.instance.collection('orders').doc(reference).set({
          'reference': reference,
          'uid': user.uid,
          'email': paidEmail,
          'amount': paidAmountPesewas,
          'currency': 'GHS',
          'status': 'paid',
          'paidAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (!mounted) return;
        if (context.mounted) {
          context.read<TransactionsProvider>().addTransaction(
                Transaction(id: reference, title: 'Money added', amount: paidAmount, date: DateTime.now()),
              );
        }
      } else {
        await FirebaseFirestore.instance.collection('orders').doc(reference).set({
          'reference': reference,
          'uid': user.uid,
          'email': email,
          'amount': amountInPesewas,
          'currency': 'GHS',
          'status': 'failed',
        }, SetOptions(merge: true));

        if (!mounted) return;
        if (context.mounted) {
          context.read<TransactionsProvider>().addTransaction(
                Transaction(id: reference, title: 'Money added', amount: amount, date: DateTime.now(), status: 'failed'),
              );
        }
      }

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PaymentStatusDialog(success: success, isDeposit: true),
      );

      setState(() => _loading = false);
      selectedPage.value = 0;
    } on PaystackException catch (e) {
      if (mounted) _showError(e.message);
    } catch (e, st) {
      debugPrint('Payment error: $e\n$st');
      if (mounted) _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleSendMoney() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final phone = _phoneController.text.trim();
    final providerCode = _providerCodes[_provider] ?? 'MTN';

    if (amount <= 0) {
      _showError('Please enter a valid amount.');
      return;
    }

    if (phone.isEmpty) {
      _showError('Please enter a destination phone number.');
      return;
    }

    final balance = context.read<TransactionsProvider>().balance;
    if (amount > balance) {
      _showError('Insufficient balance. You have GH¢${balance.toStringAsFixed(2)}.');
      return;
    }

    final reference = PaystackService.generateReference();
    final email = FirebaseAuth.instance.currentUser?.email ?? 'customer@susuplus.com';
    final amountInPesewas = (amount * 100).round();

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) _showError('Not authenticated.');
        return;
      }

      final recipient = await PaystackService.createTransferRecipient(
        name: user.displayName ?? email,
        accountNumber: phone,
        bankCode: providerCode,
      );

      if (recipient == null) {
        if (mounted) _showError('Failed to create recipient. Please try again.');
        return;
      }

      final recipientCode = recipient['recipient_code'] as String?;
      if (recipientCode == null) {
        if (mounted) _showError('Invalid recipient response.');
        return;
      }

      final transfer = await PaystackService.initiateTransfer(
        amountInPesewas: amountInPesewas,
        recipientCode: recipientCode,
        reason: 'SusuPlus payout',
        reference: reference,
      );

      if (!mounted) return;

      String transferStatus = 'failed';
      String? transferCode;

      if (transfer != null) {
        transferStatus = transfer['status'] as String? ?? 'failed';
        transferCode = transfer['transfer_code'] as String?;

        if (transferStatus == 'otp' && transferCode != null) {
          final otp = await _showOtpDialog();
          if (otp != null) {
            final finalized = await PaystackService.finalizeTransfer(
              transferCode: transferCode,
              otp: otp,
            );
            if (finalized != null && finalized['status'] == 'success') {
              transferStatus = 'success';
            } else {
              if (mounted) _showError('Invalid OTP. Please try again.');
            }
          }
        }
      }

      final success = transferStatus == 'success';

      if (success) {
        await FirebaseFirestore.instance.collection('transfers').doc(reference).set({
          'reference': reference,
          'uid': user.uid,
          'email': email,
          'amount': amountInPesewas,
          'phone': phone,
          'provider': _provider,
          'status': 'sent',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        if (context.mounted) {
          context.read<TransactionsProvider>().addTransaction(
                Transaction(id: reference, title: 'Money sent to $phone', amount: -amount, date: DateTime.now()),
              );
        }
      } else {
        await FirebaseFirestore.instance.collection('transfers').doc(reference).set({
          'reference': reference,
          'uid': user.uid,
          'email': email,
          'amount': amountInPesewas,
          'phone': phone,
          'provider': _provider,
          'status': 'failed',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        if (context.mounted) {
          context.read<TransactionsProvider>().addTransaction(
                Transaction(id: reference, title: 'Money sent to $phone', amount: -amount, date: DateTime.now(), status: 'failed'),
              );
        }
      }

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PaymentStatusDialog(success: success, isDeposit: false),
      );

      if (!mounted) return;

      setState(() => _loading = false);
      selectedPage.value = 0;
    } on PaystackException catch (e) {
      if (mounted) _showError(e.message);
    } catch (e, st) {
      debugPrint('Transfer error: $e\n$st');
      if (mounted) _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<String?> _showOtpDialog() {
    final otpController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('An OTP has been sent to your phone. Enter it below to complete the transfer.'),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(otpController.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade600),
    );
  }
}

class _PaymentStatusDialog extends StatefulWidget {
  final bool success;
  final bool isDeposit;
  const _PaymentStatusDialog({required this.success, required this.isDeposit});

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
                Text(
                  widget.isDeposit ? 'Money Added!' : 'Money Sent!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF22C55E)),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isDeposit ? 'Your balance has been updated.' : 'Sent to mobile money.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
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
                  'Transaction Failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isDeposit ? 'Insufficient funds' : 'Please try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
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