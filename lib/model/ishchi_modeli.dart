import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class IshchiModel {
  final int? id;
  final String ism;
  final String familya;
  final String telefon;
  final String lavozim;
  final String kasb;
  final String? rasm;
  final String? login;
  final String? parol;
  final String? telegramChatId;

  IshchiModel({
    this.id,
    required this.ism,
    required this.familya,
    required this.telefon,
    required this.lavozim,
    required this.kasb,
    this.rasm,
    this.login,
    this.parol,
    this.telegramChatId,
  });

  Map<String, dynamic> toJson() {
    return {
      'ism': ism,
      'familya': familya,
      'telefon': telefon,
      'lavozim': lavozim,
      'kasb': kasb,
      'rasm': rasm,
      'login': login,
      'parol': parol,
    };
  }

  factory IshchiModel.fromJson(Map<String, dynamic> json) {
    // API field mapping
    String fullName = json['fullName'] ?? "";
    String firstName = "";
    String lastName = "";

    if (fullName.isNotEmpty) {
      List<String> parts = fullName.split(' ');
      if (parts.length > 1) {
        lastName = parts[0];
        firstName = parts.sublist(1).join(' ');
      } else {
        firstName = parts[0];
      }
    }

    // Role mapping
    String role = json['role'] ?? "worker";
    String lavozim = "Ishchi";
    if (role == "admin") {
      lavozim = "Admin";
    } else if (role == "seller") {
      lavozim = "Sotuvchi";
    }

    return IshchiModel(
      id: json['id'],
      ism: json['ism'] ?? firstName,
      familya: json['familya'] ?? lastName,
      telefon: json['phone_number'] ?? json['telefon'] ?? "",
      lavozim: json['lavozim'] ?? lavozim,
      kasb: json['kasb'] ?? "Texnik xodim", // Default for UI if not present
      rasm: json['picture'] ?? json['rasm'],
      login: json['login'],
      parol: json['parol'],
      telegramChatId: json['telegram_chat_id']?.toString(),
    );
  }

  static String mapRoleToApi(String lavozim) {
    switch (lavozim) {
      case "Admin":
        return "admin";
      case "Sotuvchi":
        return "seller";
      default:
        return "worker";
    }
  }
}

class IshchiDatabase {
  static List<IshchiModel> ishchilar = [];
  static const String _storageKey = 'ishchilar_data';

  static Future<void> loadIshchilar() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      ishchilar = decoded.map((e) => IshchiModel.fromJson(e)).toList();
    }
  }

  static Future<void> _saveIshchilar() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(ishchilar.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  static void qoshish(IshchiModel ishchi) {
    ishchilar.add(ishchi);
    _saveIshchilar();
  }

  static void ochirish(int index) {
    ishchilar.removeAt(index);
    _saveIshchilar();
  }

  static void tahrirlash(int index, IshchiModel ishchi) {
    ishchilar[index] = ishchi;
    _saveIshchilar();
  }
}
