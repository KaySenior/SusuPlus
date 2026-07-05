import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/notifier.dart';

class Navbar extends StatelessWidget{
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPage,
      builder: (context, value, child) {
        return NavigationBar(
          selectedIndex: value,
          onDestinationSelected: (index) {
            selectedPage.value = index;
          },
          destinations: [
        NavigationDestination(icon: SvgPicture.asset('assets/icons/house.svg', width: 24, height: 24,), label: 'Home'),
        NavigationDestination(icon: SvgPicture.asset('assets/icons/plus.svg', width: 24, height: 24,), label: 'Add Money'),
        NavigationDestination(icon: SvgPicture.asset('assets/icons/scroll.svg', width: 24, height: 24,), label: 'Transactions'),
        NavigationDestination(icon: SvgPicture.asset('assets/icons/user.svg', width: 24, height: 24,), label: 'Account'),
      
      ]);},
    );
  }
}