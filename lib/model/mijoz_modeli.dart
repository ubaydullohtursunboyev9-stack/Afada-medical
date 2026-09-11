class MijozModel {
  final int? id;
  final String ism;
  final String familya;
  final String telefon;
  final String ishJoyi;
  final String? rasm;
  final String mijozTuri;
  final String status;

  MijozModel({
    this.id,
    required this.ism,
    this.familya = "",
    required this.telefon,
    required this.ishJoyi,
    this.rasm,
    this.mijozTuri = "Jismoniy",
    this.status = "Faol",
  });

  factory MijozModel.fromJson(Map<String, dynamic> json) {
    String fullName = json['name'] ?? "";
    List<String> parts = fullName.split(' ');
    String ism = parts.isNotEmpty ? parts[0] : "";
    String familya = parts.length > 1 ? parts.sublist(1).join(' ') : "";

    // Mapping API type to UI mijozTuri
    // shifokor -> Korporativ, bemor -> Jismoniy
    String mijozTuri = "Jismoniy";
    if (json['type'] == 'shifokor') {
      mijozTuri = "Korporativ";
    }

    // Phone cleanup: API might return +998901234567, UI expects 90 123 45 67
    String phone = json['phone'] ?? "";
    if (phone.startsWith('+998')) {
      phone = phone.substring(4);
    }
    // Add spaces for UI format: "90 123 45 67"
    if (phone.length == 9) {
      phone = "${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5, 7)} ${phone.substring(7, 9)}";
    }

    return MijozModel(
      id: json['id'],
      ism: ism,
      familya: familya,
      telefon: phone,
      ishJoyi: json['address'] ?? "",
      mijozTuri: mijozTuri,
      status: json['status'] ?? "Faol",
      rasm: null, // API does not support images for clients yet
    );
  }

  Map<String, dynamic> toJson() {
    // Mapping UI mijozTuri to API type
    String type = mijozTuri == "Korporativ" ? "shifokor" : "bemor";
    
    // Phone formatting: 90 123 45 67 -> +998901234567
    String cleanPhone = telefon.replaceAll(' ', '');
    if (!cleanPhone.startsWith('+')) {
      cleanPhone = "+998$cleanPhone";
    }

    return {
      "name": "$ism $familya".trim(),
      "type": type,
      "phone": cleanPhone,
      "address": ishJoyi,
      "status": status,
    };
  }

  MijozModel copyWith({
    int? id,
    String? ism,
    String? familya,
    String? telefon,
    String? ishJoyi,
    String? rasm,
    String? mijozTuri,
    String? status,
  }) {
    return MijozModel(
      id: id ?? this.id,
      ism: ism ?? this.ism,
      familya: familya ?? this.familya,
      telefon: telefon ?? this.telefon,
      ishJoyi: ishJoyi ?? this.ishJoyi,
      rasm: rasm ?? this.rasm,
      mijozTuri: mijozTuri ?? this.mijozTuri,
      status: status ?? this.status,
    );
  }
}


