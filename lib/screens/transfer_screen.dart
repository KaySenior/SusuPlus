import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:susu/provider/provider.dart';
import 'package:susu/models/transaction.dart';
import 'package:susu/services/momo_service.dart';
import 'package:susu/widgets/custom_row.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  bool _recurring = false;
  final _amountController = TextEditingController(text: '1.00');
  final _toController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 32),
          onPressed: () => context.pop('/homepage'),
        ),
        title: const Text(
          'Transfer',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _amountField(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _recurringRow(),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _fromRow(),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _toRow(),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _dateRow(),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _disclaimer(),
                  const SizedBox(height: 40),
                  _continueButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountField() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Amount',
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade600, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: TextField(
              controller: _amountController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, color: Colors.black87),
              decoration: const InputDecoration(border: InputBorder.none),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _recurringRow() {
    return CustomRow(
      label: 'Recurring',
      trailing: Switch(
        value: _recurring,
        activeColor: Colors.white,
        activeTrackColor: Colors.grey.shade400,
        onChanged: (v) => setState(() => _recurring = v),
      ),
    );
  }

  Widget _fromRow() {
    return CustomRow(
      label: 'From number',
      trailing: SizedBox(
        width: 200,
        height: 30,
        child: TextField(
          controller: _toController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _toRow() {
    return const CustomDropdownRow(
      label: 'To',
      value: 'Your account',
      boxLabel: '••••',
    );
  }

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
          style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
        ),
        SizedBox(height: 16),
        Text(
          'You agree to release us SusuPlus of any liability',
          style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 0,
        ),
        onPressed: () async {
          final amount = double.tryParse(_amountController.text) ?? 0;
          if (amount <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a valid amount.')),
            );
            return;
          }
          final email = 'customer@email.com';
          final reference = DateTime.now().millisecondsSinceEpoch.toString();
          final success = await MomoService.makePayment(
            email: email,
            amount: (amount * 100).toInt(),
            reference: reference,
          );
          if (success) {
            context.read<TransactionsProvider>().addTransaction(
              Transaction(
                id: reference,
                title: 'Money added',
                amount: amount,
                date: DateTime.now(),
              ),
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment successful!')),
              );
            }
            context.pop();
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment failed. Please try again.')),
              );
            }
          }
        },
        child: const Text(
          'Continue',
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }
}
