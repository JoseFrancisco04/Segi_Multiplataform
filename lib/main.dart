import 'package:flutter/material.dart';

import 'package:segimutiplataform/src/routes/AppRoutes.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segi App',
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.map,
      routes: AppRoutes.getRoutes(),

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color (0xFF2196F3),
      ),
    );
  }
}
