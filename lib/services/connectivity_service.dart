import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late StreamSubscription<InternetStatus> _internetSubscription;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    // Initial check
    _isConnected = await InternetConnection().hasInternetAccess;
    notifyListeners();

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) async {
      await _checkStatus();
    });

    // Listen to actual internet status
    _internetSubscription = InternetConnection().onStatusChange.listen((status) {
      bool newStatus = status == InternetStatus.connected;
      if (_isConnected != newStatus) {
        _isConnected = newStatus;
        notifyListeners();
      }
    });
  }

  Future<void> _checkStatus() async {
    bool hasAccess = await InternetConnection().hasInternetAccess;
    if (_isConnected != hasAccess) {
      _isConnected = hasAccess;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _internetSubscription.cancel();
    super.dispose();
  }
}
