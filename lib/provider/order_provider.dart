import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order_model.dart';
import '../model/sale_model.dart';
import '../service/api_service.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => List.unmodifiable(_orders);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchSalesFromApi() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        _error = "Token topilmadi";
        return;
      }

      final apiService = ApiService();

      final data = await apiService.getSales(token);

      final List<OrderModel> apiOrders = data.map((json) {
        final sale = SaleModel.fromJson(json);

        return OrderModel(
          id: sale.id?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),

          productName: sale.productName,

          quantity: sale.quantity,

          price: sale.price,

          date: sale.date,

          customerName: sale.customerName,

          phone: sale.customer?.telefon ??
              sale.phoneNumber ??
              "",

          comment: "",

          referrer: sale.referrerName,

          status: "Sotildi",

          paymentStatus:
          sale.debt <= 0
              ? "To'langan"
              : "To'lanmagan",

          amountPaid: sale.amountPaid,

          servicePrice: 0.0,

          // MUHIM:
          // Sotuvni qilgan account
          createdBy: sale.createdBy,
        );
      }).toList();

      // API'dan kelgan yangi sotuvlarni yangilaymiz
      _orders.removeWhere(
            (o) => o.status == "Sotildi",
      );

      _orders.addAll(apiOrders);

      // Sana bo'yicha yangi -> eski
      _orders.sort(
            (a, b) => b.date.compareTo(a.date),
      );
    } catch (e) {
      _error = e.toString();

      debugPrint(
        "Error fetching sales: $e",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get orderCount => _orders.length;

  double get todayRevenue {
    final now = DateTime.now();

    return _orders
        .where(
          (o) =>
      o.paymentStatus == "To'langan" &&
          o.date.year == now.year &&
          o.date.month == now.month &&
          o.date.day == now.day,
    )
        .fold(
      0.0,
          (sum, o) => sum + o.amountPaid,
    );
  }

  int get todayOrdersCount {
    final now = DateTime.now();

    return _orders
        .where(
          (o) =>
      o.date.year == now.year &&
          o.date.month == now.month &&
          o.date.day == now.day,
    )
        .length;
  }

  int get todayProductsSold {
    final now = DateTime.now();

    return _orders
        .where(
          (o) =>
      o.paymentStatus == "To'langan" &&
          o.date.year == now.year &&
          o.date.month == now.month &&
          o.date.day == now.day,
    )
        .fold(
      0,
          (sum, o) => sum + o.quantity,
    );
  }

  double get monthlyRevenue {
    final now = DateTime.now();

    return _orders
        .where(
          (o) =>
      o.paymentStatus == "To'langan" &&
          o.date.year == now.year &&
          o.date.month == now.month,
    )
        .fold(
      0.0,
          (sum, o) => sum + o.amountPaid,
    );
  }

  int get monthlyOrdersCount {
    final now = DateTime.now();

    return _orders
        .where(
          (o) =>
      o.date.year == now.year &&
          o.date.month == now.month,
    )
        .length;
  }

  int get monthlyProductsSold {
    final now = DateTime.now();

    return _orders
        .where(
          (o) =>
      o.paymentStatus == "To'langan" &&
          o.date.year == now.year &&
          o.date.month == now.month,
    )
        .fold(
      0,
          (sum, o) => sum + o.quantity,
    );
  }

  List<double> get dailyRevenueLast7Days {
    final now = DateTime.now();

    return List.generate(
      7,
          (index) {
        final date = now.subtract(
          Duration(days: 6 - index),
        );

        return _orders
            .where(
              (o) =>
          o.paymentStatus == "To'langan" &&
              o.date.year == date.year &&
              o.date.month == date.month &&
              o.date.day == date.day,
        )
            .fold(
          0.0,
              (sum, o) => sum + o.amountPaid,
        );
      },
    );
  }

  List<double> get monthlyRevenueLast6Months {
    final now = DateTime.now();

    return List.generate(
      6,
          (index) {
        int targetMonth =
            now.month - (5 - index);

        int targetYear = now.year;

        while (targetMonth <= 0) {
          targetMonth += 12;
          targetYear -= 1;
        }

        return _orders
            .where(
              (o) =>
          o.paymentStatus == "To'langan" &&
              o.date.year == targetYear &&
              o.date.month == targetMonth,
        )
            .fold(
          0.0,
              (sum, o) => sum + o.amountPaid,
        );
      },
    );
  }

  void addOrder(OrderModel order) {
    _orders.add(order);

    notifyListeners();
  }

  void removeOrder(String id) {
    _orders.removeWhere(
          (order) => order.id == id,
    );

    notifyListeners();
  }

  Future<void> updateOrder(
      OrderModel updatedOrder, {
      int? productId,
      String? saleType,
      int? customerId,
      int? referrerId,
      double? discount,
    }) async {
    final index = _orders.indexWhere(
          (order) => order.id == updatedOrder.id,
    );

    if (index != -1) {
      final oldOrder = _orders[index];
      _orders[index] = updatedOrder;
      notifyListeners();

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        final saleId = int.tryParse(updatedOrder.id);

        if (token != null && token.isNotEmpty && saleId != null) {
          final apiService = ApiService();
          await apiService.updateSale(
            token: token,
            id: saleId,
            productId: productId ?? 1,
            saleType: saleType ?? (customerId != null ? 'shifokor' : 'patient'),
            quantity: updatedOrder.quantity,
            paid: updatedOrder.amountPaid,
            customerId: customerId,
            referrerId: referrerId,
            phoneNumber: updatedOrder.phone,
            discount: discount,
          );
        }
      } catch (e) {
        debugPrint("Error updating order via API: $e");
        // Rollback on error to ensure local list matches remote
        _orders[index] = oldOrder;
        notifyListeners();
        rethrow;
      }
    }
  }

  void updateOrderStatus(
      String id,
      String newStatus,
      ) {
    final index = _orders.indexWhere(
          (order) => order.id == id,
    );

    if (index != -1) {
      _orders[index] =
          _orders[index].copyWith(
            status: newStatus,
          );

      notifyListeners();
    }
  }
}