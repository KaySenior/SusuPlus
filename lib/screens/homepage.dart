import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:susu/provider/provider.dart';
import 'package:susu/screens/profile_screen.dart';
import 'package:susu/screens/transaction_screen.dart';
import 'package:susu/screens/transfer_screen.dart';
import 'package:susu/screens/notification_settings_screen.dart';
import 'package:susu/widgets/navbar.dart';
import 'package:susu/models/transaction.dart';
import '../core/notifier.dart';

final List<Widget> pages = [
  const HomeShell(),
  const TransferScreen(),
  const TransactionScreen(),
  const ProfileScreen(),
];

// Centralize your palette so it's easy to theme later.
class AppColors {
  static const primary = Color(0xFF2F6BFF);
  static const primaryDark = Color(0xFF1E4FD6);
  static const bg = Color(0xFFEEF2F9);
  static const card = Colors.white;
  static const textDark = Color(0xFF16192B);
  static const textMuted = Color(0xFF8A8FA3);
  static const chipBg = Color(0xFFEFF3FF);
  static const border = Color(0xFFE7E9F0);
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        context.read<TransactionsProvider>().fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPage,
        builder: (context, index, child) {
          return IndexedStack(index: index, children: pages);
        },
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeShell> {
  @override
  Widget build(BuildContext context) {
    final balance = context.watch<TransactionsProvider>().balance;
    final transactions = context.watch<TransactionsProvider>().transactions;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Susu',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
              ),
              child: _IconBadge(
                child: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  colorFilter:
                      const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _BalanceCard(balance: balance),
            const SizedBox(height: 28),
            _SectionHeader(title: 'Get Started'),
            const SizedBox(height: 12),
            _ActionsCard(
              children: [
                _ActionTile(
                  iconAsset: 'assets/icons/money-wavy.svg',
                  title: 'Receive Money',
                  subtitle: 'Paid directly into your account',
                  onTap: () => context.go('/transfer'),
                ),
                _ActionTile(
                  iconAsset: 'assets/icons/wallet.svg',
                  title: 'Add Money',
                  subtitle: 'Get more from your account',
                  onTap: () => context.go('/transfer'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _SectionHeader(title: 'Recently Paid'),
            const SizedBox(height: 12),
            _RecentPaidCard(
              transactions: transactions,
            ),
            const SizedBox(height: 28),
            _SectionHeader(title: 'Transactions'),
            const SizedBox(height: 12),
            _TransactionsCard(
              transactions: transactions,
              onMakeTransaction: () => context.go('/transfer'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Reusable pieces ----------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final Widget child;
  const _IconBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(child: child),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Total Balance',
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'GH¢${balance.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final List<Widget> children;
  const _ActionsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 68, color: Color(0xFFEFF1F6));
  }
}

class _ActionTile extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.chipBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SvgPicture.asset(iconAsset, width: 22, height: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _RecentPaidCard extends StatelessWidget {
  final List<Transaction> transactions;
  const _RecentPaidCard({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final items = transactions.length > 3
        ? transactions.sublist(transactions.length - 3)
        : transactions;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: items.isEmpty
          ? Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.chipBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/icons/receipt.svg',
                        width: 22, height: 22,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn)),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: items.reversed.map((tx) => _txRow(tx)).toList(),
            ),
    );
  }

  Widget _txRow(Transaction tx) {
    final isCredit = tx.amount > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFF22C55E).withValues(alpha: 0.1)
                  : const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCredit ? PhosphorIcons.arrowDown : PhosphorIcons.arrowUp,
              color: Colors.black,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            isCredit ? '+₵${tx.amount.toStringAsFixed(2)}' : '-₵${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isCredit ? const Color(0xFF22C55E) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsCard extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onMakeTransaction;

  const _TransactionsCard({
    required this.transactions,
    required this.onMakeTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final items = transactions.length > 5
        ? transactions.sublist(transactions.length - 5)
        : transactions;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: items.isEmpty
          ? Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.chipBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SvgPicture.asset('assets/icons/scroll.svg',
                      width: 28, height: 28,
                      colorFilter: const ColorFilter.mode(
                          Colors.black, BlendMode.srcIn)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You have no transactions here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onMakeTransaction,
                    child: const Text(
                      'Make a transaction',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            )
          : Column(
              children: [
                ...items.reversed.map((tx) => _txRow(tx)),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        selectedPage.value = 2;
                        context.go('/homepage');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('See all transactions',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _txRow(Transaction tx) {
    final isCredit = tx.amount > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFF22C55E).withValues(alpha: 0.1)
                  : const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCredit ? PhosphorIcons.arrowDown : PhosphorIcons.arrowUp,
              color: Colors.black,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            isCredit ? '+₵${tx.amount.toStringAsFixed(2)}' : '-₵${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isCredit ? const Color(0xFF22C55E) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}