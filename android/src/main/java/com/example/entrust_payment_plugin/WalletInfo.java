package com.example.entrust_payment_plugin;

public class WalletInfo {
    String walletId;
    String issuerClientId;
    String defaultCardId;

    public WalletInfo(String walletId, String issuerClientId, String defaultCardId) {
        this.walletId = walletId;
        this.issuerClientId = issuerClientId;
        this.defaultCardId = defaultCardId;
    }
}
