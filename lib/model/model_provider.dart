import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'mahsulot_databasa.dart';
import 'mahsulot_modeli.dart';
import '../services/image_picker_service.dart';
import '../service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahsulotProvider extends ChangeNotifier {
  final TextEditingController mahsulotController = TextEditingController();
  final TextEditingController bemorNarxController = TextEditingController();
  final TextEditingController shifokorNarxController = TextEditingController();
  final TextEditingController keshbekController = TextEditingController();

  String selectedKategoriya = "Umumiy";
  String selectedStatus = "Faol";

  File? imageFile;
  int? tahrirlashIndex;
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  List<MahsulotModel> get mahsulotlar => MahsulotDatabase.mahsulotlar;
  final List<ZaxiraTarixiModel> zaxiraTarixi = [];

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        final data = await _apiService.getProducts(token);
        MahsulotDatabase.mahsulotlar = data.map((e) {
          final m = MahsulotModel.fromJson(e);
          m.zaxira = 0;
          return m;
        }).toList();
      }
    } catch (e) {
      debugPrint("Load Products Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setKategoriya(String val) {
    selectedKategoriya = val;
    notifyListeners();
  }

  void setStatus(String val) {
    selectedStatus = val;
    notifyListeners();
  }

  Future<void> rasmTanlash(BuildContext context, ImageSource source) async {
    final path = await ImagePickerService.pickImage(context, source);
    if (path != null) {
      imageFile = File(path);
      notifyListeners();
    }
  }

  Future<void> qoshish(MahsulotModel mahsulot) async {
    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        final cleanBemor = double.tryParse(mahsulot.bemorNarxi.replaceAll(RegExp(r'\D'), '')) ?? 0.0;
        final cleanShifokor = double.tryParse(mahsulot.shifokorNarxi.replaceAll(RegExp(r'\D'), '')) ?? 0.0;
        final cleanKeshbek = double.tryParse(mahsulot.keshbek.replaceAll(RegExp(r'\D'), '')) ?? 0.0;

        await _apiService.addProduct(
          token: token,
          name: mahsulot.nomi,
          priceClient: cleanBemor,
          priceDoctor: cleanShifokor,
          cashback: cleanKeshbek,
          status: mahsulot.status,
          filePath: imageFile?.path,
        );
        await loadProducts();
      }
    } catch (e) {
      debugPrint("Add Product Error: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ochirish(int index) async {
    final mahsulot = mahsulotlar[index];
    if (mahsulot.id == null) {
      MahsulotDatabase.ochirish(index);
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        await _apiService.deleteProduct(token, mahsulot.id!);
        await loadProducts();
      }
    } catch (e) {
      debugPrint("Delete Product Error: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tahrirlash(int index, MahsulotModel mahsulot) async {
    if (mahsulot.id == null) {
      throw Exception('Mahsulot ID topilmadi');
    }

    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        final cleanBemor = double.tryParse(mahsulot.bemorNarxi.replaceAll(RegExp(r'\D'), '')) ?? 0.0;
        final cleanShifokor = double.tryParse(mahsulot.shifokorNarxi.replaceAll(RegExp(r'\D'), '')) ?? 0.0;
        final cleanKeshbek = double.tryParse(mahsulot.keshbek.replaceAll(RegExp(r'\D'), '')) ?? 0.0;

        await _apiService.updateProduct(
          token: token,
          id: mahsulot.id!,
          name: mahsulot.nomi,
          priceClient: cleanBemor,
          priceDoctor: cleanShifokor,
          cashback: cleanKeshbek,
          status: mahsulot.status,
          filePath: imageFile?.path,
        );

        // Zaxirani saqlab qolish uchun mavjud mahsulotdan nusxa olamiz
        // loadProducts() kelguncha local state'ni yangilab turish shart emas 
        // chunki loadProducts() chaqiramiz. 
        // Lekin agar backend stock qaytarmasa, local zaxirani saqlash kerak bo'lardi.
        // Hozirgi talab bo'yicha zaxira yo'qolmasligi uchun loadProducts kutamiz.

        await loadProducts();
      }
    } catch (e) {
      debugPrint("Edit Product Error: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void zaxiraYangilash(String nomi, int soni, {String ishchi = "Admin"}) {
    final index = MahsulotDatabase.mahsulotlar.indexWhere((m) => m.nomi.trim().toLowerCase() == nomi.trim().toLowerCase());
    if (index != -1) {
      MahsulotDatabase.mahsulotlar[index].zaxira += soni;
      zaxiraTarixi.add(ZaxiraTarixiModel(
        ishchiNomi: ishchi,
        mahsulotNomi: MahsulotDatabase.mahsulotlar[index].nomi,
        miqdor: soni,
        sana: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  int getZaxira(MahsulotModel m) {
    return m.zaxira;
  }

  bool tekshir() {
    return mahsulotController.text.isNotEmpty &&
           bemorNarxController.text.isNotEmpty &&
           shifokorNarxController.text.isNotEmpty &&
           keshbekController.text.isNotEmpty;
  }

  void tozalash() {
    mahsulotController.clear();
    bemorNarxController.clear();
    shifokorNarxController.clear();
    keshbekController.clear();
    selectedKategoriya = "Umumiy";
    selectedStatus = "Faol";
    imageFile = null;
    tahrirlashIndex = null;
    notifyListeners();
  }

  void tahrirlashUchunYuklash(int index) {
    tahrirlashIndex = index;
    final mahsulot = mahsulotlar[index];
    mahsulotController.text = mahsulot.nomi;
    bemorNarxController.text = mahsulot.bemorNarxi;
    shifokorNarxController.text = mahsulot.shifokorNarxi;
    keshbekController.text = mahsulot.keshbek;
    selectedKategoriya = mahsulot.kategoriya;
    selectedStatus = mahsulot.status;
    if (mahsulot.rasm != null) {
      imageFile = File(mahsulot.rasm!);
    } else {
      imageFile = null;
    }
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  @override
  void dispose() {
    mahsulotController.dispose();
    bemorNarxController.dispose();
    shifokorNarxController.dispose();
    keshbekController.dispose();
    super.dispose();
  }
}
