import 'package:flutter/material.dart';
import '../model/qarz_model.dart';

class QarzProvider extends ChangeNotifier {
  final List<QarzdorModel> _qarzdorlar = [];

  List<QarzdorModel> get qarzdorlar => List.unmodifiable(_qarzdorlar);

  double get jamiQarz {
    return _qarzdorlar.fold(0.0, (sum, q) => sum + q.qarzSummasi);
  }

  int get qarzdorlarSoni {
    return _qarzdorlar.where((q) => q.qarzSummasi > 0).length;
  }

  void qarzQoshish(QarzAmaliyotModel amaliyot) {
    int index = _qarzdorlar.indexWhere((q) => 
      q.mijozIsmi.trim().toLowerCase() == amaliyot.mijozIsmi.trim().toLowerCase() &&
      q.telefon.trim() == amaliyot.telefon.trim()
    );

    if (index != -1) {
      _qarzdorlar[index].amaliyotlar.insert(0, amaliyot);
      if (amaliyot.turi == "Qarz oldi") {
        _qarzdorlar[index].qarzSummasi += amaliyot.summa;
      } else {
        _qarzdorlar[index].qarzSummasi -= amaliyot.summa;
        if (_qarzdorlar[index].qarzSummasi < 0) {
          _qarzdorlar[index].qarzSummasi = 0;
        }
      }
    } else {
      double boshlangichQarz = 0;
      if (amaliyot.turi == "Qarz oldi") {
        boshlangichQarz = amaliyot.summa;
      }
      _qarzdorlar.add(QarzdorModel(
        mijozIsmi: amaliyot.mijozIsmi,
        telefon: amaliyot.telefon,
        qarzSummasi: boshlangichQarz,
        amaliyotlar: [amaliyot],
      ));
    }
    notifyListeners();
  }
}
