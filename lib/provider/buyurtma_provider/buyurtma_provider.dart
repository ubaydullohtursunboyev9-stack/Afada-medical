import 'package:flutter/material.dart';
import '../../model/buyurtma_modeli.dart';
import '../../model/mahsulot_modeli.dart';
import '../../model/mijoz_modeli.dart';

class BuyurtmaProvider extends ChangeNotifier {
  MahsulotModel? tanlanganMahsulot;
  MijozModel? tanlanganMijoz;
  final TextEditingController soniController = TextEditingController();
  final TextEditingController izohController = TextEditingController();
  final TextEditingController sanaController = TextEditingController();
  bool tolanmagan = false;

  void qoshish() {
    if (tanlanganMahsulot != null && tanlanganMijoz != null) {
      final sana = sanaController.text.isEmpty 
          ? DateTime.now().toString().substring(0, 10) 
          : sanaController.text;
          
      BuyurtmaDatabase.qoshish(BuyurtmaModel(
        mahsulot: tanlanganMahsulot!,
        soni: int.tryParse(soniController.text) ?? 1,
        sana: sana,
        izoh: izohController.text,
        mijoz: tanlanganMijoz!,
        tolanmagan: tolanmagan,
      ));
      tozalash();
      notifyListeners();
    }
  }

  void holatniOzgartirish(int index, String yangiHolat) {
    BuyurtmaDatabase.buyurtmalar[index].holat = yangiHolat;
    notifyListeners();
  }

  void ochirish(int index) {
    BuyurtmaDatabase.ochirish(index);
    notifyListeners();
  }

  void tozalash() {
    tanlanganMahsulot = null;
    tanlanganMijoz = null;
    soniController.clear();
    izohController.clear();
    sanaController.clear();
    tolanmagan = false;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
