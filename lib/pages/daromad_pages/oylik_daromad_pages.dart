import 'dart:io';

import 'package:afada/model/mahsulot_modeli.dart';
import 'package:afada/model/model_provider.dart';
import 'package:afada/pages/daromad_pages/umumiy_daromad_pages.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/order_model.dart';
import '../../provider/order_provider.dart';

// ============================================================
// CLINICAL COLORS (Boshqa sahifalar bilan bir xil rang tizimi)
// ============================================================
class _OylikColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF8FAFC);
}

enum _OylikFilter { all, paid, pending }

class OylikDaromadPages extends StatefulWidget {
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
      "barchasi": "Barchasi",
      "oylik_trend": "Kunlik daromad dinamikasi",
      "tolov_taqsimoti": "Oylik to'lov holati",
      "qidirish": "Mahsulot yoki mijoz bo'yicha qidirish...",
      "natija_topilmadi": "Qidiruv bo'yicha buyurtma topilmadi",
      "filtrni_tozalash": "Filtrni tozalash",
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
      "valyuta": "UZS",
      "barchasi": "Все",
      "oylik_trend": "Динамика по дням месяца",
      "tolov_taqsimoti": "Статус оплат за месяц",
      "qidirish": "Поиск по товару или клиенту...",
      "natija_topilmadi": "Заказы не найдены",
      "filtrni_tozalash": "Сбросить фильтр",
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
      "valyuta": "UZS",
      "barchasi": "Барчаси",
      "oylik_trend": "Кунлик даромад динамикаси",
      "tolov_taqsimoti": "Ойлик тўлов ҳолати",
      "qidirish": "Маҳсулот ёки мижоз бўйича қидириш...",
      "natija_topilmadi": "Қидирув бўйича буюртма топилмади",
      "filtrni_tozalash": "Филтрни тозалаш",
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
    return _localizedTexts[lang]?[key] ?? _localizedTexts["Uzb"]?[key] ?? key;
  }

  @override
  State<OylikDaromadPages> createState() => _OylikDaromadPagesState();
}

class _OylikDaromadPagesState extends State<OylikDaromadPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _OylikFilter _activeFilter = _OylikFilter.all;

  static const List<String> oylar = [
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            backgroundColor:
            isDark ? _OylikColors.slateDark : _OylikColors.lightBg,
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              iconTheme: IconThemeData(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              title: Text(
                OylikDaromadPages.getTxt(lang, "daromadlar"),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(54),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? _OylikColors.cardDark
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: isDark
                          ? Colors.white60
                          : const Color(0xFF475569),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13.5,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: _OylikColors.primaryBlue,
                        boxShadow: [
                          BoxShadow(
                            color: _OylikColors.primaryBlue
                                .withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      tabs: [
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              OylikDaromadPages.getTxt(lang, "oylik_daromad"),
                            ),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              OylikDaromadPages.getTxt(lang, "umumiy_daromad"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Consumer2<OrderProvider, MahsulotProvider>(
              builder: (context, orderProvider, mahsulotProvider, child) {
                final now = DateTime.now();

                final monthlyOrders = orderProvider.orders
                    .where((o) =>
                o.date.year == now.year && o.date.month == now.month)
                    .toList();

                final double displayRevenue = orderProvider.orders
                    .where((o) =>
                (o.paymentStatus == "To'langan" ||
                    o.status == "Sotildi") &&
                    o.date.year == now.year &&
                    o.date.month == now.month)
                    .fold(0.0, (sum, o) {
                  if (o.status == "Sotildi") {
                    return sum + (o.price * o.quantity);
                  }
                  return sum + o.amountPaid;
                });

                final int displayProductsSold = orderProvider.orders
                    .where((o) =>
                (o.paymentStatus == "To'langan" ||
                    o.status == "Sotildi") &&
                    o.date.year == now.year &&
                    o.date.month == now.month)
                    .fold(0, (sum, o) => sum + o.quantity);

                final int displayTaskCount = monthlyOrders.length;

                final int paidCount = monthlyOrders
                    .where((o) =>
                o.paymentStatus == "To'langan" ||
                    o.status == "Sotildi")
                    .length;
                final int pendingCount = monthlyOrders.length - paidCount;

                final double pendingAmount = monthlyOrders
                    .where((o) =>
                o.paymentStatus != "To'langan" &&
                    o.status != "Sotildi")
                    .fold(0.0, (sum, o) => sum + (o.price * o.quantity));

                final String query = _searchQuery.trim().toLowerCase();
                final List<OrderModel> filteredOrders =
                monthlyOrders.where((o) {
                  final bool isPaid = o.paymentStatus == "To'langan" ||
                      o.status == "Sotildi";
                  if (_activeFilter == _OylikFilter.paid && !isPaid) {
                    return false;
                  }
                  if (_activeFilter == _OylikFilter.pending && isPaid) {
                    return false;
                  }
                  if (query.isEmpty) return true;
                  return o.productName.toLowerCase().contains(query) ||
                      o.customerName.toLowerCase().contains(query);
                }).toList();

                return TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([
                          orderProvider.fetchSalesFromApi(),
                          mahsulotProvider.loadProducts(),
                        ]);
                      },
                      color: _OylikColors.primaryBlue,
                      backgroundColor:
                      isDark ? _OylikColors.cardDark : Colors.white,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double contentMaxWidth =
                          constraints.maxWidth > 1080
                              ? 1080
                              : constraints.maxWidth;

                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 48),
                            child: Center(
                              child: ConstrainedBox(
                                constraints:
                                BoxConstraints(maxWidth: contentMaxWidth),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 1. KPI SUMMARY CARDS
                                    _buildSummaryCards(
                                      lang: lang,
                                      isDark: isDark,
                                      now: now,
                                      displayRevenue: displayRevenue,
                                      displayProductsSold: displayProductsSold,
                                      displayTaskCount: displayTaskCount,
                                      paidCount: paidCount,
                                      pendingCount: pendingCount,
                                    ),
                                    const SizedBox(height: 16),

                                    // 2. INTERAKTIV DIAGRAMMALAR
                                    _buildChartsSection(
                                      lang: lang,
                                      isDark: isDark,
                                      maxWidth: contentMaxWidth - 32,
                                      monthlyOrders: monthlyOrders,
                                      now: now,
                                      paidAmount: displayRevenue,
                                      pendingAmount: pendingAmount,
                                      paidCount: paidCount,
                                      pendingCount: pendingCount,
                                    ),
                                    const SizedBox(height: 16),

                                    // 3. QIDIRUV VA KAPSULA FILTR
                                    if (monthlyOrders.isNotEmpty) ...[
                                      _buildSearchAndFilterBar(
                                        lang: lang,
                                        isDark: isDark,
                                        maxWidth: contentMaxWidth - 32,
                                        allCount: monthlyOrders.length,
                                        paidCount: paidCount,
                                        pendingCount: pendingCount,
                                      ),
                                      const SizedBox(height: 14),
                                    ],

                                    // 4. BUYURTMALAR SARLAVHASI
                                    Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: _OylikColors.primaryBlue
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.receipt_long_rounded,
                                            color: _OylikColors.primaryBlue,
                                            size: 21,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "${OylikDaromadPages.getTxt(lang, oylar[now.month])} ${now.year}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 11, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: _OylikColors.primaryBlue
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "${filteredOrders.length} ${OylikDaromadPages.getTxt(lang, "ta")}",
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800,
                                              color: _OylikColors.primaryBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // 5. BUYURTMALAR RO'YXATI
                                    if (monthlyOrders.isEmpty)
                                      _buildEmptyOrdersCard(
                                        isDark: isDark,
                                        message: OylikDaromadPages.getTxt(
                                            lang, "oyda_buyurtmalar_yoq"),
                                        showClearButton: false,
                                      )
                                    else if (filteredOrders.isEmpty)
                                      _buildEmptyOrdersCard(
                                        isDark: isDark,
                                        message: OylikDaromadPages.getTxt(
                                            lang, "natija_topilmadi"),
                                        clearLabel: OylikDaromadPages.getTxt(
                                            lang, "filtrni_tozalash"),
                                        showClearButton: true,
                                        onClear: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = "";
                                            _activeFilter = _OylikFilter.all;
                                          });
                                        },
                                      )
                                    else
                                      _buildOrdersGrid(
                                        context,
                                        orders: filteredOrders,
                                        mahsulotProvider: mahsulotProvider,
                                        lang: lang,
                                        isDark: isDark,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const UmumiyDaromadPages(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // 1. KPI SUMMARY CARDS
  // ============================================================
  Widget _buildSummaryCards({
    required String lang,
    required bool isDark,
    required DateTime now,
    required double displayRevenue,
    required int displayProductsSold,
    required int displayTaskCount,
    required int paidCount,
    required int pendingCount,
  }) {
    final String unit = OylikDaromadPages.getTxt(lang, "ta");
    final String dona = OylikDaromadPages.getTxt(lang, "dona");
    final String currency = OylikDaromadPages.getTxt(lang, "valyuta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: OylikDaromadPages.getTxt(lang, oylar[now.month]),
            icon: Icons.show_chart_rounded,
            iconColor: _OylikColors.green,
            mainValue: "${_formatMoney(displayRevenue)} $currency",
            subLabel1: OylikDaromadPages.getTxt(lang, "sotildi"),
            subVal1: "$displayProductsSold $dona",
            subLabel2: OylikDaromadPages.getTxt(lang, "buyurtmalar"),
            subVal2: "$displayTaskCount $unit",
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: OylikDaromadPages.getTxt(lang, "buyurtmalar")
                .replaceAll(':', ''),
            icon: Icons.shopping_bag_rounded,
            iconColor: _OylikColors.primaryBlue,
            mainValue: "$displayTaskCount $unit",
            subLabel1: OylikDaromadPages.getTxt(lang, "tolangan"),
            subVal1: "$paidCount $unit",
            subLabel2: OylikDaromadPages.getTxt(lang, "kutilmoqda"),
            subVal2: "$pendingCount $unit",
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String mainValue,
    required String subLabel1,
    required String subVal1,
    required String subLabel2,
    required String subVal2,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF64748B).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              mainValue,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        subLabel1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subVal1,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color:
                        isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        subLabel2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subVal2,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color:
                        isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. INTERAKTIV DIAGRAMMALAR (OYLIK KUNLIK WAVE + TO'LOV DONUT)
  // ============================================================
  Widget _buildChartsSection({
    required String lang,
    required bool isDark,
    required double maxWidth,
    required List<OrderModel> monthlyOrders,
    required DateTime now,
    required double paidAmount,
    required double pendingAmount,
    required int paidCount,
    required int pendingCount,
  }) {
    final waveChartCard = _buildMonthlyWaveChartCard(
      lang: lang,
      isDark: isDark,
      monthlyOrders: monthlyOrders,
      now: now,
    );

    final donutChartCard = _buildPaymentDonutCard(
      lang: lang,
      isDark: isDark,
      paidAmount: paidAmount,
      pendingAmount: pendingAmount,
      paidCount: paidCount,
      pendingCount: pendingCount,
    );

    if (maxWidth >= 720) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: waveChartCard),
          const SizedBox(width: 14),
          Expanded(flex: 5, child: donutChartCard),
        ],
      );
    }

    return Column(
      children: [
        waveChartCard,
        const SizedBox(height: 14),
        donutChartCard,
      ],
    );
  }

  Widget _buildMonthlyWaveChartCard({
    required String lang,
    required bool isDark,
    required List<OrderModel> monthlyOrders,
    required DateTime now,
  }) {
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final data = List.generate(daysInMonth, (i) {
      final int day = i + 1;
      return monthlyOrders
          .where((o) =>
      (o.paymentStatus == "To'langan" || o.status == "Sotildi") &&
          o.date.day == day)
          .fold<double>(0.0, (sum, o) {
        if (o.status == "Sotildi") return sum + (o.price * o.quantity);
        return sum + o.amountPaid;
      });
    });

    final labels = List.generate(daysInMonth, (i) => (i + 1).toString());
    double maxVal =
    data.fold(0.0, (prev, element) => element > prev ? element : prev);
    if (maxVal <= 0) maxVal = 1000;

    String formatY(double val) {
      if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}M';
      if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}k';
      return val.toStringAsFixed(0);
    }

    final spots = List.generate(
      data.length,
          (i) => FlSpot(i.toDouble(), data[i]),
    );
    final currency = OylikDaromadPages.getTxt(lang, "valyuta");

    return Container(
      height: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  OylikDaromadPages.getTxt(lang, "oylik_trend"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_graph_rounded,
                size: 22,
                color: _OylikColors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: daysInMonth * 36.0,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (data.length - 1).toDouble(),
                    minY: 0,
                    maxY: maxVal * 1.25,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) =>
                        isDark ? const Color(0xFF0F172A) : Colors.white,
                        tooltipRoundedRadius: 12,
                        tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        tooltipMargin: 10,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              "${_formatMoney(spot.y)} $currency",
                              TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: maxVal / 3,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE2E8F0),
                        strokeWidth: 1.0,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxVal / 3,
                          getTitlesWidget: (value, meta) {
                            if (value < 0) return const SizedBox();
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 4,
                              child: Text(
                                formatY(value),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white54
                                      : const Color(0xFF64748B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final int idx = value.toInt();
                            if (idx >= 0 && idx < labels.length) {
                              final bool isToday = (idx + 1) == now.day;
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 6,
                                child: Text(
                                  labels[idx],
                                  style: TextStyle(
                                    color: isToday
                                        ? _OylikColors.primaryBlue
                                        : (isDark
                                        ? Colors.white54
                                        : const Color(0xFF64748B)),
                                    fontWeight: isToday
                                        ? FontWeight.w900
                                        : FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        curveSmoothness: 0.35,
                        preventCurveOverShooting: true,
                        spots: spots,
                        color: _OylikColors.green,
                        barWidth: 3.2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final bool isToday = (index + 1) == now.day;
                            return FlDotCirclePainter(
                              radius: isToday ? 5.5 : 4.0,
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              strokeWidth: isToday ? 3 : 2.2,
                              strokeColor: isToday
                                  ? _OylikColors.primaryBlue
                                  : _OylikColors.green,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _OylikColors.green
                                  .withValues(alpha: isDark ? 0.35 : 0.25),
                              _OylikColors.green.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDonutCard({
    required String lang,
    required bool isDark,
    required double paidAmount,
    required double pendingAmount,
    required int paidCount,
    required int pendingCount,
  }) {
    final int totalOrders = paidCount + pendingCount;
    final int paidPercent =
    totalOrders > 0 ? ((paidCount / totalOrders) * 100).round() : 0;
    final String unit = OylikDaromadPages.getTxt(lang, "ta");
    final String currency = OylikDaromadPages.getTxt(lang, "valyuta");

    final List<PieChartSectionData> sections = totalOrders == 0
        ? [
      PieChartSectionData(
        value: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFE2E8F0),
        radius: 20,
        showTitle: false,
      ),
    ]
        : [
      if (paidCount > 0)
        PieChartSectionData(
          value: paidCount.toDouble(),
          color: _OylikColors.green,
          radius: 22,
          showTitle: false,
        ),
      if (pendingCount > 0)
        PieChartSectionData(
          value: pendingCount.toDouble(),
          color: _OylikColors.amber,
          radius: 22,
          showTitle: false,
        ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  OylikDaromadPages.getTxt(lang, "tolov_taqsimoti"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.pie_chart_rounded,
                size: 22,
                color: _OylikColors.primaryBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 124,
                height: 124,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace:
                        totalOrders > 0 && paidCount > 0 && pendingCount > 0
                            ? 3
                            : 0,
                        centerSpaceRadius: 36,
                        startDegreeOffset: -90,
                        sections: sections,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$paidPercent%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          OylikDaromadPages.getTxt(lang, "tolangan"),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendTile(
                      color: _OylikColors.green,
                      label: OylikDaromadPages.getTxt(lang, "tolangan"),
                      countText: "$paidCount $unit",
                      amountText: "${_formatMoney(paidAmount)} $currency",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildLegendTile(
                      color: _OylikColors.amber,
                      label: OylikDaromadPages.getTxt(lang, "kutilmoqda"),
                      countText: "$pendingCount $unit",
                      amountText: "${_formatMoney(pendingAmount)} $currency",
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendTile({
    required Color color,
    required String label,
    required String countText,
    required String amountText,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
              ),
              Text(
                countText,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amountText,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. SEARCH + FILTER BAR
  // ============================================================
  Widget _buildSearchAndFilterBar({
    required String lang,
    required bool isDark,
    required double maxWidth,
    required int allCount,
    required int paidCount,
    required int pendingCount,
  }) {
    final searchField = Container(
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: OylikDaromadPages.getTxt(lang, "qidirish"),
          hintStyle: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 22,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = "");
            },
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );

    final filterCapsule = Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterPill(
              label:
              "${OylikDaromadPages.getTxt(lang, "barchasi")} ($allCount)",
              selected: _activeFilter == _OylikFilter.all,
              activeColor: _OylikColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _OylikFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${OylikDaromadPages.getTxt(lang, "tolangan")} ($paidCount)",
              selected: _activeFilter == _OylikFilter.paid,
              activeColor: _OylikColors.green,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _OylikFilter.paid),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${OylikDaromadPages.getTxt(lang, "kutilmoqda")} ($pendingCount)",
              selected: _activeFilter == _OylikFilter.pending,
              activeColor: _OylikColors.amber,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _OylikFilter.pending),
            ),
          ),
        ],
      ),
    );

    if (maxWidth >= 700) {
      return Row(
        children: [
          Expanded(flex: 5, child: searchField),
          const SizedBox(width: 12),
          Expanded(flex: 6, child: filterCapsule),
        ],
      );
    }

    return Column(
      children: [
        searchField,
        const SizedBox(height: 10),
        filterCapsule,
      ],
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool selected,
    required Color activeColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(19),
          boxShadow: selected
              ? [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 4. ORDERS GRID & CARD
  // ============================================================
  Widget _buildOrdersGrid(
      BuildContext context, {
        required List<OrderModel> orders,
        required MahsulotProvider mahsulotProvider,
        required String lang,
        required bool isDark,
      }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32;
        const double spacing = 12;
        final int columns = maxWidth >= 700 ? 2 : 1;
        final double itemWidth =
            (maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: orders.map((order) {
            return SizedBox(
              width: itemWidth,
              child: _buildOrderCard(
                context,
                order: order,
                mahsulotProvider: mahsulotProvider,
                lang: lang,
                isDark: isDark,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildOrderCard(
      BuildContext context, {
        required OrderModel order,
        required MahsulotProvider mahsulotProvider,
        required String lang,
        required bool isDark,
      }) {
    final bool isPaid =
        order.paymentStatus == "To'langan" || order.status == "Sotildi";
    final Color paymentColor =
    isPaid ? _OylikColors.green : _OylikColors.amber;

    final product = mahsulotProvider.mahsulotlar.firstWhere(
          (m) => m.nomi == order.productName,
      orElse: () => MahsulotModel(
        nomi: "",
        bemorNarxi: "0",
        shifokorNarxi: "0",
        kategoriya: "Umumiy",
        keshbek: "0",
        status: "Faol",
      ),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF64748B).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderProductAvatar(
            product: product,
            productName: order.productName,
            isDark: isDark,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        order.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17.5,
                          height: 1.2,
                          color:
                          isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: paymentColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isPaid
                            ? OylikDaromadPages.getTxt(lang, "tolangan")
                            : OylikDaromadPages.getTxt(lang, "kutilmoqda"),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: paymentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  OylikDaromadPages.getTxt(lang, "sana"),
                  "${order.date.day} ${OylikDaromadPages.getTxt(lang, oylar[order.date.month])} ${order.date.year}",
                  isDark,
                ),
                _buildInfoRow(
                  OylikDaromadPages.getTxt(lang, "narxi"),
                  "${_formatMoney(order.price)} ${OylikDaromadPages.getTxt(lang, "valyuta")}",
                  isDark,
                  valueColor: isDark
                      ? _OylikColors.skyBlue
                      : _OylikColors.primaryBlue,
                ),
                _buildInfoRow(
                  OylikDaromadPages.getTxt(lang, "mijoz"),
                  order.customerName.trim().isEmpty
                      ? OylikDaromadPages.getTxt(lang, "klent")
                      : order.customerName,
                  isDark,
                ),
                _buildInfoRow(
                  OylikDaromadPages.getTxt(lang, "soni"),
                  "${order.quantity} ${OylikDaromadPages.getTxt(lang, "dona")}",
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderProductAvatar({
    required MahsulotModel product,
    required String productName,
    required bool isDark,
  }) {
    final String? rasm = product.rasm;
    final bool hasImage = rasm != null && rasm.trim().isNotEmpty;
    final String initial = productName.trim().isNotEmpty
        ? productName.trim()[0].toUpperCase()
        : "?";

    Widget fallback() {
      return Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color:
            isDark ? _OylikColors.skyBlue : _OylikColors.primaryBlue,
          ),
        ),
      );
    }

    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark
            ? const Color(0xFF0F172A)
            : _OylikColors.primaryBlue.withValues(alpha: 0.1),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : _OylikColors.primaryBlue.withValues(alpha: 0.18),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: hasImage
            ? (rasm.startsWith('http')
            ? Image.network(
          rasm,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        )
            : Image.file(
          File(rasm),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        ))
            : fallback(),
      ),
    );
  }

  Widget _buildInfoRow(
      String label,
      String value,
      bool isDark, {
        Color? valueColor,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: valueColor ??
                    (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrdersCard({
    required bool isDark,
    required String message,
    required bool showClearButton,
    String? clearLabel,
    VoidCallback? onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: isDark ? _OylikColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _OylikColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              showClearButton
                  ? Icons.search_off_rounded
                  : Icons.receipt_long_outlined,
              size: 32,
              color: _OylikColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
          if (showClearButton && onClear != null && clearLabel != null) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                clearLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _OylikColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}