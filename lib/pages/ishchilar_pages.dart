import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import '../model/ishchi_modeli.dart';
import '../provider/profile_provider.dart';

// ============================================================
// CLINICAL COLORS (HomePages & OmborPages bilan bir xil)
// ============================================================
class _IshchiColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF8FAFC);
}

enum _IshchiFilter { all, doctors, techStaff }

class IshchilarPages extends StatefulWidget {
  const IshchilarPages({super.key});

  @override
  State<IshchilarPages> createState() => _IshchilarPagesState();

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Ma'lumot kiritilmagan": "Ma'lumot kiritilmagan",
      "Texnik xodim": "Texnik xodim",
      "Shifokorlar": "Shifokorlar",
      "Barchasi": "Barchasi",
      "Tahrirlash": "Tahrirlash",
      "Ishchi qo'shish": "Ishchi qo'shish",
      "Kamera": "Kamera",
      "Galereya": "Galereya",
      "F.I.Sh": "F.I.Sh",
      "Admin": "Admin",
      "Ishchi": "Ishchi",
      "Sotuvchi": "Sotuvchi",
      "Shifokor": "Shifokor",
      "Bekor qilish": "Bekor qilish",
      "Yangilash": "Yangilash",
      "Saqlash": "Saqlash",
      "Asosiy ma'lumotlarni to'ldiring": "Asosiy ma'lumotlarni to'ldiring",
      "Login Parol kiriting": "Login Parol kiriting",
      "Login": "Login",
      "Parol": "Parol",
      "Login va parolni kiriting": "Login va parolni kiriting",
      "Bu Login yoki Parol allaqachon ishlatilgan.":
      "Bu Login yoki Parol allaqachon ishlatilgan.",
      "Ishchi ma'lumotlari": "Xodim ma'lumotlari",
      "Telefon": "Telefon",
      "Lavozim": "Lavozim",
      "Kasbi": "Kasbi",
      "O'chirish": "O'chirish",
      "Yopish": "Yopish",
      "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?":
      "Haqiqatan ham ushbu xodimni o'chirmoqchimisiz?",
      "Yo'q": "Yo'q",
      "Ha": "Ha",
      "Xatolik yuz berdi": "Xatolik yuz berdi",
      "Qidirish...": "Ism yoki telefon bo'yicha qidirish...",
      "Jami xodimlar:": "Jami xodimlar:",
      "Admin / Sotuvchi:": "Admin / Sotuvchi:",
      "ta": "ta",
      "Natija topilmadi": "Qidiruv bo'yicha xodim topilmadi",
      "Filtrni tozalash": "Filtrni tozalash",
      "Qo'ng'iroq qilish": "Qo'ng'iroq qilish",
    },
    "Rus": {
      "Ma'lumot kiritilmagan": "Данные не введены",
      "Texnik xodim": "Технический персонал",
      "Shifokorlar": "Врачи",
      "Barchasi": "Все",
      "Tahrirlash": "Редактировать",
      "Ishchi qo'shish": "Добавить сотрудника",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "F.I.Sh": "Ф.И.О",
      "Admin": "Админ",
      "Ishchi": "Работник",
      "Sotuvchi": "Продавец",
      "Shifokor": "Врач",
      "Bekor qilish": "Отмена",
      "Yangilash": "Обновить",
      "Saqlash": "Сохранить",
      "Asosiy ma'lumotlarni to'ldiring": "Заполните основные данные",
      "Login Parol kiriting": "Введите логин и пароль",
      "Login": "Логин",
      "Parol": "Пароль",
      "Login va parolni kiriting": "Введите логин и пароль",
      "Bu Login yoki Parol allaqachon ishlatilgan.":
      "Этот логин или пароль уже используется.",
      "Ishchi ma'lumotlari": "Данные сотрудника",
      "Telefon": "Телефон",
      "Lavozim": "Должность",
      "Kasbi": "Специальность",
      "O'chirish": "Удалить",
      "Yopish": "Закрыть",
      "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?":
      "Вы действительно хотите удалить этого сотрудника?",
      "Yo'q": "Нет",
      "Ha": "Да",
      "Xatolik yuz berdi": "Произошла ошибка",
      "Qidirish...": "Поиск по имени или телефону...",
      "Jami xodimlar:": "Всего сотрудников:",
      "Admin / Sotuvchi:": "Админ / Продавец:",
      "ta": "чел.",
      "Natija topilmadi": "Сотрудники не найдены",
      "Filtrni tozalash": "Сбросить фильтр",
      "Qo'ng'iroq qilish": "Позвонить",
    },
    "Kiril": {
      "Ma'lumot kiritilmagan": "Маълумот киритилмаган",
      "Texnik xodim": "Техник ходим",
      "Shifokorlar": "Шифокорлар",
      "Barchasi": "Барчаси",
      "Tahrirlash": "Таҳрирлаш",
      "Ishchi qo'shish": "Ишчи қўшиш",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "F.I.Sh": "Ф.И.Ш",
      "Admin": "Админ",
      "Ishchi": "Ишчи",
      "Sotuvchi": "Сотувчи",
      "Shifokor": "Шифокор",
      "Bekor qilish": "Бекор қилиш",
      "Yangilash": "Янгилаш",
      "Saqlash": "Сақлаш",
      "Asosiy ma'lumotlarni to'ldiring": "Асосий маълумотларни тўлдиринг",
      "Login Parol kiriting": "Логин Парол киритинг",
      "Login": "Логин",
      "Parol": "Парол",
      "Login va parolni kiriting": "Логин ва паролни киритинг",
      "Bu Login yoki Parol allaqachon ishlatilgan.":
      "Бу Логин ёки Парол аллақачон ишлатилган.",
      "Ishchi ma'lumotlari": "Ходим маълумотлари",
      "Telefon": "Телефон",
      "Lavozim": "Лавозим",
      "Kasbi": "Касби",
      "O'chirish": "Ўчириш",
      "Yopish": "Ёпиш",
      "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?":
      "Ҳақиқатан ҳам ушбу ходимни ўчирмоқчимисиз?",
      "Yo'q": "Йўқ",
      "Ha": "Ҳа",
      "Xatolik yuz berdi": "Хатолик юз берди",
      "Qidirish...": "Исм ёки телефон бўйича қидириш...",
      "Jami xodimlar:": "Жами ходимлар:",
      "Admin / Sotuvchi:": "Админ / Сотувчи:",
      "ta": "та",
      "Natija topilmadi": "Қидирув бўйича ходим топилмади",
      "Filtrni tozalash": "Филтрни тозалаш",
      "Qo'ng'iroq qilish": "Қўнғироқ қилиш",
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

class _IshchilarPagesState extends State<IshchilarPages> {
  final maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _IshchiFilter _activeFilter = _IshchiFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<IshchiProvider>().fetchIshchilar();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IshchiProvider>();
    final profile = context.watch<ProfileProvider>();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<IshchiModel> allEmployees = provider.ishchilar;
    final bool hasEmployees = allEmployees.isNotEmpty;

    // FAQAT ADMIN
    final bool isAdmin = profile.role.trim().toLowerCase() == 'admin';

    final int doctorCount =
        allEmployees.where((i) => i.kasb == "Shifokor").length;
    final int techCount =
        allEmployees.where((i) => i.kasb == "Texnik xodim").length;
    final int adminSellerCount = allEmployees.where((i) {
      final role = i.lavozim.trim().toLowerCase();
      return role == "admin" || role == "sotuvchi";
    }).length;

    final String query = _searchQuery.trim().toLowerCase();
    bool matchesQuery(IshchiModel ishchi) {
      if (query.isEmpty) return true;
      final fullName = "${ishchi.familya} ${ishchi.ism}".toLowerCase();
      final phone = ishchi.telefon.toLowerCase();
      final role = ishchi.lavozim.toLowerCase();
      return fullName.contains(query) ||
          phone.contains(query) ||
          role.contains(query);
    }

    final int filteredTechCount = allEmployees
        .where((i) => i.kasb == "Texnik xodim" && matchesQuery(i))
        .length;
    final int filteredDoctorCount = allEmployees
        .where((i) => i.kasb == "Shifokor" && matchesQuery(i))
        .length;

    final bool showTech = _activeFilter == _IshchiFilter.all ||
        _activeFilter == _IshchiFilter.techStaff;
    final bool showDoctors = _activeFilter == _IshchiFilter.all ||
        _activeFilter == _IshchiFilter.doctors;

    final bool nothingMatched = (showTech ? filteredTechCount : 0) +
        (showDoctors ? filteredDoctorCount : 0) ==
        0;

    return Scaffold(
      backgroundColor: isDark ? _IshchiColors.slateDark : _IshchiColors.lightBg,
      floatingActionButton: isAdmin ? _buildAddButton(context) : null,
      body: SafeArea(
        bottom: false,
        child: provider.isLoading && !hasEmployees
            ? const Center(
          child: CircularProgressIndicator(
            color: _IshchiColors.primaryBlue,
          ),
        )
            : RefreshIndicator(
          onRefresh: () => provider.fetchIshchilar(),
          color: _IshchiColors.primaryBlue,
          backgroundColor: isDark ? _IshchiColors.cardDark : Colors.white,
          child: !hasEmployees
              ? _buildEmptyScrollableState(
            context,
            isDark: isDark,
            errorText: provider.error,
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
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.error != null)
                          _buildErrorBanner(
                            provider.error!,
                            isDark,
                          ),

                        // 1. KPI STATISTIKA KARTALARI
                        _buildSummaryCards(
                          context,
                          isDark: isDark,
                          doctorCount: doctorCount,
                          techCount: techCount,
                          totalCount: allEmployees.length,
                          adminSellerCount: adminSellerCount,
                        ),
                        const SizedBox(height: 14),

                        // 2. QIDIRUV VA KAPSULA FILTR
                        _buildSearchAndFilterBar(
                          context,
                          isDark: isDark,
                          maxWidth: contentMaxWidth - 32,
                          allCount: allEmployees.length,
                          doctorCount: doctorCount,
                          techCount: techCount,
                        ),
                        const SizedBox(height: 16),

                        // 3. XODIMLAR GURUHLARI
                        if (nothingMatched)
                          _buildNoSearchResultsCard(context, isDark)
                        else ...[
                          if (showTech && filteredTechCount > 0) ...[
                            IshchiGuruhi(
                              title: IshchilarPages.getTxt(
                                context,
                                "Texnik xodim",
                              ),
                              kasb: "Texnik xodim",
                              searchQuery: _searchQuery,
                            ),
                            if (showDoctors &&
                                filteredDoctorCount > 0)
                              const SizedBox(height: 16),
                          ],
                          if (showDoctors &&
                              filteredDoctorCount > 0)
                            IshchiGuruhi(
                              title: IshchilarPages.getTxt(
                                context,
                                "Shifokorlar",
                              ),
                              kasb: "Shifokor",
                              searchQuery: _searchQuery,
                            ),
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

  Widget _buildErrorBanner(String error, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _IshchiColors.rose.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _IshchiColors.rose.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: _IshchiColors.rose,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: _IshchiColors.rose,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 1. KPI STATISTIKA KARTALARI (HomePages & OmborPages uslubida)
  // ============================================================
  Widget _buildSummaryCards(
      BuildContext context, {
        required bool isDark,
        required int doctorCount,
        required int techCount,
        required int totalCount,
        required int adminSellerCount,
      }) {
    final unit = IshchilarPages.getTxt(context, "ta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: IshchilarPages.getTxt(context, "Shifokorlar"),
            icon: Icons.medical_services_rounded,
            iconColor: _IshchiColors.primaryBlue,
            mainValue: "$doctorCount $unit",
            subLabel1: IshchilarPages.getTxt(context, "Jami xodimlar:"),
            subVal1: "$totalCount $unit",
            subLabel2: IshchilarPages.getTxt(context, "Admin / Sotuvchi:"),
            subVal2: "$adminSellerCount $unit",
            isSelected: _activeFilter == _IshchiFilter.doctors,
            isDark: isDark,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeFilter = _activeFilter == _IshchiFilter.doctors
                    ? _IshchiFilter.all
                    : _IshchiFilter.doctors;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            context,
            title: IshchilarPages.getTxt(context, "Texnik xodim"),
            icon: Icons.engineering_rounded,
            iconColor: _IshchiColors.green,
            mainValue: "$techCount $unit",
            subLabel1: IshchilarPages.getTxt(context, "Shifokorlar"),
            subVal1: "$doctorCount $unit",
            subLabel2: IshchilarPages.getTxt(context, "Barchasi"),
            subVal2: "$totalCount $unit",
            isSelected: _activeFilter == _IshchiFilter.techStaff,
            isDark: isDark,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _activeFilter = _activeFilter == _IshchiFilter.techStaff
                    ? _IshchiFilter.all
                    : _IshchiFilter.techStaff;
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
          color: isDark ? _IshchiColors.cardDark : Colors.white,
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
  // 2. QIDIRUV VA KAPSULALI FILTR
  // ============================================================
  Widget _buildSearchAndFilterBar(
      BuildContext context, {
        required bool isDark,
        required double maxWidth,
        required int allCount,
        required int doctorCount,
        required int techCount,
      }) {
    final searchField = Container(
      decoration: BoxDecoration(
        color: isDark ? _IshchiColors.cardDark : Colors.white,
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
          hintText: IshchilarPages.getTxt(context, "Qidirish..."),
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
        color: isDark ? _IshchiColors.cardDark : const Color(0xFFF1F5F9),
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
              "${IshchilarPages.getTxt(context, "Barchasi")} ($allCount)",
              selected: _activeFilter == _IshchiFilter.all,
              activeColor: _IshchiColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _IshchiFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${IshchilarPages.getTxt(context, "Shifokorlar")} ($doctorCount)",
              selected: _activeFilter == _IshchiFilter.doctors,
              activeColor: _IshchiColors.skyBlue,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _IshchiFilter.doctors),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label:
              "${IshchilarPages.getTxt(context, "Texnik xodim")} ($techCount)",
              selected: _activeFilter == _IshchiFilter.techStaff,
              activeColor: _IshchiColors.green,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _IshchiFilter.techStaff),
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

  Widget _buildEmptyScrollableState(
      BuildContext context, {
        required bool isDark,
        String? errorText,
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
                        color: _IshchiColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.people_outline_rounded,
                        size: 44,
                        color: _IshchiColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      IshchilarPages.getTxt(
                        context,
                        "Ma'lumot kiritilmagan",
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w800,
                        color:
                        isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _IshchiColors.rose,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
        color: isDark ? _IshchiColors.cardDark : Colors.white,
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
              color: _IshchiColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 32,
              color: _IshchiColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            IshchilarPages.getTxt(context, "Natija topilmadi"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          if (_searchQuery.isNotEmpty || _activeFilter != _IshchiFilter.all) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = "";
                  _activeFilter = _IshchiFilter.all;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                IshchilarPages.getTxt(context, "Filtrni tozalash"),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _IshchiColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 105),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_IshchiColors.skyBlue, _IshchiColors.primaryBlue],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: _IshchiColors.primaryBlue.withValues(alpha: 0.4),
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
              context.read<IshchiProvider>().tozalash();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => IshchiQoshishDialog(
                  maskFormatter: maskFormatter,
                ),
              );
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
}

// ============================================================
// ISHCHI GURUHI (Responsive Grid + Zamonaviy Kartalar)
// ============================================================
class IshchiGuruhi extends StatelessWidget {
  final String title;
  final String kasb;
  final String searchQuery;

  const IshchiGuruhi({
    super.key,
    required this.title,
    required this.kasb,
    this.searchQuery = "",
  });

  String _formatPhoneDisplay(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (digits.isEmpty) return "-";

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

  String _getInitial(IshchiModel ishchi) {
    final fam = ishchi.familya.trim();
    final ism = ishchi.ism.trim();
    if (fam.isNotEmpty) return fam[0].toUpperCase();
    if (ism.isNotEmpty) return ism[0].toUpperCase();
    return "?";
  }

  Color _roleColor(String lavozim) {
    switch (lavozim.trim().toLowerCase()) {
      case 'admin':
        return _IshchiColors.rose;
      case 'sotuvchi':
        return _IshchiColors.amber;
      default:
        return _IshchiColors.primaryBlue;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.isEmpty) return;
    final normalized = cleaned.startsWith('+') ? cleaned : '+$cleaned';
    final Uri launchUri = Uri(scheme: 'tel', path: normalized);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

  void _showDetailDialog(
      BuildContext context,
      IshchiModel ishchi,
      int realIndex,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = context.read<ProfileProvider>();
    final bool isAdmin = profile.role.trim().toLowerCase() == 'admin';
    final Color accent =
    kasb == "Shifokor" ? _IshchiColors.primaryBlue : _IshchiColors.green;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? _IshchiColors.cardDark.withValues(alpha: 0.95)
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
                      IshchilarPages.getTxt(context, "Ishchi ma'lumotlari"),
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _EmployeeAvatar(
                      ishchi: ishchi,
                      size: 100,
                      accentColor: accent,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "${ishchi.familya} ${ishchi.ism}".trim(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: [
                        _badgeChip(
                          IshchilarPages.getTxt(context, ishchi.lavozim),
                          _roleColor(ishchi.lavozim),
                        ),
                        _badgeChip(
                          IshchilarPages.getTxt(context, ishchi.kasb),
                          accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                            IshchilarPages.getTxt(context, "F.I.Sh"),
                            "${ishchi.familya} ${ishchi.ism}".trim(),
                            isDark,
                          ),
                          _buildDetailDivider(isDark),
                          _buildDetailItem(
                            Icons.phone_outlined,
                            IshchilarPages.getTxt(context, "Telefon"),
                            _formatPhoneDisplay(ishchi.telefon),
                            isDark,
                          ),
                          _buildDetailDivider(isDark),
                          _buildDetailItem(
                            Icons.badge_outlined,
                            IshchilarPages.getTxt(context, "Lavozim"),
                            IshchilarPages.getTxt(context, ishchi.lavozim),
                            isDark,
                          ),
                          _buildDetailDivider(isDark),
                          _buildDetailItem(
                            Icons.work_outline_rounded,
                            IshchilarPages.getTxt(context, "Kasbi"),
                            IshchilarPages.getTxt(context, ishchi.kasb),
                            isDark,
                          ),
                          if (ishchi.login != null &&
                              ishchi.login!.trim().isNotEmpty) ...[
                            _buildDetailDivider(isDark),
                            _buildDetailItem(
                              Icons.alternate_email_rounded,
                              IshchilarPages.getTxt(context, "Login"),
                              ishchi.login!,
                              isDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _IshchiColors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => _makePhoneCall(ishchi.telefon),
                        icon: const Icon(Icons.phone_rounded, size: 20),
                        label: Text(
                          IshchilarPages.getTxt(context, "Qo'ng'iroq qilish"),
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                _IshchiColors.rose.withValues(alpha: 0.12),
                                foregroundColor: _IshchiColors.rose,
                                elevation: 0,
                                padding:
                                const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                _showDeleteDialog(context, realIndex);
                              },
                              icon: const Icon(Icons.delete_outline, size: 20),
                              label: Text(
                                IshchilarPages.getTxt(context, "O'chirish"),
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
                                backgroundColor: _IshchiColors.primaryBlue
                                    .withValues(alpha: 0.12),
                                foregroundColor: _IshchiColors.primaryBlue,
                                elevation: 0,
                                padding:
                                const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                context
                                    .read<IshchiProvider>()
                                    .tahrirlashUchunYuklash(realIndex);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => IshchiQoshishDialog(
                                    maskFormatter: MaskTextInputFormatter(
                                      mask: '## ### ## ##',
                                    ),
                                    isEditing: true,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              label: Text(
                                IshchilarPages.getTxt(context, "Tahrirlash"),
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
                        onPressed: () => Navigator.pop(dialogContext),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          IshchilarPages.getTxt(context, "Yopish"),
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
      ),
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
      bool isDark,
      ) {
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
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
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

  void _showDeleteDialog(BuildContext context, int realIndex) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? _IshchiColors.cardDark : Colors.white,
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
                color: _IshchiColors.rose.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 30,
                color: _IshchiColors.rose,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              IshchilarPages.getTxt(context, "O'chirish"),
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              IshchilarPages.getTxt(
                context,
                "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?",
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
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      IshchilarPages.getTxt(context, "Yo'q"),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _IshchiColors.rose,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      final ishchiProvider = context.read<IshchiProvider>();
                      final success = await ishchiProvider.ochirish(realIndex);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ishchiProvider.error ??
                                  IshchilarPages.getTxt(
                                    context,
                                    "Xatolik yuz berdi",
                                  ),
                            ),
                            backgroundColor: _IshchiColors.rose,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      IshchilarPages.getTxt(context, "Ha"),
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IshchiProvider>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String query = searchQuery.trim().toLowerCase();

    final filteredIshchilar = provider.ishchilar.where((ishchi) {
      if (ishchi.kasb != kasb) return false;
      if (query.isEmpty) return true;
      final fullName = "${ishchi.familya} ${ishchi.ism}".toLowerCase();
      return fullName.contains(query) ||
          ishchi.telefon.toLowerCase().contains(query) ||
          ishchi.lavozim.toLowerCase().contains(query);
    }).toList();

    if (filteredIshchilar.isEmpty) {
      return const SizedBox.shrink();
    }

    final Color accentColor =
    kasb == "Shifokor" ? _IshchiColors.primaryBlue : _IshchiColors.green;
    final IconData headerIcon = kasb == "Shifokor"
        ? Icons.medical_services_rounded
        : Icons.engineering_rounded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? _IshchiColors.cardDark : Colors.white,
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
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
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
                  "${filteredIshchilar.length} ${IshchilarPages.getTxt(context, "ta")}",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
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
                children: filteredIshchilar.map((ishchi) {
                  final realIndex = provider.ishchilar.indexOf(ishchi);
                  final Color roleColor = _roleColor(ishchi.lavozim);
                  final String displayName = "${ishchi.familya} ${ishchi.ism}"
                      .replaceAll(RegExp(r'\s+'), ' ')
                      .trim();

                  return SizedBox(
                    width: itemWidth,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showDetailDialog(context, ishchi, realIndex);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _EmployeeAvatar(
                              ishchi: ishchi,
                              size: 58,
                              accentColor: accentColor,
                              isDark: isDark,
                              fallbackInitial: _getInitial(ishchi),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: roleColor.withValues(alpha: 0.13),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      IshchilarPages.getTxt(
                                        context,
                                        ishchi.lavozim,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: roleColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    displayName,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      height: 1.2,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _formatPhoneDisplay(ishchi.telefon),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  _makePhoneCall(ishchi.telefon);
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: _IshchiColors.green
                                        .withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.phone_rounded,
                                    color: _IshchiColors.green,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}

// ============================================================
// SAFE EMPLOYEE AVATAR WIDGET (Rasm xatosiz ko'rsatiladi)
// ============================================================
class _EmployeeAvatar extends StatelessWidget {
  final IshchiModel ishchi;
  final double size;
  final Color accentColor;
  final bool isDark;
  final String? fallbackInitial;

  const _EmployeeAvatar({
    required this.ishchi,
    required this.size,
    required this.accentColor,
    required this.isDark,
    this.fallbackInitial,
  });

  @override
  Widget build(BuildContext context) {
    final String? rasm = ishchi.rasm;
    final bool hasImage = rasm != null && rasm.trim().isNotEmpty;
    final String fam = ishchi.familya.trim();
    final String ism = ishchi.ism.trim();
    final String initial = fallbackInitial ??
        (fam.isNotEmpty
            ? fam[0].toUpperCase()
            : (ism.isNotEmpty ? ism[0].toUpperCase() : "?"));

    Widget fallback() {
      return Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : accentColor,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? const Color(0xFF0F172A)
            : accentColor.withValues(alpha: 0.12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.45),
          width: 2,
        ),
      ),
      child: ClipOval(
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
}

// ============================================================
// ISHCHI QO'SHISH / TAHRIRLASH DIALOGI
// ============================================================
class IshchiQoshishDialog extends StatefulWidget {
  final MaskTextInputFormatter maskFormatter;
  final bool isEditing;

  const IshchiQoshishDialog({
    super.key,
    required this.maskFormatter,
    this.isEditing = false,
  });

  @override
  State<IshchiQoshishDialog> createState() => _IshchiQoshishDialogState();
}

class _IshchiQoshishDialogState extends State<IshchiQoshishDialog> {
  late final TextEditingController fullNameController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<IshchiProvider>();

    if (widget.isEditing) {
      fullNameController = TextEditingController(
        text: "${provider.familyaController.text} ${provider.ismController.text}"
            .trim(),
      );
    } else {
      fullNameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
      String label,
      bool isDark, {
        IconData? icon,
        String? prefix,
      }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.white70 : const Color(0xFF64748B),
        fontSize: 15,
      ),
      prefixText: prefix,
      prefixStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
      prefixIcon: icon != null
          ? Icon(
        icon,
        size: 21,
        color: isDark ? Colors.white54 : const Color(0xFF64748B),
      )
          : null,
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
        const BorderSide(color: _IshchiColors.primaryBlue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IshchiProvider>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    const lavozimItems = ["Admin", "Ishchi", "Sotuvchi"];
    const kasbItems = ["Shifokor", "Texnik xodim"];

    final String safeLavozim = lavozimItems.firstWhere(
          (e) => e.toLowerCase() == provider.lavozim.trim().toLowerCase(),
      orElse: () => lavozimItems.first,
    );
    final String safeKasb = kasbItems.firstWhere(
          (e) => e.toLowerCase() == provider.kasb.trim().toLowerCase(),
      orElse: () => kasbItems.first,
    );

    return AlertDialog(
      backgroundColor: isDark ? _IshchiColors.cardDark : Colors.white,
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
              color: _IshchiColors.primaryBlue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              widget.isEditing
                  ? Icons.edit_rounded
                  : Icons.person_add_alt_1_rounded,
              color: _IshchiColors.primaryBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.isEditing
                  ? IshchilarPages.getTxt(context, "Tahrirlash")
                  : IshchilarPages.getTxt(context, "Ishchi qo'shish"),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                      isDark ? _IshchiColors.cardDark : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (sheetContext) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: _IshchiColors.primaryBlue,
                                ),
                                title: Text(
                                  IshchilarPages.getTxt(context, "Kamera"),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  provider.rasmTanlash(
                                    context,
                                    ImageSource.camera,
                                  );
                                  Navigator.pop(sheetContext);
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.photo_library_rounded,
                                  color: _IshchiColors.primaryBlue,
                                ),
                                title: Text(
                                  IshchilarPages.getTxt(context, "Galereya"),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  provider.rasmTanlash(
                                    context,
                                    ImageSource.gallery,
                                  );
                                  Navigator.pop(sheetContext);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : _IshchiColors.primaryBlue
                              .withValues(alpha: 0.1),
                          border: Border.all(
                            color: _IshchiColors.primaryBlue
                                .withValues(alpha: 0.45),
                            width: 2.5,
                          ),
                          image: provider.imageFile != null
                              ? DecorationImage(
                            image: FileImage(provider.imageFile!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: provider.imageFile == null
                            ? ValueListenableBuilder<TextEditingValue>(
                          valueListenable: fullNameController,
                          builder: (context, value, child) {
                            final String name = value.text.trim();
                            if (name.isEmpty) {
                              return Icon(
                                Icons.add_a_photo_rounded,
                                color: isDark
                                    ? Colors.white38
                                    : _IshchiColors.primaryBlue,
                                size: 34,
                              );
                            }
                            return Center(
                              child: Text(
                                name[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? Colors.white
                                      : _IshchiColors.primaryBlue,
                                ),
                              ),
                            );
                          },
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _IshchiColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? _IshchiColors.cardDark
                                  : Colors.white,
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: fullNameController,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    IshchilarPages.getTxt(context, "F.I.Sh"),
                    isDark,
                    icon: Icons.person_outline_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: provider.telefonController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [widget.maskFormatter],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    "90 123 45 67",
                    isDark,
                    icon: Icons.phone_outlined,
                    prefix: "+998 ",
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(safeLavozim),
                  initialValue: safeLavozim,
                  dropdownColor:
                  isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    IshchilarPages.getTxt(context, "Lavozim"),
                    isDark,
                    icon: Icons.badge_outlined,
                  ),
                  items: lavozimItems
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(IshchilarPages.getTxt(context, e)),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) provider.lavozimTanlash(val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(safeKasb),
                  initialValue: safeKasb,
                  dropdownColor:
                  isDark ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: _inputDecoration(
                    IshchilarPages.getTxt(context, "Kasbi"),
                    isDark,
                    icon: Icons.work_outline_rounded,
                  ),
                  items: kasbItems
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(IshchilarPages.getTxt(context, e)),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) provider.kasbTanlash(val);
                  },
                ),
                if (provider.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: CircularProgressIndicator(
                      color: _IshchiColors.primaryBlue,
                    ),
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
                onPressed:
                provider.isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  IshchilarPages.getTxt(context, "Bekor qilish"),
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
                  backgroundColor: _IshchiColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: provider.isLoading
                    ? null
                    : () async {
                  final String full = fullNameController.text.trim();
                  final int firstSpace = full.indexOf(' ');

                  if (firstSpace != -1) {
                    provider.familyaController.text =
                        full.substring(0, firstSpace);
                    provider.ismController.text =
                        full.substring(firstSpace + 1);
                  } else {
                    provider.familyaController.text = full;
                    provider.ismController.text = " ";
                  }

                  if (provider.tekshirAsosiy()) {
                    final success = await provider.qoshish();
                    if (context.mounted) {
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.error ??
                                  IshchilarPages.getTxt(
                                    context,
                                    "Xatolik yuz berdi",
                                  ),
                            ),
                            backgroundColor: _IshchiColors.rose,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          IshchilarPages.getTxt(
                            context,
                            "Asosiy ma'lumotlarni to'ldiring",
                          ),
                        ),
                        backgroundColor: _IshchiColors.rose,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  widget.isEditing
                      ? IshchilarPages.getTxt(context, "Yangilash")
                      : IshchilarPages.getTxt(context, "Saqlash"),
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

// ============================================================
// LOGIN PAROL DIALOG
// ============================================================
class LoginParolDialog extends StatelessWidget {
  final bool isEditing;

  const LoginParolDialog({
    super.key,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IshchiProvider>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? _IshchiColors.cardDark : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      title: Center(
        child: Text(
          IshchilarPages.getTxt(context, "Login Parol kiriting"),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
            fontSize: 19,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField(
                  provider.loginController,
                  IshchilarPages.getTxt(context, "Login"),
                  isDark,
                  Icons.person_outline_rounded,
                ),
                const SizedBox(height: 14),
                _buildDialogField(
                  provider.parolController,
                  IshchilarPages.getTxt(context, "Parol"),
                  isDark,
                  Icons.lock_outline_rounded,
                  obscure: true,
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
                onPressed: () => Navigator.pop(context),
                child: Text(
                  IshchilarPages.getTxt(context, "Bekor qilish"),
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
                  backgroundColor: _IshchiColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  if (provider.tekshirLogin()) {
                    final login = provider.loginController.text;
                    final parol = provider.parolController.text;

                    bool exists = false;
                    for (var ishchi in provider.ishchilar) {
                      if (isEditing &&
                          provider.ishchilar.indexOf(ishchi) ==
                              provider.tahrirlashIndex) {
                        continue;
                      }
                      if ((ishchi.login != null && ishchi.login == login) ||
                          (ishchi.parol != null && ishchi.parol == parol)) {
                        exists = true;
                        break;
                      }
                    }

                    if (exists) {
                      _showDuplicateErrorDialog(context);
                    } else {
                      provider.qoshish();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          IshchilarPages.getTxt(
                            context,
                            "Login va parolni kiriting",
                          ),
                        ),
                        backgroundColor: _IshchiColors.rose,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  isEditing
                      ? IshchilarPages.getTxt(context, "Yangilash")
                      : IshchilarPages.getTxt(context, "Saqlash"),
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

  Widget _buildDialogField(
      TextEditingController controller,
      String hint,
      bool isDark,
      IconData icon, {
        bool obscure = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white70 : const Color(0xFF64748B),
        ),
        prefixIcon: Icon(
          icon,
          size: 21,
          color: isDark ? Colors.white54 : const Color(0xFF64748B),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          const BorderSide(color: _IshchiColors.primaryBlue, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showDuplicateErrorDialog(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        Future.delayed(
          const Duration(seconds: 3),
              () {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          },
        );

        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 36),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark
                        ? _IshchiColors.cardDark.withValues(alpha: 0.92)
                        : Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: _IshchiColors.amber,
                          size: 52,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          IshchilarPages.getTxt(
                            context,
                            "Bu Login yoki Parol allaqachon ishlatilgan.",
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
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