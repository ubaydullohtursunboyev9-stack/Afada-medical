import 'package:afada/pages/daromad_pages/umumiy_daromad_pages.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/model/model_provider.dart';
import 'package:afada/model/mahsulot_modeli.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/order_provider.dart';
import '../../model/order_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class OylikDaromadPages extends StatelessWidget {
  const OylikDaromadPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "daromadlar": "Daromadlar",
      "oylik_daromad": "Oylik daromad",
      "oylik_ish_haqqi": "Oylik ish haqqi",
      "umumiy_daromad": "Umumiy daromad",
      "umumiy_ish_haqqi": "Umumiy ish haqqi",
      "sotildi": "Sotildi:",
      "tayyorlangan": "Tayyorlangan:",
      "dona": "dona",
      "buyurtmalar": "Buyurtmalar:",
      "ishlar": "Ishlar:",
      "ta": "ta",
      "summa": "Summa:",
      "ish_haqqi": "Ish haqqi:",
      "oyda_buyurtmalar_yoq": "Bu oyda buyurtmalar yo'q",
      "oyda_ishlar_yoq": "Bu oyda ishlar yo'q",
      "sana": "Sana:",
      "narxi": "Narxi:",
      "mijoz": "Mijoz:",
      "soni": "Soni:",
      "tolov": "To'lov:",
      "tolangan": "To'langan",
      "kutilmoqda": "Kutilmoqda",
      "klent": "Klent",
      "tahrirlash": "Tahrirlash",
      "buyurtma_holati": "Buyurtma holati",
      "sotilgan_belgilash": "Bu buyurtmani sotilgan deb belgilamoqchimisiz?",
      "bekor_qilish": "Bekor qilish",
      "sotildi_btn": "Sotildi",
      "jami": "Jami:",
      "valyuta": "UZS",
      "Yanvar": "Yanvar",
      "Fevral": "Fevral",
      "Mart": "Mart",
      "Aprel": "Aprel",
      "May": "May",
      "Iyun": "Iyun",
      "Iyul": "Iyul",
      "Avgust": "Avgust",
      "Sentabr": "Sentabr",
      "Oktabr": "Oktabr",
      "Noyabr": "Noyabr",
      "Dekabr": "Dekabr",
    },
    "Rus": {
      "daromadlar": "Доходы",
      "oylik_daromad": "Месячный доход",
      "oylik_ish_haqqi": "Месячная зарплата",
      "umumiy_daromad": "Общий доход",
      "umumiy_ish_haqqi": "Общая зарплата",
      "sotildi": "Продано:",
      "tayyorlangan": "Подготовлено:",
      "dona": "шт",
      "buyurtmalar": "Заказы:",
      "ishlar": "Работы:",
      "ta": "шт",
      "summa": "Сумма:",
      "ish_haqqi": "Зарплата:",
      "oyda_buyurtmalar_yoq": "В этом месяце заказов нет",
      "oyda_ishlar_yoq": "В этом месяце работ нет",
      "sana": "Дата:",
      "narxi": "Цена:",
      "mijoz": "Клиент:",
      "soni": "Количество:",
      "tolov": "Оплата:",
      "tolangan": "Оплачено",
      "kutilmoqda": "Ожидается",
      "klent": "Клиент",
      "tahrirlash": "Редактировать",
      "buyurtma_holati": "Статус заказа",
      "sotilgan_belgilash": "Вы хотите отметить этот заказ как проданный?",
      "bekor_qilish": "Отмена",
      "sotildi_btn": "Продано",
      "jami": "Итого:",
      "valyuta": "сум",
      "Yanvar": "Январь",
      "Fevral": "Февраль",
      "Mart": "Март",
      "Aprel": "Апрель",
      "May": "Май",
      "Iyun": "Июнь",
      "Iyul": "Июль",
      "Avgust": "Август",
      "Sentabr": "Сентябрь",
      "Oktabr": "Октябрь",
      "Noyabr": "Ноябрь",
      "Dekabr": "Декабрь",
    },
    "Kiril": {
      "daromadlar": "Даромадлар",
      "oylik_daromad": "Ойлик даромад",
      "oylik_ish_haqqi": "Ойлик иш ҳаққи",
      "umumiy_daromad": "Умумий даромад",
      "umumiy_ish_haqqi": "Умумий иш ҳаққи",
      "sotildi": "Сотилди:",
      "tayyorlangan": "Тайёрланган:",
      "dona": "дона",
      "buyurtmalar": "Буюртмалар:",
      "ishlar": "Ишлар:",
      "ta": "та",
      "summa": "Сумма:",
      "ish_haqqi": "Иш ҳаққи:",
      "oyda_buyurtmalar_yoq": "Бу ойда буюртмалар йўқ",
      "oyda_ishlar_yoq": "Бу ойда ишлар йўқ",
      "sana": "Сана:",
      "narxi": "Нархи:",
      "mijoz": "Мижоз:",
      "soni": "Сони:",
      "tolov": "Тўлов:",
      "tolangan": "Тўланган",
      "kutilmoqda": "Кутилмоқда",
      "klent": "Клент",
      "tahrirlash": "Таҳрирлаш",
      "buyurtma_holati": "Буюртма ҳолати",
      "sotilgan_belgilash": "Бу буюртмани сотилган деб белгиламоқчимисиз?",
      "bekor_qilish": "Бекор қилиш",
      "sotildi_btn": "Сотилди",
      "jami": "Жами:",
      "valyuta": "сўм",
      "Yanvar": "Январ",
      "Fevral": "Феврал",
      "Mart": "Март",
      "Aprel": "Апрел",
      "May": "Май",
      "Iyun": "Июн",
      "Iyul": "Июл",
      "Avgust": "Август",
      "Sentabr": "Сентябр",
      "Oktabr": "Октабр",
      "Noyabr": "Ноябр",
      "Dekabr": "Декабр",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  final List<String> oylar = const [
    '',
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'Iyun',
    'Iyul',
    'Avgust',
    'Sentabr',
    'Oktabr',
    'Noyabr',
    'Dekabr',
  ];

  String _formatMoney(double amount) {
    return NumberFormat('#,###').format(amount).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 2,
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final String lang = profileProvider.language;

          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF181A20) : Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF181A20) : null,
              elevation: 0,
              foregroundColor: Colors.white,
              title: Text(
                getTxt(lang, "daromadlar"),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2E38) : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF3A3F4B) : Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TabBar(
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: -10, vertical: 2),
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF3C8DFF).withValues(alpha: isDark ? 0.3 : 0.8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF3C8DFF) : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    tabs: [
                      Tab(text: getTxt(lang, "oylik_daromad")),
                      Tab(text: getTxt(lang, "umumiy_daromad")),
                    ],
                  ),
                ),
              ),
            ),
            body: Consumer2<OrderProvider, MahsulotProvider>(
              builder: (context, orderProvider, mahsulotProvider, child) {
                final now = DateTime.now();
                final fullName = "${profileProvider.surname} ${profileProvider.name}".trim().toLowerCase();

                final monthlyOrders = orderProvider.orders
                    .where((o) => o.date.year == now.year && o.date.month == now.month)
                    .toList();

                final monthlyStockAdded = mahsulotProvider.zaxiraTarixi.where((z) =>
                    z.sana.year == now.year &&
                    z.sana.month == now.month).toList();

                double displayRevenue = 0;
                int displayProductsSold = 0;
                int displayTaskCount = 0;

                displayRevenue = orderProvider.orders
                    .where((o) =>
                        (o.paymentStatus == "To'langan" || o.status == "Sotildi") &&
                        o.date.year == now.year &&
                        o.date.month == now.month)
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
                        o.date.month == now.month)
                    .fold(0, (sum, o) => sum + o.quantity);
                displayTaskCount = monthlyOrders.length;

                return TabBarView(children: [
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 15, bottom: 10),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            surfaceTintColor: Colors.transparent,
                            elevation: isDark ? 0 : 10,
                            shadowColor: isDark ? Colors.black26 : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF252836) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: isDark ? Border.all(color: const Color(0xFF3A3F4B)) : null,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          getTxt(lang, oylar[now.month]),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${now.year}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: isDark ? Colors.white : Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 5, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          getTxt(lang, "sotildi"),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "$displayProductsSold ${getTxt(lang, "dona")}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: isDark ? const Color(0xFF3C8DFF) : Theme.of(context).colorScheme.primary),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 5, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          getTxt(lang, "buyurtmalar"),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "$displayTaskCount ${getTxt(lang, "ta")}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: isDark ? const Color(0xFF3C8DFF) : Theme.of(context).colorScheme.primary),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 5, right: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          getTxt(lang, "summa"),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${_formatMoney(displayRevenue)} ${getTxt(lang, "valyuta")}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: isDark ? Colors.white : Theme.of(context).colorScheme.secondary),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (monthlyOrders.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                getTxt(lang, "oyda_buyurtmalar_yoq"),
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
                            itemCount: monthlyOrders.length,
                            itemBuilder: (context, index) {
                              final order = monthlyOrders[index];
                              return _buildOrderCard(context, order, orderProvider, lang);
                            },
                          ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                  const UmumiyDaromadPages()
                ]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, OrderModel order, OrderProvider provider, String lang) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDark ? const Color(0xFF252836) : null,
      elevation: isDark ? 0 : 10,
      surfaceTintColor: Colors.transparent,
      shadowColor: isDark ? Colors.black26 : null,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5),
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
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: isDark ? const Color(0xFF2A2E38) : Colors.grey,
                  ),
                  child: Icon(Icons.shopping_bag, size: 50, color: isDark ? Colors.white24 : Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? const Color(0xFF3C8DFF) : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${getTxt(lang, "sana")} ${order.date.day} ${getTxt(lang, oylar[order.date.month])} ${order.date.year}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                    ),
                    Row(
                      children: [
                        Text(
                          getTxt(lang, "narxi"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 23),
                        Text(
                          "${_formatMoney(order.price)} ${getTxt(lang, "valyuta")}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          getTxt(lang, "mijoz"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          order.customerName.isEmpty ? getTxt(lang, "klent") : order.customerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          getTxt(lang, "soni"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Text(
                          "${order.quantity} ${getTxt(lang, "dona")}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          getTxt(lang, "tolov"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          order.status == "Sotildi" ? getTxt(lang, "tolangan") : getTxt(lang, "kutilmoqda"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: order.status == "Sotildi"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),)
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : Theme.of(context).colorScheme.onPrimaryContainer,
                    backgroundColor: isDark ? const Color(0xFF3A3F4B) : Theme.of(context).colorScheme.primaryContainer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () => _showStatusDialog(context, order, provider),
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
  }

  void _showStatusDialog(
      BuildContext context, OrderModel order, OrderProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final String lang = profileProvider.language;
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF252836) : null,
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  style: TextStyle(color: isDark ? Colors.white70 : null),
                ),
              ),
              TextButton(
                onPressed: () {
                  provider.updateOrderStatus(order.id, "Sotildi");
                  Navigator.pop(context);
                },
                child: Text(getTxt(lang, "sotildi_btn")),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWorkerStockCard(BuildContext context, ZaxiraTarixiModel z, MahsulotProvider mahsulotProvider, String lang) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final product = mahsulotProvider.mahsulotlar.firstWhere(
      (m) => m.nomi.trim().toLowerCase() == z.mahsulotNomi.trim().toLowerCase(),
      orElse: () => MahsulotModel(
          nomi: "",
          bemorNarxi: "0",
          shifokorNarxi: "0",
          kategoriya: "Umumiy",
          keshbek: "0",
          status: "Faol"),
    );
    final productPrice = double.tryParse(product.shifokorNarxi.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

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
        child: Row(
          children: [
            Container(
              width: 100,
              height: 110,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade100,
              ),
              child: product.rasm != null && product.rasm!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(File(product.rasm!), fit: BoxFit.cover),
                    )
                  : Icon(Icons.inventory_2_outlined,
                      size: 50,
                      color: isDark ? Colors.white24 : Colors.grey.shade400),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      z.mahsulotNomi,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    _buildInfoRow(context, getTxt(lang, "ish_haqqi"), "${_formatMoney(productPrice)} ${getTxt(lang, "valyuta")}"),
                    _buildInfoRow(context, getTxt(lang, "soni"), "${z.miqdor} ${getTxt(lang, "dona")}"),
                    _buildInfoRow(context, getTxt(lang, "jami"), "${_formatMoney(productPrice * z.miqdor)} ${getTxt(lang, "valyuta")}"),
                    _buildInfoRow(context, getTxt(lang, "sana"), DateFormat('dd.MM.yyyy HH:mm').format(z.sana)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
}
