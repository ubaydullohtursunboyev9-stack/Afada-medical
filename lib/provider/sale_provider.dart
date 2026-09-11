import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/sale_model.dart';
import '../service/api_service.dart';

class SaleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<SaleModel> _sales = [];
  bool _isLoading = false;
  String? _error;

  List<SaleModel> get sales => _sales;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalRevenue {
    return _sales.fold(0.0, (sum, sale) => sum + sale.amountPaid);
  }

  Future<void> fetchSales() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        final data = await _apiService.getSales(token);
        _sales = data.map((e) => SaleModel.fromJson(e)).toList();
      } else {
        _error = 'Token topilmadi';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSale({
    required int productId,
    required String saleType,
    required int quantity,
    required double paid,
    int? customerId,
    int? referrerId,
    String? phoneNumber,
    double? discount,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        await _apiService.createSale(
          token: token,
          productId: productId,
          saleType: saleType,
          quantity: quantity,
          paid: paid,
          customerId: customerId,
          referrerId: referrerId,
          phoneNumber: phoneNumber,
          discount: discount,
        );
        await fetchSales();
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

  Future<void> deleteSale(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token != null) {
        await _apiService.deleteSale(token, id);
        _sales.removeWhere((sale) => sale.id == id);
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
