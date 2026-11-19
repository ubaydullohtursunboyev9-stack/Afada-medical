import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:afada/model/ishchi_modeli.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/order_provider.dart';

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

class IshchilarOylikDaromadPagees extends StatefulWidget {
  const IshchilarOylikDaromadPagees({super.key});

  @override
  State<IshchilarOylikDaromadPagees> createState() =>
      _IshchilarOylikDaromadPageesState();
}

class _IshchilarOylikDaromadPageesState
    extends State<IshchilarOylikDaromadPagees> {
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
  String _searchQuery = "";
  String _selectedRoleFilter = "all"; // all | texnik | shifokor | sotuvchi

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "jami_mahsulotlar": "Oylik tayyorlangan",
      "jami_sotilgan": "Oylik sotilgan",
      "dona": "dona",
      "kishi": "nafar",
      "texnik_xodimlar": "Texnik xodimlar",
      "shifokorlar": "Shifokorlar",
      "sotuvchilar": "Sotuvchilar",
      "barchasi": "Barchasi",
      "tayyorlagan": "Tayyorlagan:",
      "sotildi": "Sotildi:",
      "ta": "ta",
      "tel": "Telefon:",
      "qidirish": "Xodim ismi, kasbi yoki raqami...",
      "xodimlar_topilmadi": "Bu bo'limda xodimlar topilmadi",
      "oylik_faoliyat": "Oylik ish ko'rsatkichlari",
      "xodimlar_soni": "Xodimlar:",
      "qayta_urinish": "Yangilash",
      "m_1": "Yanvar",
      "m_2": "Fevral",
      "m_3": "Mart",
      "m_4": "Aprel",
      "m_5": "May",
      "m_6": "Iyun",
      "m_7": "Iyul",
      "m_8": "Avgust",
      "m_9": "Sentabr",
      "m_10": "Oktabr",
      "m_11": "Noyabr",
      "m_12": "Dekabr",
    },
    "Rus": {
      "jami_mahsulotlar": "Произведено за месяц",
      "jami_sotilgan": "Продано за месяц",
      "dona": "шт",
      "kishi": "чел.",
      "texnik_xodimlar": "Технический персонал",
      "shifokorlar": "Врачи",
      "sotuvchilar": "Продавцы",
      "barchasi": "Все",
      "tayyorlagan": "Подготовил:",
      "sotildi": "Продано:",
      "ta": "шт",
      "tel": "Телефон:",
      "qidirish": "Поиск по имени, должности или номеру...",
      "xodimlar_topilmadi": "Сотрудники не найдены",
      "oylik_faoliyat": "Месячная активность сотрудников",
      "xodimlar_soni": "Сотрудники:",
      "qayta_urinish": "Обновить",
      "m_1": "Январь",
      "m_2": "Февраль",
      "m_3": "Март",
      "m_4": "Апрель",
      "m_5": "Май",
      "m_6": "Июнь",
      "m_7": "Июль",
      "m_8": "Август",
      "m_9": "Сентябрь",
      "m_10": "Октябрь",
      "m_11": "Ноябрь",
      "m_12": "Декабрь",
    },
    "Kiril": {
      "jami_mahsulotlar": "Ойлик тайёрланган",
      "jami_sotilgan": "Ойлик сотилган",
      "dona": "дона",
      "kishi": "нафар",
      "texnik_xodimlar": "Техник ходимлар",
      "shifokorlar": "Шифокорлар",
      "sotuvchilar": "Сотувчилар",
      "barchasi": "Барчаси",
      "tayyorlagan": "Тайёрлаган:",
      "sotildi": "Сотилди:",
      "ta": "та",
      "tel": "Телефон:",
      "qidirish": "Ходим исми, касби ёки рақами...",
      "xodimlar_topilmadi": "Бу бўлимда ходимлар топилмади",
      "oylik_faoliyat": "Ойлик иш кўрсаткичлари",
      "xodimlar_soni": "Ходимлар:",
      "qayta_urinish": "Янгилаш",
      "m_1": "Январь",
      "m_2": "Февраль",
      "m_3": "Март",
      "m_4": "Апрель",
      "m_5": "Май",
      "m_6": "Июнь",
      "m_7": "Июль",
      "m_8": "Август",
      "m_9": "Сентябрь",
      "m_10": "Октябрь",
      "m_11": "Ноябрь",
      "m_12": "Декабрь",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts["Uzb"]?[key] ??
        key;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FinishedProductProvider>().fetchFinishedProducts();
      context.read<OrderProvider>().fetchSalesFromApi();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      context.read<FinishedProductProvider>().fetchFinishedProducts(),
      context.read<OrderProvider>().fetchSalesFromApi(),
    ]);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return;

    final String formatted =
    cleaned.startsWith('+') ? cleaned : '+$cleaned';
    final Uri launchUri = Uri(scheme: 'tel', path: formatted);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  String _normalizeName(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim();
  }

  bool _isSameWorker(IshchiModel ishchi, String? createdByName) {
    if (createdByName == null || createdByName.trim().isEmpty) {
      return false;
    }

    final creator = _normalizeName(createdByName);
    if (creator.isEmpty) return false;

    final workerIsm = _normalizeName(ishchi.ism);
    final workerFamilya = _normalizeName(ishchi.familya);
    final workerLogin = _normalizeName(ishchi.login ?? "");

    if (workerLogin.isNotEmpty && (creator == workerLogin || creator.contains(workerLogin) || workerLogin.contains(creator))) {
      return true;
    }

    final familyaIsm = '$workerFamilya$workerIsm';
    final ismFamilya = '$workerIsm$workerFamilya';

    if (familyaIsm.isNotEmpty && creator == familyaIsm) return true;
    if (ismFamilya.isNotEmpty && creator == ismFamilya) return true;

    if (workerIsm.isNotEmpty && workerFamilya.isNotEmpty) {
      if (creator.contains(workerIsm) && creator.contains(workerFamilya)) {
        return true;
      }
    }

    if (workerIsm.length >= 2 && (creator == workerIsm || creator.contains(workerIsm) || workerIsm.contains(creator))) {
      return true;
    }
    if (workerFamilya.length >= 2 && (creator == workerFamilya || creator.contains(workerFamilya) || workerFamilya.contains(creator))) {
      return true;
    }

    if ((creator.contains("admin") || creator.contains("administrator")) &&
        (workerIsm.contains("admin") || workerIsm.contains("administrator") || workerLogin.contains("admin") || ishchi.lavozim.toLowerCase().contains("admin") || ishchi.kasb.toLowerCase().contains("admin"))) {
      return true;
    }

    return false;
  }

  bool _isTechWorker(IshchiModel i) =>
      i.kasb.trim().toLowerCase() == "texnik xodim";

  bool _isDoctorWorker(IshchiModel i) =>
      i.kasb.trim().toLowerCase() == "shifokor";

  bool _isSellerWorker(IshchiModel i) =>
      i.kasb.trim().toLowerCase() == "sotuvchi" ||
          i.lavozim.trim().toLowerCase() == "sotuvchi" ||
          i.kasb.trim().toLowerCase() == "seller";

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final finishedProvider = context.watch<FinishedProductProvider>();
    final orderProvider = context.watch<OrderProvider>();

    final lang = profile.language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color cardBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    /*
     * ISHCHILAR RO'YXATI
     */
    final List<IshchiModel> ishchilar =
    List<IshchiModel>.from(IshchiDatabase.ishchilar);

    /*
     * HOZIR LOGIN QILGAN ACCOUNT
     */
    final currentFullName = "${profile.surname} ${profile.name}".trim();

    final isAlreadyInList = ishchilar.any(
          (i) =>
      _normalizeName("${i.familya} ${i.ism}") ==
          _normalizeName(currentFullName),
    );

    if (!isAlreadyInList && currentFullName.isNotEmpty) {
      ishchilar.insert(
        0,
        IshchiModel(
          ism: profile.name,
          familya: profile.surname,
          telefon: profile.phone,
          lavozim: profile.role,
          kasb: profile.role,
          rasm: profile.imagePath,
          login: profile.login,
          parol: profile.password,
        ),
      );
    }

    /*
     * TEXNIK XODIMLAR VA SHIFOKORLAR
     */
    final techCount = ishchilar.where(_isTechWorker).length;
    final doctorCount = ishchilar.where(_isDoctorWorker).length;
    final sellerCount = ishchilar.where(_isSellerWorker).length;

    final now = DateTime.now();
    final monthTitle = "${getTxt(lang, "m_${now.month}")} ${now.year}";

    /*
     * FAQAT SHU OYDA QO'SHILGAN MAHSULOTLAR
     */
    final monthlyFinishedProducts =
    finishedProvider.finishedProducts.where((item) {
      final date = item.createdAt;
      if (date == null) return false;
      return date.year == now.year && date.month == now.month;
    }).toList();

    /*
     * FAQAT SHU OYDA SOTILGAN MAHSULOTLAR
     */
    final monthlySales = orderProvider.orders.where((o) {
      return o.date.year == now.year && o.date.month == now.month;
    }).toList();

    /*
     * SHU OYDA BARCHA ISHCHILAR QO'SHGAN MAHSULOTLARNING UMUMIY SONI
     */
    final totalProducts = monthlyFinishedProducts.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );

    final totalSold = monthlySales.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );

    /*
     * HAR BIR ISHCHI UCHUN OYLIK MAHSULOT SONI
     */
    int getProductCountForWorker(IshchiModel ishchi) {
      final currentUserName = "${profile.surname} ${profile.name}".trim();
      final isCurrentLoggedUser = _isSameWorker(ishchi, currentUserName) ||
          _normalizeName("${ishchi.familya} ${ishchi.ism}") == _normalizeName(currentUserName);

      return monthlyFinishedProducts.where((item) {
        if (item.createdByName != null && item.createdByName!.trim().isNotEmpty) {
          return _isSameWorker(ishchi, item.createdByName);
        }
        return isCurrentLoggedUser;
      }).fold<int>(0, (sum, item) => sum + item.quantity);
    }

    int getSoldCountForWorker(IshchiModel ishchi) {
      final currentUserName = "${profile.surname} ${profile.name}".trim();
      final isCurrentLoggedUser = _isSameWorker(ishchi, currentUserName) ||
          _normalizeName("${ishchi.familya} ${ishchi.ism}") == _normalizeName(currentUserName);

      return monthlySales.where((o) {
        String? createdByName;
        if (o.createdBy != null) {
          final m = o.createdBy!;
          final raw = m["fullName"] ?? m["full_name"] ?? m["name"] ?? m["username"] ?? m["login"] ?? m["displayName"];
          if (raw != null) createdByName = raw.toString();
        }

        if (createdByName != null && createdByName.trim().isNotEmpty) {
          return _isSameWorker(ishchi, createdByName);
        }
        return isCurrentLoggedUser;
      }).fold<int>(0, (sum, item) => sum + item.quantity);
    }

    int getWorkerCount(IshchiModel ishchi) {
      return _isSellerWorker(ishchi)
          ? getSoldCountForWorker(ishchi)
          : getProductCountForWorker(ishchi);
    }

    final int maxWorkerCount = ishchilar.fold<int>(
      0,
          (maxVal, w) {
        final c = getWorkerCount(w);
        return c > maxVal ? c : maxVal;
      },
    );

    /*
     * FILTRLANGAN RO'YXAT
     */
    final filteredIshchilar = ishchilar.where((ishchi) {
      if (_selectedRoleFilter == "texnik" && !_isTechWorker(ishchi)) {
        return false;
      }
      if (_selectedRoleFilter == "shifokor" && !_isDoctorWorker(ishchi)) {
        return false;
      }
      if (_selectedRoleFilter == "sotuvchi" && !_isSellerWorker(ishchi)) {
        return false;
      }

      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final fullName = "${ishchi.familya} ${ishchi.ism}".toLowerCase();
        final kasb = ishchi.kasb.toLowerCase();
        final lavozim = ishchi.lavozim.toLowerCase();
        final phone = ishchi.telefon.toLowerCase();
        if (!fullName.contains(q) &&
            !kasb.contains(q) &&
            !lavozim.contains(q) &&
            !phone.contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        color: _primaryBlue,
        onRefresh: _refreshAll,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final double horizontalPadding = maxWidth >= 900 ? 24 : 16;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                125,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                       * OY SARLAVHASI VA XODIMLAR SONI
                       */
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: _primaryBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _primaryBlue.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 18,
                                  color: isDark ? _skyBlue : _primaryBlue,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  monthTitle,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? _skyBlue : _primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${getTxt(lang, "xodimlar_soni")} ${ishchilar.length} ${getTxt(lang, "kishi")}",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /*
                       * KPI KARTALAR
                       */
                      LayoutBuilder(
                        builder: (context, kpiConstraints) {
                          final bool wideKpi = kpiConstraints.maxWidth >= 700;
                          final int cols = wideKpi ? 4 : 2;
                          const double spacing = 12;
                          final double itemWidth =
                              (kpiConstraints.maxWidth - spacing * (cols - 1)) /
                                  cols;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: [
                              SizedBox(
                                width: itemWidth,
                                child: _KpiSummaryCard(
                                  title: getTxt(lang, "jami_mahsulotlar"),
                                  value:
                                  "$totalProducts ${getTxt(lang, "dona")}",
                                  icon: Icons.inventory_2_rounded,
                                  accentColor: _emerald,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isSelected: _selectedRoleFilter == "all",
                                  onTap: () => setState(() {
                                    _selectedRoleFilter = "all";
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _KpiSummaryCard(
                                  title: getTxt(lang, "jami_sotilgan"),
                                  value: "$totalSold ${getTxt(lang, "dona")}",
                                  icon: Icons.trending_up_rounded,
                                  accentColor: _primaryBlue,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isSelected: _selectedRoleFilter == "sotuvchi",
                                  onTap: () => setState(() {
                                    _selectedRoleFilter =
                                    _selectedRoleFilter == "sotuvchi"
                                        ? "all"
                                        : "sotuvchi";
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _KpiSummaryCard(
                                  title: getTxt(lang, "texnik_xodimlar"),
                                  value: "$techCount ${getTxt(lang, "kishi")}",
                                  icon: Icons.engineering_rounded,
                                  accentColor: _amber,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isSelected: _selectedRoleFilter == "texnik",
                                  onTap: () => setState(() {
                                    _selectedRoleFilter =
                                    _selectedRoleFilter == "texnik"
                                        ? "all"
                                        : "texnik";
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _KpiSummaryCard(
                                  title: getTxt(lang, "shifokorlar"),
                                  value: "$doctorCount ${getTxt(lang, "kishi")}",
                                  icon: Icons.medical_services_rounded,
                                  accentColor: _indigo,
                                  isDark: isDark,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isSelected: _selectedRoleFilter == "shifokor",
                                  onTap: () => setState(() {
                                    _selectedRoleFilter =
                                    _selectedRoleFilter == "shifokor"
                                        ? "all"
                                        : "shifokor";
                                  }),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      /*
                       * QIDIRUV VA KAPSULA FILTR
                       */
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                          boxShadow: isDark
                              ? null
                              : [
                            BoxShadow(
                              color: const Color(0xFF0F172A)
                                  .withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _searchController,
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: getTxt(lang, "qidirish"),
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: textSecondary,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 22,
                                  color: textSecondary,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: textSecondary,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = "");
                                  },
                                )
                                    : null,
                                filled: true,
                                fillColor: isDark
                                    ? _slateDark.withValues(alpha: 0.65)
                                    : const Color(0xFFF1F5F9),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _FilterChipCapsule(
                                    label:
                                    "${getTxt(lang, "barchasi")} (${ishchilar.length})",
                                    selected: _selectedRoleFilter == "all",
                                    activeColor: _primaryBlue,
                                    isDark: isDark,
                                    onTap: () => setState(
                                          () => _selectedRoleFilter = "all",
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterChipCapsule(
                                    label:
                                    "${getTxt(lang, "texnik_xodimlar")} ($techCount)",
                                    selected: _selectedRoleFilter == "texnik",
                                    activeColor: _amber,
                                    isDark: isDark,
                                    onTap: () => setState(
                                          () => _selectedRoleFilter = "texnik",
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterChipCapsule(
                                    label:
                                    "${getTxt(lang, "shifokorlar")} ($doctorCount)",
                                    selected: _selectedRoleFilter == "shifokor",
                                    activeColor: _indigo,
                                    isDark: isDark,
                                    onTap: () => setState(
                                          () => _selectedRoleFilter = "shifokor",
                                    ),
                                  ),
                                  if (sellerCount > 0 ||
                                      _selectedRoleFilter == "sotuvchi") ...[
                                    const SizedBox(width: 8),
                                    _FilterChipCapsule(
                                      label:
                                      "${getTxt(lang, "sotuvchilar")} ($sellerCount)",
                                      selected:
                                      _selectedRoleFilter == "sotuvchi",
                                      activeColor: _emerald,
                                      isDark: isDark,
                                      onTap: () => setState(
                                            () => _selectedRoleFilter = "sotuvchi",
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      /*
                       * BO'LIM SARLAVHASI
                       */
                      Row(
                        children: [
                          Text(
                            getTxt(lang, "oylik_faoliyat"),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _primaryBlue.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${filteredIshchilar.length}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark ? _skyBlue : _primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /*
                       * LOADING INDIKATOR
                       */
                      if (finishedProvider.isLoading && ishchilar.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _primaryBlue,
                            ),
                          ),
                        ),

                      /*
                       * ERROR BANNER
                       */
                      if (finishedProvider.error != null)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _rose.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _rose.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: _rose,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  finishedProvider.error!,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : _rose,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _refreshAll,
                                child: Text(
                                  getTxt(lang, "qayta_urinish"),
                                  style: const TextStyle(
                                    color: _rose,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      /*
                       * XODIMLAR RO'YXATI (MOSLASHUVCHAN GRID)
                       */
                      if (filteredIshchilar.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 46,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_search_rounded,
                                size: 52,
                                color: textSecondary.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                getTxt(lang, "xodimlar_topilmadi"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w600,
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
                            w >= 1050 ? 3 : (w >= 640 ? 2 : 1);
                            const double gap = 14;
                            final double cardWidth =
                                (w - gap * (columns - 1)) / columns;

                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: filteredIshchilar.map((ishchi) {
                                final bool isSeller = _isSellerWorker(ishchi);
                                final int countValue = isSeller
                                    ? getSoldCountForWorker(ishchi)
                                    : getProductCountForWorker(ishchi);
                                final String titleKey =
                                isSeller ? "sotildi" : "tayyorlagan";
                                final double progress = maxWorkerCount > 0
                                    ? (countValue / maxWorkerCount)
                                    .clamp(0.0, 1.0)
                                    : 0.0;

                                return SizedBox(
                                  width: cardWidth,
                                  child: _WorkerMonthlyCard(
                                    ishchi: ishchi,
                                    countValue: countValue,
                                    metricLabel: getTxt(lang, titleKey),
                                    unitLabel: getTxt(lang, "ta"),
                                    phoneLabel: getTxt(lang, "tel"),
                                    progress: progress,
                                    isSeller: isSeller,
                                    isDark: isDark,
                                    cardBg: cardBg,
                                    borderColor: borderColor,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    onCallTap: ishchi.telefon.trim().isEmpty
                                        ? null
                                        : () => _makePhoneCall(ishchi.telefon),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                      if (finishedProvider.isLoading && ishchilar.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _primaryBlue,
                            ),
                          ),
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

class _KpiSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final bool isSelected;
  final VoidCallback onTap;

  const _KpiSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
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
                blurRadius: 14,
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
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 22, color: accentColor),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
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
      ),
    );
  }
}

class _FilterChipCapsule extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChipCapsule({
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
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? activeColor
                : (isDark
                ? const Color(0xFF131B2E)
                : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected
                  ? activeColor
                  : (isDark
                  ? const Color(0xFF26334D)
                  : const Color(0xFFE2E8F0)),
              width: 1,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkerMonthlyCard extends StatelessWidget {
  final IshchiModel ishchi;
  final int countValue;
  final String metricLabel;
  final String unitLabel;
  final String phoneLabel;
  final double progress;
  final bool isSeller;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback? onCallTap;

  const _WorkerMonthlyCard({
    required this.ishchi,
    required this.countValue,
    required this.metricLabel,
    required this.unitLabel,
    required this.phoneLabel,
    required this.progress,
    required this.isSeller,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onCallTap,
  });

  Color _roleColor() {
    final role = ishchi.kasb.trim().toLowerCase();
    if (role == "shifokor") return const Color(0xFF6366F1);
    if (role == "texnik xodim") return const Color(0xFFF59E0B);
    if (isSeller) return const Color(0xFF10B981);
    return const Color(0xFF0284C7);
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = _roleColor();
    final Color metricColor =
    countValue > 0 ? const Color(0xFF10B981) : textSecondary;
    final String roleText = ishchi.kasb.trim().isNotEmpty
        ? ishchi.kasb
        : ishchi.lavozim;

    return Container(
      padding: const EdgeInsets.all(16),
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
          /*
           * AVATAR + ISM + LAVOZIM
           */
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _WorkerAvatar(
                imagePath: ishchi.rasm,
                firstName: ishchi.ism,
                lastName: ishchi.familya,
                accentColor: accentColor,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${ishchi.familya} ${ishchi.ism}".trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: textPrimary,
                      ),
                    ),
                    if (roleText.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          roleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /*
           * TAYYORLAGAN / SOTILDI KO'RSATKICHI
           */
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B132B).withValues(alpha: 0.55)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.7),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      isSeller
                          ? Icons.shopping_bag_rounded
                          : Icons.precision_manufacturing_rounded,
                      size: 19,
                      color: metricColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        metricLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$countValue $unitLabel",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: metricColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      countValue > 0 ? const Color(0xFF10B981) : accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /*
           * TELEFON QATORI
           */
          Row(
            children: [
              Icon(
                Icons.phone_rounded,
                size: 18,
                color: textSecondary,
              ),
              const SizedBox(width: 7),
              Text(
                phoneLabel,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const Spacer(),
              if (onCallTap != null)
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onCallTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.call_rounded,
                          size: 15,
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatPhoneDisplay(ishchi.telefon),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  "-",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkerAvatar extends StatelessWidget {
  final String? imagePath;
  final String firstName;
  final String lastName;
  final Color accentColor;
  final bool isDark;

  const _WorkerAvatar({
    required this.imagePath,
    required this.firstName,
    required this.lastName,
    required this.accentColor,
    required this.isDark,
  });

  String _getInitials() {
    final f = firstName.trim();
    final l = lastName.trim();
    final c1 = l.isNotEmpty ? l[0].toUpperCase() : "";
    final c2 = f.isNotEmpty ? f[0].toUpperCase() : "";
    final combined = "$c1$c2".trim();
    return combined.isNotEmpty ? combined : "?";
  }

  @override
  Widget build(BuildContext context) {
    final path = imagePath?.trim() ?? "";
    final bool hasPath = path.isNotEmpty;
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');

    Widget fallback() {
      return Center(
        child: Text(
          _getInitials(),
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: accentColor,
          ),
        ),
      );
    }

    Widget imageWidget = fallback();
    if (hasPath) {
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
      width: 66,
      height: 66,
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