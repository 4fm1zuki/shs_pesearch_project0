import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final cardColor = isDark
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
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 25),

          // ==============================================
          // APPEARANCE
          // ==============================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Choose how TABANG should display.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    textColor.withOpacity(.6),
                  ),
                ),

                const SizedBox(height: 20),

                // SYSTEM

                _themeOption(
                  context,
                  ThemeMode.system,
                  Icons.settings_suggest,
                  'System',
                  'Follow your computer settings.',
                ),

                // LIGHT

                _themeOption(
                  context,
                  ThemeMode.light,
                  Icons.light_mode,
                  'Light',
                  'Always use light mode.',
                ),

                // DARK

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
        ],
      ),
    );
  }

  Widget _themeOption(
      BuildContext context,
      ThemeMode mode,
      IconData icon,
      String title,
      String description,
      ) {
    final theme = Theme.of(context);

    final selected =
        themeMode == mode;

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
        const EdgeInsets.all(12),

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
              color: selected
                  ? theme.colorScheme.primary
                  : textColor.withOpacity(.7),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                      textColor.withOpacity(.6),
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
              ),
          ],
        ),
      ),
    );
  }
}
