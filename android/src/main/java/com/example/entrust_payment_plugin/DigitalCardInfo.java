package com.example.entrust_payment_plugin;

public class DigitalCardInfo {
    String lastDigits;
    String bin;
    String expiryDate;

    public DigitalCardInfo(String lastDigits, String bin, String expiryDate) {
        this.lastDigits = lastDigits;
        this.bin = bin;
        this.expiryDate = expiryDate;
    }
}
