import 'package:afada/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/order_provider.dart';
import '../../model/order_model.dart';
import '../../model/model_provider.dart';
import '../../model/mahsulot_modeli.dart';
import '../home_pages.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class KunlikDaromadPages extends StatelessWidget {
  const KunlikDaromadPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "kunlik_daromad": "Kunlik daromad",
      "kunlik_ish_haqqi": "Kunlik ish haqqi",
      "bugungi_kun": "Bugungi kun",
      "kunlik_buyurtmalar": "Kunlik buyurtmalar",
      "mening_ishlarim": "Mening ishlarim",
      "sotilganlar": "Sotilganlar:",
      "tayyorlangan": "Tayyorlangan:",
      "dona": "dona",
      "daromad": "Daromad:",
      "ish_haqqi": "Ish haqqi:",
      "ta": "ta",
      "bugun_buyurtmalar_yoq": "Bugun buyurtmalar yo'q",
      "bugun_ishlar_yoq": "Bugun ishlar yo'q",
      "narxi": "Narxi:",
      "mijoz": "Mijoz:",
      "soni": "Soni:",
      "tolov": "To'lov:",
      "tolangan": "To'langan",
      "kutilmoqda": "Kutilmoqda",
      "nomer": "No'mer:",
      "tahrirlash": "Tahrirlash",
      "jami": "Jami:",
      "vaqt": "Vaqt:",
      "buyurtma_holati": "Buyurtma holati",
      "sotilgan_belgilash": "Bu buyurtmani sotilgan deb belgilamoqchimisiz?",
      "bekor_qilish": "Bekor qilish",
      "sotildi": "Sotildi",
      "default_mijoz": "Mijoz",
      "valyuta": "UZS",
      "phone_placeholder": "90 123 45 67",
    },
    "Rus": {
      "kunlik_daromad": "Дневной доход",
      "kunlik_ish_haqqi": "Дневная зарплата",
      "bugungi_kun": "Сегодня",
      "kunlik_buyurtmalar": "Дневные заказы",
      "mening_ishlarim": "Мои работы",
      "sotilganlar": "Продано:",
      "tayyorlangan": "Подготовлено:",
      "dona": "шт",
      "daromad": "Доход:",
      "ish_haqqi": "Зарплата:",
      "ta": "шт",
      "bugun_buyurtmalar_yoq": "Сегодня заказов нет",
      "bugun_ishlar_yoq": "Сегодня работы нет",
      "narxi": "Цена:",
      "mijoz": "Клиент:",
      "soni": "Количество:",
      "tolov": "Оплата:",
      "tolangan": "Оплачено",
      "kutilmoqda": "Ожидается",
      "nomer": "Номер:",
      "tahrirlash": "Редактировать",
      "jami": "Итого:",
      "vaqt": "Время:",
      "buyurtma_holati": "Статус заказа",
      "sotilgan_belgilash": "Вы хотите отметить этот заказ как проданный?",
      "bekor_qilish": "Отмена",
      "sotildi": "Продано",
      "default_mijoz": "Клиент",
      "valyuta": "сум",
      "phone_placeholder": "90 123 45 67",
    },
    "Kiril": {
      "kunlik_daromad": "Кунлик даромад",
      "kunlik_ish_haqqi": "Кунлик иш ҳаққи",
      "bugungi_kun": "Бугунги кун",
      "kunlik_buyurtmalar": "Кунлик буюртмалар",
      "mening_ishlarim": "Менинг ишларим",
      "sotilganlar": "Сотилганлар:",
      "tayyorlangan": "Тайёрланган:",
      "dona": "дона",
      "daromad": "Даромад:",
      "ish_haqqi": "Иш ҳаққи:",
      "ta": "та",
      "bugun_buyurtmalar_yoq": "Бугун буюртмалар йўқ",
      "bugun_ishlar_yoq": "Бугун ишлар йўқ",
      "narxi": "Нархи:",
      "mijoz": "Мижоз:",
      "soni": "Сони:",
      "tolov": "Тўлов:",
      "tolangan": "Тўланган",
      "kutilmoqda": "Кутилмоқда",
      "nomer": "Номер:",
      "tahrirlash": "Таҳрирлаш",
      "jami": "Жами:",
      "vaqt": "Вақт:",
      "buyurtma_holati": "Буюртма ҳолати",
      "sotilgan_belgilash": "Бу буюртмани сотилган деб белгиламоқчимисиз?",
      "bekor_qilish": "Бекор қилиш",
      "sotildi": "Сотилди",
      "default_mijoz": "Мижоз",
      "valyuta": "сўм",
      "phone_placeholder": "90 123 45 67",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  String _formatMoney(double amount) {
    return NumberFormat('#,###').format(amount).replaceAll(',', ' ');
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer3<OrderProvider, ProfileProvider, MahsulotProvider>(
      builder: (context, orderProvider, profileProvider, mahsulotProvider, child) {
        final now = DateTime.now();
        final fullName = "${profileProvider.surname} ${profileProvider.name}".trim().toLowerCase();

        final todayOrders = orderProvider.orders.where((o) =>
            o.date.year == now.year &&
            o.date.month == now.month &&
            o.date.day == now.day).toList();

        final filteredOrders = todayOrders;

        final todayStockAdded = mahsulotProvider.zaxiraTarixi.where((z) =>
            z.sana.year == now.year &&
            z.sana.month == now.month &&
            z.sana.day == now.day).toList();

        double displayRevenue = 0;
        int displayProductsSold = 0;

        displayRevenue = orderProvider.orders
            .where((o) =>
                (o.paymentStatus == "To'langan" || o.status == "Sotildi") &&
                o.date.year == now.year &&
                o.date.month == now.month &&
                o.date.day == now.day)
            .fold(0.0, (sum, o) {
              if (o.status == "Sotildi") {
                return sum + (o.price * o.quantity);
              }
              return sum + o.amountPaid;
            });

        displayProductsSold = orderProvider.orders
            .where((o) =>
                (o.paymentStatus == "To'langan" || o.status == "Sotildi") &&
                o.date.year == now.year &&
                o.date.month == now.month &&
                o.date.day == now.day)
            .fold(0, (sum, o) => sum + o.quantity);


        final String lang = profileProvider.language;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.blue.shade100,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF181A20) : null,
            elevation: 0,
            foregroundColor: Colors.white,
            title: Text(
              getTxt(lang, "kunlik_daromad"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 10,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: isDark ? Colors.black26 : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF252836) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isDark ? Border.all(color: const Color(0xFF3A3F4B)) : null,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  getTxt(lang, "bugungi_kun"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDark ? Colors.white : Colors.black),
                                ),
                                const Spacer(),
                                Text(
                                  "${now.day}.${now.month}.${now.year}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDark ? Colors.white70 : Colors.black54),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  getTxt(lang, "sotilganlar"),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                const Spacer(),
                                Text(
                                  "$displayProductsSold ${getTxt(lang, "dona")}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isDark ? Colors.white70 : Colors.indigo),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  getTxt(lang, "daromad"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red),
                                ),
                                const Spacer(),
                                Text(
                                  "${_formatMoney(displayRevenue)} ${getTxt(lang, "valyuta")}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Text(
                      getTxt(lang, "kunlik_daromad"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDark ? Colors.white : Colors.black),
                    ),
                    const Spacer(),
                    Text(
                      "${filteredOrders.length} ${getTxt(lang, "ta")}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo),
                    )
                  ],
                ),
              ),
              if (filteredOrders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      getTxt(lang, "bugun_buyurtmalar_yoq"),
                      style: TextStyle(
                          fontSize: 18,
                          color: isDark ? Colors.white54 : Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return Card(
                      elevation: 4,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: isDark ? Colors.black26 : null,
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF252836) : Colors.white,
                          border: isDark ? Border.all(color: const Color(0xFF3A3F4B)) : null,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 130,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade100,
                                  ),
                                  child: Consumer<MahsulotProvider>(
                                    builder: (context, mahsulotProvider, child) {
                                      final product = mahsulotProvider.mahsulotlar.firstWhere(
                                        (m) => m.nomi == order.productName,
                                        orElse: () => MahsulotModel(
                                            nomi: "",
                                            bemorNarxi: "0",
                                            shifokorNarxi: "0",
                                            kategoriya: "Umumiy",
                                            keshbek: "0",
                                            status: "Faol"),
                                      );
                                      if (product.rasm != null && product.rasm!.isNotEmpty) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.file(File(product.rasm!), fit: BoxFit.cover),
                                        );
                                      }
                                      return Container(
                                        width: 100,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: isDark
                                              ? const Color(0xFF3C8DFF).withValues(alpha: 0.25)
                                              : const Color(0xFF3C8DFF).withValues(alpha: 0.12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            order.productName.trim().isNotEmpty
                                                ? order.productName.trim().substring(0, 1).toUpperCase()
                                                : "?",
                                            style: TextStyle(
                                              fontSize: 52,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? const Color(0xFF3C8DFF)
                                                  : const Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.productName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        _buildOrderInfoRow(context, getTxt(lang, "narxi"), "${_formatMoney(order.price)} ${getTxt(lang, "valyuta")}"),
                                        _buildOrderInfoRow(context, getTxt(lang, "mijoz"), order.customerName.isEmpty ? getTxt(lang, "default_mijoz") : order.customerName),
                                        _buildOrderInfoRow(context, getTxt(lang, "soni"), "${order.quantity} ${getTxt(lang, "dona")}"),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                getTxt(lang, "tolov"),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark ? Colors.white70 : Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              order.paymentStatus == "To'langan" ? getTxt(lang, "tolangan") : getTxt(lang, "kutilmoqda"),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: order.paymentStatus == "To'langan" ? Colors.green : Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                getTxt(lang, "nomer"),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark ? Colors.white70 : Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: TextButton(
                                                onPressed: () {
                                                  _makePhoneCall("+998${order.phone.replaceAll(' ', '')}");
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                                  minimumSize: Size.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                child: Text(
                                                  order.phone.isEmpty ? getTxt(lang, "phone_placeholder") : order.phone,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: isDark ? Colors.white : Colors.indigo,
                                    backgroundColor: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade100,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                                onPressed: () {
                                  HomePages().showBuyurtmaDialog(context, order: order);
                                },
                                child: Text(
                                  getTxt(lang, "tahrirlash"),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }


  Widget _buildOrderInfoRow(BuildContext context, String label, String value) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.indigo,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, OrderModel order, OrderProvider provider, String lang) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF252836) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark ? const BorderSide(color: Color(0xFF3A3F4B)) : BorderSide.none,
        ),
        title: Text(
          getTxt(lang, "buyurtma_holati"),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          getTxt(lang, "sotilgan_belgilash"),
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              getTxt(lang, "bekor_qilish"),
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.updateOrderStatus(order.id, "Sotildi");
              Navigator.pop(context);
            },
            child: Text(
              getTxt(lang, "sotildi"),
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
