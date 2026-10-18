import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabang/main.dart';
import 'package:tabang/pages/about_help_page.dart';
import 'package:tabang/pages/blood_bank_page.dart';
import 'package:tabang/pages/chat_page.dart';
import 'package:tabang/pages/discover_page.dart';
import 'package:tabang/pages/find_donor_page.dart';
import 'package:tabang/pages/profile_page.dart';
import 'package:tabang/pages/settings_page.dart';
import 'package:tabang/services/backend_config.dart';

void main() {
  testWidgets('starts the Material 3 demo without backend credentials',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TabangApp());

    expect(backendClient, isNull);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.useMaterial3,
      isTrue,
    );
    expect(find.text('EXPLORE'), findsOneWidget);
  });

  testWidgets('renders the dashboard at phone width', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final pages = <Widget>[
      const DiscoverPage(),
      const BloodBankPage(),
      FindDonorPage(
        themeMode: ThemeMode.light,
        onThemeChanged: (_) {},
        onContactDonor: (_) {},
      ),
      const ChatPage(isDark: false),
      SettingsPage(
        themeMode: ThemeMode.light,
        onThemeChanged: (_) {},
      ),
      const AboutHelpPage(isDark: false),
      const ProfilePage(isDark: false),
    ];

    for (final page in pages) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
      await tester.pump(const Duration(milliseconds: 100));
      final exception = tester.takeException();
      expect(
        exception,
        isNull,
        reason: '${page.runtimeType}: $exception',
      );
    }

    await tester.pumpWidget(const TabangApp());
    await tester.pump(const Duration(milliseconds: 100));
    final dashboardException = tester.takeException();
    expect(
      dashboardException,
      isNull,
      reason: 'Compact dashboard: $dashboardException',
    );
  });
}
