package com.agribusiness.daily_food_price

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge display for Android 15 (SDK 35) and above
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
