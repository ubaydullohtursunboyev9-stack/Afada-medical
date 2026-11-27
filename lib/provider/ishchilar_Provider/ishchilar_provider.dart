import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/ishchi_modeli.dart';
import '../../services/image_picker_service.dart';
import '../../service/api_service.dart';
import 'package:afada/utils/error_utils.dart';

class IshchiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  final TextEditingController ismController = TextEditingController();
  final TextEditingController familyaController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController parolController = TextEditingController();

  List<IshchiModel> ishchilar = [];
  bool isLoading = false;
  String? error;

  File? imageFile;
  String lavozim = "Lavozim";
  String kasb = "Kasbi";
  int? tahrirlashId;
  int? tahrirlashIndex;

  void lavozimTanlash(String value) {
    lavozim = value;
    notifyListeners();
  }

  void kasbTanlash(String value) {
    kasb = value;
    notifyListeners();
  }

  void tanlash(String value) {
    lavozim = value;
    notifyListeners();
  }

  Future<void> rasmTanlash(
      BuildContext context,
      ImageSource source,
      ) async {
    final path = await ImagePickerService.pickImage(
      context,
      source,
    );

    if (path != null) {
      imageFile = File(path);
      notifyListeners();
    }
  }

  bool tekshirAsosiy() {
    return ismController.text.isNotEmpty &&
        familyaController.text.isNotEmpty &&
        telefonController.text.isNotEmpty &&
        lavozim != "Lavozim" &&
        kasb != "Kasbi";
  }

  bool tekshirLogin() {
    return loginController.text.isNotEmpty &&
        parolController.text.isNotEmpty;
  }

  bool tekshir() {
    if (!tekshirAsosiy()) return false;

    if (lavozim == "Ishchi") {
      return true;
    }

    return true;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // ============================================================
  // TELEFONNI API UCHUN TO'G'RI FORMATGA KELTIRISH
  // Natija doim:
  // +998901234567
  // ============================================================
  String _normalizePhone(String phone) {
    // Faqat raqamlarni qoldiramiz
    String value = phone.replaceAll(RegExp(r'\D'), '');

    // Agar +998 yoki 998 bilan kelgan bo'lsa,
    // 998 qismini olib tashlaymiz.
    if (value.startsWith('998')) {
      value = value.substring(3);
    }

    // Agar 0 bilan boshlangan bo'lsa:
    // 90 123 45 67 -> 901234567
    if (value.startsWith('0')) {
      value = value.substring(1);
    }

    // API uchun faqat BITTA +998
    return '+998$value';
  }

  Future<void> fetchIshchilar() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception("Token topilmadi");
      }

      final data = await _apiService.getUsers(token);

      ishchilar = data
          .map((e) => IshchiModel.fromJson(e))
          .toList();

      IshchiDatabase.ishchilar = List.from(ishchilar);
    } catch (e) {
      error = getFriendlyErrorMessage(e.toString());

      await IshchiDatabase.loadIshchilar();

      ishchilar = List.from(
        IshchiDatabase.ishchilar,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> qoshish() async {
    if (!tekshirAsosiy()) {
      return false;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception("Token topilmadi");
      }

      // ========================================================
      // ENG MUHIM QISM
      //
      // UI:
      // 90 123 45 67
      //
      // API:
      // +998901234567
      //
      // Bu yerda +998 hech qachon ikki marta yozilmaydi.
      // ========================================================
      final String apiPhone =
      _normalizePhone(telefonController.text);

      final userData = {
        "fullName":
        "${familyaController.text.trim()} ${ismController.text.trim()}",
        "phone_number": apiPhone,
        "role": IshchiModel.mapRoleToApi(lavozim),
      };

      if (tahrirlashId != null) {
        await _apiService.updateUser(
          token: token,
          id: tahrirlashId!,
          userData: userData,
        );
      } else {
        await _apiService.addUser(
          token: token,
          userData: userData,
        );
      }

      await fetchIshchilar();

      tozalash();

      return true;
    } catch (e) {
      error = getFriendlyErrorMessage(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> ochirish(int index) async {
    final ishchi = ishchilar[index];

    if (ishchi.id == null) {
      IshchiDatabase.ochirish(index);

      ishchilar.removeAt(index);

      notifyListeners();

      return true;
    }

    isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception("Token topilmadi");
      }

      await _apiService.deleteUser(
        token,
        ishchi.id!,
      );

      await fetchIshchilar();

      return true;
    } catch (e) {
      error = getFriendlyErrorMessage(e.toString());

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void tahrirlashUchunYuklash(int index) {
    tahrirlashIndex = index;

    final ishchi = ishchilar[index];

    tahrirlashId = ishchi.id;

    ismController.text = ishchi.ism;
    familyaController.text = ishchi.familya;

    // ========================================================
    // API dan kelgan telefon:
    //
    // +998901234567
    // ++998901234567
    // 998901234567
    // 90 123 45 67
    //
    // Qanday bo'lishidan qat'i nazar UI ga:
    //
    // 901234567
    //
    // qilib beramiz.
    // ========================================================
    String rawPhone = ishchi.telefon.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (rawPhone.startsWith('998')) {
      rawPhone = rawPhone.substring(3);
    }

    if (rawPhone.startsWith('0')) {
      rawPhone = rawPhone.substring(1);
    }

    telefonController.text = rawPhone;

    lavozim = ishchi.lavozim;
    kasb = ishchi.kasb;

    loginController.text = ishchi.login ?? "";
    parolController.text = ishchi.parol ?? "";

    if (ishchi.rasm != null &&
        ishchi.rasm!.isNotEmpty &&
        !ishchi.rasm!.startsWith('http')) {
      imageFile = File(ishchi.rasm!);
    }

    notifyListeners();
  }

  void tozalash() {
    ismController.clear();
    familyaController.clear();
    telefonController.clear();
    loginController.clear();
    parolController.clear();

    imageFile = null;

    lavozim = "Lavozim";
    kasb = "Kasbi";

    tahrirlashId = null;
    tahrirlashIndex = null;

    notifyListeners();
  }

  @override
  void dispose() {
    ismController.dispose();
    familyaController.dispose();
    telefonController.dispose();
    loginController.dispose();
    parolController.dispose();

    super.dispose();
  }
}

class KasbProvider extends ChangeNotifier {
  String Kasb = "Kasbi";

  void tanlash(String value) {
    Kasb = value;
    notifyListeners();
  }
}

class DavrProvider extends ChangeNotifier {
  String davr = "Umumiy";
  bool menuOpen = false;

  void menuOchYop() {
    menuOpen = !menuOpen;
    notifyListeners();
  }

  void menuYop() {
    menuOpen = false;
    notifyListeners();
  }

  void tanlash(String value) {
    davr = value;
    notifyListeners();
  }
}