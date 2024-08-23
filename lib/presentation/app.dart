import 'package:flutter/material.dart';

import 'package:supabase_lt/presentation/pages/countries/countries_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple.withOpacity(0.8),
        ),
      ),
      themeMode: ThemeMode.light,
      home: const CountriesPage(),
    );
  }
}
