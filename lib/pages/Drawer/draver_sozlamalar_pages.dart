import 'dart:ui';

import 'package:afada/provider/notification_provider.dart';
import 'package:afada/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';

class DraverSozlamalarPages extends StatefulWidget {
  const DraverSozlamalarPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Sozlamalar": "Sozlamalar",
      "Asosiy sozlamalar": "Asosiy sozlamalar",
      "Ma'lumot va yordam": "Ma'lumot va yordam",
      "Ko'rinish": "Ko'rinish",
      "Tungi rejim": "Tungi rejim yoqilgan",
      "Kunduzgi rejim": "Kunduzgi rejim yoqilgan",
      "Til": "Ilova tili",
      "Til tavsifi": "Interfeys tilini tanlang",
      "Bildirishnoma": "Bildirishnomalar",
      "Yoqilgan": "Yoqilgan",
      "O'chirilgan": "O'chirilgan",
      "Yordam": "Yordam",
      "Yordam tavsifi": "Foydalanish bo'yicha yo'riqnoma",
      "Yordam matni":
      "Tizimdan foydalanishda muammo yoki savollar yuzaga kelsa, bo'lim administratori bilan bog'laning. Ma'lumotlarni yangilash uchun ro'yxatlarni pastga torting.",
      "Ilova haqida": "Ilova haqida",
      "Ilova tavsifi": "Afada Medical boshqaruv tizimi",
      "Ilova matni":
      "Afada Medical — mahsulotlar, ombor zaxirasi, sotuvlar, mijozlar va xodimlar faoliyatini qulay hamda tezkor boshqarish uchun yaratilgan tizim.",
      "Yopish": "Yopish",
      "Uzb": "O'zbekcha",
      "Rus": "Ruscha",
      "Kiril": "Кирилча",
    },
    "Rus": {
      "Sozlamalar": "Настройки",
      "Asosiy sozlamalar": "Основные настройки",
      "Ma'lumot va yordam": "Информация и помощь",
      "Ko'rinish": "Оформление",
      "Tungi rejim": "Тёмная тема включена",
      "Kunduzgi rejim": "Светлая тема включена",
      "Til": "Язык приложения",
      "Til tavsifi": "Выберите язык интерфейса",
      "Bildirishnoma": "Уведомления",
      "Yoqilgan": "Включены",
      "O'chirilgan": "Отключены",
      "Yordam": "Помощь",
      "Yordam tavsifi": "Руководство по использованию",
      "Yordam matni":
      "Если возникнут вопросы или трудности при работе с системой, свяжитесь с администратором. Для обновления данных потяните список вниз.",
      "Ilova haqida": "О приложении",
      "Ilova tavsifi": "Система управления Afada Medical",
      "Ilova matni":
      "Afada Medical — удобная система для управления товарами, складом, продажами, клиентами и активностью сотрудников.",
      "Yopish": "Закрыть",
      "Uzb": "Узбекский",
      "Rus": "Русский",
      "Kiril": "Кириллица",
    },
    "Kiril": {
      "Sozlamalar": "Созламалар",
      "Asosiy sozlamalar": "Асосий созламалар",
      "Ma'lumot va yordam": "Маълумот ва ёрдам",
      "Ko'rinish": "Кўриниш",
      "Tungi rejim": "Тунги режим ёқилган",
      "Kunduzgi rejim": "Кундузги режим ёқилган",
      "Til": "Илова тили",
      "Til tavsifi": "Интерфейс тилини танланг",
      "Bildirishnoma": "Билдиришномалар",
      "Yoqilgan": "Ёқилган",
      "O'chirilgan": "Ўчирилган",
      "Yordam": "Ёрдам",
      "Yordam tavsifi": "Фойдаланиш бўйича йўриқнома",
      "Yordam matni":
      "Тизимдан фойдаланишда муаммо ёки саволлар юзага келса, бўлим администратори билан боғланинг. Маълумотларни янгилаш учун рўйхатларни пастга тортинг.",
      "Ilova haqida": "Илова ҳақида",
      "Ilova tavsifi": "Afada Medical бошқарув тизими",
      "Ilova matni":
      "Afada Medical — маҳсулотлар, омбор захираси, сотувлар, мижозлар ва ходимлар фаолиятини қулай ҳамда тезкор бошқариш учун яратилган тизим.",
      "Yopish": "Ёпиш",
      "Uzb": "Ўзбекча",
      "Rus": "Русча",
      "Kiril": "Кирилча",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts["Uzb"]?[key] ??
        key;
  }

  @override
  State<DraverSozlamalarPages> createState() => _DraverSozlamalarPagesState();
}

class _DraverSozlamalarPagesState extends State<DraverSozlamalarPages> {
  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _amber = Color(0xFFF59E0B);
  static const Color _indigo = Color(0xFF6366F1);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);
  static const Color _lightBg = Color(0xFFF8FAFC);

  void _showInfoDialog({
    required BuildContext pageContext,
    required IconData icon,
    required Color accentColor,
    required String title,
    required String body,
    required String closeLabel,
  }) {
    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'settings_info',
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
                constraints: const BoxConstraints(maxWidth: 420),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? _cardDark.withValues(alpha: 0.94)
                            : Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(26),
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
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 32, color: accentColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.45,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryBlue,
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
                                closeLabel,
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
        );
      },
    );
  }

  Widget _buildGeneralSettingsCard({
    required ThemeProvider themeProvider,
    required NotificationProvider notificationProvider,
    required ProfileProvider profileProvider,
    required String safeLanguage,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    String txt(String key) =>
        DraverSozlamalarPages.getTxt(safeLanguage, key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            txt("Asosiy sozlamalar"),
            style: TextStyle(
              fontSize: 16.5,
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
              // KO'RINISH (DARK / LIGHT)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  onTap: () =>
                      themeProvider.toggleTheme(!themeProvider.isDarkMode),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _indigo.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: _indigo,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txt("Ko'rinish"),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isDark
                                    ? txt("Tungi rejim")
                                    : txt("Kunduzgi rejim"),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          activeTrackColor: _primaryBlue,
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Divider(
                height: 1,
                indent: 18,
                endIndent: 18,
                color: borderColor,
              ),

              // TIL TANLASH (UZB / RUS / KIRIL)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _primaryBlue.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.language_rounded,
                            color: isDark ? _skyBlue : _primaryBlue,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txt("Til"),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                txt("Til tavsifi"),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: ["Uzb", "Rus", "Kiril"].map((langCode) {
                        final bool selected = safeLanguage == langCode;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: langCode == "Kiril" ? 0 : 8,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () =>
                                    profileProvider.updateLanguage(langCode),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? _primaryBlue
                                        : (isDark
                                        ? _slateDark.withValues(alpha: 0.65)
                                        : const Color(0xFFF1F5F9)),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selected
                                          ? _primaryBlue
                                          : borderColor,
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      txt(langCode),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? Colors.white
                                            : textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                indent: 18,
                endIndent: 18,
                color: borderColor,
              ),

              // BILDIRISHNOMA
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(22),
                  ),
                  onTap: () => notificationProvider.toggleNotification(
                    !notificationProvider.isNotificationEnabled,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _emerald.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            notificationProvider.isNotificationEnabled
                                ? Icons.notifications_active_rounded
                                : Icons.notifications_off_rounded,
                            color: _emerald,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txt("Bildirishnoma"),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                notificationProvider.isNotificationEnabled
                                    ? txt("Yoqilgan")
                                    : txt("O'chirilgan"),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          activeTrackColor: _emerald,
                          value: notificationProvider.isNotificationEnabled,
                          onChanged: (value) {
                            notificationProvider.toggleNotification(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String safeLanguage,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    String txt(String key) =>
        DraverSozlamalarPages.getTxt(safeLanguage, key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            txt("Ma'lumot va yordam"),
            style: TextStyle(
              fontSize: 16.5,
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
              // YORDAM
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  onTap: () => _showInfoDialog(
                    pageContext: context,
                    icon: Icons.help_outline_rounded,
                    accentColor: _amber,
                    title: txt("Yordam"),
                    body: txt("Yordam matni"),
                    closeLabel: txt("Yopish"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _amber.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.help_rounded,
                            color: _amber,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txt("Yordam"),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                txt("Yordam tavsifi"),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
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
              ),

              Divider(
                height: 1,
                indent: 18,
                endIndent: 18,
                color: borderColor,
              ),

              // ILOVA HAQIDA
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(22),
                  ),
                  onTap: () => _showInfoDialog(
                    pageContext: context,
                    icon: CupertinoIcons.book_fill,
                    accentColor: _primaryBlue,
                    title: txt("Ilova haqida"),
                    body: txt("Ilova matni"),
                    closeLabel: txt("Yopish"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _primaryBlue.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            CupertinoIcons.book,
                            color: isDark ? _skyBlue : _primaryBlue,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txt("Ilova haqida"),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                txt("Ilova tavsifi"),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    final bool isDark = themeProvider.isDarkMode;
    final String rawLang = profileProvider.language;
    final String safeLanguage =
    ["Uzb", "Rus", "Kiril"].contains(rawLang) ? rawLang : "Uzb";

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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings_rounded,
                size: 21,
                color: isDark ? _skyBlue : _primaryBlue,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                DraverSozlamalarPages.getTxt(safeLanguage, "Sozlamalar"),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 760;
            final double horizontalPad = constraints.maxWidth >= 900 ? 28 : 16;

            final generalSection = _buildGeneralSettingsCard(
              themeProvider: themeProvider,
              notificationProvider: notificationProvider,
              profileProvider: profileProvider,
              safeLanguage: safeLanguage,
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            );

            final infoSection = _buildInfoCard(
              context: context,
              safeLanguage: safeLanguage,
              isDark: isDark,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            );

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                horizontalPad,
                16,
                horizontalPad,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: generalSection),
                      const SizedBox(width: 20),
                      Expanded(flex: 5, child: infoSection),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      generalSection,
                      const SizedBox(height: 22),
                      infoSection,
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