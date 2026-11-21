import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import '../model/finished_product_model.dart';
import '../model/mahsulot_modeli.dart';
import '../model/model_provider.dart';
import 'daromad_pages/Ishchilar/ishchi malumoti/ishchi_detal.dart';

// ============================================================
// CLINICAL COLORS (HomePages bilan bir xil rang palitrasi)
// ============================================================
class _OmborColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF8FAFC);
}

enum _OmborFilter { all, ready, outOfStock }

class OmborPages extends StatefulWidget {
  const OmborPages({super.key});

  @override
  State<OmborPages> createState() => _OmborPagesState();

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Ombor": "Ombor",
      "Ma'lumot kiritilmagan": "Ma'lumot kiritilmagan",
      "Tugagan mahsulotlar": "Tugagan mahsulotlar",
      "Tayyor mahsulotlar": "Tayyor mahsulotlar",
      "1-Bo'lim": "1-Bo'lim",
      "2-Bo'lim": "2-Bo'lim",
      "Mahsulot qo'shish": "Mahsulot qo'shish",
      "Mahsulot nomi": "Mahsulot nomi",
      "Sanani kiriting": "Sanani kiriting",
      "Mahsulot soni": "Mahsulot soni",
      "Bekor qilish": "Bekor qilish",
      "Saqlash": "Saqlash",
      "Soni": "Soni",
      "Narxi": "Narxi",
      "so'm": "UZS",
      "ta": "ta",
      "Miqdor 0 dan katta bo'lishi kerak": "Miqdor 0 dan katta bo'lishi kerak",
      "Bunday mahsulot bazada mavjud emas": "Bunday mahsulot bazada mavjud emas",
      "Iltimos, barcha maydonlarni to'ldiring": "Iltimos, barcha maydonlarni to'ldiring",
      "Qidirish...": "Mahsulot nomi bo'yicha qidirish...",
      "Barchasi": "Barchasi",
      "Tayyor": "Tayyor",
      "Tugagan": "Tugagan",
      "Jami zaxira:": "Jami zaxira:",
      "Tayyorlanganlar:": "Tayyorlandi:",
      "To'ldirish": "To'ldirish",
      "Tugagan (0 ta)": "Tugagan",
      "Mahsulot muvaffaqiyatli qo'shildi": "Mahsulot muvaffaqiyatli qo'shildi",
      "Natija topilmadi": "Qidiruv bo'yicha mahsulot topilmadi",
      "Qidiruvni tozalash": "Filtrni tozalash",
      "Tez tanlash:": "Tez qo'shish:",
    },
    "Rus": {
      "Ombor": "Склад",
      "Ma'lumot kiritilmagan": "Данные не введены",
      "Tugagan mahsulotlar": "Закончившиеся товары",
      "Tayyor mahsulotlar": "Готовая продукция",
      "1-Bo'lim": "1-Отдел",
      "2-Bo'lim": "2-Отдел",
      "Mahsulot qo'shish": "Добавить продукт",
      "Mahsulot nomi": "Название продукта",
      "Sanani kiriting": "Введите дату",
      "Mahsulot soni": "Количество продукта",
      "Bekor qilish": "Отмена",
      "Saqlash": "Сохранить",
      "Soni": "Кол-во",
      "Narxi": "Цена",
      "so'm": "UZS",
      "ta": "шт",
      "Miqdor 0 dan katta bo'lishi kerak": "Количество должно быть больше 0",
      "Bunday mahsulot bazada mavjud emas": "Такого продукта нет в базе",
      "Iltimos, barcha maydonlarni to'ldiring": "Пожалуйста, заполните все поля",
      "Qidirish...": "Поиск по названию...",
      "Barchasi": "Все",
      "Tayyor": "В наличии",
      "Tugagan": "Нет в наличии",
      "Jami zaxira:": "Общий запас:",
      "Tayyorlanganlar:": "Готово:",
      "To'ldirish": "Пополнить",
      "Tugagan (0 ta)": "Закончился",
      "Mahsulot muvaffaqiyatli qo'shildi": "Продукт успешно добавлен",
      "Natija topilmadi": "Ничего не найдено",
      "Qidiruvni tozalash": "Сбросить фильтр",
      "Tez tanlash:": "Быстрый выбор:",
    },
    "Kiril": {
      "Ombor": "Омбор",
      "Ma'lumot kiritilmagan": "Маълумот киритилмаган",
      "Tugagan mahsulotlar": "Тугаган маҳсулотлар",
      "Tayyor mahsulotlar": "Тайёр маҳсулотлар",
      "1-Bo'lim": "1-Бўлим",
      "2-Bo'lim": "2-Бўлим",
      "Mahsulot qo'shish": "Маҳсулот қўшиш",
      "Mahsulot nomi": "Маҳсулот номи",
      "Sanani kiriting": "Санани киритинг",
      "Mahsulot soni": "Маҳсулот сони",
      "Bekor qilish": "Бекор қилиш",
      "Saqlash": "Сақлаш",
      "Soni": "Сони",
      "Narxi": "Нархи",
      "so'm": "UZS",
      "ta": "та",
      "Miqdor 0 dan katta bo'lishi kerak": "Миқдор 0 дан катта бўлиши керак",
      "Bunday mahsulot bazada mavjud emas": "Бундай маҳсулот базада мавжуд эмас",
      "Iltimos, barcha maydonlarni to'ldiring": "Илтимос, барча майдонларни тўлдиринг",
      "Qidirish...": "Маҳсулот номи бўйича қидириш...",
      "Barchasi": "Барчаси",
      "Tayyor": "Тайёр",
      "Tugagan": "Тугаган",
      "Jami zaxira:": "Жами захира:",
      "Tayyorlanganlar:": "Тайёрланди:",
      "To'ldirish": "Тўлдириш",
      "Tugagan (0 ta)": "Тугаган",
      "Mahsulot muvaffaqiyatli qo'shildi": "Маҳсулот муваффақиятли қўшилди",
      "Natija topilmadi": "Қидирув бўйича маҳсулот топилмади",
      "Qidiruvni tozalash": "Филтрни тозалаш",
      "Tez tanlash:": "Тез қўшиш:",
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

class _OmborPagesState extends State<OmborPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _OmborFilter _activeFilter = _OmborFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MahsulotProvider>().loadProducts();
      context.read<FinishedProductProvider>().fetchFinishedProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final mahsulotProvider = context.read<MahsulotProvider>();
    final finishedProductProvider = context.read<FinishedProductProvider>();
    await Future.wait([
      mahsulotProvider.loadProducts(),
      finishedProductProvider.fetchFinishedProducts(),
    ]);
  }

  String _formatPrice(String rawPrice) {
    final numeric = int.tryParse(rawPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return NumberFormat('#,###').format(numeric).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final mahsulotProvider = context.watch<MahsulotProvider>();
    final finishedProductProvider = context.watch<FinishedProductProvider>();
    context.watch<ProfileProvider>();

    final List<MahsulotModel> allProducts = mahsulotProvider.mahsulotlar;
    final List<FinishedProductModel> finishedProducts =
        finishedProductProvider.finishedProducts;

    final List<MahsulotModel> tugaganMahsulotlar =
    allProducts.where((p) => p.zaxira <= 0).toList();
    final List<MahsulotModel> tayyorMahsulotlar =
    allProducts.where((p) => p.zaxira > 0).toList();

    final int totalStockUnits =
    tayyorMahsulotlar.fold<int>(0, (sum, p) => sum + p.zaxira);
    final int totalFinishedQty =
    finishedProducts.fold<int>(0, (sum, item) => sum + item.quantity);

    final String query = _searchQuery.trim().toLowerCase();
    final List<MahsulotModel> filteredTugagan = query.isEmpty
        ? tugaganMahsulotlar
        : tugaganMahsulotlar
        .where((p) =>
    p.nomi.toLowerCase().contains(query) ||
        p.kategoriya.toLowerCase().contains(query))
        .toList();

    final List<MahsulotModel> filteredTayyor = query.isEmpty
        ? tayyorMahsulotlar
        : tayyorMahsulotlar
        .where((p) =>
    p.nomi.toLowerCase().contains(query) ||
        p.kategoriya.toLowerCase().contains(query))
        .toList();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isLoading =
        (mahsulotProvider.isLoading || finishedProductProvider.isLoading) &&
            allProducts.isEmpty;

    return Scaffold(
      backgroundColor: isDark ? _OmborColors.slateDark : _OmborColors.lightBg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 105),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_OmborColors.skyBlue, _OmborColors.primaryBlue],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: _OmborColors.primaryBlue.withValues(alpha: 0.4),
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
                _showAddProductDialog(
                  context,
                  mahsulotProvider,
                  finishedProductProvider,
                  isDark,
                );
              },
              child: const Center(
                child: Icon(Icons.add_rounded, color: Colors.white, size: 34),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: _OmborColors.primaryBlue,
          ),
        )
            : RefreshIndicator(
          onRefresh: _onRefresh,
          color: _OmborColors.primaryBlue,
          backgroundColor: isDark ? _OmborColors.cardDark : Colors.white,
          child: allProducts.isEmpty
              ? _buildEmptyScrollableState(
            context,
            isDark: isDark,
            icon: Icons.all_inbox_outlined,
            title: OmborPages.getTxt(context, "Ma'lumot kiritilmagan"),
          )
              : LayoutBuilder(
            builder: (context, constraints) {
              final double contentMaxWidth =
              constraints.maxWidth > 1080
                  ? 1080
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
                        _buildSummaryCards(
                          context,
                          isDark: isDark,
                          readyCount: tayyorMahsulotlar.length,
                          totalStockUnits: totalStockUnits,
                          outCount: tugaganMahsulotlar.length,
                          totalFinishedQty: totalFinishedQty,
                        ),
                        const SizedBox(height: 14),
                        _buildSearchAndFilterBar(
                          context,
                          isDark: isDark,
                          maxWidth: contentMaxWidth - 32,
                          allCount: allProducts.length,
                          readyCount: tayyorMahsulotlar.length,
                          outCount: tugaganMahsulotlar.length,
                        ),
                        const SizedBox(height: 16),
                        if (_activeFilter == _OmborFilter.all) ...[
                          if (filteredTugagan.isNotEmpty) ...[
                            _buildTugaganHorizontalSection(
                              context,
                              filteredTugagan,
                              mahsulotProvider,
                              finishedProductProvider,
                              isDark,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (filteredTayyor.isNotEmpty)
                            _buildProductsGridSection(
                              context,
                              title: OmborPages.getTxt(
                                  context, "Tayyor mahsulotlar"),
                              products: filteredTayyor,
                              accentColor: _OmborColors.green,
                              headerIcon: Icons.inventory_2_rounded,
                              mahsulotProvider: mahsulotProvider,
                              finishedProductProvider:
                              finishedProductProvider,
                              isDark: isDark,
                              isOutOfStockList: false,
                            )
                          else if (filteredTugagan.isEmpty)
                            _buildNoSearchResultsCard(
                                context, isDark),
                        ] else if (_activeFilter ==
                            _OmborFilter.ready) ...[
                          if (filteredTayyor.isNotEmpty)
                            _buildProductsGridSection(
                              context,
                              title: OmborPages.getTxt(
                                  context, "Tayyor mahsulotlar"),
                              products: filteredTayyor,
                              accentColor: _OmborColors.green,
                              headerIcon: Icons.inventory_2_rounded,
                              mahsulotProvider: mahsulotProvider,
                              finishedProductProvider:
                              finishedProductProvider,
                              isDark: isDark,
                              isOutOfStockList: false,
                            )
                          else
                            _buildNoSearchResultsCard(
                                context, isDark),
                        ] else ...[
                          if (filteredTugagan.isNotEmpty)
                            _buildProductsGridSection(
                              context,
                              title: OmborPages.getTxt(
                                  context, "Tugagan mahsulotlar"),
                              products: filteredTugagan,
                              accentColor: _OmborColors.rose,
                              headerIcon:
                              Icons.warning_amber_rounded,
                              mahsulotProvider: mahsulotProvider,
                              finishedProductProvider:
                              finishedProductProvider,
                              isDark: isDark,
                              isOutOfStockList: true,
                            )
                          else
                            _buildNoSearchResultsCard(
                                context, isDark),
                        ],
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

  Widget _buildSummaryCards(
      BuildContext context, {
        required bool isDark,
        required int readyCount,
        required int totalStockUnits,
        required int outCount,
        required int totalFinishedQty,
      }) {
    final unit = OmborPages.getTxt(context, "ta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: OmborPages.getTxt(context, "Tayyor mahsulotlar"),
            icon: Icons.inventory_2_rounded,
            iconColor: _OmborColors.green,
            mainValue: "$readyCount $unit",
            subLabel1: OmborPages.getTxt(context, "Jami zaxira:"),
            subVal1: "$totalStockUnits $unit",
            subLabel2: OmborPages.getTxt(context, "Tayyorlanganlar:"),
            subVal2: "$totalFinishedQty $unit",
            isSelected: _activeFilter == _OmborFilter.ready,
            isDark: isDark,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeFilter = _activeFilter == _OmborFilter.ready
                    ? _OmborFilter.all
                    : _OmborFilter.ready;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            context,
            title: OmborPages.getTxt(context, "Tugagan mahsulotlar"),
            icon: Icons.warning_amber_rounded,
            iconColor: _OmborColors.rose,
            mainValue: "$outCount $unit",
            subLabel1: OmborPages.getTxt(context, "Tugagan (0 ta)"),
            subVal1: "$outCount",
            subLabel2: OmborPages.getTxt(context, "Barchasi"),
            subVal2: "${readyCount + outCount}",
            isDanger: outCount > 0,
            isSelected: _activeFilter == _OmborFilter.outOfStock,
            isDark: isDark,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeFilter = _activeFilter == _OmborFilter.outOfStock
                    ? _OmborFilter.all
                    : _OmborFilter.outOfStock;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
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
        bool isDanger = false,
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
          color: isDark ? _OmborColors.cardDark : Colors.white,
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
                  color: isDanger
                      ? _OmborColors.rose
                      : (isDark ? Colors.white : const Color(0xFF0F172A)),
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

  Widget _buildSearchAndFilterBar(
      BuildContext context, {
        required bool isDark,
        required double maxWidth,
        required int allCount,
        required int readyCount,
        required int outCount,
      }) {
    final searchField = Container(
      decoration: BoxDecoration(
        color: isDark ? _OmborColors.cardDark : Colors.white,
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
        onChanged: (val) => setState(() => _searchQuery = val),
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: OmborPages.getTxt(context, "Qidirish..."),
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
        color: isDark ? _OmborColors.cardDark : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterPill(
              label: "${OmborPages.getTxt(context, "Barchasi")} ($allCount)",
              selected: _activeFilter == _OmborFilter.all,
              activeColor: _OmborColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _OmborFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label: "${OmborPages.getTxt(context, "Tayyor")} ($readyCount)",
              selected: _activeFilter == _OmborFilter.ready,
              activeColor: _OmborColors.green,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _OmborFilter.ready),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label: "${OmborPages.getTxt(context, "Tugagan")} ($outCount)",
              selected: _activeFilter == _OmborFilter.outOfStock,
              activeColor: _OmborColors.rose,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _OmborFilter.outOfStock),
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

  Widget _buildTugaganHorizontalSection(
      BuildContext context,
      List<MahsulotModel> tugaganMahsulotlar,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? _OmborColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: _OmborColors.rose.withValues(alpha: isDark ? 0.35 : 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : _OmborColors.rose.withValues(alpha: 0.06),
            blurRadius: 18,
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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _OmborColors.rose.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: _OmborColors.rose,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  OmborPages.getTxt(context, "Tugagan mahsulotlar"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: _OmborColors.rose.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${tugaganMahsulotlar.length} ${OmborPages.getTxt(context, "ta")}",
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: _OmborColors.rose,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 162,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: tugaganMahsulotlar.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final m = tugaganMahsulotlar[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showAddProductDialog(
                      context,
                      mahsulotProvider,
                      finishedProductProvider,
                      isDark,
                      initialProduct: m,
                    );
                  },
                  child: Container(
                    width: 126,
                    padding: const EdgeInsets.all(10),
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
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildProductThumbnail(
                              m,
                              size: 72,
                              borderRadius: 16,
                              isDark: isDark,
                              accentColor: _OmborColors.rose,
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _OmborColors.primaryBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? _OmborColors.cardDark
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Center(
                            child: Text(
                              m.nomi,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGridSection(
      BuildContext context, {
        required String title,
        required List<MahsulotModel> products,
        required Color accentColor,
        required IconData headerIcon,
        required MahsulotProvider mahsulotProvider,
        required FinishedProductProvider finishedProductProvider,
        required bool isDark,
        required bool isOutOfStockList,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? _OmborColors.cardDark : Colors.white,
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
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(headerIcon, color: accentColor, size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${products.length} ${OmborPages.getTxt(context, "ta")}",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.of(context).size.width - 64;
              const double spacing = 12;
              final int columns = maxWidth >= 900
                  ? 3
                  : maxWidth >= 560
                  ? 2
                  : 1;
              final double itemWidth =
                  (maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: products.map((m) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildProductItemCard(
                      context,
                      product: m,
                      isDark: isDark,
                      isOutOfStock: isOutOfStockList,
                      onAddTap: () {
                        HapticFeedback.lightImpact();
                        _showAddProductDialog(
                          context,
                          mahsulotProvider,
                          finishedProductProvider,
                          isDark,
                          initialProduct: m,
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductItemCard(
      BuildContext context, {
        required MahsulotModel product,
        required bool isDark,
        required bool isOutOfStock,
        required VoidCallback onAddTap,
      }) {
    final int zaxira = product.zaxira;
    final bool isLowStock = zaxira > 0 && zaxira <= 5;
    final Color stockColor = isOutOfStock || zaxira <= 0
        ? _OmborColors.rose
        : isLowStock
        ? _OmborColors.amber
        : _OmborColors.green;

    final String narxFormat = _formatPrice(product.bemorNarxi);
    final String unit = OmborPages.getTxt(context, "ta");

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onAddTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProductThumbnail(
              product,
              size: 82,
              borderRadius: 18,
              isDark: isDark,
              accentColor: stockColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (product.kategoriya.trim().isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: _OmborColors.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.kategoriya,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _OmborColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    product.nomi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17.5,
                      height: 1.25,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: stockColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${OmborPages.getTxt(context, "Soni")}: $zaxira $unit",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                            color: stockColor,
                          ),
                        ),
                      ),
                      Text(
                        "$narxFormat ${OmborPages.getTxt(context, "so'm")}",
                        style: TextStyle(
                          color: isDark
                              ? _OmborColors.skyBlue
                              : _OmborColors.primaryBlue,
                          fontWeight: FontWeight.w900,
                          fontSize: 15.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: OmborPages.getTxt(context, "To'ldirish"),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _OmborColors.primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 22,
                  color: _OmborColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductThumbnail(
      MahsulotModel m, {
        required double size,
        required double borderRadius,
        required bool isDark,
        required Color accentColor,
      }) {
    final bool hasImage = m.rasm != null && m.rasm!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF0F172A)
              : accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : accentColor.withValues(alpha: 0.16),
          ),
        ),
        child: hasImage
            ? Image.network(
          m.rasm!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _buildInitialAvatar(m.nomi, size, accentColor, isDark),
        )
            : _buildInitialAvatar(m.nomi, size, accentColor, isDark),
      ),
    );
  }

  Widget _buildInitialAvatar(
      String name,
      double size,
      Color accentColor,
      bool isDark,
      ) {
    final String letter =
    name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : "?";
    return Center(
      child: Text(
        letter,
        style: TextStyle(
          fontSize: size * 0.40,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white54 : accentColor,
        ),
      ),
    );
  }

  Widget _buildEmptyScrollableState(
      BuildContext context, {
        required bool isDark,
        required IconData icon,
        required String title,
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
                        color: _OmborColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 44,
                        color: _OmborColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
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

  Widget _buildNoSearchResultsCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: isDark ? _OmborColors.cardDark : Colors.white,
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
              color: _OmborColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 32,
              color: _OmborColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _searchQuery.isNotEmpty
                ? OmborPages.getTxt(context, "Natija topilmadi")
                : OmborPages.getTxt(context, "Ma'lumot kiritilmagan"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          if (_searchQuery.isNotEmpty || _activeFilter != _OmborFilter.all) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = "";
                  _activeFilter = _OmborFilter.all;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                OmborPages.getTxt(context, "Qidiruvni tozalash"),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _OmborColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddProductDialog(
      BuildContext context,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      bool isDark, {
        MahsulotModel? initialProduct,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _AddProductDialog(
          mahsulotProvider: mahsulotProvider,
          finishedProductProvider: finishedProductProvider,
          isDark: isDark,
          initialProduct: initialProduct,
          parentContext: context,
        );
      },
    );
  }
}

// ============================================================
// DIALOG STATEFUL WIDGET (Controllerlar xavfsiz boshqariladi)
// ============================================================
class _AddProductDialog extends StatefulWidget {
  final MahsulotProvider mahsulotProvider;
  final FinishedProductProvider finishedProductProvider;
  final bool isDark;
  final MahsulotModel? initialProduct;
  final BuildContext parentContext;

  const _AddProductDialog({
    required this.mahsulotProvider,
    required this.finishedProductProvider,
    required this.isDark,
    required this.parentContext,
    this.initialProduct,
  });

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  MahsulotModel? _selectedProduct;
  late DateTime _selectedDate;
  late final TextEditingController _soniController;
  late final TextEditingController _dateController;
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.initialProduct;
    _selectedDate = DateTime.now();
    _soniController = TextEditingController();
    _dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _soniController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    final isDark = widget.isDark;
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
        const BorderSide(color: _OmborColors.primaryBlue, width: 1.5),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    final int soni = int.tryParse(_soniController.text.trim()) ?? 0;

    if (_selectedProduct == null || _selectedProduct!.id == null) {
      setState(() {
        _errorText =
            OmborPages.getTxt(context, "Bunday mahsulot bazada mavjud emas");
      });
      return;
    }

    if (soni <= 0) {
      setState(() {
        _errorText =
            OmborPages.getTxt(context, "Miqdor 0 dan katta bo'lishi kerak");
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    try {
      await widget.finishedProductProvider.addFinishedProduct(
        productId: _selectedProduct!.id!,
        quantity: soni,
      );

      // Har bir qo'shish harakatini aniq sana va soati bilan alohida saqlash
      if (widget.parentContext.mounted) {
        final profile = widget.parentContext.read<ProfileProvider>();
        final now = DateTime.now();
        final exactDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          now.hour,
          now.minute,
          now.second,
        );
        await WorkerProductionLog.record(
          productName: _selectedProduct!.nomi,
          quantity: soni,
          dateTime: exactDateTime,
          workerName: "${profile.surname} ${profile.name}".trim(),
          workerLogin: profile.login,
        );

        final parentCtx = widget.parentContext;
        if (parentCtx.mounted) {
          await Future.wait([
            parentCtx.read<MahsulotProvider>().loadProducts(),
            widget.finishedProductProvider.fetchFinishedProducts(),
          ]);
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
      if (widget.parentContext.mounted) {
        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          SnackBar(
            content: Text(
              OmborPages.getTxt(
                widget.parentContext,
                "Mahsulot muvaffaqiyatli qo'shildi",
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            backgroundColor: _OmborColors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorText = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final List<MahsulotModel> allProducts = widget.mahsulotProvider.mahsulotlar;

    return AlertDialog(
      backgroundColor: isDark ? _OmborColors.cardDark : Colors.white,
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
              color: _OmborColors.primaryBlue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.add_box_rounded,
              color: _OmborColors.primaryBlue,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              OmborPages.getTxt(context, "Mahsulot qo'shish"),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Autocomplete<MahsulotModel>(
                  initialValue: TextEditingValue(
                    text: widget.initialProduct?.nomi ?? "",
                  ),
                  displayStringForOption: (m) => m.nomi,
                  optionsBuilder: (textValue) {
                    if (textValue.text.trim().isEmpty) {
                      return allProducts;
                    }
                    final q = textValue.text.trim().toLowerCase();
                    return allProducts
                        .where((m) => m.nomi.toLowerCase().contains(q));
                  },
                  onSelected: (m) {
                    setState(() {
                      _selectedProduct = m;
                      _errorText = null;
                    });
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 6,
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 220,
                            maxWidth: 340,
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shrinkWrap: true,
                            itemCount: options.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: isDark
                                  ? Colors.white10
                                  : const Color(0xFFE2E8F0),
                            ),
                            itemBuilder: (context, index) {
                              final MahsulotModel option =
                              options.elementAt(index);
                              final bool emptyStock = option.zaxira <= 0;
                              return ListTile(
                                dense: true,
                                title: Text(
                                  option.nomi,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (emptyStock
                                        ? _OmborColors.rose
                                        : _OmborColors.green)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${option.zaxira} ${OmborPages.getTxt(context, "ta")}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: emptyStock
                                          ? _OmborColors.rose
                                          : _OmborColors.green,
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
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: (value) {
                        final matched = allProducts.where(
                              (m) =>
                          m.nomi.trim().toLowerCase() ==
                              value.trim().toLowerCase(),
                        );
                        setState(() {
                          _selectedProduct =
                          matched.isNotEmpty ? matched.first : null;
                          _errorText = null;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDecoration(
                        OmborPages.getTxt(context, "Mahsulot nomi"),
                        Icons.medication_outlined,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: _inputDecoration(
                    OmborPages.getTxt(context, "Sanani kiriting"),
                    Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _soniController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() => _errorText = null);
                    }
                  },
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: _inputDecoration(
                    OmborPages.getTxt(context, "Mahsulot soni"),
                    Icons.numbers_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      OmborPages.getTxt(context, "Tez tanlash:"),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color:
                        isDark ? Colors.white54 : const Color(0xFF64748B),
                      ),
                    ),
                    ...[5, 10, 20, 50].map((val) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          final current =
                              int.tryParse(_soniController.text.trim()) ?? 0;
                          _soniController.text = (current + val).toString();
                          setState(() => _errorText = null);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 6),
                          decoration: BoxDecoration(
                            color: _OmborColors.primaryBlue
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "+$val",
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: _OmborColors.primaryBlue,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _OmborColors.rose.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _OmborColors.rose.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 19,
                          color: _OmborColors.rose,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: _OmborColors.rose,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                onPressed: _isSaving ? null : () => Navigator.pop(context),
                child: Text(
                  OmborPages.getTxt(context, "Bekor qilish"),
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
                  backgroundColor: _OmborColors.primaryBlue,
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
                  OmborPages.getTxt(context, "Saqlash"),
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