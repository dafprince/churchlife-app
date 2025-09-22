plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mobile"

    // ⚠️ Mise à jour pour compatibilité avec AndroidX récentes
    compileSdk = 35

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.mobile"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Remplacer par ton keystore pour vrai release

            // Minification et suppression des ressources inutilisées
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // ⚠️ Activation du support SplashScreen pour Android 12+
    buildFeatures {
        viewBinding = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core Android extensions
    implementation("androidx.core:core-ktx:1.12.0") 
    // Support AppCompat
    implementation("androidx.appcompat:appcompat:1.7.0") 
    // SplashScreen API (Android 12+)
    implementation("androidx.core:core-splashscreen:1.0.1") 
    // MaterialComponents pour les thèmes Material
    implementation("com.google.android.material:material:1.12.0")
}
