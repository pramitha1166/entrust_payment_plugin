import 'package:entrust_payment_plugin_example/home_screen.dart';
import 'package:entrust_payment_plugin_example/main.dart';
import 'package:entrust_payment_plugin_example/wallet_screen.dart';
import 'package:flutter/material.dart';

class ScreenRoutes {
  static const String toHome = "toHome";
  static const String toWallet = "toWallet";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ScreenRoutes.toHome:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case ScreenRoutes.toWallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
