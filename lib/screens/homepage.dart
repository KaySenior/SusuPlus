import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:susu/provider/provider.dart';
import 'package:susu/screens/profile_screen.dart';
import 'package:susu/screens/transaction_screen.dart';
import 'package:susu/screens/transfer_screen.dart';
import 'package:susu/widgets/navbar.dart';
import '../core/notifier.dart';

final List<Widget> pages = [
  const HomeShell(),
  const TransferScreen(),
  const TransactionScreen(),
  const ProfileScreen(),
];

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            Column(
              spacing: 12,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/images/atom.png'),
                    ),
                    const SizedBox(width: 8),
                    const Text('Total Balance'),
                  ],
                ),
                Text(
                  '\$${context.watch<TransactionsProvider>().balance.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Card.outlined(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/icons/money-wavy.svg',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Receive Money',
                              style: TextStyle(fontWeight: FontWeight(500)),
                            ),
                            Text(
                              'Paid directly into your account',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight(300)),
                            ),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icons/caret-right.svg',
                          width: 24,
                          height: 24,
                          colorFilter:
                              ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                        ),
                      ),
                      //const Divider(height: 1),
                      ListTile(
                        onTap: () {
                          context.go('/transfer');
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/icons/wallet.svg',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Add Money',
                              style: TextStyle(fontWeight: FontWeight(500)),
                            ),
                            Text(
                              'Get more from your account',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight(300)),
                            ),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icons/caret-right.svg',
                          width: 24,
                          height: 24,
                          colorFilter:
                              ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? Recently paid section
                const Text(
                  'Recently paid',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Card.outlined(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/icons/receipt.svg',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!context.watch<TransactionsProvider>().hasTransactions)
                              const Text(
                                'No transactions yet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight(300),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Transactions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Card.outlined(
                  color: Colors.white,
                  child: Column(
                    children: [
                      if (!context.watch<TransactionsProvider>().hasTransactions) ...[
                        const SizedBox(height: 10,),
                        const Text('You have no transactions here'),
                        const SizedBox(height: 50,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 350,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(5)
                                )
                              ),
                              onPressed: () => context.go('/transfer'),
                              child: const Text(
                                'Make a transaction',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
