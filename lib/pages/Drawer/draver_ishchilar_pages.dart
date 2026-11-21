import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/ishchi_modeli.dart';
import '../../provider/ishchilar_Provider/ishchilar_provider.dart';
import '../../provider/profile_provider.dart';
import '../Ishchilar_Pages.dart';

class DraverIshchilarPages extends StatefulWidget {
  const DraverIshchilarPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'worker_details': "Ishchi ma'lumotlari",
      'fish': 'F.I.Sh:',
      'position': 'Lavozim:',
      'profession': 'Kasbi:',
      'phone': 'Telefon:',
      'login': 'Login:',
      'password': 'Parol:',
      'credentials': 'Kirish ma\'lumotlari',
      'close': 'Yopish',
      'edit': 'Tahrirlash',
      'delete': "O'chirish",
      'delete_confirm': "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?",
      'no': "Yo'q",
      'yes': "Ha, o'chirish",
      'workers': 'Ishchilar',
      'all': 'Barchasi',
      'total_workers': 'Jami xodimlar',
      'doctors': 'Shifokorlar',
      'tech_workers': 'Texnik xodimlar',
      'unit_person': 'nafar',
      'search': 'Ism, kasb yoki telefon...',
      'no_workers': 'Ishchilar mavjud emas',
      'not_found': 'Xodim topilmadi',
    },
    'Rus': {
      'worker_details': 'Данные сотрудника',
      'fish': 'Ф.И.О:',
      'position': 'Должность:',
      'profession': 'Профессия:',
      'phone': 'Телефон:',
      'login': 'Логин:',
      'password': 'Пароль:',
      'credentials': 'Данные для входа',
      'close': 'Закрыть',
      'edit': 'Редактировать',
      'delete': 'Удалить',
      'delete_confirm': 'Вы действительно хотите удалить этого сотрудника?',
      'no': 'Нет',
      'yes': 'Да, удалить',
      'workers': 'Сотрудники',
      'all': 'Все',
      'total_workers': 'Всего',
      'doctors': 'Врачи',
      'tech_workers': 'Тех. персонал',
      'unit_person': 'чел.',
      'search': 'Имя, профессия или телефон...',
      'no_workers': 'Нет доступных сотрудников',
      'not_found': 'Сотрудник не найден',
    },
    'Kiril': {
      'worker_details': 'Ишчи маълумотлари',
      'fish': 'Ф.И.Ш:',
      'position': 'Лавозим:',
      'profession': 'Касби:',
      'phone': 'Телефон:',
      'login': 'Логин:',
      'password': 'Пароль:',
      'credentials': 'Кириш маълумотлари',
      'close': 'Ёпиш',
      'edit': 'Таҳрирлаш',
      'delete': 'Ўчириш',
      'delete_confirm': 'Ҳақиқатан ҳам ушбу ишчини ўчирмоқчимисиз?',
      'no': 'Йўқ',
      'yes': 'Ҳа, ўчириш',
      'workers': 'Ишчилар',
      'all': 'Барчаси',
      'total_workers': 'Жами ходимлар',
      'doctors': 'Шифокорлар',
      'tech_workers': 'Техник ходимлар',
      'unit_person': 'нафар',
      'search': 'Исм, касб ёки телефон...',
      'no_workers': 'Ишчилар мавжуд эмас',
      'not_found': 'Ходим топилмади',
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts['Uzb']?[key] ??
        key;
  }

  @override
  State<DraverIshchilarPages> createState() => _DraverIshchilarPagesState();
}

class _DraverIshchilarPagesState extends State<DraverIshchilarPages> {
  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
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
  String _roleFilter = "all"; // all | shifokor | texnik

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

  bool _isDoctor(IshchiModel i) =>
      i.kasb.trim().toLowerCase() == "shifokor";

  bool _isTech(IshchiModel i) =>
      i.kasb.trim().toLowerCase() == "texnik xodim";

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
    final String formatted = cleaned.startsWith('+')
        ? cleaned
        : (cleaned.startsWith('998') ? '+$cleaned' : '+998$cleaned');
    final Uri launchUri = Uri(scheme: 'tel', path: formatted);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
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
                              Icons.badge_rounded,
                              size: 21,
                              color: isDark ? _skyBlue : _primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              DraverIshchilarPages.getTxt(language, 'workers'),
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
                                hintText: DraverIshchilarPages.getTxt(
                                    language, 'search'),
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

  // =========================================================================
  // ISHCHI TAFSILOTLARI MODALI (FROSTED GLASS)
  // =========================================================================

  void _showDetailDialog(
      BuildContext pageContext,
      IshchiModel ishchi,
      int originalIndex, {
        required bool isAdmin,
      }) {
    final String language = pageContext.read<ProfileProvider>().language;
    final ishchiProvider = pageContext.read<IshchiProvider>();
    final String formattedPhone = _formatPhoneDisplay(ishchi.telefon);
    final Color accentColor = _isDoctor(ishchi)
        ? _indigo
        : (_isTech(ishchi) ? _amber : _primaryBlue);

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'worker_details',
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
                              children: [
                                Expanded(
                                  child: Text(
                                    DraverIshchilarPages.getTxt(
                                        language, 'worker_details'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
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
                            const SizedBox(height: 10),
                            _WorkerAvatar(
                              imagePath: ishchi.rasm,
                              firstName: ishchi.ism,
                              lastName: ishchi.familya,
                              accentColor: accentColor,
                              size: 92,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "${ishchi.familya} ${ishchi.ism}".trim(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                            if (ishchi.kasb.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  ishchi.kasb,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
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
                                    DraverIshchilarPages.getTxt(
                                        language, 'position'),
                                    ishchi.lavozim,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                  ),
                                  Divider(height: 16, color: borderColor),
                                  _detailRow(
                                    DraverIshchilarPages.getTxt(
                                        language, 'profession'),
                                    ishchi.kasb,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                  ),
                                  Divider(height: 16, color: borderColor),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DraverIshchilarPages.getTxt(
                                            language, 'phone'),
                                        style: TextStyle(
                                          color: textSecondary,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: formattedPhone.isEmpty
                                            ? null
                                            : () => _makePhoneCall(
                                            ishchi.telefon),
                                        child: Text(
                                          formattedPhone.isEmpty
                                              ? "—"
                                              : formattedPhone,
                                          style: TextStyle(
                                            color: isDark
                                                ? _skyBlue
                                                : _primaryBlue,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (ishchi.lavozim == "Ishchi") ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _primaryBlue.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                    _primaryBlue.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DraverIshchilarPages.getTxt(
                                          language, 'credentials'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color:
                                        isDark ? _skyBlue : _primaryBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _detailRow(
                                      DraverIshchilarPages.getTxt(
                                          language, 'login'),
                                      ishchi.login ?? "—",
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                    ),
                                    const SizedBox(height: 8),
                                    _detailRow(
                                      DraverIshchilarPages.getTxt(
                                          language, 'password'),
                                      ishchi.parol ?? "—",
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            if (isAdmin)
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
                                        _showDeleteDialog(
                                          pageContext,
                                          originalIndex,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 19,
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          DraverIshchilarPages.getTxt(
                                              language, 'delete'),
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
                                        ishchiProvider
                                            .tahrirlashUchunYuklash(
                                            originalIndex);
                                        showDialog(
                                          context: pageContext,
                                          barrierDismissible: false,
                                          builder: (_) => IshchiQoshishDialog(
                                            maskFormatter:
                                            MaskTextInputFormatter(
                                              mask: '## ### ## ##',
                                            ),
                                            isEditing: true,
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        size: 19,
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          DraverIshchilarPages.getTxt(
                                              language, 'edit'),
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
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                  child: Text(
                                    DraverIshchilarPages.getTxt(
                                        language, 'close'),
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
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
            value.trim().isEmpty ? "—" : value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15.5,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // O'CHIRISH TASDIQLASH DIALOGI
  // =========================================================================

  void _showDeleteDialog(BuildContext pageContext, int originalIndex) {
    final String language = pageContext.read<ProfileProvider>().language;
    final ishchiProvider = pageContext.read<IshchiProvider>();

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'delete_worker',
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
                            DraverIshchilarPages.getTxt(language, 'delete'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DraverIshchilarPages.getTxt(
                                language, 'delete_confirm'),
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
                                    DraverIshchilarPages.getTxt(
                                        language, 'no'),
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
                                  onPressed: () {
                                    ishchiProvider.ochirish(originalIndex);
                                    Navigator.pop(dialogContext);
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
                                      DraverIshchilarPages.getTxt(
                                          language, 'yes'),
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

  @override
  Widget build(BuildContext context) {
    context.watch<IshchiProvider>();
    final List<IshchiModel> ishchilar = IshchiDatabase.ishchilar;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = context.watch<ProfileProvider>();
    final bool isAdmin = profile.role.trim().toLowerCase() == "admin";
    final String language = profile.language;

    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color cardBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final int doctorCount = ishchilar.where(_isDoctor).length;
    final int techCount = ishchilar.where(_isTech).length;

    final List<IshchiModel> filteredIshchilar = ishchilar.where((i) {
      if (_roleFilter == "shifokor" && !_isDoctor(i)) return false;
      if (_roleFilter == "texnik" && !_isTech(i)) return false;

      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final digitsQ = q.replaceAll(RegExp(r'\D'), '');
        final fullName = "${i.familya} ${i.ism}".toLowerCase();
        final revName = "${i.ism} ${i.familya}".toLowerCase();
        final rawPhone = i.telefon.replaceAll(RegExp(r'\D'), '');

        if (!fullName.contains(q) &&
            !revName.contains(q) &&
            !i.kasb.toLowerCase().contains(q) &&
            !i.lavozim.toLowerCase().contains(q) &&
            !i.telefon.toLowerCase().contains(q) &&
            !(digitsQ.isNotEmpty && rawPhone.contains(digitsQ))) {
          return false;
        }
      }
      return true;
    }).toList();

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
                context.read<IshchiProvider>().tozalash();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => IshchiQoshishDialog(
                    maskFormatter: MaskTextInputFormatter(
                      mask: '## ### ## ##',
                    ),
                  ),
                );
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double horizontalPad = constraints.maxWidth >= 900 ? 24 : 16;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
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
                    // ======================================================
                    // KPI KARTALAR (3 TA)
                    // ======================================================
                    LayoutBuilder(
                      builder: (context, kpiConstraints) {
                        const double gap = 10;
                        final double itemW =
                            (kpiConstraints.maxWidth - gap * 2) / 3;

                        return Row(
                          children: [
                            SizedBox(
                              width: itemW,
                              child: _WorkerKpiCard(
                                title: DraverIshchilarPages.getTxt(
                                    language, 'total_workers'),
                                value: "${ishchilar.length}",
                                unit: DraverIshchilarPages.getTxt(
                                    language, 'unit_person'),
                                icon: Icons.groups_rounded,
                                accentColor: _primaryBlue,
                                isSelected: _roleFilter == "all",
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                onTap: () =>
                                    setState(() => _roleFilter = "all"),
                              ),
                            ),
                            const SizedBox(width: gap),
                            SizedBox(
                              width: itemW,
                              child: _WorkerKpiCard(
                                title: DraverIshchilarPages.getTxt(
                                    language, 'doctors'),
                                value: "$doctorCount",
                                unit: DraverIshchilarPages.getTxt(
                                    language, 'unit_person'),
                                icon: Icons.medical_services_rounded,
                                accentColor: _indigo,
                                isSelected: _roleFilter == "shifokor",
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                onTap: () => setState(() {
                                  _roleFilter = _roleFilter == "shifokor"
                                      ? "all"
                                      : "shifokor";
                                }),
                              ),
                            ),
                            const SizedBox(width: gap),
                            SizedBox(
                              width: itemW,
                              child: _WorkerKpiCard(
                                title: DraverIshchilarPages.getTxt(
                                    language, 'tech_workers'),
                                value: "$techCount",
                                unit: DraverIshchilarPages.getTxt(
                                    language, 'unit_person'),
                                icon: Icons.engineering_rounded,
                                accentColor: _amber,
                                isSelected: _roleFilter == "texnik",
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                onTap: () => setState(() {
                                  _roleFilter = _roleFilter == "texnik"
                                      ? "all"
                                      : "texnik";
                                }),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // ======================================================
                    // ROL FILTR KAPSULALARI
                    // ======================================================
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _RoleFilterPill(
                            label:
                            "${DraverIshchilarPages.getTxt(language, 'all')} (${ishchilar.length})",
                            selected: _roleFilter == "all",
                            activeColor: _primaryBlue,
                            isDark: isDark,
                            onTap: () => setState(() => _roleFilter = "all"),
                          ),
                          const SizedBox(width: 8),
                          _RoleFilterPill(
                            label:
                            "${DraverIshchilarPages.getTxt(language, 'doctors')} ($doctorCount)",
                            selected: _roleFilter == "shifokor",
                            activeColor: _indigo,
                            isDark: isDark,
                            onTap: () =>
                                setState(() => _roleFilter = "shifokor"),
                          ),
                          const SizedBox(width: 8),
                          _RoleFilterPill(
                            label:
                            "${DraverIshchilarPages.getTxt(language, 'tech_workers')} ($techCount)",
                            selected: _roleFilter == "texnik",
                            activeColor: _amber,
                            isDark: isDark,
                            onTap: () =>
                                setState(() => _roleFilter = "texnik"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ======================================================
                    // XODIMLAR RO'YXATI (1 / 2 / 3 USTUN)
                    // ======================================================
                    if (filteredIshchilar.isEmpty)
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
                              color: textSecondary.withValues(alpha: 0.55),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ishchilar.isEmpty
                                  ? DraverIshchilarPages.getTxt(
                                  language, 'no_workers')
                                  : DraverIshchilarPages.getTxt(
                                  language, 'not_found'),
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
                            children: filteredIshchilar.map((ishchi) {
                              final int originalIndex =
                              ishchilar.indexOf(ishchi);
                              final String formattedPhone =
                              _formatPhoneDisplay(ishchi.telefon);
                              final Color roleAccent = _isDoctor(ishchi)
                                  ? _indigo
                                  : (_isTech(ishchi) ? _amber : _primaryBlue);

                              return SizedBox(
                                width: cardWidth,
                                child: _WorkerCard(
                                  ishchi: ishchi,
                                  formattedPhone: formattedPhone,
                                  accentColor: roleAccent,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  onTap: () => _showDetailDialog(
                                    context,
                                    ishchi,
                                    originalIndex,
                                    isAdmin: isAdmin,
                                  ),
                                  onCallTap: formattedPhone.isEmpty
                                      ? null
                                      : () => _makePhoneCall(ishchi.telefon),
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
  }
}

class _WorkerKpiCard extends StatelessWidget {
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

  const _WorkerKpiCard({
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

class _RoleFilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _RoleFilterPill({
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

class _WorkerCard extends StatelessWidget {
  final IshchiModel ishchi;
  final String formattedPhone;
  final Color accentColor;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final VoidCallback? onCallTap;

  const _WorkerCard({
    required this.ishchi,
    required this.formattedPhone,
    required this.accentColor,
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
              _WorkerAvatar(
                imagePath: ishchi.rasm,
                firstName: ishchi.ism,
                lastName: ishchi.familya,
                accentColor: accentColor,
                size: 64,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${ishchi.familya} ${ishchi.ism}".trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (ishchi.kasb.trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ishchi.kasb,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      formattedPhone.isEmpty ? "—" : formattedPhone,
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

class _WorkerAvatar extends StatelessWidget {
  final String? imagePath;
  final String firstName;
  final String lastName;
  final Color accentColor;
  final double size;
  final bool isDark;

  const _WorkerAvatar({
    required this.imagePath,
    required this.firstName,
    required this.lastName,
    required this.accentColor,
    required this.size,
    required this.isDark,
  });

  String _initials() {
    final l = lastName.trim();
    final f = firstName.trim();
    final c1 = l.isNotEmpty ? l[0].toUpperCase() : "";
    final c2 = f.isNotEmpty ? f[0].toUpperCase() : "";
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
        shape: BoxShape.circle,
        color: accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }
}