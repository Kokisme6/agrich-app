plugins {
    id("com.android.application")
    id("kotlin-android")

   
    id("dev.flutter.flutter-gradle-plugin")

    
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.agriwealth"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.agriwealth"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

      
        manifestPlaceholders.put("appId", "YOUR_FACEBOOK_APP_ID")
        manifestPlaceholders.put("appName", "AgriWealth")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
  
    implementation("com.google.android.gms:play-services-auth:21.0.0")

    implementation("com.google.firebase:firebase-auth-ktx:22.3.1")

    implementation("com.facebook.android:facebook-android-sdk:16.0.1")
}
