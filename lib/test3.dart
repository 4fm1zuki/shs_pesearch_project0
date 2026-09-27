import 'package:flutter/material.dart';

void main() {
  runApp(const TabangApp());
}

class TabangApp extends StatelessWidget {
  const TabangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TABANG',
      theme: ThemeData(
        fontFamily: 'Arial',
        brightness: Brightness.light,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool sidebarOpen = true;
  bool darkMode = false;
  int selectedIndex = 0;

  final List<String> menuItems = [
    'Discover',
    'Blood Bank\nInventory',
    'Find Donor',
    'Settings',
    'About & Help',
  ];

  final List<IconData> menuIcons = [
    Icons.explore_outlined,
    Icons.bloodtype_outlined,
    Icons.location_on_outlined,
    Icons.settings_outlined,
    Icons.info_outline,
  ];

  // ======================================================
  // LIGHT MODE COLORS
  // ======================================================

  Color get backgroundColor =>
      darkMode ? const Color(0xFF181818) : const Color(0xFFD3D3D3);

  Color get headerColor =>
      darkMode ? const Color(0xFF242424) : const Color(0xFFF4F4F4);

  Color get sidebarColor =>
      darkMode ? const Color(0xFF202020) : const Color(0xFFE9E9E9);

  Color get selectedSidebarColor =>
      darkMode ? const Color(0xFF333333) : Colors.white;

  Color get cardColor =>
      darkMode ? const Color(0xFF292929) : Colors.white;

  Color get textColor =>
      darkMode ? Colors.white : Colors.black;

  Color get secondaryTextColor =>
      darkMode ? const Color(0xFFBDBDBD) : const Color(0xFF454545);

  Color get borderColor =>
      darkMode ? const Color(0xFF444444) : const Color(0xFFBBBBBB);

  Color get blogImageColor =>
      darkMode ? const Color(0xFF333333) : const Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    // ======================================
                    // APP HEADER
                    // ======================================

                    Container(
                      height: 65,
                      color: headerColor,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'Insert Logo with Title Vro',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 19,
                          color: textColor,
                        ),
                      ),
                    ),

                    // ======================================
                    // BODY
                    // ======================================

                    Expanded(
                      child: Row(
                        children: [
                          // SIDEBAR
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: sidebarOpen ? 220 : 0,
                            child: sidebarOpen
                                ? _buildSidebar()
                                : const SizedBox(),
                          ),

                          // MAIN CONTENT
                          Expanded(
                            child: _buildPage(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // PAGE ROUTING
  // ======================================================

  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return DiscoverPage(
          darkMode: darkMode,
          backgroundColor: backgroundColor,
          cardColor: cardColor,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          onMenuPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        );

      case 3:
        return SettingsPage(
          darkMode: darkMode,
          backgroundColor: backgroundColor,
          cardColor: cardColor,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          onDarkModeChanged: (value) {
            setState(() {
              darkMode = value;
            });
          },
          onMenuPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        );

      default:
        return BlankPage(
          darkMode: darkMode,
          backgroundColor: backgroundColor,
          onMenuPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        );
    }
  }

  // ======================================================
  // SIDEBAR
  // ======================================================

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: sidebarColor,
      child: Column(
        children: [
          const SizedBox(height: 10),

          // MENU ITEMS
          ...List.generate(
            menuItems.length,
                (index) {
              final selected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 55,
                  decoration: BoxDecoration(
                    color: selected
                        ? selectedSidebarColor
                        : sidebarColor,
                    border: Border(
                      bottom: BorderSide(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),

                      Icon(
                        menuIcons[index],
                        size: 22,
                        color: secondaryTextColor,
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          menuItems[index],
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 13,
                            color: textColor,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const Spacer(),

          // PROFILE
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: selectedSidebarColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),

                  Icon(
                    Icons.account_circle_outlined,
                    size: 22,
                    color: secondaryTextColor,
                  ),

                  const SizedBox(width: 12),

                  Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// DISCOVER PAGE
// ==========================================================

class DiscoverPage extends StatelessWidget {
  final VoidCallback onMenuPressed;

  final bool darkMode;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;

  const DiscoverPage({
    super.key,
    required this.onMenuPressed,
    required this.darkMode,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================================================
          // MENU + SEARCH
          // ================================================

          Row(
            children: [
              // SIDEBAR BUTTON
              GestureDetector(
                onTap: onMenuPressed,
                child: Container(
                  width: 42,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.menu,
                    size: 25,
                    color: secondaryTextColor,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // SEARCH BAR
              Container(
                height: 36,
                width: 320,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: secondaryTextColor,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.search,
                        size: 20,
                        color: secondaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ================================================
          // FEATURED AREA
          // ================================================

          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          const SizedBox(height: 30),

          // ================================================
          // BLOG TITLE
          // ================================================

          Text(
            'BLOGS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          // ================================================
          // BLOG CARDS
          // ================================================

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildBlogCard(),
                ),

                const SizedBox(width: 40),

                Expanded(
                  child: _buildBlogCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: darkMode
                ? Colors.black54
                : Colors.black26,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Blog image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: darkMode
                    ? const Color(0xFF333333)
                    : const Color(0xFFF8F8F8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),

          // Bottom
          Container(
            height: 45,
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'See more',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),

                const SizedBox(width: 7),

                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: secondaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// SETTINGS PAGE
// ==========================================================

class SettingsPage extends StatelessWidget {
  final bool darkMode;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;

  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onMenuPressed;

  const SettingsPage({
    super.key,
    required this.darkMode,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onDarkModeChanged,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: backgroundColor,
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu button
          GestureDetector(
            onTap: onMenuPressed,
            child: Container(
              width: 42,
              height: 36,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.menu,
                size: 25,
                color: secondaryTextColor,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            'Settings',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 20),

          // Theme setting
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  darkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: secondaryTextColor,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        darkMode
                            ? 'Dark theme is enabled'
                            : 'Light theme is enabled',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Switch(
                  value: darkMode,
                  onChanged: onDarkModeChanged,
                  activeThumbColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// BLANK PAGES
// ==========================================================

class BlankPage extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final bool darkMode;
  final Color backgroundColor;

  const BlankPage({
    super.key,
    required this.onMenuPressed,
    required this.darkMode,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
    darkMode ? const Color(0xFF292929) : Colors.white;

    final iconColor =
    darkMode ? Colors.white70 : const Color(0xFF555555);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: onMenuPressed,
          child: Container(
            width: 42,
            height: 36,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.menu,
              size: 25,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
