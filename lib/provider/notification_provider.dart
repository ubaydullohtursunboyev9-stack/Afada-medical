import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  static const String _notificationKey = "isNotificationEnabled";
  bool _isNotificationEnabled = true;

  bool get isNotificationEnabled => _isNotificationEnabled;

  NotificationProvider() {
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool(_notificationKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleNotification(bool value) async {
    _isNotificationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, _isNotificationEnabled);
    notifyListeners();
  }
}
