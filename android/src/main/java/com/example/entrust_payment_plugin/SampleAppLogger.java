package com.example.entrust_payment_plugin;

import android.util.Log;

import androidx.annotation.Nullable;

public final class SampleAppLogger {
    private static final String MAIN_TAG = "Antelop-SampleApp";

    public static void d(String tag, @Nullable String msg) {
        Log.d(MAIN_TAG, "[" + tag + "] - " + (msg == null ? "null" : msg));
    }

    public static void e(String tag, @Nullable String msg) {
        Log.e(MAIN_TAG, "[" + tag + "] - " + (msg == null ? "null" : msg));
    }

    public static void e(String tag, @Nullable String msg, Throwable throwable) {
        Log.e(MAIN_TAG, "[" + tag + "] - " + (msg == null ? "null" : msg), throwable);
    }

}
