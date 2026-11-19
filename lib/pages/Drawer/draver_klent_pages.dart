import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/mijoz_modeli.dart';
import '../../provider/mijoz_provider/mijoz_provider.dart';
import '../../provider/profile_provider.dart';

class DraverKlentPages extends StatefulWidget {
  const DraverKlentPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "mijozlar": "Mijozlar",
      "barchasi": "Barchasi",
      "jami_mijozlar": "Jami mijozlar",
      "galereya": "Galereya",
      "kamera": "Kamera",
      "rasm_tanlash": "Mijoz rasmini tanlash",
      "tel": "Tel:",
      "mijoz_qoshish": "Mijoz qo'shish",
      "mijozni_tahrirlash": "Mijozni tahrirlash",
      "f_i_sh": "F.I.Sh",
      "manzil": "Manzil",
      "telefon_raqami": "Telefon raqami",
      "mijoz_turi": "Mijoz turi",
      "jismoniy": "Jismoniy",
      "korporativ": "Korporativ",
      "status": "Status",
      "faol": "Faol",
      "nofaol": "Nofaol",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "tahrirlash": "Tahrirlash",
      "ochirish": "O'chirish",
      "ism_telefon_majburiy": "Ism va telefon raqami majburiy",
      "ochirishni_tasdiqlang": "O'chirishni tasdiqlang",
      "mijozni_ochirish_savol":
      "Haqiqatan ham ushbu mijozni o'chirmoqchimisiz?",
      "yoq": "Yo'q",
      "ha": "Ha, o'chirish",
      "qidirish": "Ism, telefon yoki manzil...",
      "mijoz_topilmadi": "Mijoz topilmadi",
      "qayta_urinish": "Qayta urinish",
      "nafar": "nafar",
      "tozalash": "Tozalash",
    },
    "Rus": {
      "mijozlar": "Клиенты",
      "barchasi": "Все",
      "jami_mijozlar": "Всего клиентов",
      "galereya": "Галерея",
      "kamera": "Камера",
      "rasm_tanlash": "Выбрать фото клиента",
      "tel": "Тел:",
      "mijoz_qoshish": "Добавить клиента",
      "mijozni_tahrirlash": "Редактировать клиента",
      "f_i_sh": "Ф.И.О",
      "manzil": "Адрес",
      "telefon_raqami": "Номер телефона",
      "mijoz_turi": "Тип клиента",
      "jismoniy": "Физическое лицо",
      "korporativ": "Корпоративный",
      "status": "Статус",
      "faol": "Активный",
      "nofaol": "Неактивный",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "tahrirlash": "Редактировать",
      "ochirish": "Удалить",
      "ism_telefon_majburiy": "Имя и номер телефона обязательны",
      "ochirishni_tasdiqlang": "Подтвердите удаление",
      "mijozni_ochirish_savol":
      "Вы действительно хотите удалить этого клиента?",
      "yoq": "Нет",
      "ha": "Да, удалить",
      "qidirish": "Имя, телефон или адрес...",
      "mijoz_topilmadi": "Клиенты не найдены",
      "qayta_urinish": "Повторить",
      "nafar": "чел.",
      "tozalash": "Сбросить",
    },
    "Kiril": {
      "mijozlar": "Мижозлар",
      "barchasi": "Барчаси",
      "jami_mijozlar": "Жами мижозлар",
      "galereya": "Галерея",
      "kamera": "Камера",
      "rasm_tanlash": "Мижоз расмини танлаш",
      "tel": "Тел:",
      "mijoz_qoshish": "Мижоз қўшиш",
      "mijozni_tahrirlash": "Мижозни таҳрирлаш",
      "f_i_sh": "Ф.И.Ш",
      "manzil": "Манзил",
      "telefon_raqami": "Телефон рақами",
      "mijoz_turi": "Мижоз тури",
      "jismoniy": "Жисмоний",
      "korporativ": "Корпоратив",
      "status": "Статус",
      "faol": "Фаол",
      "nofaol": "Нофаол",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "tahrirlash": "Таҳрирлаш",
      "ochirish": "Ўчириш",
      "ism_telefon_majburiy": "Исм ва телефон рақами мажбурий",
      "ochirishni_tasdiqlang": "Ўчиришни тасдиқланг",
      "mijozni_ochirish_savol":
      "Ҳақиқатан ҳам ушбу мижозни ўчирмоқчимисиз?",
      "yoq": "Йўқ",
      "ha": "Ҳа, ўчириш",
      "qidirish": "Исм, телефон ёки манзил...",
      "mijoz_topilmadi": "Мижоз топилмади",
      "qayta_urinish": "Қайта уриниш",
      "nafar": "нафар",
      "tozalash": "Тозалаш",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts["Uzb"]?[key] ??
        key;
  }

  @override
  State<DraverKlentPages> createState() => _DraverKlentPagesState();
}

class _DraverKlentPagesState extends State<DraverKlentPages> {
  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _amber = Color(0xFFF59E0B);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);
  static const Color _lightBg = Color(0xFFF8FAFC);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchOpen = false;
  String _searchQuery = "";
  String _typeFilter = "all"; // all | Korporativ | Jismoniy

  static String getTxt(String lang, String key) =>
      DraverKlentPages.getTxt(lang, key);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MijozProvider>().loadMijozlar();
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

  Future<void> _makePhoneCall(String rawPhone) async {
    final cleaned = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return;
    final formatted = cleaned.startsWith('+') ? cleaned : '+$cleaned';
    final Uri launchUri = Uri(scheme: 'tel', path: formatted);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _showMijozDialog(BuildContext pageContext, {MijozModel? mijoz}) {
    final provider = pageContext.read<MijozProvider>();
    final lang = pageContext.read<ProfileProvider>().language;

    if (mijoz != null) {
      provider.controllergaYuklash(mijoz);
    } else {
      provider.tozalash();
    }

    showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (_) => _MijozFormDialog(
        lang: lang,
        mijoz: mijoz,
        onRequestDelete: mijoz?.id == null
            ? null
            : () => _showDeleteConfirmDialog(pageContext, mijoz!.id!),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext pageContext, int id) {
    final provider = pageContext.read<MijozProvider>();
    final messenger = ScaffoldMessenger.of(pageContext);
    final lang = pageContext.read<ProfileProvider>().language;

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'delete_client',
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
                            getTxt(lang, "ochirishni_tasdiqlang"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getTxt(lang, "mijozni_ochirish_savol"),
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
                                    getTxt(lang, "yoq"),
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
                                    await provider.ochirish(id);
                                    if (provider.errorMessage != null) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(provider.errorMessage!),
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
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      getTxt(lang, "ha"),
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
  // ANIMATSIYALI APPBAR SARLAVHA + O'NGDAN CHAPGA SURILUVCHI QIDIRUV
  // =========================================================================

  Widget _buildAnimatedAppBarTitle({
    required String lang,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
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
              // CHAP TOMONDA: IKONKA + "MIJOZLAR" SARLAVHASI
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
                              Icons.people_alt_rounded,
                              size: 21,
                              color: isDark ? _skyBlue : _primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              getTxt(lang, "mijozlar"),
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

              // O'NG TOMONDAN CHAPGA ANIMATSIYA BILAN SURILADIGAN QIDIRUV
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
                                hintText: getTxt(lang, "qidirish"),
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
    final lang = profile.language;
    final bool isAdmin = profile.role.trim().toLowerCase() == "admin";

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
          borderColor: borderColor,
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
              onTap: () => _showMijozDialog(context),
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
      body: Consumer<MijozProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.mijozlar.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _primaryBlue),
            );
          }

          if (provider.errorMessage != null && provider.mijozlar.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _rose.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: _rose,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => provider.loadMijozlar(),
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      label: Text(
                        getTxt(lang, "qayta_urinish"),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final allMijozlar = provider.mijozlar;
          final int korporativCount =
              allMijozlar.where((m) => m.mijozTuri == "Korporativ").length;
          final int jismoniyCount = allMijozlar.length - korporativCount;

          final filteredMijozlar = allMijozlar.where((m) {
            if (_typeFilter == "Korporativ" && m.mijozTuri != "Korporativ") {
              return false;
            }
            if (_typeFilter == "Jismoniy" && m.mijozTuri == "Korporativ") {
              return false;
            }

            if (_searchQuery.trim().isNotEmpty) {
              final q = _searchQuery.trim().toLowerCase();
              final digitsQ = q.replaceAll(RegExp(r'\D'), '');
              final fullName = "${m.ism} ${m.familya}".toLowerCase();
              final revName = "${m.familya} ${m.ism}".toLowerCase();
              final rawPhone = m.telefon.replaceAll(RegExp(r'\D'), '');

              if (!m.ism.toLowerCase().contains(q) &&
                  !m.familya.toLowerCase().contains(q) &&
                  !fullName.contains(q) &&
                  !revName.contains(q) &&
                  !m.telefon.toLowerCase().contains(q) &&
                  !(digitsQ.isNotEmpty && rawPhone.contains(digitsQ)) &&
                  !m.ishJoyi.toLowerCase().contains(q)) {
                return false;
              }
            }
            return true;
          }).toList();

          return RefreshIndicator(
            color: _primaryBlue,
            onRefresh: () => provider.loadMijozlar(),
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
                                    child: _ClientKpiCard(
                                      title: getTxt(lang, "jami_mijozlar"),
                                      value: "${allMijozlar.length}",
                                      unit: getTxt(lang, "nafar"),
                                      icon: Icons.groups_rounded,
                                      accentColor: _primaryBlue,
                                      isSelected: _typeFilter == "all",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(
                                            () => _typeFilter = "all",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: itemW,
                                    child: _ClientKpiCard(
                                      title: getTxt(lang, "korporativ"),
                                      value: "$korporativCount",
                                      unit: getTxt(lang, "nafar"),
                                      icon: Icons.business_center_rounded,
                                      accentColor: _emerald,
                                      isSelected: _typeFilter == "Korporativ",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _typeFilter =
                                        _typeFilter == "Korporativ"
                                            ? "all"
                                            : "Korporativ";
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: gap),
                                  SizedBox(
                                    width: itemW,
                                    child: _ClientKpiCard(
                                      title: getTxt(lang, "jismoniy"),
                                      value: "$jismoniyCount",
                                      unit: getTxt(lang, "nafar"),
                                      icon: Icons.person_rounded,
                                      accentColor: _amber,
                                      isSelected: _typeFilter == "Jismoniy",
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      onTap: () => setState(() {
                                        _typeFilter = _typeFilter == "Jismoniy"
                                            ? "all"
                                            : "Jismoniy";
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
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _FilterPill(
                                        label:
                                        "${getTxt(lang, "barchasi")} (${allMijozlar.length})",
                                        selected: _typeFilter == "all",
                                        activeColor: _primaryBlue,
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _typeFilter = "all",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _FilterPill(
                                        label:
                                        "${getTxt(lang, "korporativ")} ($korporativCount)",
                                        selected: _typeFilter == "Korporativ",
                                        activeColor: _emerald,
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _typeFilter = "Korporativ",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _FilterPill(
                                        label:
                                        "${getTxt(lang, "jismoniy")} ($jismoniyCount)",
                                        selected: _typeFilter == "Jismoniy",
                                        activeColor: _amber,
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _typeFilter = "Jismoniy",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // ================================================
                          // MIJOZLAR RO'YXATI (1 / 2 / 3 USTUN)
                          // ================================================
                          if (filteredMijozlar.isEmpty)
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
                                    Icons.person_search_rounded,
                                    size: 54,
                                    color:
                                    textSecondary.withValues(alpha: 0.55),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    getTxt(lang, "mijoz_topilmadi"),
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
                                  children: filteredMijozlar.map((mijoz) {
                                    final bool isCorp =
                                        mijoz.mijozTuri == "Korporativ";
                                    final String displayPhone =
                                    _formatPhoneDisplay(mijoz.telefon);

                                    return SizedBox(
                                      width: cardWidth,
                                      child: _ClientCard(
                                        mijoz: mijoz,
                                        isCorp: isCorp,
                                        typeLabel: isCorp
                                            ? getTxt(lang, "korporativ")
                                            : getTxt(lang, "jismoniy"),
                                        phoneDisplay: displayPhone,
                                        telLabel: getTxt(lang, "tel"),
                                        canEdit: isAdmin,
                                        isDark: isDark,
                                        cardBg: cardBg,
                                        borderColor: borderColor,
                                        textPrimary: textPrimary,
                                        textSecondary: textSecondary,
                                        onTap: isAdmin
                                            ? () => _showMijozDialog(
                                          context,
                                          mijoz: mijoz,
                                        )
                                            : null,
                                        onCallTap: displayPhone.isEmpty
                                            ? null
                                            : () => _makePhoneCall(
                                          mijoz.telefon,
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
}

// ===========================================================================
// KPI KARTA
// ===========================================================================

class _ClientKpiCard extends StatelessWidget {
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

  const _ClientKpiCard({
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

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterPill({
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
                : (isDark
                ? const Color(0xFF1C2541)
                : Colors.white),
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
// MIJOZ KARTASI
// ===========================================================================

class _ClientCard extends StatelessWidget {
  final MijozModel mijoz;
  final bool isCorp;
  final String typeLabel;
  final String phoneDisplay;
  final String telLabel;
  final bool canEdit;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback? onTap;
  final VoidCallback? onCallTap;

  const _ClientCard({
    required this.mijoz,
    required this.isCorp,
    required this.typeLabel,
    required this.phoneDisplay,
    required this.telLabel,
    required this.canEdit,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color typeColor =
    isCorp ? const Color(0xFF0284C7) : const Color(0xFFF59E0B);

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ClientAvatar(
                imagePath: mijoz.rasm,
                firstName: mijoz.ism,
                lastName: mijoz.familya,
                accentColor: typeColor,
                size: 62,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${mijoz.ism} ${mijoz.familya}".trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: typeColor,
                            ),
                          ),
                        ),
                        if (mijoz.ishJoyi.trim().isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 15,
                                color: Color(0xFF10B981),
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  mijoz.ishJoyi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$telLabel $phoneDisplay",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onCallTap != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: onCallTap,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.call_rounded,
                        color: Color(0xFF10B981),
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
  }
}

class _ClientAvatar extends StatelessWidget {
  final String? imagePath;
  final String firstName;
  final String lastName;
  final Color accentColor;
  final double size;
  final bool isDark;

  const _ClientAvatar({
    required this.imagePath,
    required this.firstName,
    required this.lastName,
    required this.accentColor,
    required this.size,
    required this.isDark,
  });

  String _initials() {
    final f = firstName.trim();
    final l = lastName.trim();
    final c1 = f.isNotEmpty ? f[0].toUpperCase() : "";
    final c2 = l.isNotEmpty ? l[0].toUpperCase() : "";
    final combined = "$c1$c2".trim();
    return combined.isNotEmpty ? combined : "?";
  }

  @override
  Widget build(BuildContext context) {
    final path = imagePath?.trim() ?? "";
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');

    Widget fallback() {
      return Center(
        child: Text(
          _initials(),
          style: TextStyle(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w800,
            color: accentColor,
          ),
        ),
      );
    }

    Widget child = fallback();
    if (path.isNotEmpty) {
      if (isNetwork) {
        child = Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          child = Image.file(
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
        shape: BoxShape.circle,
        color: accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

// ===========================================================================
// MIJOZ QO'SHISH / TAHRIRLASH DIALOGI (LEAK-FREE STATEFULWIDGET)
// ===========================================================================

class _MijozFormDialog extends StatefulWidget {
  final String lang;
  final MijozModel? mijoz;
  final VoidCallback? onRequestDelete;

  const _MijozFormDialog({
    required this.lang,
    required this.mijoz,
    required this.onRequestDelete,
  });

  @override
  State<_MijozFormDialog> createState() => _MijozFormDialogState();
}

class _MijozFormDialogState extends State<_MijozFormDialog> {
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);

  static const List<String> _uzbCities = [
    "Toshkent",
    "Samarqand",
    "Andijon",
    "Buxoro",
    "Farg'ona",
    "Jizzax",
    "Namangan",
    "Navoiy",
    "Qashqadaryo",
    "Qoraqalpog'iston",
    "Sirdaryo",
    "Surxondaryo",
    "Xorazm",
  ];

  late final TextEditingController _fullNameController;
  final FocusNode _addressFocusNode = FocusNode();
  final MaskTextInputFormatter _maskFormatter =
  MaskTextInputFormatter(mask: '## ### ## ##');

  bool _isSubmitting = false;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.mijoz != null
          ? "${widget.mijoz!.ism} ${widget.mijoz!.familya}".trim()
          : "",
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _showImageSourceSheet(BuildContext dialogContext) {
    final bool isDark =
        Theme.of(dialogContext).brightness == Brightness.dark;
    final provider = dialogContext.read<MijozProvider>();
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
                    DraverKlentPages.getTxt(lang, "rasm_tanlash"),
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
                        color: _emerald.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.photo_library_rounded,
                        color: _emerald,
                      ),
                    ),
                    title: Text(
                      DraverKlentPages.getTxt(lang, 'galereya'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      provider.rasmTanlash(
                        dialogContext,
                        ImageSource.gallery,
                      );
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
                        color: _primaryBlue.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.photo_camera_rounded,
                        color: _primaryBlue,
                      ),
                    ),
                    title: Text(
                      DraverKlentPages.getTxt(lang, 'kamera'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      provider.rasmTanlash(
                        dialogContext,
                        ImageSource.camera,
                      );
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

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
    String? hint,
    String? prefixText,
  }) {
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
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

  Future<void> _save() async {
    final provider = context.read<MijozProvider>();
    final lang = widget.lang;

    final String full = _fullNameController.text.trim();
    final int firstSpace = full.indexOf(' ');
    if (firstSpace != -1) {
      provider.ismController.text = full.substring(0, firstSpace);
      provider.familyaController.text = full.substring(firstSpace + 1).trim();
    } else {
      provider.ismController.text = full;
      provider.familyaController.text = "";
    }

    if (!provider.tekshir()) {
      setState(() {
        _inlineError = DraverKlentPages.getTxt(lang, "ism_telefon_majburiy");
      });
      return;
    }

    setState(() {
      _inlineError = null;
      _isSubmitting = true;
    });

    if (widget.mijoz == null) {
      await provider.qoshish();
    } else {
      await provider.tahrirlash(widget.mijoz!.id!);
    }

    if (!mounted) return;

    if (provider.errorMessage != null) {
      setState(() {
        _inlineError = provider.errorMessage;
        _isSubmitting = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<MijozProvider>();

    final Color dialogBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final String safeMijozTuri =
    (provider.mijozTuri == "Korporativ" ||
        provider.mijozTuri == "Jismoniy")
        ? provider.mijozTuri
        : "Jismoniy";
    final String safeStatus =
    (provider.status == "Faol" || provider.status == "Nofaol")
        ? provider.status
        : "Faol";

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
              widget.mijoz == null
                  ? Icons.person_add_alt_1_rounded
                  : Icons.edit_rounded,
              size: 21,
              color: isDark ? _skyBlue : _primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.mijoz == null
                  ? DraverKlentPages.getTxt(lang, "mijoz_qoshish")
                  : DraverKlentPages.getTxt(lang, "mijozni_tahrirlash"),
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

                // AVATAR TANLASH
                Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceSheet(context),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _fullNameController,
                          builder: (context, val, _) {
                            final name = val.text.trim();
                            final parts = name.split(' ');
                            return _ClientAvatar(
                              imagePath: provider.tanlanganRasm,
                              firstName: parts.isNotEmpty ? parts[0] : "",
                              lastName: parts.length > 1 ? parts[1] : "",
                              accentColor: _primaryBlue,
                              size: 98,
                              isDark: isDark,
                            );
                          },
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 34,
                            height: 34,
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
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // F.I.SH
                TextField(
                  controller: _fullNameController,
                  onChanged: (_) {
                    if (_inlineError != null) {
                      setState(() => _inlineError = null);
                    }
                  },
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _fieldDecoration(
                    label: DraverKlentPages.getTxt(lang, "f_i_sh"),
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 12),

                // MANZIL (AUTOCOMPLETE)
                LayoutBuilder(
                  builder: (context, fieldConstraints) {
                    return RawAutocomplete<String>(
                      textEditingController: provider.ishJoyiController,
                      focusNode: _addressFocusNode,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return _uzbCities.where(
                              (option) => option.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                        );
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: TextStyle(color: textPrimary, fontSize: 15.5),
                          decoration: _fieldDecoration(
                            label: DraverKlentPages.getTxt(lang, "manzil"),
                            icon: Icons.location_on_outlined,
                            isDark: isDark,
                          ),
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
                                maxHeight: 200,
                              ),
                              child: ListView.separated(
                                padding:
                                const EdgeInsets.symmetric(vertical: 4),
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
                                      option,
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w600,
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

                const SizedBox(height: 12),

                // TELEFON
                TextField(
                  controller: provider.telefonController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_maskFormatter],
                  onChanged: (_) {
                    if (_inlineError != null) {
                      setState(() => _inlineError = null);
                    }
                  },
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _fieldDecoration(
                    label: DraverKlentPages.getTxt(lang, "telefon_raqami"),
                    icon: Icons.phone_android_rounded,
                    isDark: isDark,
                    prefixText: "+",
                    hint: "90 123 45 67",
                  ),
                ),

                const SizedBox(height: 12),

                // MIJOZ TURI
                DropdownButtonFormField<String>(
                  initialValue: safeMijozTuri,
                  isExpanded: true,
                  dropdownColor: dialogBg,
                  decoration: _fieldDecoration(
                    label: DraverKlentPages.getTxt(lang, "mijoz_turi"),
                    icon: Icons.category_outlined,
                    isDark: isDark,
                  ),
                  items: const ["Korporativ", "Jismoniy"]
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e == "Korporativ"
                            ? DraverKlentPages.getTxt(lang, "korporativ")
                            : DraverKlentPages.getTxt(lang, "jismoniy"),
                        style: TextStyle(color: textPrimary),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => provider.mijozTuri = val);
                  },
                ),

                const SizedBox(height: 12),

                // STATUS
                DropdownButtonFormField<String>(
                  initialValue: safeStatus,
                  isExpanded: true,
                  dropdownColor: dialogBg,
                  decoration: _fieldDecoration(
                    label: DraverKlentPages.getTxt(lang, "status"),
                    icon: Icons.verified_user_outlined,
                    isDark: isDark,
                  ),
                  items: const ["Faol", "Nofaol"]
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e == "Faol"
                            ? DraverKlentPages.getTxt(lang, "faol")
                            : DraverKlentPages.getTxt(lang, "nofaol"),
                        style: TextStyle(color: textPrimary),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => provider.status = val);
                  },
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.mijoz == null)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                  _isSubmitting ? null : () => Navigator.pop(context),
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
                      DraverKlentPages.getTxt(lang, "bekor_qilish"),
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
                  onPressed: _isSubmitting ? null : _save,
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
                      DraverKlentPages.getTxt(lang, "saqlash"),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _save,
                      icon: _isSubmitting
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.check_rounded, size: 19),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          DraverKlentPages.getTxt(lang, "tahrirlash"),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  if (widget.onRequestDelete != null) ...[
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                        Navigator.pop(context);
                        widget.onRequestDelete!();
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 19),
                      label: Text(
                        DraverKlentPages.getTxt(lang, "ochirish"),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _rose,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                child: Text(
                  DraverKlentPages.getTxt(lang, "bekor_qilish"),
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}