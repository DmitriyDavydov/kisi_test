package com.example.kisi_test

import KisiDataProvider
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "kisi.test/kisi_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "kisiTapToAccess") {

                val arguments = call.arguments as? Map<String, Any>
                val id = arguments?.get("id") as? Int ?: 0
                val secret = arguments?.get("secret") as? String ?: ""
                val phoneKey = arguments?.get("phoneKey") as? String ?: ""
                val certificate = arguments?.get("certificate") as? String ?: ""

                val kisiDataProvider = KisiDataProvider(applicationContext,id,secret,phoneKey,certificate)
                kisiDataProvider.onCreate()
                result.success(true)
            } else {
                result.notImplemented()
            }
        }

    }
}

