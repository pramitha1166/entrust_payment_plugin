import 'dart:math';

import 'package:entrust_payment_plugin/entrust_payment_plugin.dart';
import 'package:entrust_payment_plugin_example/router.dart';
import 'package:entrust_payment_plugin_example/test_field_with_label.dart';
import 'package:entrust_payment_plugin_example/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _entrustNfcPlugin = EntrustPaymentPlugin();

Future activateWallet(String pin, BuildContext context) async {
  String result;
  try {
    result = await _entrustNfcPlugin.connectWalletWithAuth(pin) ?? "";

    print("Wallet init result --> " + result);
    if (context.mounted) {
      if (result == "WALLET_CONNECTED") {
        moveToWalletScreen(context);
      } else {
        Navigator.of(context).pop();
      }
    }
  } on PlatformException catch (e) {
    result = "";
    print(e.code);
    print("Error with activating wallet");
    showToast(message: "Error with connect wallet");
    Navigator.of(context).pop();
  } on Exception catch (e) {
    print(e);
    Navigator.of(context).pop();
  }
}

void moveToWalletScreen(BuildContext context) {
  Navigator.popAndPushNamed(context, ScreenRoutes.toWallet);
}

Future openPinSheet({
  required BuildContext context,
}) {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, state) => GestureDetector(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Enter pass-code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: TextField(
                          controller: _controllers[index],
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            counterText: '', // Hide counter
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < 3) {
                              // Move to the next field if one digit is entered
                              FocusScope.of(context).nextFocus();
                            }
                            String pin = _controllers
                                .map((controller) => controller.text)
                                .join();
                            if (pin.length == 4) {
                              activateWallet(pin, context);
                            }
                          },
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
