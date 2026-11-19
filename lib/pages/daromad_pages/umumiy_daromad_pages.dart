import 'dart:io';

import 'package:afada/model/mahsulot_modeli.dart';
import 'package:afada/model/model_provider.dart';
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
class _UmumiyColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color cardDark = Color(0xFF1C2541);
}

enum _UmumiyFilter { all, paid, pending }

class UmumiyDaromadPages extends StatefulWidget {
  const UmumiyDaromadPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "umumiy_daromad": "Umumiy daromad",
      "umumiy_buyurtmalar": "Umumiy buyurtmalar",
      "sotilganlar": "Sotilganlar:",
      "buyurtmalar": "Buyurtmalar:",
      "jami": "Jami:",
      "narxi": "Narxi:",
      "mijoz": "Mijoz:",
      "soni": "Soni:",
      "tolov": "To'lov:",
      "tolangan": "To'langan",
      "kutilmoqda": "Kutilmoqda",
      "nomer": "Nomer:",
      "tahrirlash": "Tahrirlash",
      "vaqt": "Vaqt:",
      "sana": "Sana:",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "buyurtmani_tahrirlash": "Buyurtmani tahrirlash",
      "buyurtma_holati": "Buyurtma holati",
      "sotildi": "Sotildi",
      "sotilgan_belgilash": "Bu buyurtmani sotilgan deb belgilamoqchimisiz?",
      "umumiy_hisobot": "Umumiy hisobot",
      "mening_hisobotim": "Mening hisobotim",
      "jami_sotildi": "Jami sotildi:",
      "jami_tayyorlandi": "Jami tayyorlandi:",
      "dona": "dona",
      "ta": "ta",
      "umumiy_summa": "Umumiy summa:",
      "valyuta": "UZS",
      "buyurtmalar_mavjud_emas": "Buyurtmalar mavjud emas",
      "ish_haqqi": "Ish haqqi:",
      "klent": "Klent",
      "holatni_ozgartirish": "Holatni o'zgartirish",
      "barchasi": "Barchasi",
      "yillik_trend": "Oylar kesimida daromad",
      "tolov_taqsimoti": "Umumiy to'lov holati",
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
      "Yan": "Yan",
      "Fev": "Fev",
      "Mar": "Mar",
      "Apr": "Apr",
      "May_short": "May",
      "Iyun_short": "Iyun",
      "Iyul_short": "Iyul",
      "Avg": "Avg",
      "Sen": "Sen",
      "Okt": "Okt",
      "Noy": "Noy",
      "Dek": "Dek",
    },
    "Rus": {
      "umumiy_daromad": "Общий доход",
      "umumiy_buyurtmalar": "Общие заказы",
      "sotilganlar": "Продано:",
      "buyurtmalar": "Заказы:",
      "jami": "Итого:",
      "narxi": "Цена:",
      "mijoz": "Клиент:",
      "soni": "Количество:",
      "tolov": "Оплата:",
      "tolangan": "Оплачено",
      "kutilmoqda": "Ожидается",
      "nomer": "Номер:",
      "tahrirlash": "Редактировать",
      "vaqt": "Время:",
      "sana": "Дата:",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "buyurtmani_tahrirlash": "Редактировать заказ",
      "buyurtma_holati": "Статус заказа",
      "sotildi": "Продано",
      "sotilgan_belgilash": "Вы хотите отметить этот заказ как проданный?",
      "umumiy_hisobot": "Общий отчет",
      "mening_hisobotim": "Мой отчет",
      "jami_sotildi": "Всего продано:",
      "jami_tayyorlandi": "Всего подготовлено:",
      "dona": "шт",
      "ta": "шт",
      "umumiy_summa": "Общая сумма:",
      "valyuta": "UZS",
      "buyurtmalar_mavjud_emas": "Заказов нет",
      "ish_haqqi": "Зарплата:",
      "klent": "Клиент",
      "holatni_ozgartirish": "Изменить статус",
      "barchasi": "Все",
      "yillik_trend": "Доход по месяцам",
      "tolov_taqsimoti": "Общий статус оплат",
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
      "Yan": "Янв",
      "Fev": "Фев",
      "Mar": "Мар",
      "Apr": "Апр",
      "May_short": "Май",
      "Iyun_short": "Июн",
      "Iyul_short": "Июл",
      "Avg": "Авг",
      "Sen": "Сен",
      "Okt": "Окт",
      "Noy": "Ноя",
      "Dek": "Дек",
    },
    "Kiril": {
      "umumiy_daromad": "Умумий даромад",
      "umumiy_buyurtmalar": "Умумий буюртмалар",
      "sotilganlar": "Сотилганлар:",
      "buyurtmalar": "Буюртмалар:",
      "jami": "Жами:",
      "narxi": "Нархи:",
      "mijoz": "Мижоз:",
      "soni": "Сони:",
      "tolov": "Тўлов:",
      "tolangan": "Тўланган",
      "kutilmoqda": "Кутилмоқда",
      "nomer": "Номер:",
      "tahrirlash": "Таҳрирлаш",
      "vaqt": "Вақт:",
      "sana": "Сана:",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "buyurtmani_tahrirlash": "Буюртмани таҳрирлаш",
      "buyurtma_holati": "Буюртма ҳолати",
      "sotildi": "Сотилди",
      "sotilgan_belgilash": "Бу буюртмани сотилган деб белгиламоқчимисиз?",
      "umumiy_hisobot": "Умумий ҳисобот",
      "mening_hisobotim": "Менинг ҳисоботим",
      "jami_sotildi": "Жами сотилди:",
      "jami_tayyorlandi": "Жами тайёрланди:",
      "dona": "дона",
      "ta": "та",
      "umumiy_summa": "Умумий сумма:",
      "valyuta": "UZS",
      "buyurtmalar_mavjud_emas": "Буюртмалар мавжуд эмас",
      "ish_haqqi": "Иш ҳаққи:",
      "klent": "Клент",
      "holatni_ozgartirish": "Ҳолатни ўзгартириш",
      "barchasi": "Барчаси",
      "yillik_trend": "Ойлар кесимида даромад",
      "tolov_taqsimoti": "Умумий тўлов ҳолати",
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
      "Yan": "Янв",
      "Fev": "Фев",
      "Mar": "Мар",
      "Apr": "Апр",
      "May_short": "Май",
      "Iyun_short": "Июн",
      "Iyul_short": "Июл",
      "Avg": "Авг",
      "Sen": "Сен",
      "Okt": "Окт",
      "Noy": "Ноя",
      "Dek": "Дек",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? _localizedTexts["Uzb"]?[key] ?? key;
  }

  @override
  State<UmumiyDaromadPages> createState() => _UmumiyDaromadPagesState();
}

class _UmumiyDaromadPagesState extends State<UmumiyDaromadPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _UmumiyFilter _activeFilter = _UmumiyFilter.all;

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

  static const List<String> _shortMonthKeys = [
    'Yan',
    'Fev',
    'Mar',
    'Apr',
    'May_short',
    'Iyun_short',
    'Iyul_short',
    'Avg',
    'Sen',
    'Okt',
    'Noy',
    'Dek',
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

    return Consumer3<OrderProvider, ProfileProvider, MahsulotProvider>(
      builder:
          (context, orderProvider, profileProvider, mahsulotProvider, child) {
        final String lang = profileProvider.language;
        final now = DateTime.now();
        final allOrders = orderProvider.orders;

        final paidOrders = allOrders.where(
              (o) => o.paymentStatus == "To'langan" || o.status == "Sotildi",
        );

        final double totalRevenue = paidOrders.fold(0.0, (sum, o) {
          if (o.status == "Sotildi") {
            return sum + (o.price * o.quantity);
          }
          return sum + o.amountPaid;
        });

        final int totalProductsCount =
        paidOrders.fold(0, (sum, o) => sum + o.quantity);
        final int totalTaskCount = allOrders.length;

        final int paidCount = paidOrders.length;
        final int pendingCount = allOrders.length - paidCount;

        final double pendingAmount = allOrders
            .where(
              (o) => o.paymentStatus != "To'langan" && o.status != "Sotildi",
        )
            .fold(0.0, (sum, o) => sum + (o.price * o.quantity));

        final String query = _searchQuery.trim().toLowerCase();
        final List<OrderModel> filteredOrders = allOrders.where((o) {
          final bool isPaid =
              o.paymentStatus == "To'langan" || o.status == "Sotildi";
          if (_activeFilter == _UmumiyFilter.paid && !isPaid) return false;
          if (_activeFilter == _UmumiyFilter.pending && isPaid) return false;
          if (query.isEmpty) return true;
          return o.productName.toLowerCase().contains(query) ||
              o.customerName.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                orderProvider.fetchSalesFromApi(),
                mahsulotProvider.loadProducts(),
              ]);
            },
            color: _UmumiyColors.primaryBlue,
            backgroundColor: isDark ? _UmumiyColors.cardDark : Colors.white,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double contentMaxWidth =
                constraints.maxWidth > 1080 ? 1080 : constraints.maxWidth;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. KPI SUMMARY CARDS
                          _buildSummaryCards(
                            lang: lang,
                            isDark: isDark,
                            totalProducts: totalProductsCount,
                            totalOrders: totalTaskCount,
                            totalRevenue: totalRevenue,
                            paidCount: paidCount,
                            pendingCount: pendingCount,
                          ),
                          const SizedBox(height: 16),

                          // 2. INTERAKTIV DIAGRAMMALAR
                          _buildChartsSection(
                            lang: lang,
                            isDark: isDark,
                            maxWidth: contentMaxWidth - 32,
                            allOrders: allOrders,
                            now: now,
                            paidAmount: totalRevenue,
                            pendingAmount: pendingAmount,
                            paidCount: paidCount,
                            pendingCount: pendingCount,
                          ),
                          const SizedBox(height: 16),

                          // 3. QIDIRUV VA KAPSULA FILTR
                          if (allOrders.isNotEmpty) ...[
                            _buildSearchAndFilterBar(
                              lang: lang,
                              isDark: isDark,
                              maxWidth: contentMaxWidth - 32,
                              allCount: allOrders.length,
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
                                  color: _UmumiyColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: _UmumiyColors.primaryBlue,
                                  size: 21,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  UmumiyDaromadPages.getTxt(
                                      lang, "umumiy_buyurtmalar"),
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
                                  color: _UmumiyColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${filteredOrders.length} ${UmumiyDaromadPages.getTxt(lang, "ta")}",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: _UmumiyColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 5. BUYURTMALAR RO'YXATI
                          if (allOrders.isEmpty)
                            _buildEmptyOrdersCard(
                              isDark: isDark,
                              message: UmumiyDaromadPages.getTxt(
                                  lang, "buyurtmalar_mavjud_emas"),
                              showClearButton: false,
                            )
                          else if (filteredOrders.isEmpty)
                            _buildEmptyOrdersCard(
                              isDark: isDark,
                              message: UmumiyDaromadPages.getTxt(
                                  lang, "natija_topilmadi"),
                              clearLabel: UmumiyDaromadPages.getTxt(
                                  lang, "filtrni_tozalash"),
                              showClearButton: true,
                              onClear: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                  _activeFilter = _UmumiyFilter.all;
                                });
                              },
                            )
                          else
                            _buildOrdersGrid(
                              context,
                              orders: filteredOrders,
                              mahsulotProvider: mahsulotProvider,
                              orderProvider: orderProvider,
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
        );
      },
    );
  }

  // ============================================================
  // 1. KPI SUMMARY CARDS
  // ============================================================
  Widget _buildSummaryCards({
    required String lang,
    required bool isDark,
    required int totalProducts,
    required int totalOrders,
    required double totalRevenue,
    required int paidCount,
    required int pendingCount,
  }) {
    final String unit = UmumiyDaromadPages.getTxt(lang, "ta");
    final String dona = UmumiyDaromadPages.getTxt(lang, "dona");
    final String currency = UmumiyDaromadPages.getTxt(lang, "valyuta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: UmumiyDaromadPages.getTxt(lang, "umumiy_hisobot"),
            icon: Icons.analytics_rounded,
            iconColor: _UmumiyColors.green,
            mainValue: "${_formatMoney(totalRevenue)} $currency",
            subLabel1: UmumiyDaromadPages.getTxt(lang, "jami_sotildi"),
            subVal1: "$totalProducts $dona",
            subLabel2: UmumiyDaromadPages.getTxt(lang, "buyurtmalar"),
            subVal2: "$totalOrders $unit",
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: UmumiyDaromadPages.getTxt(lang, "umumiy_buyurtmalar"),
            icon: Icons.shopping_bag_rounded,
            iconColor: _UmumiyColors.primaryBlue,
            mainValue: "$totalOrders $unit",
            subLabel1: UmumiyDaromadPages.getTxt(lang, "tolangan"),
            subVal1: "$paidCount $unit",
            subLabel2: UmumiyDaromadPages.getTxt(lang, "kutilmoqda"),
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
        color: isDark ? _UmumiyColors.cardDark : Colors.white,
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
  // 2. INTERAKTIV DIAGRAMMALAR (12 OYLIK WAVE + TO'LOV DONUT)
  // ============================================================
  Widget _buildChartsSection({
    required String lang,
    required bool isDark,
    required double maxWidth,
    required List<OrderModel> allOrders,
    required DateTime now,
    required double paidAmount,
    required double pendingAmount,
    required int paidCount,
    required int pendingCount,
  }) {
    final waveChartCard = _buildYearlyWaveChartCard(
      lang: lang,
      isDark: isDark,
      allOrders: allOrders,
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

  Widget _buildYearlyWaveChartCard({
    required String lang,
    required bool isDark,
    required List<OrderModel> allOrders,
    required DateTime now,
  }) {
    final data = List.generate(12, (index) {
      final int targetMonth = index + 1;
      return allOrders
          .where((o) =>
      o.date.year == now.year &&
          o.date.month == targetMonth &&
          (o.paymentStatus == "To'langan" || o.status == "Sotildi"))
          .fold<double>(0.0, (sum, o) {
        if (o.status == "Sotildi") return sum + (o.price * o.quantity);
        return sum + o.amountPaid;
      });
    });

    final labels = _shortMonthKeys
        .map((k) => UmumiyDaromadPages.getTxt(lang, k))
        .toList();

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
    final currency = UmumiyDaromadPages.getTxt(lang, "valyuta");

    return Container(
      height: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _UmumiyColors.cardDark : Colors.white,
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
                  "${UmumiyDaromadPages.getTxt(lang, "yillik_trend")} (${now.year})",
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
                color: _UmumiyColors.skyBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
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
                          final bool isCurrentMonth = (idx + 1) == now.month;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 6,
                            child: Text(
                              labels[idx],
                              style: TextStyle(
                                color: isCurrentMonth
                                    ? _UmumiyColors.primaryBlue
                                    : (isDark
                                    ? Colors.white54
                                    : const Color(0xFF64748B)),
                                fontWeight: isCurrentMonth
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                                fontSize: 10.5,
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
                    color: _UmumiyColors.skyBlue,
                    barWidth: 3.2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final bool isCurrentMonth = (index + 1) == now.month;
                        return FlDotCirclePainter(
                          radius: isCurrentMonth ? 5.5 : 4.0,
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          strokeWidth: isCurrentMonth ? 3 : 2.2,
                          strokeColor: isCurrentMonth
                              ? _UmumiyColors.primaryBlue
                              : _UmumiyColors.skyBlue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _UmumiyColors.skyBlue
                              .withValues(alpha: isDark ? 0.35 : 0.25),
                          _UmumiyColors.skyBlue.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
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
    final String unit = UmumiyDaromadPages.getTxt(lang, "ta");
    final String currency = UmumiyDaromadPages.getTxt(lang, "valyuta");

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
          color: _UmumiyColors.green,
          radius: 22,
          showTitle: false,
        ),
      if (pendingCount > 0)
        PieChartSectionData(
          value: pendingCount.toDouble(),
          color: _UmumiyColors.amber,
          radius: 22,
          showTitle: false,
        ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _UmumiyColors.cardDark : Colors.white,
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
                  UmumiyDaromadPages.getTxt(lang, "tolov_taqsimoti"),
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
                color: _UmumiyColors.green,
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
                          UmumiyDaromadPages.getTxt(lang, "tolangan"),
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
                      color: _UmumiyColors.green,
                      label: UmumiyDaromadPages.getTxt(lang, "tolangan"),
                      countText: "$paidCount $unit",
                      amountText: "${_formatMoney(paidAmount)} $currency",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildLegendTile(
                      color: _UmumiyColors.amber,
                      label: UmumiyDaromadPages.getTxt(lang, "kutilmoqda"),
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
        color: isDark ? _UmumiyColors.cardDark : Colors.white,
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
          hintText: UmumiyDaromadPages.getTxt(lang, "qidirish"),
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
        color: isDark ? _UmumiyColors.cardDark : const Color(0xFFF1F5F9),
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
              "${UmumiyDaromadPages.getTxt(lang, "barchasi")} ($allCount)",
              selected: _activeFilter == _UmumiyFilter.all,
              activeColor: _UmumiyColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _UmumiyFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${UmumiyDaromadPages.getTxt(lang, "tolangan")} ($paidCount)",
              selected: _activeFilter == _UmumiyFilter.paid,
              activeColor: _UmumiyColors.green,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _UmumiyFilter.paid),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${UmumiyDaromadPages.getTxt(lang, "kutilmoqda")} ($pendingCount)",
              selected: _activeFilter == _UmumiyFilter.pending,
              activeColor: _UmumiyColors.amber,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _UmumiyFilter.pending),
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
        required OrderProvider orderProvider,
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
                orderProvider: orderProvider,
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
        required OrderProvider orderProvider,
        required String lang,
        required bool isDark,
      }) {
    final bool isPaid =
        order.paymentStatus == "To'langan" || order.status == "Sotildi";
    final bool isSold = order.status == "Sotildi";
    final Color paymentColor =
    isPaid ? _UmumiyColors.green : _UmumiyColors.amber;

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
      decoration: BoxDecoration(
        color: isDark ? _UmumiyColors.cardDark : Colors.white,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
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
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
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
                                  ? UmumiyDaromadPages.getTxt(lang, "tolangan")
                                  : UmumiyDaromadPages.getTxt(
                                  lang, "kutilmoqda"),
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
                        UmumiyDaromadPages.getTxt(lang, "sana"),
                        "${order.date.day} ${UmumiyDaromadPages.getTxt(lang, oylar[order.date.month])} ${order.date.year}",
                        isDark,
                      ),
                      _buildInfoRow(
                        UmumiyDaromadPages.getTxt(lang, "narxi"),
                        "${_formatMoney(order.price)} ${UmumiyDaromadPages.getTxt(lang, "valyuta")}",
                        isDark,
                        valueColor: isDark
                            ? _UmumiyColors.skyBlue
                            : _UmumiyColors.primaryBlue,
                      ),
                      _buildInfoRow(
                        UmumiyDaromadPages.getTxt(lang, "mijoz"),
                        order.customerName.trim().isEmpty
                            ? UmumiyDaromadPages.getTxt(lang, "klent")
                            : order.customerName,
                        isDark,
                      ),
                      _buildInfoRow(
                        UmumiyDaromadPages.getTxt(lang, "soni"),
                        "${order.quantity} ${UmumiyDaromadPages.getTxt(lang, "dona")}",
                        isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isSold) ...[
            Divider(
              height: 1,
              color:
              isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: _UmumiyColors.green,
                    backgroundColor:
                    _UmumiyColors.green.withValues(alpha: 0.12),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () =>
                      _showStatusDialog(context, order, orderProvider),
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      size: 18),
                  label: Text(
                    UmumiyDaromadPages.getTxt(lang, "sotildi"),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            isDark ? _UmumiyColors.skyBlue : _UmumiyColors.primaryBlue,
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
            : _UmumiyColors.primaryBlue.withValues(alpha: 0.1),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : _UmumiyColors.primaryBlue.withValues(alpha: 0.18),
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
        color: isDark ? _UmumiyColors.cardDark : Colors.white,
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
              color: _UmumiyColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              showClearButton
                  ? Icons.search_off_rounded
                  : Icons.receipt_long_outlined,
              size: 32,
              color: _UmumiyColors.primaryBlue,
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
                foregroundColor: _UmumiyColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showStatusDialog(
      BuildContext context,
      OrderModel order,
      OrderProvider provider,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final String lang = profileProvider.language;

          return AlertDialog(
            backgroundColor: isDark ? _UmumiyColors.cardDark : Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
              side: BorderSide(
                color:
                isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _UmumiyColors.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 30,
                    color: _UmumiyColors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  UmumiyDaromadPages.getTxt(lang, "buyurtma_holati"),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  UmumiyDaromadPages.getTxt(lang, "sotilgan_belgilash"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          UmumiyDaromadPages.getTxt(lang, "bekor_qilish"),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _UmumiyColors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          provider.updateOrderStatus(order.id, "Sotildi");
                          Navigator.pop(dialogContext);
                        },
                        child: Text(
                          UmumiyDaromadPages.getTxt(lang, "sotildi"),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}