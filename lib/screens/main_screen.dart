import 'package:flutter/material.dart';

import 'favorite_screen.dart';
import 'home_screen.dart';
import 'recipe_list_screen.dart';

/// MainScreen – shell utama yang menampung NavigationBar.
/// Semua tab (Home, Recipes, Favorites) dirender di sini.
/// Pakai IndexedStack supaya state tiap tab tidak hilang saat berpindah.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index tab yang sedang aktif (0 = Home, 1 = Recipes, 2 = Favorites)
  int _selectedIndex = 0;

  // Daftar screen tiap tab.
  // IndexedStack menjaga state masing-masing screen agar tidak di-rebuild
  // saat pengguna berpindah tab.
  static const _screens = <Widget>[
    HomeScreen(),
    RecipeListScreen(),
    FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: tampilkan hanya satu screen, sisanya tetap hidup di memori
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // NavigationBar bawah dengan 3 destinasi
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: _tabLabel(0),
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search_rounded),
            label: _tabLabel(1),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite_rounded),
            label: _tabLabel(2),
          ),
        ],
      ),
    );
  }

  // Label tab sesuai index
  String _tabLabel(int index) => switch (index) {
        0 => 'Home',
        1 => 'Recipes',
        2 => 'Favorites',
        _ => '',
      };
}

