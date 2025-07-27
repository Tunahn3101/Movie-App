import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import '../themes/theme_provider.dart';

enum _SelectedTab { home, search, library, setting }

class UiBottomNavigation extends StatefulWidget {
  const UiBottomNavigation({super.key});

  @override
  State<UiBottomNavigation> createState() => _UiBottomNavigationState();
}

class _UiBottomNavigationState extends State<UiBottomNavigation> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  Widget _selectedPage() {
    switch (_selectedTab) {
      case _SelectedTab.home:
        return const HomeScreen();
      case _SelectedTab.search:
        return const SearchScreen();
      case _SelectedTab.library:
        return const LibraryScreen();
      case _SelectedTab.setting:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final selectedColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 23, 23, 23);
    return Scaffold(
      extendBody: true,
      body: _selectedPage(),
      bottomNavigationBar: CrystalNavigationBar(
        margin: EdgeInsets.zero,
        marginR: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        paddingR: EdgeInsets.zero,
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        // indicatorColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black.withOpacity(0.1),
        // outlineBorderColor: Colors.black.withOpacity(0.1),

        onTap: _handleIndexChanged,
        items: [
          /// Home
          CrystalNavigationBarItem(
            icon: IconlyBold.home,
            unselectedIcon: IconlyLight.home,
            selectedColor: selectedColor,
          ),

          /// Search
          CrystalNavigationBarItem(
            icon: IconlyBold.search,
            unselectedIcon: IconlyLight.search,
            selectedColor: selectedColor,
          ),

          /// Library
          CrystalNavigationBarItem(
            icon: IconlyBold.category,
            unselectedIcon: IconlyLight.category,
            selectedColor: selectedColor,
          ),

          /// Settings
          CrystalNavigationBarItem(
            icon: IconlyBold.setting,
            unselectedIcon: IconlyLight.setting,
            selectedColor: selectedColor,
          ),
        ],
      ),
    );
  }
}
