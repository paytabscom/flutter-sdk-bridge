import java.util.Properties
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val keystorePropertiesFile = File("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        load(keystorePropertiesFile.reader())
    }
}
android {
    namespace = "com.paytabs.flutter_payment_sdk_bridge_example"
    compileSdk = 36
    val appVersionCode = (System.getenv()["NEW_BUILD_NUMBER"] ?: "1")?.toInt()
    val appVersionName = (System.getenv()["VERSION_NAME"] ?: "1.0.0")?.toString()
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        jvmToolchain(17)
    }

    defaultConfig {
        applicationId = "com.paytabs.flutter_payment_sdk_bridge_example"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = appVersionCode
        versionName = appVersionName
    }
    signingConfigs {
        create("release") {
            val isCI = System.getenv()["CI"]?.toBoolean() == true
            if (isCI) { // CI=true is exported by Codemagic
                val keystorePath = System.getenv()["CM_KEYSTORE_PATH"]
                val keystorePassword = System.getenv()["CM_KEYSTORE_PASSWORD"]
                val keyAliasEnv = System.getenv()["CM_KEY_ALIAS"]
                val keyPasswordEnv = System.getenv()["CM_KEY_PASSWORD"]
                
                if (keystorePath != null && keystorePassword != null && 
                    keyAliasEnv != null && keyPasswordEnv != null) {
                    storeFile = file(keystorePath)
                    storePassword = keystorePassword
                    keyAlias = keyAliasEnv
                    keyPassword = keyPasswordEnv
                }
            } else if (keystorePropertiesFile.exists()) {
                val storeFileProp = keystoreProperties.getProperty("storeFile")
                val storePasswordProp = keystoreProperties.getProperty("storePassword")
                val keyAliasProp = keystoreProperties.getProperty("keyAlias")
                val keyPasswordProp = keystoreProperties.getProperty("keyPassword")
                
                if (storeFileProp != null && storePasswordProp != null && 
                    keyAliasProp != null && keyPasswordProp != null) {
                    storeFile = file(storeFileProp)
                    storePassword = storePasswordProp
                    keyAlias = keyAliasProp
                    keyPassword = keyPasswordProp
                }
            }
        }
    }

    buildTypes {
        release {
            val releaseSigningConfig = signingConfigs.findByName("release")
            if (releaseSigningConfig != null && releaseSigningConfig.storeFile != null) {
                signingConfig = releaseSigningConfig
            }
        }
    }
}

flutter {
    source = "../.."
}
