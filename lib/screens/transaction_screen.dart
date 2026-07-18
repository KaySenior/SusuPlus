import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:susu/provider/provider.dart';
import '../core/notifier.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    final items = context.watch<TransactionsProvider>().transactions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF2F9),
        elevation: 0,
        title: const Text(
          'Transactions',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFEEF2F9),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/icons/receipt.svg', width: 80, height: 80),
                    const SizedBox(height: 24),
                    const Text(
                      'No transactions yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'When you send or receive money, your transactions will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.4),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6FD9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        onPressed: () { selectedPage.value = 1; context.go('/homepage'); },
                        child: const Text(
                          'Make a transaction',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final tx = items.reversed.toList()[i];
                final isFailed = tx.status == 'failed';
                final isCredit = tx.amount > 0 && !isFailed;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isFailed
                              ? Colors.grey.shade100
                              : isCredit
                                  ? const Color(0xFF22C55E).withValues(alpha: 0.1)
                                  : const Color(0xFFEF4444).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isFailed ? PhosphorIcons.x : isCredit ? PhosphorIcons.arrowDown : PhosphorIcons.arrowUp,
                          color: isFailed ? Colors.grey : Colors.black,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.title,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                ),
                                if (isFailed) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('Failed',
                                        style: TextStyle(fontSize: 11, color: Color(0xFFEF4444), fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!isFailed)
                        Text(
                          isCredit
                              ? '+₵${tx.amount.toStringAsFixed(2)}'
                              : '-₵${tx.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isCredit ? const Color(0xFF22C55E) : Colors.black87,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
