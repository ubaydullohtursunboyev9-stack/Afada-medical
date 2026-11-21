import 'dart:io';

import 'package:afada/provider/profile_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/model_provider.dart';
import '../../model/order_model.dart';
import '../../provider/order_provider.dart';
import '../home_pages.dart';

// ============================================================
// CLINICAL COLORS (Boshqa sahifalar bilan bir xil rang tizimi)
// ============================================================
class _KunlikColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF8FAFC);
}

enum _KunlikFilter { all, paid, pending }

class KunlikDaromadPages extends StatefulWidget {
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
      "barchasi": "Barchasi",
      "buyurtmalar": "Buyurtmalar",
      "haftalik_trend": "Oxirgi 7 kunlik daromad",
      "tolov_taqsimoti": "Bugungi to'lov holati",
      "qidirish": "Mahsulot, mijoz yoki raqam...",
      "natija_topilmadi": "Qidiruv bo'yicha buyurtma topilmadi",
      "filtrni_tozalash": "Filtrni tozalash",
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
      "valyuta": "UZS",
      "phone_placeholder": "90 123 45 67",
      "barchasi": "Все",
      "buyurtmalar": "Заказы",
      "haftalik_trend": "Доход за последние 7 дней",
      "tolov_taqsimoti": "Статус оплат за сегодня",
      "qidirish": "Товар, клиент или номер...",
      "natija_topilmadi": "Заказы не найдены",
      "filtrni_tozalash": "Сбросить фильтр",
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
      "valyuta": "UZS",
      "phone_placeholder": "90 123 45 67",
      "barchasi": "Барчаси",
      "buyurtmalar": "Буюртмалар",
      "haftalik_trend": "Охирги 7 кунлик даромад",
      "tolov_taqsimoti": "Бугунги тўлов ҳолати",
      "qidirish": "Маҳсулот, мижоз ёки рақам...",
      "natija_topilmadi": "Қидирув бўйича буюртма топилмади",
      "filtrni_tozalash": "Филтрни тозалаш",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? _localizedTexts["Uzb"]?[key] ?? key;
  }

  @override
  State<KunlikDaromadPages> createState() => _KunlikDaromadPagesState();
}

class _KunlikDaromadPagesState extends State<KunlikDaromadPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _KunlikFilter _activeFilter = _KunlikFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatMoney(double amount) {
    return NumberFormat('#,###').format(amount).replaceAll(',', ' ');
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.isEmpty) return;
    String normalized = digits;
    if (!normalized.startsWith('+')) {
      normalized = normalized.startsWith('998')
          ? '+$normalized'
          : '+998$normalized';
    }
    final Uri launchUri = Uri(scheme: 'tel', path: normalized);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

  String _formatPhoneDisplay(String phone, String lang) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (digits.isEmpty) {
      return KunlikDaromadPages.getTxt(lang, "phone_placeholder");
    }

    if (digits.startsWith('998') && digits.length == 12) {
      final cc = digits.substring(0, 3);
      final code = digits.substring(3, 5);
      final p1 = digits.substring(5, 8);
      final p2 = digits.substring(8, 10);
      final p3 = digits.substring(10, 12);
      return '+$cc $code $p1 $p2 $p3';
    }

    if (digits.length == 9) {
      final code = digits.substring(0, 2);
      final p1 = digits.substring(2, 5);
      final p2 = digits.substring(5, 7);
      final p3 = digits.substring(7, 9);
      return '+998 $code $p1 $p2 $p3';
    }

    final trimmed = phone.trim();
    if (trimmed.startsWith('+')) return trimmed;
    return '+$digits';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer3<OrderProvider, ProfileProvider, MahsulotProvider>(
      builder:
          (context, orderProvider, profileProvider, mahsulotProvider, child) {
        final now = DateTime.now();
        final String lang = profileProvider.language;

        final todayOrders = orderProvider.orders
            .where((o) =>
        o.date.year == now.year &&
            o.date.month == now.month &&
            o.date.day == now.day)
            .toList();

        final double displayRevenue = orderProvider.orders
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

        final int displayProductsSold = orderProvider.orders
            .where((o) =>
        (o.paymentStatus == "To'langan" || o.status == "Sotildi") &&
            o.date.year == now.year &&
            o.date.month == now.month &&
            o.date.day == now.day)
            .fold(0, (sum, o) => sum + o.quantity);

        final int paidCount = todayOrders
            .where(
                (o) => o.paymentStatus == "To'langan" || o.status == "Sotildi")
            .length;
        final int pendingCount = todayOrders.length - paidCount;

        final double pendingAmount = todayOrders
            .where(
                (o) => o.paymentStatus != "To'langan" && o.status != "Sotildi")
            .fold(0.0, (sum, o) => sum + (o.price * o.quantity));

        final String query = _searchQuery.trim().toLowerCase();
        final List<OrderModel> filteredOrders = todayOrders.where((o) {
          final bool isPaid =
              o.paymentStatus == "To'langan" || o.status == "Sotildi";
          if (_activeFilter == _KunlikFilter.paid && !isPaid) return false;
          if (_activeFilter == _KunlikFilter.pending && isPaid) return false;
          if (query.isEmpty) return true;
          return o.productName.toLowerCase().contains(query) ||
              o.customerName.toLowerCase().contains(query) ||
              o.phone.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor:
          isDark ? _KunlikColors.slateDark : _KunlikColors.lightBg,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    KunlikDaromadPages.getTxt(lang, "kunlik_daromad"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? _KunlikColors.cardDark
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: _KunlikColors.primaryBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd.MM.yyyy').format(now),
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                orderProvider.fetchSalesFromApi(),
                mahsulotProvider.loadProducts(),
              ]);
            },
            color: _KunlikColors.primaryBlue,
            backgroundColor: isDark ? _KunlikColors.cardDark : Colors.white,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double contentMaxWidth =
                constraints.maxWidth > 1080 ? 1080 : constraints.maxWidth;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 48),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. KPI STATISTIKA KARTALARI
                          _buildSummaryCards(
                            lang: lang,
                            isDark: isDark,
                            displayRevenue: displayRevenue,
                            displayProductsSold: displayProductsSold,
                            totalOrders: todayOrders.length,
                            paidCount: paidCount,
                            pendingCount: pendingCount,
                          ),
                          const SizedBox(height: 16),

                          // 2. DIAGRAMMALAR (7 kunlik dinamika + Bugungi to'lov taqsimoti)
                          _buildChartsSection(
                            lang: lang,
                            isDark: isDark,
                            maxWidth: contentMaxWidth - 32,
                            allOrders: orderProvider.orders,
                            now: now,
                            paidAmount: displayRevenue,
                            pendingAmount: pendingAmount,
                            paidCount: paidCount,
                            pendingCount: pendingCount,
                          ),
                          const SizedBox(height: 16),

                          // 3. QIDIRUV VA KAPSULA FILTR
                          if (todayOrders.isNotEmpty) ...[
                            _buildSearchAndFilterBar(
                              lang: lang,
                              isDark: isDark,
                              maxWidth: contentMaxWidth - 32,
                              allCount: todayOrders.length,
                              paidCount: paidCount,
                              pendingCount: pendingCount,
                            ),
                            const SizedBox(height: 14),
                          ],

                          // 4. BUYURTMALAR RO'YXATI SARLAVHASI
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: _KunlikColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: _KunlikColors.primaryBlue,
                                  size: 21,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  KunlikDaromadPages.getTxt(
                                      lang, "kunlik_buyurtmalar"),
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
                                  color: _KunlikColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${filteredOrders.length} ${KunlikDaromadPages.getTxt(lang, "ta")}",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: _KunlikColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 5. BUYURTMALAR KARTALARI
                          if (todayOrders.isEmpty)
                            _buildEmptyOrdersCard(
                              isDark: isDark,
                              message: KunlikDaromadPages.getTxt(
                                  lang, "bugun_buyurtmalar_yoq"),
                              showClearButton: false,
                            )
                          else if (filteredOrders.isEmpty)
                            _buildEmptyOrdersCard(
                              isDark: isDark,
                              message: KunlikDaromadPages.getTxt(
                                  lang, "natija_topilmadi"),
                              clearLabel: KunlikDaromadPages.getTxt(
                                  lang, "filtrni_tozalash"),
                              showClearButton: true,
                              onClear: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                  _activeFilter = _KunlikFilter.all;
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
    required double displayRevenue,
    required int displayProductsSold,
    required int totalOrders,
    required int paidCount,
    required int pendingCount,
  }) {
    final unit = KunlikDaromadPages.getTxt(lang, "ta");
    final dona = KunlikDaromadPages.getTxt(lang, "dona");
    final currency = KunlikDaromadPages.getTxt(lang, "valyuta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: KunlikDaromadPages.getTxt(lang, "daromad")
                .replaceAll(':', ''),
            icon: Icons.insights_rounded,
            iconColor: _KunlikColors.green,
            mainValue: "${_formatMoney(displayRevenue)} $currency",
            subLabel1: KunlikDaromadPages.getTxt(lang, "sotilganlar"),
            subVal1: "$displayProductsSold $dona",
            subLabel2: KunlikDaromadPages.getTxt(lang, "bugungi_kun"),
            subVal2: DateFormat('dd.MM').format(DateTime.now()),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: KunlikDaromadPages.getTxt(lang, "buyurtmalar"),
            icon: Icons.shopping_bag_rounded,
            iconColor: _KunlikColors.primaryBlue,
            mainValue: "$totalOrders $unit",
            subLabel1: KunlikDaromadPages.getTxt(lang, "tolangan"),
            subVal1: "$paidCount $unit",
            subLabel2: KunlikDaromadPages.getTxt(lang, "kutilmoqda"),
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
        color: isDark ? _KunlikColors.cardDark : Colors.white,
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
  // 2. INTERAKTIV DIAGRAMMALAR (7 KUNLIK WAVE + TO'LOV DONUT)
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
    final waveChartCard = _build7DayWaveChartCard(
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

  Widget _build7DayWaveChartCard({
    required String lang,
    required bool isDark,
    required List<OrderModel> allOrders,
    required DateTime now,
  }) {
    final days = List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return d;
    });

    final data = days.map((date) {
      return allOrders
          .where((o) =>
      (o.paymentStatus == "To'langan" || o.status == "Sotildi") &&
          o.date.year == date.year &&
          o.date.month == date.month &&
          o.date.day == date.day)
          .fold<double>(0.0, (sum, o) {
        if (o.status == "Sotildi") return sum + (o.price * o.quantity);
        return sum + o.amountPaid;
      });
    }).toList();

    final labels = days.map((d) => DateFormat('dd.MM').format(d)).toList();
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
    final currency = KunlikDaromadPages.getTxt(lang, "valyuta");

    return Container(
      height: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _KunlikColors.cardDark : Colors.white,
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
                  KunlikDaromadPages.getTxt(lang, "haftalik_trend"),
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
                color: _KunlikColors.skyBlue,
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
                          final bool isToday = idx == labels.length - 1;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 6,
                            child: Text(
                              labels[idx],
                              style: TextStyle(
                                color: isToday
                                    ? _KunlikColors.primaryBlue
                                    : (isDark
                                    ? Colors.white54
                                    : const Color(0xFF64748B)),
                                fontWeight:
                                isToday ? FontWeight.w900 : FontWeight.w700,
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
                    color: _KunlikColors.skyBlue,
                    barWidth: 3.2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final bool isToday = index == spots.length - 1;
                        return FlDotCirclePainter(
                          radius: isToday ? 5.5 : 4.2,
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          strokeWidth: isToday ? 3 : 2.3,
                          strokeColor: isToday
                              ? _KunlikColors.primaryBlue
                              : _KunlikColors.skyBlue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _KunlikColors.skyBlue
                              .withValues(alpha: isDark ? 0.35 : 0.25),
                          _KunlikColors.skyBlue.withValues(alpha: 0.0),
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
    final String unit = KunlikDaromadPages.getTxt(lang, "ta");
    final String currency = KunlikDaromadPages.getTxt(lang, "valyuta");

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
          color: _KunlikColors.green,
          radius: 22,
          showTitle: false,
        ),
      if (pendingCount > 0)
        PieChartSectionData(
          value: pendingCount.toDouble(),
          color: _KunlikColors.amber,
          radius: 22,
          showTitle: false,
        ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _KunlikColors.cardDark : Colors.white,
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
                  KunlikDaromadPages.getTxt(lang, "tolov_taqsimoti"),
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
                color: _KunlikColors.green,
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
                        sectionsSpace: totalOrders > 0 && paidCount > 0 && pendingCount > 0 ? 3 : 0,
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
                          KunlikDaromadPages.getTxt(lang, "tolangan"),
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
                      color: _KunlikColors.green,
                      label: KunlikDaromadPages.getTxt(lang, "tolangan"),
                      countText: "$paidCount $unit",
                      amountText: "${_formatMoney(paidAmount)} $currency",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    _buildLegendTile(
                      color: _KunlikColors.amber,
                      label: KunlikDaromadPages.getTxt(lang, "kutilmoqda"),
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
        color: isDark ? _KunlikColors.cardDark : Colors.white,
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
          hintText: KunlikDaromadPages.getTxt(lang, "qidirish"),
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
        color: isDark ? _KunlikColors.cardDark : const Color(0xFFF1F5F9),
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
              "${KunlikDaromadPages.getTxt(lang, "barchasi")} ($allCount)",
              selected: _activeFilter == _KunlikFilter.all,
              activeColor: _KunlikColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _KunlikFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${KunlikDaromadPages.getTxt(lang, "tolangan")} ($paidCount)",
              selected: _activeFilter == _KunlikFilter.paid,
              activeColor: _KunlikColors.green,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _KunlikFilter.paid),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${KunlikDaromadPages.getTxt(lang, "kutilmoqda")} ($pendingCount)",
              selected: _activeFilter == _KunlikFilter.pending,
              activeColor: _KunlikColors.amber,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _KunlikFilter.pending),
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
  // 4. BUYURTMALAR GRIDI VA KARTASI
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
    final bool isPaid = order.paymentStatus == "To'langan";
    final bool isSold = order.status == "Sotildi";
    final Color paymentColor =
    isPaid ? _KunlikColors.green : _KunlikColors.amber;

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
        color: isDark ? _KunlikColors.cardDark : Colors.white,
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
                                  ? KunlikDaromadPages.getTxt(lang, "tolangan")
                                  : KunlikDaromadPages.getTxt(
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
                      _buildOrderInfoRow(
                        KunlikDaromadPages.getTxt(lang, "narxi"),
                        "${_formatMoney(order.price)} ${KunlikDaromadPages.getTxt(lang, "valyuta")}",
                        isDark,
                        valueColor: isDark
                            ? _KunlikColors.skyBlue
                            : _KunlikColors.primaryBlue,
                      ),
                      _buildOrderInfoRow(
                        KunlikDaromadPages.getTxt(lang, "mijoz"),
                        order.customerName.trim().isEmpty
                            ? KunlikDaromadPages.getTxt(lang, "default_mijoz")
                            : order.customerName,
                        isDark,
                      ),
                      _buildOrderInfoRow(
                        KunlikDaromadPages.getTxt(lang, "soni"),
                        "${order.quantity} ${KunlikDaromadPages.getTxt(lang, "dona")}",
                        isDark,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "${KunlikDaromadPages.getTxt(lang, "nomer")} ",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white60
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => _makePhoneCall(order.phone),
                              child: Text(
                                _formatPhoneDisplay(order.phone, lang),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: _KunlikColors.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                if (!isSold) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: _KunlikColors.green,
                        backgroundColor:
                        _KunlikColors.green.withValues(alpha: 0.12),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => _showStatusDialog(
                          context, order, orderProvider, lang),
                      icon: const Icon(Icons.check_circle_outline_rounded,
                          size: 18),
                      label: Text(
                        KunlikDaromadPages.getTxt(lang, "sotildi"),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isDark
                          ? Colors.white
                          : _KunlikColors.primaryBlue,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : _KunlikColors.primaryBlue.withValues(alpha: 0.1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      HomePages().showBuyurtmaDialog(context, order: order);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(
                      KunlikDaromadPages.getTxt(lang, "tahrirlash"),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
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
            color: isDark
                ? _KunlikColors.skyBlue
                : _KunlikColors.primaryBlue,
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
            : _KunlikColors.primaryBlue.withValues(alpha: 0.1),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : _KunlikColors.primaryBlue.withValues(alpha: 0.18),
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

  Widget _buildOrderInfoRow(
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
        color: isDark ? _KunlikColors.cardDark : Colors.white,
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
              color: _KunlikColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              showClearButton
                  ? Icons.search_off_rounded
                  : Icons.receipt_long_outlined,
              size: 32,
              color: _KunlikColors.primaryBlue,
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
                foregroundColor: _KunlikColors.primaryBlue,
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
      String lang,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? _KunlikColors.cardDark : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
                color: _KunlikColors.green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 30,
                color: _KunlikColors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              KunlikDaromadPages.getTxt(lang, "buyurtma_holati"),
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              KunlikDaromadPages.getTxt(lang, "sotilgan_belgilash"),
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
                      KunlikDaromadPages.getTxt(lang, "bekor_qilish"),
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
                      backgroundColor: _KunlikColors.green,
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
                      KunlikDaromadPages.getTxt(lang, "sotildi"),
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
      ),
    );
  }
}