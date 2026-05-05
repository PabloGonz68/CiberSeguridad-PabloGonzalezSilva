##############################################################################
#  android/app/proguard-rules.pro
#
#  Reglas ProGuard / R8 para builds de RELEASE
#
#  SEGURIDAD (MASVS-RESILIENCE-3 / M7 — Insufficient Binary Protections):
#  ─ R8 ofusca nombres de clases, métodos y campos.
#  ─ Combinado con el flag --obfuscate de Flutter, dificulta la ingeniería
#    inversa con herramientas como jadx, apktool o Ghidra.
#  ─ También reduce el tamaño del APK.
#
#  ACTIVAR en android/app/build.gradle:
#    buildTypes {
#      release {
#        minifyEnabled true
#        shrinkResources true
#        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
#      }
#    }
#
#  BUILD con ofuscación Flutter:
#    flutter build apk --release --obfuscate --split-debug-info=./debug-info/
#    flutter build appbundle --release --obfuscate --split-debug-info=./debug-info/
#
#  GUARDAR los archivos de debug-info/ para poder simbolizar stack traces
#  en producción con: flutter symbolize -i <stack_trace> -d debug-info/
##############################################################################

# ── Flutter Engine ────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ── Android Keystore (para flutter_secure_storage) ────────────────
-keep class androidx.security.crypto.** { *; }

# ── freeRASP (Talsec) — no ofuscar las clases de detección ────────
-keep class com.aheaditec.talsec_security.** { *; }
-dontwarn com.aheaditec.talsec_security.**

# ── Gson / JSON serialization ─────────────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# ── Dio / OkHttp ──────────────────────────────────────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ── Eliminar logs en release ──────────────────────────────────────
# Elimina llamadas a android.util.Log para evitar fugas de información
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
}
