import 'package:flutter/material.dart';
import 'package:segimutiplataform/src/views/MapView.dart';
import 'package:segimutiplataform/src/views/LoginView.dart';
import 'package:segimutiplataform/src/views/RegisterView.dart';
import 'package:segimutiplataform/src/views/HelpView.dart';

class AppRoutes{
  static const String map = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String help = "/help";

  static Map<String, WidgetBuilder> getRoutes(){
    return{
      map: (context) => const MapView(),
      login: (context) => const LoginView(),
      register: (context) => const RegisterView(),
      help: (context) => const HelpView(),
    };
  }

}