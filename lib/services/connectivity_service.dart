import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    // Initial check
    try {
      final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
      _updateStatus(results);
    } catch (e) {
      debugPrint("Error checking connectivity: $e");
    }

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateStatus(results);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // Agar ro'yxatda none bo'lsa yoki ro'yxat bo'sh bo'lsa, internet yo'q deb hisoblaymiz
    bool status = false;
    if (results.isNotEmpty) {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.vpn)) {
        status = true;
      }
    }
    
    if (_isConnected != status) {
      _isConnected = status;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
