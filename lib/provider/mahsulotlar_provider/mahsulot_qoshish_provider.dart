import 'package:flutter/material.dart';

class BuyurtmaHolatProvider extends ChangeNotifier {
  String tayyorlashText = "Tayyorlash";
  String sotishText = "Sotish";

  bool tayyorlanmoqda = false;
  bool tayyor = false;
  bool sotilmoqda = false;

  void tayyorlashBoshlash() {
    tayyorlanmoqda = true;
    tayyorlashText = "Tayyorlanmoqda";
    notifyListeners();
  }

  void tayyorBoldi() {
    tayyor = true;
    tayyorlashText = "Tayyor";
    notifyListeners();
  }

  void sotishBoshlash() {
    sotilmoqda = true;
    sotishText = "Sotilmoqda";
    notifyListeners();
  }

  void sotildi() {
    sotishText = "Sotildi";
    notifyListeners();
  }
}
