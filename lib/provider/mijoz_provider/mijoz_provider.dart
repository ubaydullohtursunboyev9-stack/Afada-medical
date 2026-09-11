import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/mijoz_modeli.dart';
import '../../service/api_service.dart';
import '../../services/image_picker_service.dart';

class MijozProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  final TextEditingController ismController = TextEditingController();
  final TextEditingController familyaController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController ishJoyiController = TextEditingController();
  String mijozTuri = "Jismoniy";
  String status = "Faol";

  String? tanlanganRasm;
  
  List<MijozModel> mijozlar = [];
  bool isLoading = false;
  String? errorMessage;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> loadMijozlar() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token topilmadi");

      final data = await _apiService.getClients(token);
      mijozlar = data.map((e) => MijozModel.fromJson(e)).toList();

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rasmTanlash(BuildContext context, ImageSource source) async {
    final path = await ImagePickerService.pickImage(context, source);
    if (path != null) {
      tanlanganRasm = path;
      notifyListeners();
    }
  }

  Future<void> qoshish() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token topilmadi");

      final newMijoz = MijozModel(
        ism: ismController.text,
        familya: familyaController.text,
        telefon: telefonController.text,
        ishJoyi: ishJoyiController.text,
        rasm: tanlanganRasm,
        mijozTuri: mijozTuri,
        status: status,
      );

      final response = await _apiService.addClient(
        token: token,
        clientData: newMijoz.toJson(),
      );

      final addedMijoz = MijozModel.fromJson(response);
      mijozlar.add(addedMijoz);

      
      tozalash();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ochirish(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token topilmadi");

      await _apiService.deleteClient(token, id);
      mijozlar.removeWhere((m) => m.id == id);

    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tahrirlash(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token topilmadi");

      final updatedMijoz = MijozModel(
        id: id,
        ism: ismController.text,
        familya: familyaController.text,
        telefon: telefonController.text,
        ishJoyi: ishJoyiController.text,
        rasm: tanlanganRasm,
        mijozTuri: mijozTuri,
        status: status,
      );

      final response = await _apiService.updateClient(
        token: token,
        id: id,
        clientData: updatedMijoz.toJson(),
      );

      final result = MijozModel.fromJson(response);
      int index = mijozlar.indexWhere((m) => m.id == id);
      if (index != -1) {
        mijozlar[index] = result;

      }
      
      tozalash();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void controllergaYuklash(MijozModel mijoz) {
    ismController.text = mijoz.ism;
    familyaController.text = mijoz.familya;
    telefonController.text = mijoz.telefon;
    ishJoyiController.text = mijoz.ishJoyi;
    mijozTuri = mijoz.mijozTuri;
    status = mijoz.status;
    tanlanganRasm = mijoz.rasm;
    notifyListeners();
  }

  bool tekshir() {
    return ismController.text.isNotEmpty &&
        telefonController.text.isNotEmpty;
  }

  void tozalash() {
    ismController.clear();
    familyaController.clear();
    telefonController.clear();
    ishJoyiController.clear();
    mijozTuri = "Jismoniy";
    status = "Faol";
    tanlanganRasm = null;
    notifyListeners();
  }
}
