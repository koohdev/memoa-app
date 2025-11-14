# Flutter-specific additions to ProGuard rules.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }
-keep class com.google.firebase.** {
    *;
}
-keep class com.google.android.gms.** {
    *;
}
-keep class com.google.android.play.core.** {
    *;
}
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.play.core.**
