import 'dart:convert';

class Wallet {
  final String walletId;
  final String? issuerClientId;
  final String? defaultCardId;

  Wallet({required this.walletId, this.defaultCardId, this.issuerClientId});

  factory Wallet.fromJSON(Map<String, dynamic> json) {
    return Wallet(
      walletId: json['walletId'],
      issuerClientId: json['issuerClientId'],
      defaultCardId: json['issuerClientId']
    );
  }

  factory Wallet.fromString(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    return Wallet.fromJSON(json);
  }
}
