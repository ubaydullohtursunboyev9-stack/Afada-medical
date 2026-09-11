import 'package:flutter/material.dart';
import 'dart:io';


class ProviderFlotingbottom extends ChangeNotifier {

  bool mahsulotQoshishCard = false;

  void qoshish() {
    mahsulotQoshishCard = !mahsulotQoshishCard;
    notifyListeners();
  }

}

File? imageFile;

class BekorqilishProvider extends ChangeNotifier {

  TextEditingController mahsulotController =
  TextEditingController();

  TextEditingController sanaController =
  TextEditingController();

  TextEditingController telefonController =
  TextEditingController();

  File? imageFile;

  bool tekshir() {

    if (mahsulotController.text.trim().isEmpty) {
      return false;
    }

    if (sanaController.text.trim().isEmpty) {
      return false;
    }

    if (telefonController.text.trim().isEmpty) {
      return false;
    }

    if (imageFile == null) {
      return false;
    }

    return true;
  }

  void bekorQilish() {
    mahsulotController.clear();
    sanaController.clear();
    telefonController.clear();

    imageFile = null;

    notifyListeners();
  }
}

class MijoztanlashProvider extends ChangeNotifier {

  String mijozTuri = "Mijoz";

  void tanlash(String value) {
    mijozTuri = value;
    notifyListeners();
  }
}

class TolovProvider extends ChangeNotifier {

  String holat = "To'lanmagan";

  void tanlash(String value) {
    holat = value;
    notifyListeners();
  }
}