import 'mahsulot_modeli.dart';
import 'mijoz_modeli.dart';

class BuyurtmaModel {
  final MahsulotModel mahsulot;
  final int soni;
  final String sana;
  final String izoh;
  final MijozModel mijoz;
  final bool tolanmagan;
  String holat; // 'Tayyorlash', 'Tayyorlanmoqda', 'Tayyor', 'Sotilmoqda', 'Sotildi', 'Bekor qilindi'

  BuyurtmaModel({
    required this.mahsulot,
    required this.soni,
    required this.sana,
    required this.izoh,
    required this.mijoz,
    required this.tolanmagan,
    this.holat = 'Tayyorlash',
  });
}

class BuyurtmaDatabase {
  static List<BuyurtmaModel> buyurtmalar = [];

  static void qoshish(BuyurtmaModel buyurtma) {
    buyurtmalar.add(buyurtma);
  }

  static void ochirish(int index) {
    buyurtmalar.removeAt(index);
  }

  static void tahrirlash(int index, BuyurtmaModel buyurtma) {
    buyurtmalar[index] = buyurtma;
  }
}
