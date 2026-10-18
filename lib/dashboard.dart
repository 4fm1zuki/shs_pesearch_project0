import 'package:flutter/material.dart';

import 'pages/discover_page.dart';
import 'pages/blood_bank_page.dart';
import 'pages/find_donor_page.dart';
import 'pages/chat_page.dart';
import 'pages/settings_page.dart';
import 'pages/about_help_page.dart';
import 'pages/profile_page.dart';

class Dashboard extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const Dashboard({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool sidebarOpen = false;

  int selectedIndex = 0;
  String? selectedChatContact;

  Widget _buildPageStack() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IndexedStack(
      index: selectedIndex,
      children: [
        const DiscoverPage(),
        const BloodBankPage(),
        FindDonorPage(
          themeMode: widget.themeMode,
          onThemeChanged: widget.onThemeChanged,
          onContactDonor: (name) {
            setState(() {
              selectedChatContact = name;
              selectedIndex = 3;
            });
          },
        ),
        ChatPage(
          isDark: isDark,
          initialContactName: selectedChatContact,
        ),
        SettingsPage(
          themeMode: widget.themeMode,
          onThemeChanged: widget.onThemeChanged,
        ),
        AboutHelpPage(isDark: isDark),
        ProfilePage(isDark: isDark),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 800;

    if (isCompact) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle(selectedIndex)),
          actions: [
            PopupMenuButton<int>(
              tooltip: 'More pages',
              onSelected: (index) => setState(() => selectedIndex = index),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 5, child: Text('About & Help')),
                PopupMenuItem(value: 6, child: Text('Profile')),
              ],
            ),
          ],
        ),
        body: _buildPageStack(),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex.clamp(0, 4),
          onDestinationSelected: (index) =>
              setState(() => selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.bloodtype_outlined),
              selectedIcon: Icon(Icons.bloodtype),
              label: 'Blood Bank',
            ),
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined),
              selectedIcon: Icon(Icons.location_on),
              label: 'Find Donor',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => sidebarOpen = true),
            onExit: (_) => setState(() => sidebarOpen = false),
            child: NavigationRail(
              extended: sidebarOpen,
              labelType: sidebarOpen ? null : NavigationRailLabelType.all,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => selectedIndex = index),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(Icons.water_drop,
                        color: Theme.of(context).colorScheme.primary),
                    if (sidebarOpen) ...[
                      const SizedBox(height: 8),
                      Text('TABANG',
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Discover'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bloodtype_outlined),
                  selectedIcon: Icon(Icons.bloodtype),
                  label: Text('Blood Bank'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.location_on_outlined),
                  selectedIcon: Icon(Icons.location_on),
                  label: Text('Find Donor'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble),
                  label: Text('Chat'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('About & Help'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
              ],
            ),
          ),
          Expanded(child: _buildPageStack()),
        ],
      ),
    );
  }

  String _pageTitle(int index) {
    switch (index) {
      case 1:
        return 'Blood Bank';
      case 2:
        return 'Find Donor';
      case 3:
        return 'Chat';
      case 4:
        return 'Settings';
      case 5:
        return 'About & Help';
      case 6:
        return 'Profile';
      default:
        return 'TABANG';
    }
  }
}
