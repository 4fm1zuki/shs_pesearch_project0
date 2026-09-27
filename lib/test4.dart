import 'package:flutter/material.dart';

void main() {
  runApp(const TabangApp());
}

// ==========================================================
// APP
// ==========================================================

class TabangApp extends StatefulWidget {
  const TabangApp({super.key});

  @override
  State<TabangApp> createState() => _TabangAppState();
}

class _TabangAppState extends State<TabangApp> {
  ThemeMode themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TABANG',

      // ====================================================
      // LIGHT THEME
      // ====================================================

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFD3D3D3),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F4F4),
          foregroundColor: Colors.black,
        ),
      ),

      // ====================================================
      // DARK THEME
      // ====================================================

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFF181818),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF242424),
          foregroundColor: Colors.white,
        ),
      ),

      // ====================================================
      // THEME MODE
      // ====================================================

      themeMode: themeMode,

      home: Dashboard(
        themeMode: themeMode,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

// ==========================================================
// DASHBOARD
// ==========================================================

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
  bool sidebarOpen = true;
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

  // ========================================================
  // THEME COLORS
  // ========================================================

  Color get backgroundColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF181818)
        : const Color(0xFFD3D3D3);
  }

  Color get headerColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF242424)
        : const Color(0xFFF4F4F4);
  }

  Color get sidebarColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF202020)
        : const Color(0xFFE9E9E9);
  }

  Color get selectedColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF333333)
        : Colors.white;
  }

  Color get cardColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF292929)
        : Colors.white;
  }

  Color get borderColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF444444)
        : const Color(0xFFBBBBBB);
  }

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
                    // BODY
                    // ======================================

                    Expanded(
                      child: Row(
                        children: [
                          // SIDEBAR

                          AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 250),

                            curve: Curves.easeInOut,

                            width: sidebarOpen ? 220 : 0,

                            child: sidebarOpen
                                ? _buildSidebar()
                                : const SizedBox(),
                          ),

                          // PAGE

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

  // ========================================================
  // PAGE ROUTING
  // ========================================================

  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return DiscoverPage(
          onMenuPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        );

      case 3:
        return SettingsPage(
          themeMode: widget.themeMode,
          onThemeChanged: widget.onThemeChanged,
          onMenuPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        );

      default:
        return BlankPage(
          onMenuPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        );
    }
  }

  // ========================================================
  // SIDEBAR
  // ========================================================

  Widget _buildSidebar() {
    final textColor =
        Theme.of(context).colorScheme.onSurface;

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
              final selected =
                  selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },

                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 150),

                  height: 55,

                  decoration: BoxDecoration(
                    color: selected
                        ? selectedColor
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
                        color: textColor.withOpacity(.75),
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

          Container(
            height: 50,
            width: double.infinity,

            decoration: BoxDecoration(
              color: selectedColor,

              borderRadius:
              const BorderRadius.only(
                topRight: Radius.circular(10),
              ),
            ),

            child: Row(
              children: [
                const SizedBox(width: 20),

                Icon(
                  Icons.account_circle_outlined,
                  size: 22,
                  color: textColor.withOpacity(.75),
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

  const DiscoverPage({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? const Color(0xFF292929)
        : Colors.white;

    final imageColor = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFF8F8F8);

    final textColor =
        theme.colorScheme.onSurface;

    return Container(
      color: theme.scaffoldBackgroundColor,

      padding: const EdgeInsets.fromLTRB(
        25,
        20,
        25,
        20,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ================================================
          // MENU + SEARCH
          // ================================================

          Row(
            children: [
              // MENU BUTTON

              GestureDetector(
                onTap: onMenuPressed,

                child: Container(
                  width: 42,
                  height: 36,

                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),

                  child: Icon(
                    Icons.menu,
                    size: 25,
                    color: textColor,
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
                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: textColor,
                          ),

                          decoration:
                          InputDecoration(
                            border: InputBorder.none,

                            hintText:
                            'Search...',

                            hintStyle: TextStyle(
                              color: textColor
                                  .withOpacity(.5),
                            ),

                            isDense: true,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.search,
                        size: 20,
                        color: textColor,
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

              borderRadius:
              BorderRadius.circular(15),
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

          const SizedBox(height: 12),

          // ================================================
          // BLOG CARDS
          // ================================================

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildBlogCard(
                    cardColor,
                    imageColor,
                    textColor,
                    isDark,
                  ),
                ),

                const SizedBox(width: 40),

                Expanded(
                  child: _buildBlogCard(
                    cardColor,
                    imageColor,
                    textColor,
                    isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
      Color cardColor,
      Color imageColor,
      Color textColor,
      bool isDark,
      ) {
    return Container(
      height: 200,

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
        BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black54
                : Colors.black26,

            blurRadius: 2,

            offset:
            const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [
          // IMAGE

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: imageColor,

                borderRadius:
                const BorderRadius.only(
                  topLeft:
                  Radius.circular(10),

                  topRight:
                  Radius.circular(10),
                ),
              ),
            ),
          ),

          // BOTTOM

          Container(
            height: 45,

            padding:
            const EdgeInsets.only(
              right: 15,
            ),

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.end,

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
                  color: textColor,
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
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final VoidCallback onMenuPressed;

  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onMenuPressed,
  });

  String get themeName {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';

      case ThemeMode.dark:
        return 'Dark';

      case ThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardColor =
    theme.brightness == Brightness.dark
        ? const Color(0xFF292929)
        : Colors.white;

    final textColor =
        theme.colorScheme.onSurface;

    return Container(
      color: theme.scaffoldBackgroundColor,

      padding: const EdgeInsets.all(25),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // MENU BUTTON

          GestureDetector(
            onTap: onMenuPressed,

            child: Container(
              width: 42,
              height: 36,

              decoration: BoxDecoration(
                color: cardColor,

                borderRadius:
                BorderRadius.circular(6),
              ),

              child: Icon(
                Icons.menu,
                size: 25,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // TITLE

          Text(
            'Settings',

            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 20),

          // ================================================
          // THEME CARD
          // ================================================

          Container(
            width: double.infinity,

            padding:
            const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: cardColor,

              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Icon(
                      themeMode ==
                          ThemeMode.dark
                          ? Icons.dark_mode
                          : themeMode ==
                          ThemeMode.light
                          ? Icons.light_mode
                          : Icons.settings_suggest,

                      color: textColor,
                    ),

                    const SizedBox(width: 15),

                    Text(
                      'Appearance',

                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  'Choose how TABANG should display its theme.',

                  style: TextStyle(
                    color:
                    textColor.withOpacity(.7),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                // THEME OPTIONS

                _themeOption(
                  context,
                  ThemeMode.system,
                  Icons.settings_suggest,
                  'System',
                  'Follow your computer settings.',
                ),

                _themeOption(
                  context,
                  ThemeMode.light,
                  Icons.light_mode,
                  'Light',
                  'Always use light mode.',
                ),

                _themeOption(
                  context,
                  ThemeMode.dark,
                  Icons.dark_mode,
                  'Dark',
                  'Always use dark mode.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'Current theme: $themeName',

            style: TextStyle(
              color:
              textColor.withOpacity(.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOption(
      BuildContext context,
      ThemeMode mode,
      IconData icon,
      String title,
      String subtitle,
      ) {
    final theme = Theme.of(context);

    final selected = themeMode == mode;

    final textColor =
        theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        onThemeChanged(mode);
      },

      child: Container(
        margin:
        const EdgeInsets.only(bottom: 8),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              .withOpacity(.12)
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(8),

          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : Colors.transparent,
          ),
        ),

        child: Row(
          children: [
            Icon(
              icon,

              size: 22,

              color: selected
                  ? theme.colorScheme.primary
                  : textColor.withOpacity(.7),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      color: textColor,
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,

                    style: TextStyle(
                      color: textColor
                          .withOpacity(.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              Icon(
                Icons.check_circle,
                color:
                theme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// BLANK PAGES
// ==========================================================

class BlankPage extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const BlankPage({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardColor =
    theme.brightness == Brightness.dark
        ? const Color(0xFF292929)
        : Colors.white;

    return Container(
      color: theme.scaffoldBackgroundColor,

      padding:
      const EdgeInsets.fromLTRB(
        25,
        20,
        25,
        20,
      ),

      child: Align(
        alignment: Alignment.topLeft,

        child: GestureDetector(
          onTap: onMenuPressed,

          child: Container(
            width: 42,
            height: 36,

            decoration: BoxDecoration(
              color: cardColor,

              borderRadius:
              BorderRadius.circular(6),
            ),

            child: Icon(
              Icons.menu,
              size: 25,
              color:
              theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
