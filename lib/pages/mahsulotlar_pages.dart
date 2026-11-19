import 'dart:io';
import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/mahsulot_modeli.dart';
import '../model/model_provider.dart';
import '../provider/profile_provider.dart';

// ============================================================
// CLINICAL COLORS (Boshqa sahifalar bilan bir xil rang tizimi)
// ============================================================
class _MahsulotColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF8FAFC);
}

enum _MahsulotFilter { all, active, inactive }

class MahsulotlarPages extends StatefulWidget {
  const MahsulotlarPages({super.key});

  @override
  State<MahsulotlarPages> createState() => _MahsulotlarPagesState();

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Mahsulot": "Mahsulot",
      "Mahsulot qo'shish": "Mahsulot qo'shish",
      "Ma'lumot kiritilmagan": "Ma'lumot kiritilmagan",
      "Bekor qilish": "Bekor qilish",
      "Saqlash": "Saqlash",
      "Mahsulot nomi": "Mahsulot nomi",
      "Bemor narxi": "Bemor narxi",
      "Shifokor narxi": "Shifokor narxi",
      "Kategoriya": "Kategoriya",
      "Keshbek": "Keshbek",
      "Status": "Status",
      "Faol": "Faol",
      "Nofaol": "Nofaol",
      "Umumiy": "Umumiy",
      "Tahrirlash": "Tahrirlash",
      "O'chirish": "O'chirish",
      "Yangilash": "Yangilash",
      "Kamera": "Kamera",
      "Galereya": "Galereya",
      "Ma'lumotlarni to'liq kiriting": "Ma'lumotlarni to'liq kiriting",
      "UZS": "UZS",
      "Mahsulotni o'chirish": "Mahsulotni o'chirish",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
      "Mahsulot qidirish": "Mahsulot nomi bo'yicha qidirish...",
      "Mahsulot topilmadi": "Mahsulot topilmadi",
      "Barchasi": "Barchasi",
      "Jami:": "Jami:",
      "ta": "ta",
      "Yopish": "Yopish",
      "Filtrni tozalash": "Filtrni tozalash",
      "Xatolik yuz berdi": "Xatolik yuz berdi",
    },
    "Rus": {
      "Mahsulot": "Продукт",
      "Mahsulot qo'shish": "Добавить продукт",
      "Ma'lumot kiritilmagan": "Данные не введены",
      "Bekor qilish": "Отмена",
      "Saqlash": "Сохранить",
      "Mahsulot nomi": "Название продукта",
      "Bemor narxi": "Цена для пациента",
      "Shifokor narxi": "Цена для врача",
      "Kategoriya": "Категория",
      "Keshbek": "Кешбэк",
      "Status": "Статус",
      "Faol": "Активный",
      "Nofaol": "Неактивный",
      "Umumiy": "Общий",
      "Tahrirlash": "Изменить",
      "O'chirish": "Удалить",
      "Yangilash": "Обновить",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "Ma'lumotlarni to'liq kiriting": "Введите данные полностью",
      "UZS": "UZS",
      "Mahsulotni o'chirish": "Удаление товара",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Вы действительно хотите удалить этот товар?",
      "Mahsulot qidirish": "Поиск по названию...",
      "Mahsulot topilmadi": "Продукт не найден",
      "Barchasi": "Все",
      "Jami:": "Всего:",
      "ta": "шт",
      "Yopish": "Закрыть",
      "Filtrni tozalash": "Сбросить фильтр",
      "Xatolik yuz berdi": "Произошла ошибка",
    },
    "Kiril": {
      "Mahsulot": "Маҳсулот",
      "Mahsulot qo'shish": "Маҳсулот қўшиш",
      "Ma'lumot kiritilmagan": "Маълумот киритилмаган",
      "Bekor qilish": "Бекор қилиш",
      "Saqlash": "Сақлаш",
      "Mahsulot nomi": "Маҳсулот номи",
      "Bemor narxi": "Бемор нархи",
      "Shifokor narxi": "Шифокор нархи",
      "Kategoriya": "Категория",
      "Keshbek": "Кешбек",
      "Status": "Статус",
      "Faol": "Фаол",
      "Nofaol": "Нофаол",
      "Umumiy": "Умумий",
      "Tahrirlash": "Таҳрирлаш",
      "O'chirish": "Ўчириш",
      "Yangilash": "Янгилаш",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "Ma'lumotlarni to'liq kiriting": "Маълумотларни тўлиқ киритинг",
      "UZS": "UZS",
      "Mahsulotni o'chirish": "Маҳсулотни ўчириш",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Ҳақиқатан ҳам ушбу маҳсулотни ўчирмоқчимисиз?",
      "Mahsulot qidirish": "Маҳсулот номи бўйича қидириш...",
      "Mahsulot topilmadi": "Маҳсулот топилмади",
      "Barchasi": "Барчаси",
      "Jami:": "Жами:",
      "ta": "та",
      "Yopish": "Ёпиш",
      "Filtrni tozalash": "Филтрни тозалаш",
      "Xatolik yuz berdi": "Хатолик юз берди",
    },
  };

  static String getTxt(BuildContext context, String key) {
    try {
      final lang = Provider.of<ProfileProvider>(context, listen: false).language;
      return _localizedTexts[lang]?[key] ?? _localizedTexts["Uzb"]?[key] ?? key;
    } catch (_) {
      return _localizedTexts["Uzb"]?[key] ?? key;
    }
  }
}

class _MahsulotlarPagesState extends State<MahsulotlarPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _MahsulotFilter _activeFilter = _MahsulotFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MahsulotProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getTxt(String lang, String key) {
    return MahsulotlarPages._localizedTexts[lang]?[key] ??
        MahsulotlarPages._localizedTexts["Uzb"]?[key] ??
        key;
  }

  String _formatPrice(String price) {
    final cleanPrice = price.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPrice.isEmpty) return price;
    final number = int.tryParse(cleanPrice);
    if (number == null) return price;
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
    );
  }

  bool _isStatusActive(String status) {
    final s = status.trim().toLowerCase();
    return s == 'faol' || s == 'active' || s == 'активный' || s == 'фаол';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahsulotProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String lang = profileProvider.language;
    final bool isAdmin = profileProvider.role.trim().toLowerCase() == 'admin';

    final List<MahsulotModel> allProducts = provider.mahsulotlar;
    final int activeCount =
        allProducts.where((m) => _isStatusActive(m.status)).length;
    final int inactiveCount = allProducts.length - activeCount;

    final String query = _searchQuery.trim().toLowerCase();
    final List<MahsulotModel> filteredMahsulotlar = allProducts.where((m) {
      if (_activeFilter == _MahsulotFilter.active &&
          !_isStatusActive(m.status)) {
        return false;
      }
      if (_activeFilter == _MahsulotFilter.inactive &&
          _isStatusActive(m.status)) {
        return false;
      }
      if (query.isEmpty) return true;
      return m.nomi.toLowerCase().contains(query) ||
          m.kategoriya.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor:
      isDark ? _MahsulotColors.slateDark : _MahsulotColors.lightBg,
      floatingActionButton: isAdmin ? _buildAddButton(context, lang) : null,
      body: SafeArea(
        bottom: false,
        child: provider.isLoading && allProducts.isEmpty
            ? const Center(
          child: CircularProgressIndicator(
            color: _MahsulotColors.primaryBlue,
          ),
        )
            : RefreshIndicator(
          onRefresh: provider.loadProducts,
          color: _MahsulotColors.primaryBlue,
          backgroundColor:
          isDark ? _MahsulotColors.cardDark : Colors.white,
          child: allProducts.isEmpty
              ? _buildEmptyScrollableState(
            context,
            isDark: isDark,
            lang: lang,
          )
              : LayoutBuilder(
            builder: (context, constraints) {
              final double contentMaxWidth =
              constraints.maxWidth > 1160
                  ? 1160
                  : constraints.maxWidth;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 125),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(maxWidth: contentMaxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. KPI STATISTIKA KARTALARI
                        _buildSummaryCards(
                          context,
                          lang: lang,
                          isDark: isDark,
                          totalCount: allProducts.length,
                          activeCount: activeCount,
                          inactiveCount: inactiveCount,
                        ),
                        const SizedBox(height: 14),

                        // 2. QIDIRUV VA KAPSULA FILTR
                        _buildSearchAndFilterBar(
                          context,
                          lang: lang,
                          isDark: isDark,
                          maxWidth: contentMaxWidth - 32,
                          allCount: allProducts.length,
                          activeCount: activeCount,
                          inactiveCount: inactiveCount,
                        ),
                        const SizedBox(height: 16),

                        // 3. MAHSULOTLAR GRID
                        if (filteredMahsulotlar.isEmpty)
                          _buildEmptySearchResults(
                              context, isDark, lang)
                        else
                          _buildProductGrid(
                            context,
                            products: filteredMahsulotlar,
                            allProducts: allProducts,
                            isDark: isDark,
                            lang: lang,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 1. KPI SUMMARY CARDS
  // ============================================================
  Widget _buildSummaryCards(
      BuildContext context, {
        required String lang,
        required bool isDark,
        required int totalCount,
        required int activeCount,
        required int inactiveCount,
      }) {
    final unit = _getTxt(lang, "ta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: _getTxt(lang, "Faol"),
            icon: Icons.check_circle_rounded,
            iconColor: _MahsulotColors.green,
            mainValue: "$activeCount $unit",
            subLabel1: _getTxt(lang, "Jami:"),
            subVal1: "$totalCount $unit",
            subLabel2: _getTxt(lang, "Nofaol"),
            subVal2: "$inactiveCount $unit",
            isSelected: _activeFilter == _MahsulotFilter.active,
            isDark: isDark,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeFilter = _activeFilter == _MahsulotFilter.active
                    ? _MahsulotFilter.all
                    : _MahsulotFilter.active;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: _getTxt(lang, "Nofaol"),
            icon: Icons.pause_circle_outline_rounded,
            iconColor: _MahsulotColors.amber,
            mainValue: "$inactiveCount $unit",
            subLabel1: _getTxt(lang, "Faol"),
            subVal1: "$activeCount $unit",
            subLabel2: _getTxt(lang, "Barchasi"),
            subVal2: "$totalCount $unit",
            isSelected: _activeFilter == _MahsulotFilter.inactive,
            isDark: isDark,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeFilter = _activeFilter == _MahsulotFilter.inactive
                    ? _MahsulotFilter.all
                    : _MahsulotFilter.inactive;
              });
            },
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
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final Color borderColor = isSelected
        ? iconColor
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? _MahsulotColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.6 : 1.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Icon(
                  isSelected
                      ? Icons.filter_alt_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size: isSelected ? 18 : 14,
                  color: isSelected
                      ? iconColor
                      : (isDark ? Colors.white24 : Colors.black26),
                ),
              ],
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
                  fontSize: 24,
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
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
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
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
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
    );
  }

  // ============================================================
  // 2. SEARCH + SEGMENTED FILTER CAPSULE
  // ============================================================
  Widget _buildSearchAndFilterBar(
      BuildContext context, {
        required String lang,
        required bool isDark,
        required double maxWidth,
        required int allCount,
        required int activeCount,
        required int inactiveCount,
      }) {
    final searchField = Container(
      decoration: BoxDecoration(
        color: isDark ? _MahsulotColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFF64748B).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
          hintText: _getTxt(lang, "Mahsulot qidirish"),
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
        color: isDark ? _MahsulotColors.cardDark : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterPill(
              label: "${_getTxt(lang, "Barchasi")} ($allCount)",
              selected: _activeFilter == _MahsulotFilter.all,
              activeColor: _MahsulotColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _MahsulotFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label: "${_getTxt(lang, "Faol")} ($activeCount)",
              selected: _activeFilter == _MahsulotFilter.active,
              activeColor: _MahsulotColors.green,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _MahsulotFilter.active),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label: "${_getTxt(lang, "Nofaol")} ($inactiveCount)",
              selected: _activeFilter == _MahsulotFilter.inactive,
              activeColor: _MahsulotColors.amber,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _MahsulotFilter.inactive),
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
  // 3. RESPONSIVE MAHSULOTLAR GRID
  // ============================================================
  Widget _buildProductGrid(
      BuildContext context, {
        required List<MahsulotModel> products,
        required List<MahsulotModel> allProducts,
        required bool isDark,
        required String lang,
      }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32;

        int crossAxisCount = 2;
        double cardHeight = 258;

        if (width >= 1020) {
          crossAxisCount = 5;
          cardHeight = 266;
        } else if (width >= 780) {
          crossAxisCount = 4;
          cardHeight = 264;
        } else if (width >= 540) {
          crossAxisCount = 3;
          cardHeight = 262;
        } else if (width < 340) {
          crossAxisCount = 1;
          cardHeight = 240;
        }

        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            final mahsulot = products[index];
            final originalIndex = allProducts.indexOf(mahsulot);
            final bool isActive = _isStatusActive(mahsulot.status);
            final Color statusColor =
            isActive ? _MahsulotColors.green : _MahsulotColors.rose;

            return InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                HapticFeedback.lightImpact();
                _showDetailsDialog(
                  context,
                  mahsulot,
                  lang,
                  originalIndex,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? _MahsulotColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
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
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _buildProductImage(
                                mahsulot,
                                isDark: isDark,
                                fallbackFontSize: 52,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0F172A)
                                    .withValues(alpha: 0.85)
                                    : Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                _getTxt(lang, mahsulot.status),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mahsulot.nomi,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16.5,
                              height: 1.2,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${_formatPrice(mahsulot.bemorNarxi)} ${_getTxt(lang, "UZS")}",
                              style: TextStyle(
                                color: isDark
                                    ? _MahsulotColors.skyBlue
                                    : _MahsulotColors.primaryBlue,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductImage(
      MahsulotModel mahsulot, {
        required bool isDark,
        double fallbackFontSize = 52,
      }) {
    final String? rasm = mahsulot.rasm;
    final bool hasImage = rasm != null && rasm.trim().isNotEmpty;
    final String initial = mahsulot.nomi.trim().isNotEmpty
        ? mahsulot.nomi.trim()[0].toUpperCase()
        : "?";

    Widget fallback() {
      return Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fallbackFontSize,
            fontWeight: FontWeight.w900,
            color: isDark
                ? Colors.white24
                : _MahsulotColors.primaryBlue.withValues(alpha: 0.35),
          ),
        ),
      );
    }

    if (!hasImage) return fallback();

    if (rasm.startsWith('http')) {
      return Image.network(
        rasm,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    return Image.file(
      File(rasm),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }

  // ============================================================
  // EMPTY & NO SEARCH RESULTS STATES
  // ============================================================
  Widget _buildEmptyScrollableState(
      BuildContext context, {
        required bool isDark,
        required String lang,
      }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color:
                        _MahsulotColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_outlined,
                        size: 44,
                        color: _MahsulotColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getTxt(lang, "Ma'lumot kiritilmagan"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w800,
                        color:
                        isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptySearchResults(
      BuildContext context,
      bool isDark,
      String lang,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: isDark ? _MahsulotColors.cardDark : Colors.white,
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
              color: _MahsulotColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 32,
              color: _MahsulotColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _getTxt(lang, "Mahsulot topilmadi"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          if (_searchQuery.isNotEmpty || _activeFilter != _MahsulotFilter.all) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = "";
                  _activeFilter = _MahsulotFilter.all;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                _getTxt(lang, "Filtrni tozalash"),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _MahsulotColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, String lang) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 105),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_MahsulotColors.skyBlue, _MahsulotColors.primaryBlue],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: _MahsulotColors.primaryBlue.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<MahsulotProvider>().tozalash();
              _showProductDialog(context, lang);
            },
            child: const Center(
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DELETE CONFIRMATION DIALOG
  // ============================================================
  void _showDeleteConfirmationDialog(
      BuildContext parentContext,
      BuildContext detailDialogContext,
      String lang,
      int index,
      ) {
    final bool isDark = Theme.of(parentContext).brightness == Brightness.dark;

    showDialog(
      context: parentContext,
      builder: (confirmContext) {
        return AlertDialog(
          backgroundColor: isDark ? _MahsulotColors.cardDark : Colors.white,
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
                  color: _MahsulotColors.rose.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 30,
                  color: _MahsulotColors.rose,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getTxt(lang, "Mahsulotni o'chirish"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getTxt(
                  lang,
                  "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(confirmContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _getTxt(lang, "Bekor qilish"),
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _MahsulotColors.rose,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () {
                        parentContext.read<MahsulotProvider>().ochirish(index);
                        Navigator.pop(confirmContext);
                        if (detailDialogContext.mounted) {
                          Navigator.pop(detailDialogContext);
                        }
                      },
                      child: Text(
                        _getTxt(lang, "O'chirish"),
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
    );
  }

  // ============================================================
  // PRODUCT DETAILS DIALOG
  // ============================================================
  void _showDetailsDialog(
      BuildContext context,
      MahsulotModel mahsulot,
      String lang,
      int index,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileProvider = context.read<ProfileProvider>();
    final bool isAdmin = profileProvider.role.trim().toLowerCase() == 'admin';
    final bool isActive = _isStatusActive(mahsulot.status);
    final Color statusColor =
    isActive ? _MahsulotColors.green : _MahsulotColors.rose;

    showDialog(
      context: context,
      builder: (detailContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? _MahsulotColors.cardDark.withValues(alpha: 0.95)
                      : Colors.white.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getTxt(lang, "Mahsulot"),
                        style: TextStyle(
                          color:
                          isDark ? Colors.white : const Color(0xFF0F172A),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: 136,
                        height: 136,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: _buildProductImage(
                            mahsulot,
                            isDark: isDark,
                            fallbackFontSize: 64,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mahsulot.nomi,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color:
                          isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          _badgeChip(_getTxt(lang, mahsulot.status), statusColor),
                          if (mahsulot.kategoriya.trim().isNotEmpty)
                            _badgeChip(
                              _getTxt(lang, mahsulot.kategoriya),
                              _MahsulotColors.primaryBlue,
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildDetailItem(
                              Icons.person_outline_rounded,
                              _getTxt(lang, "Bemor narxi"),
                              "${_formatPrice(mahsulot.bemorNarxi)} ${_getTxt(lang, "UZS")}",
                              isDark,
                              valueColor: isDark
                                  ? _MahsulotColors.skyBlue
                                  : _MahsulotColors.primaryBlue,
                            ),
                            _buildDetailDivider(isDark),
                            _buildDetailItem(
                              Icons.medical_services_outlined,
                              _getTxt(lang, "Shifokor narxi"),
                              "${_formatPrice(mahsulot.shifokorNarxi)} ${_getTxt(lang, "UZS")}",
                              isDark,
                            ),
                            _buildDetailDivider(isDark),
                            _buildDetailItem(
                              Icons.category_outlined,
                              _getTxt(lang, "Kategoriya"),
                              _getTxt(lang, mahsulot.kategoriya),
                              isDark,
                            ),
                            _buildDetailDivider(isDark),
                            _buildDetailItem(
                              Icons.percent_rounded,
                              _getTxt(lang, "Keshbek"),
                              mahsulot.keshbek,
                              isDark,
                            ),
                            _buildDetailDivider(isDark),
                            _buildDetailItem(
                              Icons.verified_outlined,
                              _getTxt(lang, "Status"),
                              _getTxt(lang, mahsulot.status),
                              isDark,
                              valueColor: statusColor,
                            ),
                          ],
                        ),
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _MahsulotColors.rose
                                      .withValues(alpha: 0.12),
                                  foregroundColor: _MahsulotColors.rose,
                                  elevation: 0,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                    context,
                                    detailContext,
                                    lang,
                                    index,
                                  );
                                },
                                icon:
                                const Icon(Icons.delete_outline, size: 20),
                                label: Text(
                                  _getTxt(lang, "O'chirish"),
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _MahsulotColors.primaryBlue
                                      .withValues(alpha: 0.12),
                                  foregroundColor: _MahsulotColors.primaryBlue,
                                  elevation: 0,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(detailContext);
                                  final provider =
                                  context.read<MahsulotProvider>();
                                  provider.tahrirlashIndex = index;
                                  provider.mahsulotController.text =
                                      mahsulot.nomi;
                                  provider.bemorNarxController.text =
                                      mahsulot.bemorNarxi;
                                  provider.shifokorNarxController.text =
                                      mahsulot.shifokorNarxi;
                                  provider.keshbekController.text =
                                      mahsulot.keshbek;
                                  provider.setKategoriya(mahsulot.kategoriya);
                                  provider.setStatus(mahsulot.status);
                                  provider.imageFile = mahsulot.rasm != null
                                      ? File(mahsulot.rasm!)
                                      : null;

                                  _showProductDialog(
                                    context,
                                    lang,
                                    isEditing: true,
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                label: Text(
                                  _getTxt(lang, "Tahrirlash"),
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.pop(detailContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            _getTxt(lang, "Yopish"),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _badgeChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailDivider(bool isDark) {
    return Divider(
      height: 16,
      color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildDetailItem(
      IconData icon,
      String label,
      String value,
      bool isDark, {
        Color? valueColor,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: isDark ? Colors.white54 : const Color(0xFF64748B),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ??
                      (isDark ? Colors.white : const Color(0xFF0F172A)),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADD / EDIT PRODUCT DIALOG
  // ============================================================
  void _showProductDialog(
      BuildContext context,
      String lang, {
        bool isEditing = false,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ProductFormDialog(
          lang: lang,
          isEditing: isEditing,
          parentContext: context,
        );
      },
    );
  }
}

// ============================================================
// PRODUCT FORM DIALOG STATEFUL WIDGET
// ============================================================
class _ProductFormDialog extends StatefulWidget {
  final String lang;
  final bool isEditing;
  final BuildContext parentContext;

  const _ProductFormDialog({
    required this.lang,
    required this.isEditing,
    required this.parentContext,
  });

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  bool _isSaving = false;

  String _getTxt(String key) {
    return MahsulotlarPages._localizedTexts[widget.lang]?[key] ??
        MahsulotlarPages._localizedTexts["Uzb"]?[key] ??
        key;
  }

  InputDecoration _inputDecoration(
      String label,
      bool isDark,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.white70 : const Color(0xFF64748B),
        fontSize: 15,
      ),
      prefixIcon: Icon(
        icon,
        size: 21,
        color: isDark ? Colors.white54 : const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
        const BorderSide(color: _MahsulotColors.primaryBlue, width: 1.5),
      ),
    );
  }

  Widget _buildImagePreview(File file, bool isDark) {
    Widget fallback() {
      return Icon(
        Icons.add_a_photo_rounded,
        size: 38,
        color: isDark ? Colors.white38 : _MahsulotColors.primaryBlue,
      );
    }

    if (file.path.startsWith('http')) {
      return Image.network(
        file.path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }

  Future<void> _submit() async {
    final provider = context.read<MahsulotProvider>();

    if (!provider.tekshir()) {
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(
          backgroundColor: _MahsulotColors.rose,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Text(
            _getTxt("Ma'lumotlarni to'liq kiriting"),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    final mahsulot = MahsulotModel(
      id: widget.isEditing && provider.tahrirlashIndex != null
          ? provider.mahsulotlar[provider.tahrirlashIndex!].id
          : null,
      nomi: provider.mahsulotController.text,
      bemorNarxi: provider.bemorNarxController.text,
      shifokorNarxi: provider.shifokorNarxController.text,
      kategoriya: provider.selectedKategoriya,
      keshbek: provider.keshbekController.text,
      status: provider.selectedStatus,
      rasm: provider.imageFile?.path,
    );

    setState(() => _isSaving = true);

    try {
      if (widget.isEditing && provider.tahrirlashIndex != null) {
        await provider.tahrirlash(provider.tahrirlashIndex!, mahsulot);
      } else {
        await provider.qoshish(mahsulot);
      }
      provider.tozalash();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
      if (widget.parentContext.mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            backgroundColor: _MahsulotColors.rose,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<MahsulotProvider>();

    const categoryItems = ["Umumiy"];
    final String safeKategoriya = categoryItems.contains(provider.selectedKategoriya)
        ? provider.selectedKategoriya
        : categoryItems.first;

    const statusItems = ["Faol", "Nofaol"];
    final String safeStatus = statusItems.contains(provider.selectedStatus)
        ? provider.selectedStatus
        : statusItems.first;

    return AlertDialog(
      backgroundColor: isDark ? _MahsulotColors.cardDark : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _MahsulotColors.primaryBlue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              widget.isEditing
                  ? Icons.edit_rounded
                  : Icons.add_box_rounded,
              color: _MahsulotColors.primaryBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.isEditing
                  ? _getTxt("Tahrirlash")
                  : _getTxt("Mahsulot qo'shish"),
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                      isDark ? _MahsulotColors.cardDark : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (bottomContext) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: _MahsulotColors.primaryBlue,
                                  ),
                                  title: Text(
                                    _getTxt("Kamera"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color:
                                      isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    context
                                        .read<MahsulotProvider>()
                                        .rasmTanlash(
                                      context,
                                      ImageSource.camera,
                                    );
                                    Navigator.pop(bottomContext);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_library_rounded,
                                    color: _MahsulotColors.primaryBlue,
                                  ),
                                  title: Text(
                                    _getTxt("Galereya"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color:
                                      isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    context
                                        .read<MahsulotProvider>()
                                        .rasmTanlash(
                                      context,
                                      ImageSource.gallery,
                                    );
                                    Navigator.pop(bottomContext);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 116,
                        height: 116,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : _MahsulotColors.primaryBlue
                              .withValues(alpha: 0.1),
                          border: Border.all(
                            color: _MahsulotColors.primaryBlue
                                .withValues(alpha: 0.45),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: provider.imageFile != null
                              ? _buildImagePreview(provider.imageFile!, isDark)
                              : Center(
                            child: Icon(
                              Icons.add_a_photo_rounded,
                              size: 38,
                              color: isDark
                                  ? Colors.white38
                                  : _MahsulotColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _MahsulotColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? _MahsulotColors.cardDark
                                  : Colors.white,
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: provider.mahsulotController,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    _getTxt("Mahsulot nomi"),
                    isDark,
                    Icons.medication_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: provider.bemorNarxController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'uz',
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    _getTxt("Bemor narxi"),
                    isDark,
                    Icons.payments_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: provider.shifokorNarxController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'uz',
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    _getTxt("Shifokor narxi"),
                    isDark,
                    Icons.medical_services_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey("kat_$safeKategoriya"),
                  initialValue: safeKategoriya,
                  dropdownColor:
                  isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    _getTxt("Kategoriya"),
                    isDark,
                    Icons.category_outlined,
                  ),
                  items: categoryItems
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(_getTxt(e)),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      provider.setKategoriya(val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: provider.keshbekController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    _getTxt("Keshbek"),
                    isDark,
                    Icons.percent_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey("status_$safeStatus"),
                  initialValue: safeStatus,
                  dropdownColor:
                  isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    _getTxt("Status"),
                    isDark,
                    Icons.verified_outlined,
                  ),
                  items: statusItems
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(_getTxt(e)),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      provider.setStatus(val);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  foregroundColor: isDark ? Colors.white70 : Colors.black87,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isSaving
                    ? null
                    : () {
                  provider.tozalash();
                  Navigator.pop(context);
                },
                child: Text(
                  _getTxt("Bekor qilish"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _MahsulotColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  widget.isEditing
                      ? _getTxt("Yangilash")
                      : _getTxt("Saqlash"),
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
    );
  }
}