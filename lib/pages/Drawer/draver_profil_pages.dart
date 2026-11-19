import 'dart:io';
import 'dart:ui';

import 'package:afada/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../provider/profile_provider.dart';

class DraverProfilPages extends StatefulWidget {
  const DraverProfilPages({super.key});

  @override
  State<DraverProfilPages> createState() => _DraverProfilPagesState();
}

class _DraverProfilPagesState extends State<DraverProfilPages> {
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

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'profile': 'Profil',
      'full_name': 'F.I.Sh',
      'phone': 'Telefon raqami',
      'role': 'Lavozim',
      'admin': 'Admin',
      'worker': 'Ishchi',
      'seller': 'Sotuvchi',
      'doctor': 'Shifokor',
      'tech_worker': 'Texnik xodim',
      'camera': 'Kamera',
      'camera_desc': 'Yangi rasmga olish',
      'gallery': 'Galereya',
      'gallery_desc': 'Qurilmadan rasm tanlash',
      'change_photo': 'Profil rasmini o\'zgartirish',
      'personal_info': 'Shaxsiy ma\'lumotlar',
      'account_actions': 'Hisob boshqaruvi',
      'logout': 'Hisobdan chiqish',
      'logout_confirm': 'Hisobdan chiqmoqchimisiz?',
      'logout_subtitle': 'Tizimdan chiqqaningizdan so\'ng qayta kirish talab qilinadi.',
      'user_default': 'Foydalanuvchi',
      'no': "Yo'q",
      'yes': 'Ha, chiqish',
    },
    'Rus': {
      'profile': 'Профиль',
      'full_name': 'Ф.И.О',
      'phone': 'Номер телефона',
      'role': 'Должность',
      'admin': 'Админ',
      'worker': 'Работник',
      'seller': 'Продавец',
      'doctor': 'Врач',
      'tech_worker': 'Технический персонал',
      'camera': 'Камера',
      'camera_desc': 'Сделать новое фото',
      'gallery': 'Галерея',
      'gallery_desc': 'Выбрать фото из устройства',
      'change_photo': 'Изменить фото профиля',
      'personal_info': 'Личные данные',
      'account_actions': 'Управление аккаунтом',
      'logout': 'Выйти из аккаунта',
      'logout_confirm': 'Вы уверены, что хотите выйти?',
      'logout_subtitle': 'После выхода потребуется повторная авторизация.',
      'user_default': 'Пользователь',
      'no': 'Нет',
      'yes': 'Да, выйти',
    },
    'Kiril': {
      'profile': 'Профил',
      'full_name': 'Ф.И.Ш',
      'phone': 'Телефон рақами',
      'role': 'Лавозим',
      'admin': 'Админ',
      'worker': 'Ишчи',
      'seller': 'Сотувчи',
      'doctor': 'Шифокор',
      'tech_worker': 'Техник ходим',
      'camera': 'Камера',
      'camera_desc': 'Янги расмга олиш',
      'gallery': 'Галерея',
      'gallery_desc': 'Қурилмадан расм танлаш',
      'change_photo': 'Профил расмини ўзгартириш',
      'personal_info': 'Шахсий маълумотлар',
      'account_actions': 'Ҳисоб бошқаруви',
      'logout': 'Ҳисобдан чиқиш',
      'logout_confirm': 'Ҳисобдан чиқмоқчимисиз?',
      'logout_subtitle': 'Тизимдан чиққанингиздан сўнг қайта кириш талаб қилинади.',
      'user_default': 'Фойдаланувчи',
      'no': 'Йўқ',
      'yes': 'Ҳа, чиқиш',
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts['Uzb']?[key] ??
        key;
  }

  // ============================================================
  // PROFILE IMAGE PICKER
  // ============================================================

  void _showImagePickerSheet(BuildContext pageContext) {
    final bool isDark = Theme.of(pageContext).brightness == Brightness.dark;
    final profileProvider = pageContext.read<ProfileProvider>();
    final String language = profileProvider.language;

    final Color sheetBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    showModalBottomSheet(
      context: pageContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Center(
            heightFactor: 1.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  color: sheetBg,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.14),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      getTxt(language, 'change_photo'),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _PickerOptionTile(
                      icon: Icons.camera_alt_rounded,
                      title: getTxt(language, 'camera'),
                      subtitle: getTxt(language, 'camera_desc'),
                      accentColor: _primaryBlue,
                      isDark: isDark,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        if (!mounted) return;
                        profileProvider.pickImage(
                          pageContext,
                          ImageSource.camera,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _PickerOptionTile(
                      icon: Icons.photo_library_rounded,
                      title: getTxt(language, 'gallery'),
                      subtitle: getTxt(language, 'gallery_desc'),
                      accentColor: _emerald,
                      isDark: isDark,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        if (!mounted) return;
                        profileProvider.pickImage(
                          pageContext,
                          ImageSource.gallery,
                        );
                      },
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

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog(BuildContext pageContext) {
    final profileProvider = pageContext.read<ProfileProvider>();
    final String language = profileProvider.language;
    final navigator = Navigator.of(pageContext);

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'logout',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (dialogContext, anim1, anim2) => const SizedBox.shrink(),
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
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? _cardDark.withValues(alpha: 0.92)
                            : Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 66,
                            height: 66,
                            decoration: BoxDecoration(
                              color: _rose.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              size: 32,
                              color: _rose,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            getTxt(language, 'logout_confirm'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getTxt(language, 'logout_subtitle'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.5,
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
                                      vertical: 14,
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
                                    getTxt(language, 'no'),
                                    style: TextStyle(
                                      fontSize: 15.5,
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
                                    await profileProvider.logout();
                                    if (!mounted) return;
                                    navigator.pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                          (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _rose,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      getTxt(language, 'yes'),
                                      style: const TextStyle(
                                        fontSize: 15.5,
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

  // ============================================================
  // ROLE HELPERS
  // ============================================================

  String _localizedRole(String role, String language) {
    final normalized = role.trim().toLowerCase();

    if (normalized == 'admin') {
      return getTxt(language, 'admin');
    }
    if (normalized == 'seller' || normalized == 'sotuvchi') {
      return getTxt(language, 'seller');
    }
    if (normalized == 'shifokor' || normalized == 'doctor') {
      return getTxt(language, 'doctor');
    }
    if (normalized == 'texnik xodim' || normalized == 'texnik') {
      return getTxt(language, 'tech_worker');
    }
    return getTxt(language, 'worker');
  }

  Color _roleAccentColor(String role) {
    final normalized = role.trim().toLowerCase();
    if (normalized == 'admin') return _primaryBlue;
    if (normalized == 'seller' || normalized == 'sotuvchi') return _emerald;
    if (normalized == 'shifokor' || normalized == 'doctor') return _indigo;
    if (normalized == 'texnik xodim' || normalized == 'texnik') return _amber;
    return _primaryBlue;
  }

  IconData _roleIcon(String role) {
    final normalized = role.trim().toLowerCase();
    if (normalized == 'admin') return Icons.admin_panel_settings_rounded;
    if (normalized == 'seller' || normalized == 'sotuvchi') {
      return Icons.storefront_rounded;
    }
    if (normalized == 'shifokor' || normalized == 'doctor') {
      return Icons.medical_services_rounded;
    }
    if (normalized == 'texnik xodim' || normalized == 'texnik') {
      return Icons.engineering_rounded;
    }
    return Icons.badge_rounded;
  }

  // ============================================================
  // HERO PROFILE CARD
  // ============================================================

  Widget _buildProfileHeroCard({
    required BuildContext context,
    required ProfileProvider profile,
    required String displayName,
    required String displayRole,
    required Color roleAccent,
    required IconData roleIcon,
    required String language,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _ProfileAvatar(
                imagePath: profile.imagePath,
                firstName: profile.name,
                lastName: profile.surname,
                fallbackName: displayName,
                accentColor: roleAccent,
                isDark: isDark,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _showImagePickerSheet(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_skyBlue, _primaryBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: cardBg,
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryBlue.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            displayName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: roleAccent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: roleAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(roleIcon, size: 17, color: roleAccent),
                const SizedBox(width: 7),
                Text(
                  displayRole,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: roleAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showImagePickerSheet(context),
              icon: Icon(
                Icons.photo_camera_outlined,
                size: 19,
                color: isDark ? _skyBlue : _primaryBlue,
              ),
              label: Text(
                getTxt(language, 'change_photo'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? _skyBlue : _primaryBlue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                side: BorderSide(
                  color: _primaryBlue.withValues(alpha: 0.35),
                ),
                backgroundColor: _primaryBlue.withValues(alpha: 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAILS & ACTIONS COLUMN
  // ============================================================

  Widget _buildDetailsAndActions({
    required BuildContext context,
    required String language,
    required String displayName,
    required String displayPhone,
    required String displayRole,
    required Color roleAccent,
    required IconData roleIcon,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            getTxt(language, 'personal_info'),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.045),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                label: getTxt(language, 'full_name'),
                value: displayName,
                icon: Icons.person_rounded,
                accentColor: _primaryBlue,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: borderColor,
              ),
              _buildInfoRow(
                label: getTxt(language, 'phone'),
                value: displayPhone,
                icon: Icons.phone_rounded,
                accentColor: _emerald,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: borderColor,
              ),
              _buildInfoRow(
                label: getTxt(language, 'role'),
                value: displayRole,
                icon: roleIcon,
                accentColor: roleAccent,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            getTxt(language, 'account_actions'),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showLogoutDialog(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _rose.withValues(alpha: 0.35),
                ),
                boxShadow: isDark
                    ? null
                    : [
                  BoxShadow(
                    color: _rose.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _rose.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: _rose,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      getTxt(language, 'logout'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _rose,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color: _rose.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 23,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '—' : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrettyPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (digits.isEmpty) return '—';

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
    if (trimmed.startsWith('+')) {
      return trimmed;
    }
    return '+$digits';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = context.watch<ProfileProvider>();
    final String language = profile.language;

    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color cardBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final String fullName = '${profile.surname} ${profile.name}'.trim();
    final String displayName =
    fullName.isEmpty ? getTxt(language, 'user_default') : fullName;
    final String displayPhone = _formatPrettyPhone(profile.phone);
    final String displayRole = _localizedRole(profile.role, language);
    final Color roleAccent = _roleAccentColor(profile.role);
    final IconData roleIcon = _roleIcon(profile.role);

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
                Icons.person_rounded,
                size: 22,
                color: isDark ? _skyBlue : _primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                getTxt(language, 'profile'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 760;
            final double horizontalPad = constraints.maxWidth >= 900 ? 28 : 16;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                horizontalPad,
                16,
                horizontalPad,
                36,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1020),
                  child: isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildProfileHeroCard(
                          context: context,
                          profile: profile,
                          displayName: displayName,
                          displayRole: displayRole,
                          roleAccent: roleAccent,
                          roleIcon: roleIcon,
                          language: language,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                        ),
                      ),
                      const SizedBox(width: 22),
                      Expanded(
                        flex: 7,
                        child: _buildDetailsAndActions(
                          context: context,
                          language: language,
                          displayName: displayName,
                          displayPhone: displayPhone,
                          displayRole: displayRole,
                          roleAccent: roleAccent,
                          roleIcon: roleIcon,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileHeroCard(
                        context: context,
                        profile: profile,
                        displayName: displayName,
                        displayRole: displayRole,
                        roleAccent: roleAccent,
                        roleIcon: roleIcon,
                        language: language,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                      ),
                      const SizedBox(height: 22),
                      _buildDetailsAndActions(
                        context: context,
                        language: language,
                        displayName: displayName,
                        displayPhone: displayPhone,
                        displayRole: displayRole,
                        roleAccent: roleAccent,
                        roleIcon: roleIcon,
                        isDark: isDark,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
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
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final String firstName;
  final String lastName;
  final String fallbackName;
  final Color accentColor;
  final bool isDark;

  const _ProfileAvatar({
    required this.imagePath,
    required this.firstName,
    required this.lastName,
    required this.fallbackName,
    required this.accentColor,
    required this.isDark,
  });

  String _getInitials() {
    final l = lastName.trim();
    final f = firstName.trim();
    if (l.isNotEmpty || f.isNotEmpty) {
      final c1 = l.isNotEmpty ? l[0].toUpperCase() : '';
      final c2 = f.isNotEmpty ? f[0].toUpperCase() : '';
      return '$c1$c2'.trim();
    }
    final fallback = fallbackName.trim();
    return fallback.isNotEmpty ? fallback[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final path = imagePath?.trim() ?? '';
    final bool hasPath = path.isNotEmpty;
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');

    Widget fallbackWidget() {
      return Center(
        child: Text(
          _getInitials(),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: accentColor,
          ),
        ),
      );
    }

    Widget content = fallbackWidget();
    if (hasPath) {
      if (isNetwork) {
        content = Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackWidget(),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          content = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallbackWidget(),
          );
        }
      }
    }

    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.75),
            const Color(0xFF38BDF8).withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.25 : 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? const Color(0xFF0B132B) : const Color(0xFFF1F5F9),
        ),
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }
}

class _PickerOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool isDark;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _PickerOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.isDark,
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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0B132B).withValues(alpha: 0.6)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: accentColor, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}