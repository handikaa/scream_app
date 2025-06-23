# Flutter/Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep MainActivity and other entry points
-keep class com.yourpackage.** { *; }

# Gson or serialization (if used)
-keep class * implements java.io.Serializable
-keepattributes Signature
-keepattributes *Annotation*
