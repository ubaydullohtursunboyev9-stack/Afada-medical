import 'package:afada/pages/daromad_pages/Ishchilar/Ishchilar_oylik_daromad_pagees.dart';
import 'package:afada/pages/daromad_pages/Ishchilar/Kunlik_daromad_pages.dart';
import 'package:afada/pages/daromad_pages/Ishchilar/ishchilar_umumiydaromad_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afada/provider/profile_provider.dart';

class IshchilarIshhaqqiPages extends StatelessWidget {
  const IshchilarIshhaqqiPages({super.key});

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
    return _localizedTexts[lang]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<ProfileProvider>().language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            getTxt(lang, "title"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Container(
              height: 30,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2E38) : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF3A3F4B) : Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(horizontal: -10, vertical: 2),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark ? const Color(0xFF3C8DFF).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.25),
                  border: Border.all(
                    color: isDark ? const Color(0xFF3C8DFF) : Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                tabs: [
                  Tab(text: getTxt(lang, "kunlik")),
                  Tab(text: getTxt(lang, "oylik")),
                  Tab(text: getTxt(lang, "umumiy")),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [
          KunlikDaromadPages(),
          IshchilarOylikDaromadPagees(),
          IshchilarUmumiydaromadPages()
        ]),
      ),
    );
  }
}
