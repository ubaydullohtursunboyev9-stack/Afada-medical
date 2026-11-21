import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/finished_product_model.dart';
import '../service/api_service.dart';

class FinishedProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<FinishedProductModel> _finishedProducts = [];
  bool _isLoading = false;
  String? _error;

  List<FinishedProductModel> get finishedProducts => _finishedProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFinishedProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _finishedProducts = [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFinishedProduct({
    required int productId,
    required int quantity,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        await _apiService.addFinishedProduct(
          token: token,
          productId: productId,
          quantity: quantity,
        );
        await fetchFinishedProducts();
      } else {
        _error = 'Token topilmadi';
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
