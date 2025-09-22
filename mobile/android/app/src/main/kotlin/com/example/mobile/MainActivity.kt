package com.example.mobile

import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // ✅ Installer le SplashScreen pour Android 12+
        val splashScreen = installSplashScreen()

        super.onCreate(savedInstanceState)

        // Optionnel : garder le splash jusqu'à ce que Flutter soit prêt
        splashScreen.setKeepOnScreenCondition {
            false // false = Flutter est prêt, le splash se retire
        }
    }
}
