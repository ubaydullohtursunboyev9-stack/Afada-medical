import 'mahsulot_modeli.dart';

class MahsulotDatabase {
  static List<MahsulotModel> mahsulotlar = [];

  static void qoshish(MahsulotModel mahsulot) {
    mahsulotlar.add(mahsulot);
  }

  static void ochirish(int index) {
    mahsulotlar.removeAt(index);
  }

  static void tahrirlash(int index, MahsulotModel mahsulot) {
    mahsulotlar[index] = mahsulot;
  }
}