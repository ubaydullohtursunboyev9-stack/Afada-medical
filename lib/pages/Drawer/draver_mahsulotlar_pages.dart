import 'dart:io';
import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/model_provider.dart';
import '../../provider/profile_provider.dart';

String _formatMoneyString(String value) {
  final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (clean.isEmpty) return value;
  final num = int.tryParse(clean);
  if (num == null) return value;
  return num.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ' ',
  );
}

class DraverMahsulotlarPages extends StatefulWidget {
  const DraverMahsulotlarPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Mahsulot": "Mahsulotlar",
      "Barchasi": "Barchasi",
      "Jami mahsulot": "Jami mahsulot",
      "xil": "xil",
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
      "Rasm tanlash": "Mahsulot rasmini tanlash",
      "Ma'lumotlarni to'liq kiriting": "Ma'lumotlarni to'liq kiriting",
      "UZS": "UZS",
      "Mahsulotni o'chirish": "Mahsulotni o'chirish",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
      "Qidirish...": "Nomi yoki kategoriya...",
      "Mahsulot topilmadi": "Mahsulot topilmadi",
    },
    "Rus": {
      "Mahsulot": "Продукты",
      "Barchasi": "Все",
      "Jami mahsulot": "Всего товаров",
      "xil": "вид.",
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
      "Rasm tanlash": "Выбрать фото продукта",
      "Ma'lumotlarni to'liq kiriting": "Введите данные полностью",
      "UZS": "UZS",
      "Mahsulotni o'chirish": "Удаление товара",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Вы действительно хотите удалить этот товар?",
      "Qidirish...": "Название или категория...",
      "Mahsulot topilmadi": "Товар не найден",
    },
    "Kiril": {
      "Mahsulot": "Маҳсулотлар",
      "Barchasi": "Барчаси",
      "Jami mahsulot": "Жами маҳсулот",
      "xil": "хил",
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
      "Rasm tanlash": "Маҳсулот расмини танлаш",
      "Ma'lumotlarni to'liq kiriting": "Маълумотларни тўлиқ киритинг",
      "UZS": "UZS",
      "Mahsulotni o'chirish": "Маҳсулотни ўчириш",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Ҳақиқатан ҳам ушбу маҳсулотни ўчирмоқчимисиз?",
      "Qidirish...": "Номи ёки категория...",
      "Mahsulot topilmadi": "Маҳсулот топилмади",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts["Uzb"]?[key] ??
        key;
  }

  @override
  State<DraverMahsulotlarPages> createState() =>
      _DraverMahsulotlarPagesState();
}

class _DraverMahsulotlarPagesState extends State<DraverMahsulotlarPages> {
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
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchOpen = false;
  String _searchQuery = "";
  String _statusFilter = "all"; // all | Faol | Nofaol

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
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _isSearchOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _searchQuery = "";
      _isSearchOpen = false;
    });
  }

  // =========================================================================
  // ANIMATSIYALI APPBAR: O'NGDAN CHAPGA SURILUVCHI QIDIRUV
  // =========================================================================

  Widget _buildAnimatedAppBarTitle({
    required String lang,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          const double buttonSize = 44;
          final double closedLeft =
          (maxWidth - buttonSize).clamp(0.0, double.infinity);

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // CHAP TOMONDA: IKONKA + "MAHSULOTLAR"
              AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _isSearchOpen ? 0.0 : 1.0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  offset: _isSearchOpen
                      ? const Offset(-0.18, 0)
                      : Offset.zero,
                  child: IgnorePointer(
                    ignoring: _isSearchOpen,
                    child: Padding(
                      padding: const EdgeInsets.only(right: buttonSize + 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _primaryBlue.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.medical_services_rounded,
                              size: 21,
                              color: isDark ? _skyBlue : _primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              DraverMahsulotlarPages.getTxt(lang, "Mahsulot"),
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
                    ),
                  ),
                ),
              ),

              // O'NGDAN CHAPGA ANIMATSIYA BILAN SURILADIGAN QIDIRUV
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                top: 1,
                bottom: 1,
                right: 0,
                left: _isSearchOpen ? 0 : closedLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isSearchOpen
                          ? cardBg
                          : _primaryBlue.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _isSearchOpen
                            ? _primaryBlue.withValues(alpha: 0.65)
                            : _primaryBlue.withValues(alpha: 0.22),
                        width: _isSearchOpen ? 1.4 : 1.0,
                      ),
                    ),
                    child: _isSearchOpen
                        ? OverflowBox(
                      alignment: Alignment.centerRight,
                      minWidth: maxWidth,
                      maxWidth: maxWidth,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(
                            Icons.search_rounded,
                            size: 21,
                            color: isDark ? _skyBlue : _primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val),
                              textInputAction: TextInputAction.search,
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: DraverMahsulotlarPages.getTxt(
                                    lang, "Qidirish..."),
                                hintStyle: TextStyle(
                                  fontSize: 14.5,
                                  color: textSecondary,
                                ),
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: _closeSearch,
                            icon: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: _openSearch,
                        child: Center(
                          child: Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: isDark ? _skyBlue : _primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = context.watch<ProfileProvider>();
    final bool isAdmin = profile.role.trim().toLowerCase() == "admin";
    final String lang = profile.language;

    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color cardBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleSpacing: 12,
        title: _buildAnimatedAppBarTitle(
          lang: lang,
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ),
      floatingActionButton: isAdmin
          ? Padding(
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
              onTap: () {
                context.read<MahsulotProvider>().tozalash();
                _showProductDialog(context);
              },
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
      )
          : null,
      body: Consumer<MahsulotProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.mahsulotlar.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _primaryBlue),
            );
          }

          final List<MahsulotModel> allProducts = provider.mahsulotlar;
          final int activeCount =
              allProducts.where((m) => m.status == "Faol").length;
          final int inactiveCount = allProducts.length - activeCount;

          final List<MahsulotModel> filteredMahsulotlar =
          allProducts.where((m) {
            if (_statusFilter == "Faol" && m.status != "Faol") return false;
            if (_statusFilter == "Nofaol" && m.status == "Faol") return false;

            if (_searchQuery.trim().isNotEmpty) {
              final query = _searchQuery.trim().toLowerCase();
              return m.nomi.toLowerCase().contains(query) ||
                  m.kategoriya.toLowerCase().contains(query);
            }
            return true;
          }).toList();

          return RefreshIndicator(
            color: _primaryBlue,
            onRefresh: () => provider.loadProducts(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double horizontalPad =
                constraints.maxWidth >= 900 ? 24 : 16;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPad,
                    12,
                    horizontalPad,
                    105,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1240),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ================================================
                          // KPI KARTALAR (3 TA)
                          // ================================================
                          LayoutBuilder(
                            builder: (context, kpiConstraints) {
                              const double gap = 10;
                              final double itemW =
                                  (kpiConstraints.maxWidth - gap * 2) / 3;

                              return Row(
                                children: [
                                  SizedBox(
                                    width: itemW,
                                    child: _ProductKpiCard(
                                      title: DraverMahsulotlarPages.getTxt(
                                          lang, "Jami mahsulot"),
                                      value: "${allProducts.length}",
                                      unit: DraverMahsulotlarPages.getTxt(
                                          lang, "xil"),
                                      icon: Icons.inventory_2_rounded,
                                      accentColor: _primaryBlue,
                                      isSelected: _statusFilter == "all",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(
                                            () => _statusFilter = "all",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: itemW,
                                    child: _ProductKpiCard(
                                      title: DraverMahsulotlarPages.getTxt(
                                          lang, "Faol"),
                                      value: "$activeCount",
                                      unit: DraverMahsulotlarPages.getTxt(
                                          lang, "xil"),
                                      icon: Icons.check_circle_rounded,
                                      accentColor: _emerald,
                                      isSelected: _statusFilter == "Faol",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _statusFilter = _statusFilter == "Faol"
                                            ? "all"
                                            : "Faol";
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: itemW,
                                    child: _ProductKpiCard(
                                      title: DraverMahsulotlarPages.getTxt(
                                          lang, "Nofaol"),
                                      value: "$inactiveCount",
                                      unit: DraverMahsulotlarPages.getTxt(
                                          lang, "xil"),
                                      icon: Icons.pause_circle_rounded,
                                      accentColor: _rose,
                                      isSelected: _statusFilter == "Nofaol",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _statusFilter =
                                        _statusFilter == "Nofaol"
                                            ? "all"
                                            : "Nofaol";
                                      }),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 14),

                          // ================================================
                          // STATUS FILTR KAPSULALARI
                          // ================================================
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _StatusFilterPill(
                                  label:
                                  "${DraverMahsulotlarPages.getTxt(lang, "Barchasi")} (${allProducts.length})",
                                  selected: _statusFilter == "all",
                                  activeColor: _primaryBlue,
                                  isDark: isDark,
                                  onTap: () =>
                                      setState(() => _statusFilter = "all"),
                                ),
                                const SizedBox(width: 8),
                                _StatusFilterPill(
                                  label:
                                  "${DraverMahsulotlarPages.getTxt(lang, "Faol")} ($activeCount)",
                                  selected: _statusFilter == "Faol",
                                  activeColor: _emerald,
                                  isDark: isDark,
                                  onTap: () =>
                                      setState(() => _statusFilter = "Faol"),
                                ),
                                const SizedBox(width: 8),
                                _StatusFilterPill(
                                  label:
                                  "${DraverMahsulotlarPages.getTxt(lang, "Nofaol")} ($inactiveCount)",
                                  selected: _statusFilter == "Nofaol",
                                  activeColor: _rose,
                                  isDark: isDark,
                                  onTap: () =>
                                      setState(() => _statusFilter = "Nofaol"),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ================================================
                          // MAHSULOTLAR RO'YXATI (1 / 2 / 3 USTUN)
                          // ================================================
                          if (filteredMahsulotlar.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 54,
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
                                    Icons.inventory_2_outlined,
                                    size: 54,
                                    color:
                                    textSecondary.withValues(alpha: 0.55),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "Mahsulot topilmadi"),
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
                                w >= 1100 ? 3 : (w >= 680 ? 2 : 1);
                                const double gap = 14;
                                final double cardWidth =
                                    (w - gap * (columns - 1)) / columns;

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: filteredMahsulotlar.map((mahsulot) {
                                    final int originalIndex =
                                    provider.mahsulotlar.indexOf(mahsulot);

                                    return SizedBox(
                                      width: cardWidth,
                                      child: _ProductListCard(
                                        mahsulot: mahsulot,
                                        lang: lang,
                                        isDark: isDark,
                                        cardBg: cardBg,
                                        borderColor: borderColor,
                                        textPrimary: textPrimary,
                                        textSecondary: textSecondary,
                                        onTap: () => _showProductDetailsDialog(
                                          context,
                                          originalIndex,
                                          mahsulot,
                                          isAdmin: isAdmin,
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
  // MAHSULOT TAFSILOTLARI MODALI (FROSTED GLASS)
  // =========================================================================

  void _showProductDetailsDialog(
      BuildContext pageContext,
      int index,
      MahsulotModel mahsulot, {
        required bool isAdmin,
      }) {
    final lang = pageContext.read<ProfileProvider>().language;
    final provider = pageContext.read<MahsulotProvider>();
    final String currency = DraverMahsulotlarPages.getTxt(lang, "UZS");
    final bool isActive = mahsulot.status == "Faol";

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'product_details',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        final bool isDark =
            Theme.of(dialogContext).brightness == Brightness.dark;
        final Color borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
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
              insetPadding: const EdgeInsets.symmetric(horizontal: 18),
              contentPadding: EdgeInsets.zero,
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: isDark
                            ? _cardDark.withValues(alpha: 0.94)
                            : Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: borderColor),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            _ProductImageBox(
                              imagePath: mahsulot.rasm,
                              productName: mahsulot.nomi,
                              size: 108,
                              radius: 22,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              mahsulot.nomi,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: (isActive ? _emerald : _rose)
                                    .withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                DraverMahsulotlarPages.getTxt(
                                    lang, mahsulot.status),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: isActive ? _emerald : _rose,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? _slateDark.withValues(alpha: 0.6)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                children: [
                                  _detailRow(
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "Bemor narxi"),
                                    "${_formatMoneyString(mahsulot.bemorNarxi)} $currency",
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    valueColor:
                                    isDark ? _skyBlue : _primaryBlue,
                                  ),
                                  Divider(height: 16, color: borderColor),
                                  _detailRow(
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "Shifokor narxi"),
                                    "${_formatMoneyString(mahsulot.shifokorNarxi)} $currency",
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    valueColor: _emerald,
                                  ),
                                  Divider(height: 16, color: borderColor),
                                  _detailRow(
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "Keshbek"),
                                    "${_formatMoneyString(mahsulot.keshbek)} $currency",
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    valueColor: _amber,
                                  ),
                                  Divider(height: 16, color: borderColor),
                                  _detailRow(
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "Kategoriya"),
                                    DraverMahsulotlarPages.getTxt(
                                        lang, mahsulot.kategoriya),
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                  ),
                                ],
                              ),
                            ),
                            if (isAdmin) ...[
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: _rose),
                                        foregroundColor: _rose,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(14),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 13,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        _showDeleteDialog(pageContext, index);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 19,
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          DraverMahsulotlarPages.getTxt(
                                              lang, "O'chirish"),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryBlue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(14),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 13,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        provider.tahrirlashUchunYuklash(index);
                                        _showProductDialog(
                                          pageContext,
                                          isEditing: true,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        size: 19,
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          DraverMahsulotlarPages.getTxt(
                                              lang, "Tahrirlash"),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
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

  Widget _detailRow(
      String label,
      String value, {
        required Color textPrimary,
        required Color textSecondary,
        Color? valueColor,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textSecondary,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // MAHSULOT QO'SHISH / TAHRIRLASH DIALOGI
  // =========================================================================

  void _showProductDialog(
      BuildContext pageContext, {
        bool isEditing = false,
      }) {
    final lang = pageContext.read<ProfileProvider>().language;
    showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (_) => _ProductFormDialog(
        lang: lang,
        isEditing: isEditing,
      ),
    );
  }

  // =========================================================================
  // O'CHIRISH TASDIQLASH DIALOGI
  // =========================================================================

  void _showDeleteDialog(BuildContext pageContext, int index) {
    final provider = pageContext.read<MahsulotProvider>();
    final messenger = ScaffoldMessenger.of(pageContext);
    final lang = pageContext.read<ProfileProvider>().language;

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'delete_product',
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
                            DraverMahsulotlarPages.getTxt(
                                lang, "Mahsulotni o'chirish"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DraverMahsulotlarPages.getTxt(
                              lang,
                              "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
                            ),
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
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
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
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "Bekor qilish"),
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
                                      await provider.ochirish(index);
                                    } catch (e) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
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
                                    DraverMahsulotlarPages.getTxt(
                                        lang, "O'chirish"),
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
}

// ===========================================================================
// KPI KARTA & FILTR KAPSULA
// ===========================================================================

class _ProductKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;
  final bool isSelected;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _ProductKpiCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
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
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.75)
                  : borderColor,
              width: isSelected ? 1.6 : 1.0,
            ),
            boxShadow: isDark
                ? null
                : [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: accentColor),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  "$value $unit",
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
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

class _StatusFilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _StatusFilterPill({
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
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? activeColor
                : (isDark ? const Color(0xFF1C2541) : Colors.white),
            borderRadius: BorderRadius.circular(13),
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
              fontSize: 13.5,
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
// MAHSULOT KARTASI
// ===========================================================================

class _ProductListCard extends StatelessWidget {
  final MahsulotModel mahsulot;
  final String lang;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _ProductListCard({
    required this.mahsulot,
    required this.lang,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = mahsulot.status == "Faol";
    final Color statusColor =
    isActive ? const Color(0xFF10B981) : const Color(0xFFF43F5E);
    final String currency = DraverMahsulotlarPages.getTxt(lang, "UZS");

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ProductImageBox(
                    imagePath: mahsulot.rasm,
                    productName: mahsulot.nomi,
                    size: 74,
                    radius: 16,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mahsulot.nomi,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 7,
                          runSpacing: 5,
                          children: [
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
                                DraverMahsulotlarPages.getTxt(
                                    lang, mahsulot.status),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1)
                                    .withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                DraverMahsulotlarPages.getTxt(
                                    lang, mahsulot.kategoriya),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6366F1),
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
              const SizedBox(height: 13),
              Container(
                padding: const EdgeInsets.all(12),
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
                    _PriceLine(
                      label: DraverMahsulotlarPages.getTxt(lang, "Bemor narxi"),
                      value: "${_formatMoneyString(mahsulot.bemorNarxi)} $currency",
                      valueColor: isDark
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF0284C7),
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 6),
                    _PriceLine(
                      label:
                      DraverMahsulotlarPages.getTxt(lang, "Shifokor narxi"),
                      value: "${_formatMoneyString(mahsulot.shifokorNarxi)} $currency",
                      valueColor: const Color(0xFF10B981),
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 6),
                    _PriceLine(
                      label: DraverMahsulotlarPages.getTxt(lang, "Keshbek"),
                      value: "${_formatMoneyString(mahsulot.keshbek)} $currency",
                      valueColor: const Color(0xFFF59E0B),
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color textSecondary;

  const _PriceLine({
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
            fontSize: 13.5,
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
                fontSize: 15.5,
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

class _ProductImageBox extends StatelessWidget {
  final String? imagePath;
  final String productName;
  final double size;
  final double radius;
  final bool isDark;

  const _ProductImageBox({
    required this.imagePath,
    required this.productName,
    required this.size,
    required this.radius,
    required this.isDark,
  });

  String _initial() {
    final trimmed = productName.trim();
    return trimmed.isNotEmpty ? trimmed[0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    final String path = imagePath?.trim() ?? "";
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');
    final Color letterColor =
    isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    Widget fallback() {
      return Center(
        child: Text(
          _initial(),
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w800,
            color: letterColor,
          ),
        ),
      );
    }

    Widget imageWidget = fallback();
    if (path.isNotEmpty) {
      if (isNetwork) {
        imageWidget = Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          imageWidget = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback(),
          );
        }
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: const Color(0xFF0284C7).withValues(alpha: isDark ? 0.16 : 0.1),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFF0284C7).withValues(alpha: 0.25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }
}

// ===========================================================================
// MAHSULOT QO'SHISH / TAHRIRLASH DIALOGI (STATEFULWIDGET)
// ===========================================================================

class _ProductFormDialog extends StatefulWidget {
  final String lang;
  final bool isEditing;

  const _ProductFormDialog({
    required this.lang,
    required this.isEditing,
  });

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);

  bool _isSubmitting = false;
  String? _inlineError;

  void _showImageSourceSheet(BuildContext dialogContext) {
    final bool isDark =
        Theme.of(dialogContext).brightness == Brightness.dark;
    final provider = dialogContext.read<MahsulotProvider>();
    final lang = widget.lang;
    final Color sheetBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: dialogContext,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    DraverMahsulotlarPages.getTxt(lang, "Rasm tanlash"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: _primaryBlue.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: _primaryBlue,
                      ),
                    ),
                    title: Text(
                      DraverMahsulotlarPages.getTxt(lang, "Kamera"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      provider.rasmTanlash(dialogContext, ImageSource.camera);
                    },
                  ),
                  const SizedBox(height: 6),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: _emerald.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.photo_library_rounded,
                        color: _emerald,
                      ),
                    ),
                    title: Text(
                      DraverMahsulotlarPages.getTxt(lang, "Galereya"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      provider.rasmTanlash(dialogContext, ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: isDark
          ? _slateDark.withValues(alpha: 0.65)
          : const Color(0xFFF8FAFC),
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

  Future<void> _submit() async {
    final provider = context.read<MahsulotProvider>();
    final lang = widget.lang;

    if (!provider.tekshir()) {
      setState(() {
        _inlineError = DraverMahsulotlarPages.getTxt(
            lang, "Ma'lumotlarni to'liq kiriting");
      });
      return;
    }

    setState(() {
      _inlineError = null;
      _isSubmitting = true;
    });

    final int? editIdx = provider.tahrirlashIndex;
    final MahsulotModel? existing =
    (widget.isEditing &&
        editIdx != null &&
        editIdx >= 0 &&
        editIdx < provider.mahsulotlar.length)
        ? provider.mahsulotlar[editIdx]
        : null;

    final mahsulot = MahsulotModel(
      id: existing?.id,
      nomi: provider.mahsulotController.text,
      bemorNarxi: provider.bemorNarxController.text,
      shifokorNarxi: provider.shifokorNarxController.text,
      kategoriya: provider.selectedKategoriya,
      keshbek: provider.keshbekController.text,
      status: provider.selectedStatus,
      rasm: provider.imageFile?.path ?? existing?.rasm,
      zaxira: existing?.zaxira ?? 0,
    );

    try {
      if (widget.isEditing && editIdx != null) {
        await provider.tahrirlash(editIdx, mahsulot);
      } else {
        await provider.qoshish(mahsulot);
      }
      provider.tozalash();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inlineError = e.toString();
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<MahsulotProvider>();

    final Color dialogBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final List<String> kategoriyaItems = ["Umumiy"];
    if (provider.selectedKategoriya.isNotEmpty &&
        !kategoriyaItems.contains(provider.selectedKategoriya)) {
      kategoriyaItems.add(provider.selectedKategoriya);
    }
    final String safeKategoriya =
    kategoriyaItems.contains(provider.selectedKategoriya)
        ? provider.selectedKategoriya
        : "Umumiy";

    final String safeStatus =
    (provider.selectedStatus == "Faol" ||
        provider.selectedStatus == "Nofaol")
        ? provider.selectedStatus
        : "Faol";

    final int? editIdx = provider.tahrirlashIndex;
    final String? existingRasm = (widget.isEditing &&
        editIdx != null &&
        editIdx >= 0 &&
        editIdx < provider.mahsulotlar.length)
        ? provider.mahsulotlar[editIdx].rasm
        : null;
    final String? previewPath = provider.imageFile?.path ?? existingRasm;

    final media = MediaQuery.of(context);
    final double dialogWidth =
    media.size.width >= 600 ? 460 : media.size.width - 28;
    final double maxHeight =
    (media.size.height - media.viewInsets.bottom - 150)
        .clamp(280.0, 560.0);

    return AlertDialog(
      backgroundColor: dialogBg,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 14, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _primaryBlue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.isEditing
                  ? Icons.edit_rounded
                  : Icons.add_box_rounded,
              size: 21,
              color: isDark ? _skyBlue : _primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.isEditing
                  ? DraverMahsulotlarPages.getTxt(lang, "Tahrirlash")
                  : DraverMahsulotlarPages.getTxt(lang, "Mahsulot qo'shish"),
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
            onPressed: _isSubmitting
                ? null
                : () {
              provider.tozalash();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_rounded, color: textSecondary),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
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

                // RASM TANLASH
                Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceSheet(context),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: provider.mahsulotController,
                          builder: (context, val, _) {
                            return _ProductImageBox(
                              imagePath: previewPath,
                              productName: val.text,
                              size: 108,
                              radius: 22,
                              isDark: isDark,
                            );
                          },
                        ),
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [_skyBlue, _primaryBlue],
                              ),
                              border: Border.all(color: dialogBg, width: 2.5),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: provider.mahsulotController,
                  onChanged: (_) {
                    if (_inlineError != null) {
                      setState(() => _inlineError = null);
                    }
                  },
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label:
                    DraverMahsulotlarPages.getTxt(lang, "Mahsulot nomi"),
                    icon: Icons.inventory_2_outlined,
                    isDark: isDark,
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
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label: DraverMahsulotlarPages.getTxt(lang, "Bemor narxi"),
                    icon: Icons.paid_outlined,
                    isDark: isDark,
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
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label:
                    DraverMahsulotlarPages.getTxt(lang, "Shifokor narxi"),
                    icon: Icons.medical_information_outlined,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: safeKategoriya,
                  isExpanded: true,
                  dropdownColor: dialogBg,
                  decoration: _inputDecoration(
                    label: DraverMahsulotlarPages.getTxt(lang, "Kategoriya"),
                    icon: Icons.category_outlined,
                    isDark: isDark,
                  ),
                  items: kategoriyaItems
                      .map(
                        (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        DraverMahsulotlarPages.getTxt(lang, item),
                        style: TextStyle(color: textPrimary),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) provider.setKategoriya(val);
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: provider.keshbekController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label: DraverMahsulotlarPages.getTxt(lang, "Keshbek"),
                    icon: Icons.card_giftcard_rounded,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: safeStatus,
                  isExpanded: true,
                  dropdownColor: dialogBg,
                  decoration: _inputDecoration(
                    label: DraverMahsulotlarPages.getTxt(lang, "Status"),
                    icon: Icons.verified_outlined,
                    isDark: isDark,
                  ),
                  items: const ["Faol", "Nofaol"]
                      .map(
                        (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        DraverMahsulotlarPages.getTxt(lang, item),
                        style: TextStyle(color: textPrimary),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) provider.setStatus(val);
                  },
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                  provider.tozalash();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    DraverMahsulotlarPages.getTxt(lang, "Bekor qilish"),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
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
                    : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.isEditing
                        ? DraverMahsulotlarPages.getTxt(lang, "Yangilash")
                        : DraverMahsulotlarPages.getTxt(lang, "Saqlash"),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
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