import 'package:afada/pages/daromad_pages/Ishchilar/Ishchilar_oylik_daromad_pagees.dart';
import 'package:afada/pages/daromad_pages/Ishchilar/Kunlik_daromad_pages.dart';
import 'package:afada/pages/daromad_pages/Ishchilar/ishchilar_umumiydaromad_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afada/provider/profile_provider.dart';

class IshchilarIshhaqqiPages extends StatelessWidget {
  const IshchilarIshhaqqiPages({super.key});

  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _lightBg = Color(0xFFF8FAFC);

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "title": "Ishchilar",
      "kunlik": "Kunlik",
      "oylik": "Oylik",
      "umumiy": "Umumiy",
    },
    "Rus": {
      "title": "Рабочие",
      "kunlik": "Дневной",
      "oylik": "Ежемесячный",
      "umumiy": "Общий",
    },
    "Kiril": {
      "title": "Ишчилар",
      "kunlik": "Кунлик",
      "oylik": "Ойлик",
      "umumiy": "Умумий",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts["Uzb"]?[key] ??
        key;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<ProfileProvider>().language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  Icons.groups_rounded,
                  size: 22,
                  color: isDark ? _skyBlue : _primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  getTxt(lang, "title"),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF131B2E)
                          : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF26334D)
                            : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      splashBorderRadius: BorderRadius.circular(25),
                      labelColor: Colors.white,
                      unselectedLabelColor: textSecondary,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFF0284C7),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      tabs: [
                        _buildTab(text: getTxt(lang, "kunlik")),
                        _buildTab(text: getTxt(lang, "oylik")),
                        _buildTab(text: getTxt(lang, "umumiy")),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            KunlikDaromadPages(),
            IshchilarOylikDaromadPagees(),
            IshchilarUmumiydaromadPages(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String text,
  }) {
    return Tab(
      height: 34,
      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}