import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Hoy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card),
          label: 'Credencial',
        ),
      ],
    );
  }
}
