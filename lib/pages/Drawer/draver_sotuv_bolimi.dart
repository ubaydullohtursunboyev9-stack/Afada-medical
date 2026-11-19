import 'dart:ui';

import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/sale_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/mijoz_modeli.dart';
import '../../model/model_provider.dart';
import '../../provider/mijoz_provider/mijoz_provider.dart';
import '../../provider/order_provider.dart';
import '../../provider/profile_provider.dart';

String _formatPhoneDisplay(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^\d]'), '').trim();
  if (digits.isEmpty) return "";

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

  final trimmed = raw.trim();
  if (trimmed.startsWith('+')) return trimmed;
  return '+$digits';
}

class DraverSotuvBolimi extends StatefulWidget {
  const DraverSotuvBolimi({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "sotuv_bolimi": "Sotuv bo'limi",
      "restricted_msg": "Bu bo'lim faqat Administrator uchun mavjud.",
      "umumiy_tushum": "Umumiy tushum",
      "jami_tolangan": "To'langan summa",
      "jami_qarzdorlik": "Qarzdorlik",
      "jami_sotuvlar": "Jami sotuvlar",
      "sotuv_dinamikasi": "So'nggi 7 kunlik sotuvlar",
      "tolov_ulushi": "To'lov holati taqsimoti",
      "barchasi": "Barchasi",
      "qidirish": "Mijoz, mahsulot, telefon yoki yuboruvchi...",
      "sotuvlar_royxati": "Sotuvlar tarixi",
      "sotilganlar_yoq": "Sotilgan mahsulotlar yo'q",
      "natija_topilmadi": "Qidiruv bo'yicha sotuvlar topilmadi",
      "mijoz": "Mijoz:",
      "tel": "Tel:",
      "yuboruvchi": "Yuboruvchi:",
      "mahsulot": "Mahsulot:",
      "soni": "Soni:",
      "sana": "Sana:",
      "jami_summa": "Jami summa:",
      "tolangan": "To'langan:",
      "qarz": "Qarz:",
      "tolov_holati": "To'lov holati:",
      "tolangan_status": "To'langan",
      "tolanmagan_status": "To'lanmagan",
      "mahsulot_sotish": "Mahsulot sotish",
      "savdo_turi": "Savdo turi",
      "bir_martalik": "Bir martalik mijoz",
      "doimiy_mijoz": "Doimiy mijoz",
      "mijoz_tanlang": "Mijoz tanlang",
      "mijoz_telefoni": "Mijoz telefoni",
      "mijoz_ismi": "Mijoz ismi",
      "telefon_raqami": "Telefon raqami",
      "mahsulot_tanlang": "Mahsulot tanlang",
      "sotish_narxi": "Sotish narxi",
      "chegirma": "Chegirma",
      "yuboruvchi_ixtiyoriy": "Yuboruvchi (Ixtiyoriy)",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "ochirish": "O'chirish",
      "sotuvni_ochirish": "Sotuvni o'chirish",
      "ochirish_tasdiq": "Haqiqatan ham ushbu sotuvni o'chirmoqchimisiz?",
      "zaxira_yetarli_emas": "Zaxirada yetarli mahsulot yo'q!",
      "miqdor_xato": "Miqdor kamida 1 dona bo'lishi kerak!",
      "muvaffaqiyat": "Sotuv muvaffaqiyatli amalga oshirildi!",
      "o'chirildi": "Muvaffaqiyatli o'chirildi",
      "xatolik": "Xatolik yuz berdi",
      "barcha_maydonlar": "Barcha majburiy maydonlarni to'ldiring!",
      "dona": "dona",
      "ta_sotuv": "ta",
      "mavjud": "Mavjud",
      "valyuta": "UZS",
      "tozalash": "Tozalash",
    },
    "Rus": {
      "sotuv_bolimi": "Отдел продаж",
      "restricted_msg": "Этот раздел доступен только администратору.",
      "umumiy_tushum": "Общая выручка",
      "jami_tolangan": "Оплачено всего",
      "jami_qarzdorlik": "Задолженность",
      "jami_sotuvlar": "Всего продаж",
      "sotuv_dinamikasi": "Продажи за последние 7 дней",
      "tolov_ulushi": "Распределение оплат",
      "barchasi": "Все",
      "qidirish": "Клиент, товар, телефон или отправитель...",
      "sotuvlar_royxati": "История продаж",
      "sotilganlar_yoq": "Проданных товаров нет",
      "natija_topilmadi": "По запросу ничего не найдено",
      "mijoz": "Клиент:",
      "tel": "Тел:",
      "yuboruvchi": "Отправитель:",
      "mahsulot": "Товар:",
      "soni": "Количество:",
      "sana": "Дата:",
      "jami_summa": "Общая сумма:",
      "tolangan": "Оплачено:",
      "qarz": "Долг:",
      "tolov_holati": "Статус оплаты:",
      "tolangan_status": "Оплачено",
      "tolanmagan_status": "Не оплачено",
      "mahsulot_sotish": "Продажа товара",
      "savdo_turi": "Тип продажи",
      "bir_martalik": "Разовый клиент",
      "doimiy_mijoz": "Постоянный клиент",
      "mijoz_tanlang": "Выберите клиента",
      "mijoz_telefoni": "Телефон клиента",
      "mijoz_ismi": "Имя клиента",
      "telefon_raqami": "Номер телефона",
      "mahsulot_tanlang": "Выберите товар",
      "sotish_narxi": "Цена продажи",
      "chegirma": "Скидка",
      "yuboruvchi_ixtiyoriy": "Отправитель (необязательно)",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "ochirish": "Удалить",
      "sotuvni_ochirish": "Удалить продажу",
      "ochirish_tasdiq": "Вы действительно хотите удалить эту продажу?",
      "zaxira_yetarli_emas": "Недостаточно товара на складе!",
      "miqdor_xato": "Количество должно быть не менее 1!",
      "muvaffaqiyat": "Продажа успешно завершена!",
      "o'chirildi": "Успешно удалено",
      "xatolik": "Произошла ошибка",
      "barcha_maydonlar": "Заполните все обязательные поля!",
      "dona": "шт",
      "ta_sotuv": "шт",
      "mavjud": "В наличии",
      "valyuta": "UZS",
      "tozalash": "Сбросить",
    },
    "Kiril": {
      "sotuv_bolimi": "Сотув бўлими",
      "restricted_msg": "Бу бўлим фақат Администратор учун мавжуд.",
      "umumiy_tushum": "Умумий тушум",
      "jami_tolangan": "Тўланган сумма",
      "jami_qarzdorlik": "Қарздорлик",
      "jami_sotuvlar": "Жами сотувлар",
      "sotuv_dinamikasi": "Сўнгги 7 кунлик сотувлар",
      "tolov_ulushi": "Тўлов ҳолати тақсимоти",
      "barchasi": "Барчаси",
      "qidirish": "Мижоз, маҳсулот, телефон ёки юборувчи...",
      "sotuvlar_royxati": "Сотувлар тарихи",
      "sotilganlar_yoq": "Сотилган маҳсулотлар йўқ",
      "natija_topilmadi": "Қидирув бўйича сотувлар топилмади",
      "mijoz": "Мижоз:",
      "tel": "Тел:",
      "yuboruvchi": "Юборувчи:",
      "mahsulot": "Маҳсулот:",
      "soni": "Сони:",
      "sana": "Сана:",
      "jami_summa": "Жами сумма:",
      "tolangan": "Тўланган:",
      "qarz": "Қарз:",
      "tolov_holati": "Тўлов ҳолати:",
      "tolangan_status": "Тўланган",
      "tolanmagan_status": "Тўланмаган",
      "mahsulot_sotish": "Маҳсулот сотиш",
      "savdo_turi": "Савдо тури",
      "bir_martalik": "Бир марталик мижоз",
      "doimiy_mijoz": "Доимий мижоз",
      "mijoz_tanlang": "Мижоз танланг",
      "mijoz_telefoni": "Мижоз телефони",
      "mijoz_ismi": "Мижоз исми",
      "telefon_raqami": "Телефон рақами",
      "mahsulot_tanlang": "Маҳсулот танланг",
      "sotish_narxi": "Сотиш нархи",
      "chegirma": "Чегирма",
      "yuboruvchi_ixtiyoriy": "Юборувчи (Ихтиёрий)",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "ochirish": "Ўчириш",
      "sotuvni_ochirish": "Сотувни ўчириш",
      "ochirish_tasdiq": "Ҳақиқатан ҳам ушбу сотувни ўчирмоқчимисиз?",
      "zaxira_yetarli_emas": "Захирада етарли маҳсулот йўқ!",
      "miqdor_xato": "Миқдор камида 1 дона бўлиши керак!",
      "muvaffaqiyat": "Сотув муваффақиятли амалга оширилди!",
      "o'chirildi": "Муваффақиятли ўчирилди",
      "xatolik": "Хатолик юз берди",
      "barcha_maydonlar": "Барча мажбурий майдонларни тўлдиринг!",
      "dona": "дона",
      "ta_sotuv": "та",
      "mavjud": "Мавжуд",
      "valyuta": "UZS",
      "tozalash": "Тозалаш",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts["Uzb"]?[key] ??
        key;
  }

  @override
  State<DraverSotuvBolimi> createState() => _DraverSotuvBolimiState();
}

class _DraverSotuvBolimiState extends State<DraverSotuvBolimi> {
  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _amber = Color(0xFFF59E0B);
  static const Color _indigo = Color(0xFF6366F1);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);
  static const Color _lightBg = Color(0xFFF8FAFC);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _paymentFilter = "all"; // all | paid | unpaid

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SaleProvider>().fetchSales();
      context.read<OrderProvider>().fetchSalesFromApi();
      context.read<MahsulotProvider>().loadProducts();
      context.read<MijozProvider>().loadMijozlar();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await context.read<SaleProvider>().fetchSales();
    if (!mounted) return;
    await context.read<OrderProvider>().fetchSalesFromApi();
    if (!mounted) return;
    await context.read<MahsulotProvider>().loadProducts();
    if (!mounted) return;
    await context.read<MijozProvider>().loadMijozlar();
  }

  String _formatMoney(num value) {
    return NumberFormat('#,###', 'en_US')
        .format(value)
        .replaceAll(',', ' ');
  }

  String _formatCompactAxis(double value) {
    if (value >= 1000000000) {
      return "${(value / 1000000000).toStringAsFixed(1)}B";
    }
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    }
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}K";
    }
    return value.toInt().toString();
  }

  Future<void> _makePhoneCall(String rawPhone) async {
    final digits = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.isEmpty) return;
    final formatted = digits.startsWith('+')
        ? digits
        : (digits.startsWith('998') ? '+$digits' : '+998$digits');
    final uri = Uri(scheme: 'tel', path: formatted);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<ProfileProvider>().language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color cardBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final String currency = DraverSotuvBolimi.getTxt(lang, "valyuta");

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.point_of_sale_rounded,
                size: 22,
                color: isDark ? _skyBlue : _primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                DraverSotuvBolimi.getTxt(lang, "sotuv_bolimi"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: DraverSotuvBolimi.getTxt(lang, "mahsulot_sotish"),
            onPressed: () => _showSotishDialog(context),
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.add_shopping_cart_rounded,
                size: 20,
                color: isDark ? _skyBlue : _primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [_skyBlue, _primaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _primaryBlue.withValues(alpha: 0.38),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => _showSotishDialog(context),
              child: const Center(
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer2<SaleProvider, MahsulotProvider>(
        builder: (context, saleProvider, mahsulotProvider, child) {
          final sotilganlar = saleProvider.sales;

          if (saleProvider.isLoading && sotilganlar.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _primaryBlue),
            );
          }

          final double jamiTushum = saleProvider.totalRevenue;
          final double jamiTolangan = sotilganlar.fold<double>(
            0.0,
                (sum, s) => sum + s.amountPaid,
          );
          final double jamiQarz = sotilganlar.fold<double>(
            0.0,
                (sum, s) => sum + (s.debt > 0 ? s.debt : 0),
          );
          final int jamiDona = sotilganlar.fold<int>(
            0,
                (sum, s) => sum + s.quantity,
          );
          final int paidCount =
              sotilganlar.where((s) => s.debt <= 0).length;
          final int unpaidCount =
              sotilganlar.where((s) => s.debt > 0).length;

          // Filtrlangan ro'yxat
          final filteredSales = sotilganlar.where((o) {
            if (_paymentFilter == "paid" && o.debt > 0) return false;
            if (_paymentFilter == "unpaid" && o.debt <= 0) return false;

            if (_searchQuery.trim().isNotEmpty) {
              final q = _searchQuery.trim().toLowerCase();
              final phone = (o.customer?.telefon ?? o.phoneNumber ?? "")
                  .toLowerCase();
              final refName =
              o.referrer != null ? o.referrerName.toLowerCase() : "";
              if (!o.customerName.toLowerCase().contains(q) &&
                  !o.productName.toLowerCase().contains(q) &&
                  !phone.contains(q) &&
                  !refName.contains(q)) {
                return false;
              }
            }
            return true;
          }).toList();

          // So'nggi 7 kunlik sotuvlar statistikasi
          final now = DateTime.now();
          final List<DateTime> last7Days = List.generate(7, (i) {
            final d = now.subtract(Duration(days: 6 - i));
            return DateTime(d.year, d.month, d.day);
          });
          final List<double> dailyTotals = last7Days.map((day) {
            return sotilganlar
                .where((s) =>
            s.date.year == day.year &&
                s.date.month == day.month &&
                s.date.day == day.day)
                .fold<double>(0.0, (sum, s) => sum + s.jamiSumma);
          }).toList();

          return RefreshIndicator(
            color: _primaryBlue,
            onRefresh: _refreshAll,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxW = constraints.maxWidth;
                final double horizontalPad = maxW >= 900 ? 24 : 16;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPad,
                    12,
                    horizontalPad,
                    110,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ================================================
                          // KPI KARTALAR (2x2 mobil, 4x1 desktop)
                          // ================================================
                          LayoutBuilder(
                            builder: (context, kpiConstraints) {
                              final int cols =
                              kpiConstraints.maxWidth >= 820 ? 4 : 2;
                              const double gap = 12;
                              final double itemW =
                                  (kpiConstraints.maxWidth -
                                      gap * (cols - 1)) /
                                      cols;

                              return Wrap(
                                spacing: gap,
                                runSpacing: gap,
                                children: [
                                  SizedBox(
                                    width: itemW,
                                    child: _KpiMetricCard(
                                      title: DraverSotuvBolimi.getTxt(
                                          lang, "umumiy_tushum"),
                                      value:
                                      "${_formatMoney(jamiTushum)} $currency",
                                      icon: Icons.account_balance_wallet_rounded,
                                      accentColor: _primaryBlue,
                                      isHero: true,
                                      isSelected: _paymentFilter == "all",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(
                                            () => _paymentFilter = "all",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemW,
                                    child: _KpiMetricCard(
                                      title: DraverSotuvBolimi.getTxt(
                                          lang, "jami_tolangan"),
                                      value:
                                      "${_formatMoney(jamiTolangan)} $currency",
                                      icon: Icons.verified_rounded,
                                      accentColor: _emerald,
                                      isHero: false,
                                      isSelected: _paymentFilter == "paid",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _paymentFilter =
                                        _paymentFilter == "paid"
                                            ? "all"
                                            : "paid";
                                      }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemW,
                                    child: _KpiMetricCard(
                                      title: DraverSotuvBolimi.getTxt(
                                          lang, "jami_qarzdorlik"),
                                      value:
                                      "${_formatMoney(jamiQarz)} $currency",
                                      icon: Icons.pending_actions_rounded,
                                      accentColor:
                                      jamiQarz > 0 ? _rose : _amber,
                                      isHero: false,
                                      isSelected: _paymentFilter == "unpaid",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _paymentFilter =
                                        _paymentFilter == "unpaid"
                                            ? "all"
                                            : "unpaid";
                                      }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemW,
                                    child: _KpiMetricCard(
                                      title: DraverSotuvBolimi.getTxt(
                                          lang, "jami_sotuvlar"),
                                      value:
                                      "${sotilganlar.length} ${DraverSotuvBolimi.getTxt(lang, "ta_sotuv")} • $jamiDona ${DraverSotuvBolimi.getTxt(lang, "dona")}",
                                      icon: Icons.shopping_bag_rounded,
                                      accentColor: _indigo,
                                      isHero: false,
                                      isSelected: false,
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(
                                            () => _paymentFilter = "all",
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          // ================================================
                          // DIAGRAMMALAR (SOTUVLAR MAVJUD BO'LGANDA)
                          // ================================================
                          if (sotilganlar.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            LayoutBuilder(
                              builder: (context, chartConstraints) {
                                final bool sideBySide =
                                    chartConstraints.maxWidth >= 860;
                                final lineChartCard = _build7DaySalesChart(
                                  lang: lang,
                                  currency: currency,
                                  days: last7Days,
                                  totals: dailyTotals,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                );
                                final pieChartCard = _buildPaymentStatusChart(
                                  lang: lang,
                                  currency: currency,
                                  paidCount: paidCount,
                                  unpaidCount: unpaidCount,
                                  paidSum: jamiTolangan,
                                  debtSum: jamiQarz,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                );

                                if (sideBySide) {
                                  return Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 7, child: lineChartCard),
                                      const SizedBox(width: 14),
                                      Expanded(flex: 5, child: pieChartCard),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    lineChartCard,
                                    const SizedBox(height: 14),
                                    pieChartCard,
                                  ],
                                );
                              },
                            ),
                          ],

                          const SizedBox(height: 18),

                          // ================================================
                          // QIDIRUV VA FILTR KAPSULASI
                          // ================================================
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderColor),
                              boxShadow: isDark
                                  ? null
                                  : [
                                BoxShadow(
                                  color: const Color(0xFF0F172A)
                                      .withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _searchController,
                                  onChanged: (val) =>
                                      setState(() => _searchQuery = val),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: DraverSotuvBolimi.getTxt(
                                        lang, "qidirish"),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: textSecondary,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      size: 22,
                                      color: textSecondary,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                      icon: Icon(
                                        Icons.close_rounded,
                                        size: 20,
                                        color: textSecondary,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(
                                                () => _searchQuery = "");
                                      },
                                    )
                                        : null,
                                    filled: true,
                                    fillColor: isDark
                                        ? _slateDark.withValues(alpha: 0.65)
                                        : const Color(0xFFF1F5F9),
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 13,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _FilterCapsule(
                                        label:
                                        "${DraverSotuvBolimi.getTxt(lang, "barchasi")} (${sotilganlar.length})",
                                        selected: _paymentFilter == "all",
                                        activeColor: _primaryBlue,
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _paymentFilter = "all",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _FilterCapsule(
                                        label:
                                        "${DraverSotuvBolimi.getTxt(lang, "tolangan_status")} ($paidCount)",
                                        selected: _paymentFilter == "paid",
                                        activeColor: _emerald,
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _paymentFilter = "paid",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _FilterCapsule(
                                        label:
                                        "${DraverSotuvBolimi.getTxt(lang, "tolanmagan_status")} ($unpaidCount)",
                                        selected: _paymentFilter == "unpaid",
                                        activeColor: _rose,
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _paymentFilter = "unpaid",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ================================================
                          // RO'YXAT SARLAVHASI
                          // ================================================
                          Row(
                            children: [
                              Text(
                                DraverSotuvBolimi.getTxt(
                                    lang, "sotuvlar_royxati"),
                                style: TextStyle(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _primaryBlue.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${filteredSales.length}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? _skyBlue : _primaryBlue,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (_searchQuery.isNotEmpty ||
                                  _paymentFilter != "all")
                                TextButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = "";
                                      _paymentFilter = "all";
                                    });
                                  },
                                  child: Text(
                                    DraverSotuvBolimi.getTxt(lang, "tozalash"),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? _skyBlue : _primaryBlue,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ================================================
                          // SOTUVLAR KARTALARI (1 / 2 / 3 USTUN)
                          // ================================================
                          if (filteredSales.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 52,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    sotilganlar.isEmpty
                                        ? Icons.receipt_long_rounded
                                        : Icons.search_off_rounded,
                                    size: 54,
                                    color:
                                    textSecondary.withValues(alpha: 0.55),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    sotilganlar.isEmpty
                                        ? DraverSotuvBolimi.getTxt(
                                        lang, "sotilganlar_yoq")
                                        : DraverSotuvBolimi.getTxt(
                                        lang, "natija_topilmadi"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            LayoutBuilder(
                              builder: (context, gridConstraints) {
                                final double w = gridConstraints.maxWidth;
                                final int columns =
                                w >= 1140 ? 3 : (w >= 700 ? 2 : 1);
                                const double gap = 14;
                                final double cardWidth =
                                    (w - gap * (columns - 1)) / columns;

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: filteredSales.map((o) {
                                    final String? rawPhone =
                                        o.customer?.telefon ?? o.phoneNumber;
                                    final String formattedPhone =
                                    rawPhone != null
                                        ? _formatPhoneDisplay(rawPhone)
                                        : "";
                                    final bool isPaid = o.debt <= 0;

                                    return SizedBox(
                                      width: cardWidth,
                                      child: _SaleItemCard(
                                        productName: o.productName,
                                        customerName: o.customerName,
                                        phone: formattedPhone,
                                        referrerName: o.referrer != null
                                            ? o.referrerName
                                            : null,
                                        quantityText:
                                        "${o.quantity} ${DraverSotuvBolimi.getTxt(lang, "dona")}",
                                        dateText: DateFormat('dd.MM.yyyy HH:mm')
                                            .format(o.date),
                                        totalText:
                                        "${_formatMoney(o.jamiSumma)} $currency",
                                        paidText:
                                        "${_formatMoney(o.amountPaid)} $currency",
                                        debtText: o.debt > 0
                                            ? "${_formatMoney(o.debt)} $currency"
                                            : null,
                                        isPaid: isPaid,
                                        lang: lang,
                                        isDark: isDark,
                                        cardBg: cardBg,
                                        borderColor: borderColor,
                                        textPrimary: textPrimary,
                                        textSecondary: textSecondary,
                                        onCallTap: formattedPhone.isEmpty
                                            ? null
                                            : () => _makePhoneCall(rawPhone!),
                                        onDeleteTap: o.id == null
                                            ? null
                                            : () => _confirmDelete(
                                          context,
                                          o.id!,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // =========================================================================
  // 7 KUNLIK SOTUV DINAMIKASI GRAFIGI
  // =========================================================================

  Widget _build7DaySalesChart({
    required String lang,
    required String currency,
    required List<DateTime> days,
    required List<double> totals,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final double maxVal = totals.fold<double>(
      0.0,
          (prev, el) => el > prev ? el : prev,
    );
    final double chartMaxY = maxVal <= 0 ? 100000 : maxVal * 1.25;

    final List<FlSpot> spots = List.generate(
      totals.length,
          (i) => FlSpot(i.toDouble(), totals[i]),
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryBlue.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  size: 20,
                  color: isDark ? _skyBlue : _primaryBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  DraverSotuvBolimi.getTxt(lang, "sotuv_dinamikasi"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 205,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: chartMaxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMaxY / 4,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: borderColor.withValues(alpha: 0.65),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      interval: chartMaxY / 4,
                      getTitlesWidget: (value, meta) {
                        if (value < 0) return const SizedBox.shrink();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 6,
                          child: Text(
                            _formatCompactAxis(value),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            DateFormat('dd.MM').format(days[idx]),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) =>
                    isDark ? _slateDark : const Color(0xFF0F172A),
                    tooltipRoundedRadius: 12,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final idx = spot.x.toInt().clamp(0, days.length - 1);
                        final dateStr = DateFormat('dd.MM').format(days[idx]);
                        return LineTooltipItem(
                          "$dateStr\n${_formatMoney(spot.y)} $currency",
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    gradient: const LinearGradient(
                      colors: [_skyBlue, _primaryBlue],
                    ),
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeColor: _primaryBlue,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _skyBlue.withValues(alpha: 0.28),
                          _primaryBlue.withValues(alpha: 0.02),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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

  // =========================================================================
  // TO'LOV HOLATI DONUT DIAGRAMMASI
  // =========================================================================

  Widget _buildPaymentStatusChart({
    required String lang,
    required String currency,
    required int paidCount,
    required int unpaidCount,
    required double paidSum,
    required double debtSum,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final int total = paidCount + unpaidCount;
    final double paidPct = total > 0 ? (paidCount / total) * 100 : 0;
    final double unpaidPct = total > 0 ? (unpaidCount / total) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _emerald.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  size: 20,
                  color: _emerald,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  DraverSotuvBolimi.getTxt(lang, "tolov_ulushi"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 145,
                height: 165,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 42,
                        startDegreeOffset: -90,
                        sections: [
                          PieChartSectionData(
                            value: paidCount > 0 ? paidCount.toDouble() : 0.01,
                            color: _emerald,
                            radius: 22,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: unpaidCount > 0
                                ? unpaidCount.toDouble()
                                : (paidCount > 0 ? 0.0 : 0.01),
                            color: _rose,
                            radius: 22,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${paidPct.round()}%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          DraverSotuvBolimi.getTxt(lang, "tolangan_status"),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
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
                    _LegendItem(
                      color: _emerald,
                      title: DraverSotuvBolimi.getTxt(lang, "tolangan_status"),
                      countText: "$paidCount (${paidPct.round()}%)",
                      amountText: "${_formatMoney(paidSum)} $currency",
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 16),
                    _LegendItem(
                      color: _rose,
                      title:
                      DraverSotuvBolimi.getTxt(lang, "tolanmagan_status"),
                      countText: "$unpaidCount (${unpaidPct.round()}%)",
                      amountText: "${_formatMoney(debtSum)} $currency",
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
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

  // =========================================================================
  // O'CHIRISH TASDIQLASH DIALOGI (FROSTED GLASS)
  // =========================================================================

  void _confirmDelete(BuildContext pageContext, int id) {
    final saleProvider = pageContext.read<SaleProvider>();
    final orderProvider = pageContext.read<OrderProvider>();
    final mahsulotProvider = pageContext.read<MahsulotProvider>();
    final finishedProvider = pageContext.read<FinishedProductProvider>();
    final messenger = ScaffoldMessenger.of(pageContext);
    final lang = pageContext.read<ProfileProvider>().language;

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'delete_sale',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        final bool isDark =
            Theme.of(dialogContext).brightness == Brightness.dark;
        final Color textPrimary =
        isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              contentPadding: EdgeInsets.zero,
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? _cardDark.withValues(alpha: 0.94)
                            : Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: _rose.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: _rose,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            DraverSotuvBolimi.getTxt(lang, "sotuvni_ochirish"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DraverSotuvBolimi.getTxt(lang, "ochirish_tasdiq"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.35,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    side: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    DraverSotuvBolimi.getTxt(
                                        lang, "bekor_qilish"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(dialogContext);
                                    try {
                                      await saleProvider.deleteSale(id);
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            DraverSotuvBolimi.getTxt(
                                                lang, "o'chirildi"),
                                          ),
                                          backgroundColor: _emerald,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );

                                      try {
                                        await orderProvider.fetchSalesFromApi();
                                        await mahsulotProvider.loadProducts();
                                        await finishedProvider
                                            .fetchFinishedProducts();
                                      } catch (e) {
                                        debugPrint("Refresh error: $e");
                                      }
                                    } catch (e) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            DraverSotuvBolimi.getTxt(
                                                lang, "xatolik"),
                                          ),
                                          backgroundColor: _rose,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _rose,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    DraverSotuvBolimi.getTxt(lang, "ochirish"),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // MAHSULOT SOTISH DIALOGI
  // =========================================================================

  void _showSotishDialog(BuildContext pageContext) {
    final lang = pageContext.read<ProfileProvider>().language;
    showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (_) => _AddSaleDialog(lang: lang),
    );
  }
}

// ===========================================================================
// KPI METRIC CARD
// ===========================================================================

class _KpiMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final bool isHero;
  final bool isSelected;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _KpiMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.isHero,
    required this.isSelected,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHero ? null : cardBg,
            gradient: isHero
                ? const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            borderRadius: BorderRadius.circular(20),
            border: isHero
                ? null
                : Border.all(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.75)
                  : borderColor,
              width: isSelected ? 1.6 : 1.0,
            ),
            boxShadow: isHero
                ? [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ]
                : (isDark
                ? null
                : [
              BoxShadow(
                color:
                const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: isHero
                          ? Colors.white.withValues(alpha: 0.18)
                          : accentColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 21,
                      color: isHero ? Colors.white : accentColor,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected && !isHero)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isHero
                      ? Colors.white.withValues(alpha: 0.85)
                      : textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isHero ? Colors.white : textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String countText;
  final String amountText;
  final Color textPrimary;
  final Color textSecondary;

  const _LegendItem({
    required this.color,
    required this.title,
    required this.countText,
    required this.amountText,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 11,
          height: 11,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title • $countText",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  amountText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterCapsule extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterCapsule({
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? activeColor
                : (isDark
                ? const Color(0xFF0B132B).withValues(alpha: 0.7)
                : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? activeColor
                  : (isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0)),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF334155)),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// SOTUV KARTASI
// ===========================================================================

class _SaleItemCard extends StatelessWidget {
  final String productName;
  final String customerName;
  final String phone;
  final String? referrerName;
  final String quantityText;
  final String dateText;
  final String totalText;
  final String paidText;
  final String? debtText;
  final bool isPaid;
  final String lang;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback? onCallTap;
  final VoidCallback? onDeleteTap;

  const _SaleItemCard({
    required this.productName,
    required this.customerName,
    required this.phone,
    required this.referrerName,
    required this.quantityText,
    required this.dateText,
    required this.totalText,
    required this.paidText,
    required this.debtText,
    required this.isPaid,
    required this.lang,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onCallTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
    isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SARLAVHA: MAHSULOT + TO'LOV HOLATI
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 22,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1)
                                .withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            quantityText,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isPaid
                                ? DraverSotuvBolimi.getTxt(
                                lang, "tolangan_status")
                                : DraverSotuvBolimi.getTxt(
                                lang, "tolanmagan_status"),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onDeleteTap != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onDeleteTap,
                  tooltip: DraverSotuvBolimi.getTxt(lang, "ochirish"),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFF43F5E),
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // MIJOZ, TELEFON, YUBORUVCHI, SANA
          _InfoLine(
            icon: Icons.person_rounded,
            label: DraverSotuvBolimi.getTxt(lang, "mijoz"),
            value: customerName,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_rounded, size: 17, color: textSecondary),
                const SizedBox(width: 8),
                Text(
                  DraverSotuvBolimi.getTxt(lang, "tel"),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: onCallTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.call_rounded,
                          size: 14,
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (referrerName != null && referrerName!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoLine(
              icon: Icons.send_rounded,
              label: DraverSotuvBolimi.getTxt(lang, "yuboruvchi"),
              value: referrerName!,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ],
          const SizedBox(height: 8),
          _InfoLine(
            icon: Icons.schedule_rounded,
            label: DraverSotuvBolimi.getTxt(lang, "sana"),
            value: dateText,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 14),

          // MOLIYAVIY BLOK
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B132B).withValues(alpha: 0.55)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.75),
              ),
            ),
            child: Column(
              children: [
                _MoneyRow(
                  label: DraverSotuvBolimi.getTxt(lang, "jami_summa"),
                  value: totalText,
                  valueColor: textPrimary,
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 6),
                _MoneyRow(
                  label: DraverSotuvBolimi.getTxt(lang, "tolangan"),
                  value: paidText,
                  valueColor: const Color(0xFF10B981),
                  textSecondary: textSecondary,
                ),
                if (debtText != null) ...[
                  const SizedBox(height: 6),
                  _MoneyRow(
                    label: DraverSotuvBolimi.getTxt(lang, "qarz"),
                    value: debtText!,
                    valueColor: const Color(0xFFF43F5E),
                    textSecondary: textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;

  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MoneyRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color textSecondary;

  const _MoneyRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// MAHSULOT SOTISH DIALOGI (STATEFULWIDGET — LEAK-FREE)
// ===========================================================================

class _AddSaleDialog extends StatefulWidget {
  final String lang;

  const _AddSaleDialog({required this.lang});

  @override
  State<_AddSaleDialog> createState() => _AddSaleDialogState();
}

class _AddSaleDialogState extends State<_AddSaleDialog> {
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);

  MahsulotModel? _selectedMahsulot;
  MijozModel? _selectedMijoz;
  MijozModel? _selectedReferrer;

  String _savdoTuri = "Bir martalik mijoz";
  String _tolovHolati = "To'landi";
  bool _isSubmitting = false;
  String? _inlineError;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController =
  TextEditingController(text: "+998 ");
  final TextEditingController _soniController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _chegirmaController =
  TextEditingController(text: "0");
  final TextEditingController _jamiSummaController = TextEditingController();
  final TextEditingController _tolanganSummaController =
  TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _soniController.dispose();
    _priceController.dispose();
    _chegirmaController.dispose();
    _jamiSummaController.dispose();
    _tolanganSummaController.dispose();
    super.dispose();
  }

  String _formatMoney(num val) {
    return NumberFormat('#,###', 'en_US')
        .format(val < 0 ? 0 : val)
        .replaceAll(',', ' ');
  }

  double _parseNum(String text) {
    return double.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
  }

  void _recalculateTotals({bool syncPaidIfFull = true}) {
    if (_selectedMahsulot == null) {
      _jamiSummaController.clear();
      return;
    }
    final double p = _parseNum(_selectedMahsulot!.bemorNarxi);
    final int q =
        int.tryParse(_soniController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            0;
    final double d = _parseNum(_chegirmaController.text);
    final double total = (p * q) - d;
    final String formatted = _formatMoney(total < 0 ? 0 : total);

    _jamiSummaController.text = formatted;
    if (syncPaidIfFull && _tolovHolati == "To'landi") {
      _tolanganSummaController.text = formatted;
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
    String? helperText,
    bool readOnly = false,
  }) {
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final Color fillColor = readOnly
        ? (isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFE2E8F0).withValues(alpha: 0.55))
        : (isDark
        ? _slateDark.withValues(alpha: 0.65)
        : const Color(0xFFF8FAFC));

    return InputDecoration(
      labelText: label,
      helperText: helperText,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: fillColor,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.6),
      ),
    );
  }

  Future<void> _submitSale() async {
    final lang = widget.lang;
    final bool isDoimiy = _savdoTuri == "Doimiy mijoz";
    final bool mijozTanlangan = isDoimiy
        ? _selectedMijoz != null
        : _phoneController.text.trim().length >= 5;

    if (_selectedMahsulot == null ||
        !mijozTanlangan ||
        _soniController.text.trim().isEmpty) {
      setState(() {
        _inlineError = DraverSotuvBolimi.getTxt(lang, "barcha_maydonlar");
      });
      return;
    }

    final int quantity = int.tryParse(
      _soniController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    ) ??
        0;

    if (quantity <= 0) {
      setState(() {
        _inlineError = DraverSotuvBolimi.getTxt(lang, "miqdor_xato");
      });
      return;
    }

    if (quantity > _selectedMahsulot!.zaxira) {
      setState(() {
        _inlineError = DraverSotuvBolimi.getTxt(lang, "zaxira_yetarli_emas");
      });
      return;
    }

    setState(() {
      _inlineError = null;
      _isSubmitting = true;
    });

    final saleProvider = context.read<SaleProvider>();
    final orderProvider = context.read<OrderProvider>();
    final mahsulotProvider = context.read<MahsulotProvider>();
    final finishedProductProvider = context.read<FinishedProductProvider>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      final double paid = _tolovHolati == "To'landi"
          ? _parseNum(_tolanganSummaController.text)
          : 0.0;
      final double discount = _parseNum(_chegirmaController.text);

      await saleProvider.addSale(
        productId: _selectedMahsulot!.id!,
        saleType: isDoimiy ? 'client' : 'patient',
        quantity: quantity,
        paid: paid,
        customerId: _selectedMijoz?.id,
        referrerId: _selectedReferrer?.id,
        phoneNumber: isDoimiy ? null : _phoneController.text,
        discount: discount,
      );

      await orderProvider.fetchSalesFromApi();
      await mahsulotProvider.loadProducts();
      await finishedProductProvider.fetchFinishedProducts();

      if (mounted) {
        Navigator.pop(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(DraverSotuvBolimi.getTxt(lang, "muvaffaqiyat")),
            backgroundColor: _emerald,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inlineError = DraverSotuvBolimi.getTxt(lang, "xatolik");
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final mahsulotProvider = context.watch<MahsulotProvider>();
    final mijozProvider = context.watch<MijozProvider>();

    final Color dialogBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final media = MediaQuery.of(context);
    final double maxDialogWidth =
    media.size.width >= 640 ? 520 : media.size.width - 28;
    final double maxDialogHeight =
    (media.size.height - media.viewInsets.bottom - 140)
        .clamp(280.0, 580.0);

    final MijozModel? safeReferrer =
    mijozProvider.mijozlar.contains(_selectedReferrer)
        ? _selectedReferrer
        : null;

    return AlertDialog(
      backgroundColor: dialogBg,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 16, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _primaryBlue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.point_of_sale_rounded,
              size: 22,
              color: isDark ? _skyBlue : _primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              DraverSotuvBolimi.getTxt(lang, "mahsulot_sotish"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, color: textSecondary),
          ),
        ],
      ),
      content: SizedBox(
        width: maxDialogWidth,
        height: maxDialogHeight,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_inlineError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: _rose.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _rose.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: _rose,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _inlineError!,
                          style: TextStyle(
                            color: isDark ? Colors.white : _rose,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // SAVDO TURI
              DropdownButtonFormField<String>(
                initialValue: _savdoTuri,
                isExpanded: true,
                dropdownColor: dialogBg,
                decoration: _inputDecoration(
                  label: DraverSotuvBolimi.getTxt(lang, "savdo_turi"),
                  icon: Icons.swap_horizontal_circle_outlined,
                  isDark: isDark,
                ),
                items: const [
                  "Bir martalik mijoz",
                  "Doimiy mijoz",
                ]
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      DraverSotuvBolimi.getTxt(
                        lang,
                        e == "Bir martalik mijoz"
                            ? "bir_martalik"
                            : "doimiy_mijoz",
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _savdoTuri = val;
                    _selectedMijoz = null;
                    _inlineError = null;
                    _nameController.clear();
                    _phoneController.text = "+998 ";
                  });
                },
              ),

              const SizedBox(height: 14),

              // DOIMIY MIJOZ YOKI BIR MARTALIK MIJOZ
              if (_savdoTuri == "Doimiy mijoz") ...[
                LayoutBuilder(
                  builder: (context, fieldConstraints) {
                    return Autocomplete<MijozModel>(
                      displayStringForOption: (m) => "${m.ism} ${m.familya}",
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return mijozProvider.mijozlar;
                        }
                        final query = textEditingValue.text.toLowerCase();
                        final rawQuery = query.replaceAll(RegExp(r'\D'), '');
                        return mijozProvider.mijozlar.where((m) {
                          final fullName =
                          "${m.ism} ${m.familya}".toLowerCase();
                          final phone = m.telefon.replaceAll(' ', '');
                          return m.ism.toLowerCase().contains(query) ||
                              m.familya.toLowerCase().contains(query) ||
                              fullName.contains(query) ||
                              (rawQuery.isNotEmpty &&
                                  phone.contains(rawQuery));
                        });
                      },
                      onSelected: (MijozModel val) {
                        setState(() {
                          _selectedMijoz = val;
                          _inlineError = null;
                          _phoneController.text = _formatPhoneDisplay(val.telefon);
                        });
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: _inputDecoration(
                            label: DraverSotuvBolimi.getTxt(
                                lang, "mijoz_tanlang"),
                            icon: Icons.search_rounded,
                            isDark: isDark,
                          ),
                          onSubmitted: (_) => onFieldSubmitted(),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 6,
                            color: dialogBg,
                            borderRadius: BorderRadius.circular(14),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: fieldConstraints.maxWidth,
                                maxHeight: 220,
                              ),
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                shrinkWrap: true,
                                itemCount: options.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: borderColor,
                                ),
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  final displayTel = _formatPhoneDisplay(option.telefon);
                                  return ListTile(
                                    dense: true,
                                    title: Text(
                                      "${option.ism} ${option.familya}",
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    subtitle: Text(
                                      displayTel,
                                      style: TextStyle(
                                        color: textSecondary,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                if (_selectedMijoz != null) ...[
                  const SizedBox(height: 14),
                  TextField(
                    controller: _phoneController,
                    readOnly: true,
                    decoration: _inputDecoration(
                      label: DraverSotuvBolimi.getTxt(lang, "mijoz_telefoni"),
                      icon: Icons.phone_android_outlined,
                      isDark: isDark,
                      readOnly: true,
                    ),
                  ),
                ],
              ] else ...[
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration(
                    label: DraverSotuvBolimi.getTxt(lang, "mijoz_ismi"),
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_UzPhoneInputFormatter()],
                  decoration: _inputDecoration(
                    label: DraverSotuvBolimi.getTxt(lang, "telefon_raqami"),
                    icon: Icons.phone_android_outlined,
                    isDark: isDark,
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // MAHSULOT TANLASH
              LayoutBuilder(
                builder: (context, fieldConstraints) {
                  return Autocomplete<MahsulotModel>(
                    displayStringForOption: (m) => m.nomi,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      final options = mahsulotProvider.mahsulotlar
                          .where((m) => m.zaxira > 0);
                      if (textEditingValue.text.isEmpty) {
                        return options;
                      }
                      return options.where(
                            (m) => m.nomi
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()),
                      );
                    },
                    onSelected: (MahsulotModel val) {
                      setState(() {
                        _selectedMahsulot = val;
                        _inlineError = null;
                        final double p = _parseNum(val.bemorNarxi);
                        _priceController.text = _formatMoney(p);
                        if (_soniController.text.isEmpty) {
                          _soniController.text = "1";
                        }
                        _recalculateTotals(syncPaidIfFull: true);
                      });
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: _inputDecoration(
                          label: DraverSotuvBolimi.getTxt(
                              lang, "mahsulot_tanlang"),
                          icon: Icons.inventory_2_outlined,
                          isDark: isDark,
                        ),
                        onSubmitted: (_) => onFieldSubmitted(),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 6,
                          color: dialogBg,
                          borderRadius: BorderRadius.circular(14),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: fieldConstraints.maxWidth,
                              maxHeight: 220,
                            ),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              shrinkWrap: true,
                              itemCount: options.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: borderColor,
                              ),
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    option.nomi,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _emerald.withValues(alpha: 0.14),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${option.zaxira} ${DraverSotuvBolimi.getTxt(lang, "dona")}",
                                      style: const TextStyle(
                                        color: _emerald,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              // MAHSULOT TANLANGANDAN KEYIN
              if (_selectedMahsulot != null) ...[
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _soniController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => setState(() {
                          _inlineError = null;
                          _recalculateTotals(syncPaidIfFull: true);
                        }),
                        decoration: _inputDecoration(
                          label: DraverSotuvBolimi.getTxt(lang, "soni"),
                          icon: Icons.shopping_cart_outlined,
                          isDark: isDark,
                          helperText:
                          "${DraverSotuvBolimi.getTxt(lang, "mavjud")}: ${_selectedMahsulot!.zaxira}",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: _priceController,
                        readOnly: true,
                        decoration: _inputDecoration(
                          label:
                          DraverSotuvBolimi.getTxt(lang, "sotish_narxi"),
                          icon: Icons.paid_outlined,
                          isDark: isDark,
                          readOnly: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chegirmaController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _CurrencyInputFormatter(),
                        ],
                        onChanged: (_) => setState(() {
                          _inlineError = null;
                          _recalculateTotals(syncPaidIfFull: true);
                        }),
                        decoration: _inputDecoration(
                          label: DraverSotuvBolimi.getTxt(lang, "chegirma"),
                          icon: Icons.discount_outlined,
                          isDark: isDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _jamiSummaController,
                        readOnly: true,
                        decoration: _inputDecoration(
                          label: DraverSotuvBolimi.getTxt(lang, "jami_summa"),
                          icon: Icons.receipt_long_outlined,
                          isDark: isDark,
                          readOnly: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              // TO'LOV HOLATI
              DropdownButtonFormField<String>(
                initialValue: _tolovHolati,
                isExpanded: true,
                dropdownColor: dialogBg,
                decoration: _inputDecoration(
                  label: DraverSotuvBolimi.getTxt(lang, "tolov_holati"),
                  icon: Icons.account_balance_wallet_outlined,
                  isDark: isDark,
                ),
                items: const [
                  "To'landi",
                  "To'lanmadi",
                ]
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      DraverSotuvBolimi.getTxt(
                        lang,
                        e == "To'landi"
                            ? "tolangan_status"
                            : "tolanmagan_status",
                      ),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _tolovHolati = val;
                    if (_tolovHolati == "To'landi") {
                      _recalculateTotals(syncPaidIfFull: true);
                    } else {
                      _tolanganSummaController.clear();
                    }
                  });
                },
              ),

              if (_tolovHolati == "To'landi") ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _tolanganSummaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CurrencyInputFormatter(),
                  ],
                  decoration: _inputDecoration(
                    label: DraverSotuvBolimi.getTxt(lang, "tolangan"),
                    icon: Icons.paid_outlined,
                    isDark: isDark,
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // YUBORUVCHI (IXTIYORIY)
              DropdownButtonFormField<MijozModel>(
                initialValue: safeReferrer,
                isExpanded: true,
                dropdownColor: dialogBg,
                decoration: _inputDecoration(
                  label:
                  DraverSotuvBolimi.getTxt(lang, "yuboruvchi_ixtiyoriy"),
                  icon: Icons.send_outlined,
                  isDark: isDark,
                ),
                items: mijozProvider.mijozlar
                    .map(
                      (m) => DropdownMenuItem(
                    value: m,
                    child: Text(
                      "${m.ism} ${m.familya}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                    .toList(),
                onChanged: (val) => setState(() => _selectedReferrer = val),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  DraverSotuvBolimi.getTxt(lang, "bekor_qilish"),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSale,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  DraverSotuvBolimi.getTxt(lang, "saqlash"),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final double? value = double.tryParse(digits);
    if (value == null) return oldValue;

    final String formattedText =
    NumberFormat('#,###', 'en_US').format(value).replaceAll(',', ' ');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _UzPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final String text = newValue.text;

    if (text.length < 5) {
      return const TextEditingValue(
        text: '+998 ',
        selection: TextSelection.collapsed(offset: 5),
      );
    }

    if (!text.startsWith('+998 ')) {
      return oldValue;
    }

    String digits = text.substring(5).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    final StringBuffer result = StringBuffer('+998 ');
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || i == 7) {
        result.write(' ');
      }
      result.write(digits[i]);
    }

    final String formatted = result.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}