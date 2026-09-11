import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../widgets/in_app_notification_banner.dart';

class NotificationService {
  static const String _notificationKey = "isNotificationEnabled";

  static Future<void> init() async {
    // No initialization needed for in-app notifications
  }

  static Future<bool> _isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey) ?? true;
  }

  static Future<void> showNotification(
    BuildContext context, {
    required String title,
    required String body,
  }) async {
    if (!await _isNotificationEnabled()) return;

    // Vibrate
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }

    if (!context.mounted) return;

    // Show Overlay
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => InAppNotificationBanner(
        title: title,
        message: body,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlayState.insert(overlayEntry);
  }
}
