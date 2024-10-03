package com.example.entrust_payment_plugin.services;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.entrust_payment_plugin.SampleAppLogger;

import java.util.Date;
import java.util.List;
import java.util.Map;

import fr.antelop.sdk.AntelopError;
import fr.antelop.sdk.authentication.CustomerAuthenticationMethod;
import fr.antelop.sdk.transaction.TransactionDecision;
import fr.antelop.sdk.transaction.hce.DefaultHceTransactionListener;
import fr.antelop.sdk.transaction.hce.HceTransaction;
import fr.antelop.sdk.transaction.hce.HceTransactionStep;

public class NfcTransactionListener extends DefaultHceTransactionListener {

    private static final String NFC_TRANSACTION_TAG = "NfcTransaction";

    public NfcTransactionListener() {
        super();
    }

    @Override
    public void onTransactionStart(@NonNull Context context) {
        SampleAppLogger.d(NFC_TRANSACTION_TAG, "Nfc Transaction has been started.");
        super.onTransactionStart(context);
    }

    @Override
    public void onTransactionDone(@NonNull Context context, @NonNull HceTransaction hceTransaction) {
        super.onTransactionDone(context, hceTransaction);
    }

    @Override
    public void onCredentialsRequired(@NonNull Context context, @NonNull List<CustomerAuthenticationMethod> list, @NonNull HceTransaction hceTransaction) {
        super.onCredentialsRequired(context, list, hceTransaction);
    }

    @Override
    public void onTransactionError(@NonNull Context context, @NonNull AntelopError antelopError) {
        super.onTransactionError(context, antelopError);
    }

    @Override
    public void onTransactionProgress(@NonNull Context context, @NonNull HceTransactionStep hceTransactionStep) {
        super.onTransactionProgress(context, hceTransactionStep);
    }

    @Nullable
    @Override
    public TransactionDecision onTransactionFinalization(@NonNull Context context, @Nullable CustomerAuthenticationMethod customerAuthenticationMethod, @Nullable Date date, @NonNull HceTransaction hceTransaction) {
        return super.onTransactionFinalization(context, customerAuthenticationMethod, date, hceTransaction);
    }

    @Override
    public void onTransactionsUpdated(@NonNull Context context, @NonNull Map<String, HceTransaction> map) {
        super.onTransactionsUpdated(context, map);
    }
}
