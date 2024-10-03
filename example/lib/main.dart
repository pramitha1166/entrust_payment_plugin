import 'package:entrust_payment_plugin_example/common_button.dart';
import 'package:entrust_payment_plugin_example/pin_enter_sheet.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:entrust_payment_plugin_example/router.dart' as router;
import 'package:flutter/services.dart';
import 'package:entrust_payment_plugin/entrust_payment_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _entrustNfcPlugin = EntrustPaymentPlugin();
  String walletInitResult = "No-Initialize Yet";
  String walletProvisionedStatus = "";
  String walletStatus = "";
  String clientId = "";
  String walletId = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _entrustNfcPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Widget _commonButton({required VoidCallback onPress, required String title}) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _spaceTop() {
    return const Padding(padding: EdgeInsets.only(top: 10));
  }

  Widget _titleText({required String text}) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 14),
    );
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entrust SDK',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.Router.generateRoute,
      initialRoute: router.ScreenRoutes.toHome,
      navigatorKey: navigatorKey,
    );
  }
}
