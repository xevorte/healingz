import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'pages/onboarding_page.dart';

class HealingzApp extends StatelessWidget {
  const HealingzApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Healingz',
    theme: AppTheme.light,
    initialRoute: '/',
    routes: {'/': (_) => const OnboardingPage()},
  );
}
