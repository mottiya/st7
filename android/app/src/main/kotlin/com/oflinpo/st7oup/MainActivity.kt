package com.oflinpo.st7oup;

import androidx.annotation.NonNull
import com.oflinpo.st7oup.components.CustomNativeAdFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class MainActivity : FlutterActivity() {
    private val channel = "channel"
    private var registeredFactories = mutableListOf<String>()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)

        val factory = CustomNativeAdFactory(layoutInflater)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "registerFactory" -> {
                    val adId = call.arguments as String
                    if (registeredFactories.contains(adId)) result.success(true)
                    GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, adId, factory)
                    registeredFactories.add(adId)
                    result.success(true)
                }
                "isFactoryRegistered" -> {
                    val adId = call.arguments as String
                    result.success(registeredFactories.contains(adId))
                }
                else -> result.notImplemented()
            }
        }

    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        registeredFactories.forEach {
            GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, it)
        }
        super.cleanUpFlutterEngine(flutterEngine)
    }


}