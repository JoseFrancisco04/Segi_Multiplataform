import 'package:flutter/material.dart';

import 'package:segimutiplataform/src/routes/AppRoutes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
EQUIPO:

Jose Francisco Hernandez Fernando
Jesus Orlando Garrido Cruz
Alan Sanchez Garrido
Guadalupe Cruz Hernandez

 */

Future<void> main() async{
  await dotenv.load(fileName: ".env");
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
