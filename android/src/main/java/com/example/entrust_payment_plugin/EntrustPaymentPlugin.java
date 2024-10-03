package com.example.entrust_payment_plugin;

import android.content.Context;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import fr.antelop.sdk.AntelopCallback;
import fr.antelop.sdk.AntelopError;
import fr.antelop.sdk.AsyncRequestType;
import fr.antelop.sdk.EligibilityDenialReason;
import fr.antelop.sdk.Product;
import fr.antelop.sdk.Wallet;
import fr.antelop.sdk.WalletManager;
import fr.antelop.sdk.WalletManagerCallback;
import fr.antelop.sdk.WalletProvisioning;
import fr.antelop.sdk.WalletProvisioningCallback;
import fr.antelop.sdk.authentication.CustomerAuthenticationMethodType;
import fr.antelop.sdk.authentication.CustomerAuthenticationPasscode;
import fr.antelop.sdk.authentication.CustomerCredentialsRequiredReason;
import fr.antelop.sdk.authentication.LocalAuthenticationErrorReason;
import fr.antelop.sdk.card.Card;
import fr.antelop.sdk.configuration.AntelopConfiguration;
import fr.antelop.sdk.configuration.AntelopConfigurationManager;
import fr.antelop.sdk.exception.WalletValidationException;
import fr.antelop.sdk.transaction.hce.DefaultHceTransactionListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.Map;
import fr.antelop.sdk.digitalcard.DigitalCard;



/** EntrustPaymentPlugin */
public class EntrustPaymentPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Result result;
  private Wallet myWallet;
  private String pin;
  private WalletProvisioning walletProvisioning;
  private WalletManager walletManager;
  private DefaultHceTransactionListener defaultHceTransactionListener;
  private static final String CARD_ENROLL_TAG = "EnrollCard";
  private static final String WALLET_CONNECTION_TAG = "WalletConnection";
  private static final String DIGITAL_CARDS_TAG = "DigitalCards";

  private final Gson gson = new Gson();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "entrust_payment_plugin");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    setSdkConfig();
    try {
      this.walletProvisioning = new WalletProvisioning(context, walletProvisioningCallback);
    } catch (WalletValidationException e) {
      throw new RuntimeException(e);
    }
    try {
      this.walletManager = new WalletManager(context, walletManagerCallback, null);
    } catch (WalletValidationException e) {
      throw new RuntimeException(e);
    }
    this.defaultHceTransactionListener = new DefaultHceTransactionListener();
  }

  private void setSdkConfig() {
    AntelopConfigurationManager.set(new AntelopConfiguration(1254182304490748048L, "demo"));
  }

  private final WalletProvisioningCallback walletProvisioningCallback = new WalletProvisioningCallback() {
    @Override
    public void onProvisioningError(AntelopError p0, Object p1) {
      result.success("PROVISIONING_ERROR");
    }

    @Override
    public void onProvisioningSuccess(Object p0) {
      result.success("PROVISIONING_SUCCESS");
    }

    @Override
    public void onProvisioningPending(Object p0) {
    }

    @Override
    public void onInitializationError(@NonNull AntelopError antelopError, Object p1) {
      result.success("INIT_ERROR");
    }

    @Override
    public void onInitializationSuccess(Object p0) {
      result.success("INIT_SUCCESS");
    }

    @Override
    public void onDeviceEligible(boolean p0, @NonNull java.util.List<Product> products, Object p2) {
    }

    @Override
    public void onDeviceNotEligible(@NonNull EligibilityDenialReason denialReason, Object p1, String p2) {
    }

    @Override
    public void onCheckEligibilityError(@NonNull AntelopError error, Object p1) {
    }
  };

  private final WalletManagerCallback walletManagerCallback = new WalletManagerCallback() {
    @Override
    public void onConnectionError(AntelopError error, Object p1) {
      SampleAppLogger.e(WALLET_CONNECTION_TAG, "Wallet connection failed. " + error.getMessage());
      result.success("ERROR_CONNECT_WALLET");
    }

    @Override
    public void onConnectionSuccess(Wallet wallet, Object p1) {
      myWallet = wallet;
      SampleAppLogger.d(WALLET_CONNECTION_TAG, "Wallet connected successfully");
      SampleAppLogger.d(WALLET_CONNECTION_TAG, "Wallet Data --> " + myWallet.toString());
      result.success("WALLET_CONNECTED");
    }

    @Override
    public void onCredentialsRequired(@NonNull CustomerCredentialsRequiredReason reason, AntelopError p1, Object p2) {
      try {
        onCheckCredentials(reason);
      } catch (WalletValidationException e) {
        throw new RuntimeException(e);
      }
    }

    @Override
    public void onProvisioningRequired(Object p0) {
      result.success("PROVISIONING_REQUIRED");
    }

    @Override
    public void onAsyncRequestSuccess(@NonNull AsyncRequestType requestType, Object p1) {
      System.out.println("onAsyncRequestSuccess");
    }

    @Override
    public void onAsyncRequestError(@NonNull AsyncRequestType requestType,@NonNull AntelopError error, Object p2) {
      System.out.println("onAsyncRequestError");
    }

    @Override
    public void onLocalAuthenticationSuccess(@NonNull CustomerAuthenticationMethodType authenticationMethodType, Object p1) {
    }

    @Override
    public void onLocalAuthenticationError(@NonNull CustomerAuthenticationMethodType authenticationMethodType, LocalAuthenticationErrorReason p1, String p2, Object p3) {
    }
  };

  private final AntelopCallback onCardEnrollCallBack = new AntelopCallback() {
    @Override
    public void onSuccess() {
      SampleAppLogger.d(CARD_ENROLL_TAG, "Card enrollment success");
    }

    @Override
    public void onError(@NonNull AntelopError antelopError) {
      SampleAppLogger.d(CARD_ENROLL_TAG, "Card enrollment failed. " + antelopError.getMessage());
    }
  };

  private void onCheckCredentials(CustomerCredentialsRequiredReason reason) throws WalletValidationException {
    if (reason == CustomerCredentialsRequiredReason.NotSet) {
      CustomerAuthenticationPasscode customerAuthenticationPasscode = new CustomerAuthenticationPasscode(pin.getBytes());
      walletManager.connect(null, customerAuthenticationPasscode);
    } else if (reason == CustomerCredentialsRequiredReason.ValidationNeeded) {
      CustomerAuthenticationPasscode customerAuthenticationPasscode = new CustomerAuthenticationPasscode(pin.getBytes());
      walletManager.connect(customerAuthenticationPasscode, null);
    } else {
      result.success("CREDENTIALS_REQUIRED");
    }
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "initializeWallet":
        initializeWallet();
        break;
      case "provisionWallet":
        provisionWallet();
        break;
      case "connectWalletWithPasscode":
        String passcode = call.argument("passcode");
        if (passcode != null) {
          connectWalletWithPasscode(passcode);
        }
        break;
      case "getWalletInfo":
        getWalletInfo();
        break;
      case "disconnectWallet":
        disconnectWallet();
        break;
      case "clearWallet":
//        clearWallet();
        try {
          getDigitalCard();
        } catch (WalletValidationException e) {
          throw new RuntimeException(e);
        }
        break;
      case "logoutWallet":
        try {
          logoutWallet();
        } catch (WalletValidationException e) {
          throw new RuntimeException(e);
        }
        break;
      case "connectWallet":
//        connectWallet();
        startNfcPayment();
        break;
      case "enrollCard":
        String cardEnrollData = call.argument("cardEnrollData");
        if (cardEnrollData != null) {
          try {
            enrollCard(cardEnrollData);
          } catch (WalletValidationException e) {
            e.printStackTrace();
            SampleAppLogger.e(CARD_ENROLL_TAG, e.getMessage());
          }
        }
        break;
    }
  }

  private void getWalletInfo() {
    WalletInfo walletInfo = new WalletInfo(myWallet.getWalletId(), myWallet.getIssuerClientId(), myWallet.getDefaultCardId());
    String walletData = gson.toJson(walletInfo);
    result.success(walletData);
  }

  private void connectWalletWithPasscode(String pin) {
    try {
      this.pin = pin;
      byte[] passcode = pin.getBytes();
      CustomerAuthenticationPasscode customerAuthenticationPasscode = new CustomerAuthenticationPasscode(passcode);
      walletManager.connect(null, customerAuthenticationPasscode);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  private void startNfcPayment() {
//    Intent serviceIntent = new Intent(context, NfcTransactionService.class);
//    context.startService(serviceIntent);
  }

  private void connectWallet() {
    try {
      walletManager.connect();
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  private void disconnectWallet() {
    walletManager.disconnect();
    result.success("WALLET_DISCONNECTED");
  }

  private void clearWallet() {
    walletManager.clean();
    result.success("CLEANED_WALLET");
  }

  /**
   * Log-out the wallet when we exit from wallet
   * @throws WalletValidationException
   */
  private void logoutWallet() throws WalletValidationException {
    walletManager.logout();
    result.success("LOGOUT_WALLET");
  }

  /**
   * 1. At the first step we need to initialize the wallet
   */
  private void initializeWallet() {
    walletProvisioning.initialize();
  }

  /**
   * 1. At the second step we need to provision the wallet before the the connect
   */
  private void provisionWallet() {
    try {
      walletProvisioning.launch(null, null, "basic", null);
    } catch (WalletValidationException ex) {
      if ("Wallet is already provisioned".equals(ex.getMessage())) {
        result.success("ALREADY_PROVISIONED");
      }
    }
  }

  private void enrollCard(String cardEnrollData) throws WalletValidationException {
    // Enroll card logic
    this.myWallet.enrollDigitalCard(context, "eyJ4NWMiOlsiTUlJQzNqQ0NBY2FnQXdJQkFnSUpBT1FDdnc2Tjh4WFRNQTBHQ1NxR1NJYjNEUUVCQ3dVQU1JR1RNUXN3Q1FZRFZRUUdFd0pHVWpFTU1Bb0dBMVVFQ0F3RFNXUkdNUTR3REFZRFZRUUhEQVZRWVhKcGN6RVFNQTRHQTFVRUNnd0hRVzUwWld4dmNERVFNQTRHQTFVRUN3d0hRVzUwWld4dmNERWpNQ0VHQTFVRUF3d2FRVzUwWld4dmNDQlJkV0ZzYVdZZ1UxTk1JRkpQVDFRZ1EwRXhIVEFiQmdrcWhraUc5dzBCQ1FFV0RtOXdjMEJoYm5SbGJHOXdMbVp5TUI0WERUSXlNREl4TmpFd01qVXpOVm9YRFRJM01ESXhOVEV3TWpVek5Wb3djVEVMTUFrR0ExVUVCaE1DUmxJeERqQU1CZ05WQkFnTUJWQmhjbWx6TVE0d0RBWURWUVFIREFWUVFWSkpVekVaTUJjR0ExVUVDZ3dRUVU1VVJVeFBVQ0JRUVZsTlJVNVVVekVuTUNVR0ExVUVBd3dlVkVWVFZDQkVSVTFQSUVSSlIwbFVRVXdnUTBGU1JDQlFWVk5JSUV0UU1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRU9iSDFrUUpLajRhcnJtWjdlTnhQVFdNWHFGTHFwcE1ESFpZbUVqdFlHQnBrNmlJaFZYWmQ5YWdnSFJkaUxkZlYrZ1ZENnAzZXdrRUNTREpBaDJGODhLTWhNQjh3SFFZRFZSME9CQllFRkhlMGZSZERCL0NVc1l2U1haU3pjYUVSa2hjS01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ3ZzblRQR2VaZlZ6M1hhZWhlY2lmMU9XdEhodlNJTnhwNmpldVJ4UElFREE0OGhWVjlDczd2OUFEazIxcEFpVGdyZWp0SWtPMGxWd1lPcE12QUdQOElqYXVMdk5NeUJ5MWx5T0xUc0puM21oa1NkaFRRN2ZDQXFlTTdQWktGSHd3TEJyQ0ErbGpCTVliMTVuOE5zM0RRS09YKzhjbWRJR2tVRVcwWUkvZDJvbDk5dnMyQk8remJ1MGplUk0vSmJRazl5Y3pCNUFFRDdPUFlLQk54TDJzR0xYQWlIN2cvWnRCM2FlK0VCQ0o0cmo3Vm04Qmd0Y2FOelM1VnJVTHM0eTE2dWUvZnRKRFZMWTFMRWFTdFZsQm9FbnV3dzRjblpXRStvdHNGSWp2VHJuZFhRaHNRejVNTmRmLzlVK2xQVGtnVUNwUFB3NlNURmtUVG9uUG9KWENXIl0sImtpZCI6IjI4NDU3Mjc1NzExODIxMzQ3IiwidHlwIjoiSk9TRSIsImFsZyI6IkVTMjU2In0.ZXlKbGNHc2lPbnNpYTNSNUlqb2lSVU1pTENKamNuWWlPaUpRTFRJMU5pSXNJbmdpT2lKYVNXMU9TR0ZCZUdKRGMxUmpXV2x1YTNaeVVtUmhlR0Y0T0c0eFVtbHNia2x3Y21KQldUaEhjMFk0SWl3aWVTSTZJbXhCVjNSa1h6ZzJNWFpFYWt4eE9GVk9iSGwzYzFZeE4xUkVlRzV5UjBNeFdWWm9NVFJRUm5ScFNqQWlmU3dpYTJsa0lqb2lNamswTmprd05UTTBNVFEwTURFd09USTNOeUlzSW1WdVl5STZJa0V5TlRaSFEwMGlMQ0poYkdjaU9pSkZRMFJJTFVWVEluMC4uaFVET2tCb3ljZWpsQS1jXy41dGc2T2hobUItRFFpMGk3dTk3WVJzQnl2YWIxd0U3ZWtadkNPd0NsM1VrbXpHbnJCQ2F0Vzc4Tm1CM3A0R0NLMlM1eW1WTE5mRGZHaGJ6dHFZTWhQTVJpSjMwM3E5Mm8tZ2g3N0hybDJFVkNDc1hNSTFqUlV3Vzd6dXE2eHdaVE9qelF4d2gwX2U4OUkzT2RRYUo2OWRaWGFQV0paajRvSmRQcFhERDVRZF9RZ21ibTN1OTZ0YXlZTnNPSVJ5TXBFcXZVanhIb1BteDkwTER5RWRoNElGczd4U1JYUGhCbU94VzdFYXZXLWdnRHZxdjB4SzBhRVJnR2hCSEVMa1VoOEhxVVl3dWR5VWJsSFI2OWpXbjMyMjQuaWZhdERKOUhuWFE2VUx6VnY4UzRfZw.Ti9hV58LXFr133R9AiwmPJSRM8043J8X6FevysvpPUkF_s9o6JXxY0MgaPugt3oLp7Ey7CSUtc4mdWREY4fWBA", onCardEnrollCallBack);
  }


  private void getDigitalCard() throws WalletValidationException {
    Map<String, Card> cards = this.myWallet.cards(true);
    SampleAppLogger.d(DIGITAL_CARDS_TAG, cards.toString());
    DigitalCard digitalCard = this.myWallet.getDigitalCard("4937057314420231668");
    if(digitalCard!=null) {
      SampleAppLogger.d(DIGITAL_CARDS_TAG, digitalCard.toString());
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
