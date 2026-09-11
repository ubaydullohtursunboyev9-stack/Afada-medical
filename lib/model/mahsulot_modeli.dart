class MahsulotModel {
  int? id;
  String nomi;
  String bemorNarxi;
  String shifokorNarxi;
  String kategoriya;
  String keshbek;
  String status;
  String? rasm;
  int zaxira;

  MahsulotModel({
    this.id,
    required this.nomi,
    required this.bemorNarxi,
    required this.shifokorNarxi,
    required this.kategoriya,
    required this.keshbek,
    required this.status,
    this.rasm,
    this.zaxira = 0,
  });

  factory MahsulotModel.fromJson(Map<String, dynamic> json) {
    return MahsulotModel(
      id: json['id'],
      nomi: json['name'] ?? '',
      bemorNarxi: json['price_client']?.toString() ?? '0',
      shifokorNarxi: json['price_doctor']?.toString() ?? '0',
      kategoriya: (json['category'] is Map) ? (json['category']['name'] ?? 'Umumiy') : 'Umumiy',
      keshbek: json['cashback']?.toString() ?? '0',
      status: json['status'] ?? 'Faol',
      rasm: json['picture'],
      zaxira: json['stock'] ?? 0,
    );
  }
}

class ZaxiraTarixiModel {
  final String ishchiNomi;
  final String mahsulotNomi;
  final int miqdor;
  final DateTime sana;

  ZaxiraTarixiModel({
    required this.ishchiNomi,
    required this.mahsulotNomi,
    required this.miqdor,
    required this.sana,
  });
}
