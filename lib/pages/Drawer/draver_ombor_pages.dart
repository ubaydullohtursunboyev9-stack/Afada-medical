import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/model_provider.dart';
import '../../provider/profile_provider.dart';

class DraverOmborPages extends StatefulWidget {
  const DraverOmborPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'warehouse': 'Ombor',
      'all': 'Barchasi',
      'total_products': 'Jami mahsulot',
      'available': 'Tayyor',
      'out_of_stock': 'Tugagan',
      'in_stock': 'Zaxirada:',
      'pcs': 'dona',
      'price': 'Narxi:',
      'currency': 'UZS',
      'search': 'Mahsulot nomini qidiring...',
      'no_product': 'Mahsulot topilmadi',
      'type_unit': 'xil',
    },
    'Rus': {
      'warehouse': 'Склад',
      'all': 'Все',
      'total_products': 'Всего товаров',
      'available': 'В наличии',
      'out_of_stock': 'Закончились',
      'in_stock': 'В наличии:',
      'pcs': 'шт',
      'price': 'Цена:',
      'currency': 'UZS',
      'search': 'Поиск по названию товара...',
      'no_product': 'Товар не найден',
      'type_unit': 'вид.',
    },
    'Kiril': {
      'warehouse': 'Омбор',
      'all': 'Барчаси',
      'total_products': 'Жами маҳсулот',
      'available': 'Тайёр',
      'out_of_stock': 'Тугаган',
      'in_stock': 'Захирада:',
      'pcs': 'дона',
      'price': 'Нархи:',
      'currency': 'UZS',
      'search': 'Маҳсулот номини қидиринг...',
      'no_product': 'Маҳсулот топилмади',
      'type_unit': 'хил',
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts['Uzb']?[key] ??
        key;
  }

  @override
  State<DraverOmborPages> createState() => _DraverOmborPagesState();
}

class _DraverOmborPagesState extends State<DraverOmborPages> {
  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);
  static const Color _lightBg = Color(0xFFF8FAFC);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchOpen = false;
  String _searchQuery = "";
  String _stockFilter = "all"; // all | available | out

  static String getTxt(String lang, String key) =>
      DraverOmborPages.getTxt(lang, key);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final prov = context.read<MahsulotProvider>();
      if (prov.mahsulotlar.isEmpty) {
        prov.loadProducts();
      }
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

  String _formatPrice(String rawPrice) {
    final int val =
        int.tryParse(rawPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return NumberFormat('#,###', 'en_US').format(val).replaceAll(',', ' ');
  }

  // =========================================================================
  // ANIMATSIYALI APPBAR: O'NGDAN CHAPGA SURILUVCHI QIDIRUV
  // =========================================================================

  Widget _buildAnimatedAppBarTitle({
    required String language,
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
              // CHAP TOMONDA: IKONKA + "OMBOR"
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
                              Icons.warehouse_rounded,
                              size: 21,
                              color: isDark ? _skyBlue : _primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              getTxt(language, 'warehouse'),
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
                                hintText: getTxt(language, 'search'),
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
    final String language = context.watch<ProfileProvider>().language;

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
          language: language,
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ),
      body: Consumer<MahsulotProvider>(
        builder: (context, mahsulotProv, child) {
          final List<MahsulotModel> allProducts = mahsulotProv.mahsulotlar;

          final int availableCount = allProducts
              .where((m) => mahsulotProv.getZaxira(m) > 0)
              .length;
          final int outCount = allProducts.length - availableCount;

          final List<MahsulotModel> filteredMahsulotlar =
          allProducts.where((m) {
            final int zaxira = mahsulotProv.getZaxira(m);
            if (_stockFilter == "available" && zaxira <= 0) return false;
            if (_stockFilter == "out" && zaxira > 0) return false;

            if (_searchQuery.trim().isNotEmpty) {
              final query = _searchQuery.trim().toLowerCase();
              return m.nomi.toLowerCase().contains(query);
            }
            return true;
          }).toList();

          filteredMahsulotlar.sort((a, b) {
            final int aZaxira = mahsulotProv.getZaxira(a);
            final int bZaxira = mahsulotProv.getZaxira(b);
            if (aZaxira == 0 && bZaxira != 0) return 1;
            if (aZaxira != 0 && bZaxira == 0) return -1;
            return 0;
          });

          return RefreshIndicator(
            color: _primaryBlue,
            onRefresh: () => mahsulotProv.loadProducts(),
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
                    32,
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
                                    child: _WarehouseKpiCard(
                                      title: getTxt(language, 'total_products'),
                                      value: "${allProducts.length}",
                                      unit: getTxt(language, 'type_unit'),
                                      icon: Icons.inventory_2_rounded,
                                      accentColor: _primaryBlue,
                                      isSelected: _stockFilter == "all",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(
                                            () => _stockFilter = "all",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: itemW,
                                    child: _WarehouseKpiCard(
                                      title: getTxt(language, 'available'),
                                      value: "$availableCount",
                                      unit: getTxt(language, 'type_unit'),
                                      icon: Icons.check_circle_rounded,
                                      accentColor: _emerald,
                                      isSelected: _stockFilter == "available",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _stockFilter =
                                        _stockFilter == "available"
                                            ? "all"
                                            : "available";
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: itemW,
                                    child: _WarehouseKpiCard(
                                      title: getTxt(language, 'out_of_stock'),
                                      value: "$outCount",
                                      unit: getTxt(language, 'type_unit'),
                                      icon: Icons.warning_amber_rounded,
                                      accentColor: _rose,
                                      isSelected: _stockFilter == "out",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _stockFilter = _stockFilter == "out"
                                            ? "all"
                                            : "out";
                                      }),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 14),

                          // ================================================
                          // KAPSULA FILTRLAR
                          // ================================================
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _StockFilterPill(
                                  label:
                                  "${getTxt(language, 'all')} (${allProducts.length})",
                                  selected: _stockFilter == "all",
                                  activeColor: _primaryBlue,
                                  isDark: isDark,
                                  onTap: () =>
                                      setState(() => _stockFilter = "all"),
                                ),
                                const SizedBox(width: 8),
                                _StockFilterPill(
                                  label:
                                  "${getTxt(language, 'available')} ($availableCount)",
                                  selected: _stockFilter == "available",
                                  activeColor: _emerald,
                                  isDark: isDark,
                                  onTap: () => setState(
                                        () => _stockFilter = "available",
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _StockFilterPill(
                                  label:
                                  "${getTxt(language, 'out_of_stock')} ($outCount)",
                                  selected: _stockFilter == "out",
                                  activeColor: _rose,
                                  isDark: isDark,
                                  onTap: () =>
                                      setState(() => _stockFilter = "out"),
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
                                    getTxt(language, 'no_product'),
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
                                w >= 1080 ? 3 : (w >= 680 ? 2 : 1);
                                const double gap = 14;
                                final double cardWidth =
                                    (w - gap * (columns - 1)) / columns;

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: filteredMahsulotlar.map((m) {
                                    final int zaxira =
                                    mahsulotProv.getZaxira(m);
                                    final String narxFormat =
                                    _formatPrice(m.bemorNarxi);

                                    return SizedBox(
                                      width: cardWidth,
                                      child: _WarehouseProductCard(
                                        product: m,
                                        zaxira: zaxira,
                                        priceFormatted:
                                        "$narxFormat ${getTxt(language, 'currency')}",
                                        inStockLabel:
                                        getTxt(language, 'in_stock'),
                                        pcsLabel: getTxt(language, 'pcs'),
                                        priceLabel: getTxt(language, 'price'),
                                        outOfStockLabel:
                                        getTxt(language, 'out_of_stock'),
                                        isDark: isDark,
                                        cardBg: cardBg,
                                        borderColor: borderColor,
                                        textPrimary: textPrimary,
                                        textSecondary: textSecondary,
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
}

class _WarehouseKpiCard extends StatelessWidget {
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

  const _WarehouseKpiCard({
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

class _StockFilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _StockFilterPill({
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

class _WarehouseProductCard extends StatelessWidget {
  final MahsulotModel product;
  final int zaxira;
  final String priceFormatted;
  final String inStockLabel;
  final String pcsLabel;
  final String priceLabel;
  final String outOfStockLabel;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _WarehouseProductCard({
    required this.product,
    required this.zaxira,
    required this.priceFormatted,
    required this.inStockLabel,
    required this.pcsLabel,
    required this.priceLabel,
    required this.outOfStockLabel,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOut = zaxira <= 0;
    final Color statusColor =
    isOut ? const Color(0xFFF43F5E) : const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOut
              ? const Color(0xFFF43F5E).withValues(alpha: 0.7)
              : borderColor,
          width: isOut ? 1.5 : 1.0,
        ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ProductThumb(
            imagePath: product.rasm,
            productName: product.nomi,
            isOut: isOut,
            isDark: isDark,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nomi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    height: 1.2,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOut
                            ? Icons.error_outline_rounded
                            : Icons.inventory_rounded,
                        size: 15,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          isOut
                              ? "$outOfStockLabel (0 $pcsLabel)"
                              : "$inStockLabel $zaxira $pcsLabel",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      priceLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          priceFormatted,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7),
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
    );
  }
}

class _ProductThumb extends StatelessWidget {
  final String? imagePath;
  final String productName;
  final bool isOut;
  final bool isDark;

  const _ProductThumb({
    required this.imagePath,
    required this.productName,
    required this.isOut,
    required this.isDark,
  });

  String _firstLetter() {
    final trimmed = productName.trim();
    return trimmed.isNotEmpty ? trimmed[0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    final String path = imagePath?.trim() ?? "";
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');
    final Color letterColor = isOut
        ? const Color(0xFFF43F5E)
        : (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7));

    Widget fallback() {
      return Center(
        child: Text(
          _firstLetter(),
          style: TextStyle(
            fontSize: 32,
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
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isOut
            ? const Color(0xFFF43F5E).withValues(alpha: isDark ? 0.16 : 0.1)
            : (isDark
            ? const Color(0xFF0284C7).withValues(alpha: 0.16)
            : const Color(0xFF0284C7).withValues(alpha: 0.1)),
        border: Border.all(
          color: isOut
              ? const Color(0xFFF43F5E).withValues(alpha: 0.4)
              : (isDark
              ? const Color(0xFF334155)
              : const Color(0xFF0284C7).withValues(alpha: 0.25)),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }
}