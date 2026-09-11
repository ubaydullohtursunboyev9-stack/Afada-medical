class QarzAmaliyotModel {
  final String id;
  final String mijozIsmi;
  final String telefon;
  final String izoh;
  final String turi; // "Qarz oldi" yoki "Qarz to'ladi"
  final double summa;
  final DateTime sana;

  QarzAmaliyotModel({
    required this.id,
    required this.mijozIsmi,
    required this.telefon,
    this.izoh = "",
    required this.turi,
    required this.summa,
    required this.sana,
  });
}

class QarzdorModel {
  final String mijozIsmi;
  final String telefon;
  double qarzSummasi;
  final List<QarzAmaliyotModel> amaliyotlar;

  QarzdorModel({
    required this.mijozIsmi,
    required this.telefon,
    this.qarzSummasi = 0.0,
    required this.amaliyotlar,
  });
}
