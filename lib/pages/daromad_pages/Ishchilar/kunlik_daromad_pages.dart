import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:afada/model/ishchi_modeli.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import 'package:afada/provider/order_provider.dart';
import 'package:afada/utils/error_utils.dart';
import 'package:afada/provider/profile_provider.dart';

import 'ishchi malumoti/ishchi_detal.dart';


// ============================================================
// CLINICAL COLORS (Boshqa sahifalar bilan bir xil rang tizimi)
// ============================================================
class _WorkerColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color rose = Color(0xFFF43F5E);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
}

enum _WorkerFilter { all, doctors, techStaff }

class KunlikDaromadPages extends StatefulWidget {
  const KunlikDaromadPages({super.key});

  @override
  State<KunlikDaromadPages> createState() => _KunlikDaromadPagesState();
}

class _KunlikDaromadPagesState extends State<KunlikDaromadPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  _WorkerFilter _activeFilter = _WorkerFilter.all;

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "jami_ishchilar": "Jami ishchilar",
      "dona": "dona",
      "texnik_xodimlar": "Texnik xodimlar",
      "shifokorlar": "Shifokorlar",
      "tayyorlagan": "Tayyorlagan:",
      "sotildi": "Sotildi:",
      "ta": "ta",
      "tel": "Tel:",
      "barchasi": "Barchasi",
      "qidirish": "Ism yoki telefon bo'yicha qidirish...",
      "natija_topilmadi": "Qidiruv bo'yicha xodim topilmadi",
      "filtrni_tozalash": "Filtrni tozalash",
      "bugungi_natija": "Bugungi natija",
      "malumot_yoq": "Ma'lumot kiritilmagan",
      "xodimlar": "Xodimlar faoliyati",
    },
    "Rus": {
      "jami_ishchilar": "Всего сотрудников",
      "dona": "шт",
      "texnik_xodimlar": "Технический персонал",
      "shifokorlar": "Врачи",
      "tayyorlagan": "Подготовил:",
      "sotildi": "Продано:",
      "ta": "шт",
      "tel": "Тел:",
      "barchasi": "Все",
      "qidirish": "Поиск по имени или телефону...",
      "natija_topilmadi": "Сотрудники не найдены",
      "filtrni_tozalash": "Сбросить фильтр",
      "bugungi_natija": "Итог за сегодня",
      "malumot_yoq": "Данные не введены",
      "xodimlar": "Активность персонала",
    },
    "Kiril": {
      "jami_ishchilar": "Жами ишчилар",
      "dona": "дона",
      "texnik_xodimlar": "Техник ходимлар",
      "shifokorlar": "Шифокорлар",
      "tayyorlagan": "Тайёрлаган:",
      "sotildi": "Сотилди:",
      "ta": "та",
      "tel": "Тел:",
      "barchasi": "Барчаси",
      "qidirish": "Исм ёки телефон бўйича қидириш...",
      "natija_topilmadi": "Қидирув бўйича ходим топилмади",
      "filtrni_tozalash": "Филтрни тозалаш",
      "bugungi_natija": "Бугунги натижа",
      "malumot_yoq": "Маълумот киритилмаган",
      "xodimlar": "Ходимлар фаолияти",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? _localizedTexts["Uzb"]?[key] ?? key;
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.isEmpty) return;

    String normalized = digits;
    if (!normalized.startsWith('+')) {
      normalized = normalized.startsWith('998')
          ? '+$normalized'
          : '+998$normalized';
    }

    final Uri launchUri = Uri(scheme: 'tel', path: normalized);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

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

    if (workerLogin.isNotEmpty &&
        (creator == workerLogin ||
            creator.contains(workerLogin) ||
            workerLogin.contains(creator))) {
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

    if (workerIsm.length >= 2 &&
        (creator == workerIsm ||
            creator.contains(workerIsm) ||
            workerIsm.contains(creator))) {
      return true;
    }
    if (workerFamilya.length >= 2 &&
        (creator == workerFamilya ||
            creator.contains(workerFamilya) ||
            workerFamilya.contains(creator))) {
      return true;
    }

    if ((creator.contains("admin") || creator.contains("administrator")) &&
        (workerIsm.contains("admin") ||
            workerIsm.contains("administrator") ||
            workerLogin.contains("admin") ||
            ishchi.lavozim.toLowerCase().contains("admin") ||
            ishchi.kasb.toLowerCase().contains("admin"))) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final finishedProvider = context.watch<FinishedProductProvider>();
    final orderProvider = context.watch<OrderProvider>();

    final String lang = profile.language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<IshchiModel> ishchilar =
    List<IshchiModel>.from(IshchiDatabase.ishchilar);

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

    final techCount = ishchilar.where((i) {
      return i.kasb.trim().toLowerCase() == "texnik xodim";
    }).length;

    final doctorCount = ishchilar.where((i) {
      return i.kasb.trim().toLowerCase() == "shifokor";
    }).length;

    final now = DateTime.now();

    final todayFinishedProducts = finishedProvider.finishedProducts.where((item) {
      final date = item.createdAt?.toLocal();
      if (date == null) return false;
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();

    final todaySales = orderProvider.orders.where((o) {
      final localDate = o.date.toLocal();
      return localDate.year == now.year &&
          localDate.month == now.month &&
          localDate.day == now.day;
    }).toList();

    int getProductCountForWorker(IshchiModel ishchi) {
      final currentUserName = "${profile.surname} ${profile.name}".trim();
      final isCurrentLoggedUser = _isSameWorker(ishchi, currentUserName) ||
          _normalizeName("${ishchi.familya} ${ishchi.ism}") ==
              _normalizeName(currentUserName);

      return todayFinishedProducts.where((item) {
        if (item.createdByName != null &&
            item.createdByName!.trim().isNotEmpty) {
          return _isSameWorker(ishchi, item.createdByName);
        }
        return isCurrentLoggedUser;
      }).fold<int>(0, (sum, item) => sum + item.quantity);
    }

    int getSoldCountForWorker(IshchiModel ishchi) {
      final currentUserName = "${profile.surname} ${profile.name}".trim();
      final isCurrentLoggedUser = _isSameWorker(ishchi, currentUserName) ||
          _normalizeName("${ishchi.familya} ${ishchi.ism}") ==
              _normalizeName(currentUserName);

      return todaySales.where((o) {
        String? createdByName;
        if (o.createdBy != null) {
          final m = o.createdBy!;
          final raw = m["fullName"] ??
              m["full_name"] ??
              m["name"] ??
              m["username"] ??
              m["login"] ??
              m["displayName"];
          if (raw != null) createdByName = raw.toString();
        }

        if (createdByName != null && createdByName.trim().isNotEmpty) {
          return _isSameWorker(ishchi, createdByName);
        }
        return isCurrentLoggedUser;
      }).fold<int>(0, (sum, item) => sum + item.quantity);
    }

    final int totalPreparedToday = todayFinishedProducts.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );
    final int totalSoldToday = todaySales.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );

    final String query = _searchQuery.trim().toLowerCase();
    final List<IshchiModel> filteredIshchilar = ishchilar.where((ishchi) {
      final String kasbLower = ishchi.kasb.trim().toLowerCase();
      if (_activeFilter == _WorkerFilter.doctors && kasbLower != "shifokor") {
        return false;
      }
      if (_activeFilter == _WorkerFilter.techStaff &&
          kasbLower != "texnik xodim") {
        return false;
      }
      if (query.isEmpty) return true;
      final fullName = "${ishchi.familya} ${ishchi.ism}".toLowerCase();
      return fullName.contains(query) ||
          ishchi.telefon.toLowerCase().contains(query) ||
          ishchi.lavozim.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? _WorkerColors.slateDark : Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            finishedProvider.fetchFinishedProducts(),
            orderProvider.fetchSalesFromApi(),
          ]);
        },
        color: _WorkerColors.primaryBlue,
        backgroundColor: isDark ? _WorkerColors.cardDark : Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double contentMaxWidth =
            constraints.maxWidth > 1080 ? 1080 : constraints.maxWidth;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (finishedProvider.error != null)
                        _buildErrorBanner(finishedProvider.error!),

                      // 1. KPI SUMMARY CARDS
                      _buildSummaryCards(
                        lang: lang,
                        isDark: isDark,
                        totalWorkers: ishchilar.length,
                        techCount: techCount,
                        doctorCount: doctorCount,
                        totalPreparedToday: totalPreparedToday,
                        totalSoldToday: totalSoldToday,
                      ),
                      const SizedBox(height: 14),

                      // 2. QIDIRUV VA KAPSULA FILTR
                      if (ishchilar.isNotEmpty) ...[
                        _buildSearchAndFilterBar(
                          lang: lang,
                          isDark: isDark,
                          maxWidth: contentMaxWidth - 32,
                          allCount: ishchilar.length,
                          doctorCount: doctorCount,
                          techCount: techCount,
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (finishedProvider.isLoading && ishchilar.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _WorkerColors.primaryBlue,
                            ),
                          ),
                        )
                      else ...[
                        if (finishedProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: LinearProgressIndicator(
                              color: _WorkerColors.primaryBlue,
                              minHeight: 3,
                            ),
                          ),

                        // 3. XODIMLAR SARLAVHASI
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _WorkerColors.primaryBlue
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.people_alt_rounded,
                                color: _WorkerColors.primaryBlue,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                getTxt(lang, "xodimlar"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _WorkerColors.primaryBlue
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${filteredIshchilar.length} ${getTxt(lang, "ta")}",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: _WorkerColors.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 4. XODIMLAR KARTALARI (Bosilganda IshchiDetail ga o'tadi)
                        if (ishchilar.isEmpty)
                          _buildEmptyCard(
                            isDark: isDark,
                            message: getTxt(lang, "malumot_yoq"),
                            showClearButton: false,
                          )
                        else if (filteredIshchilar.isEmpty)
                          _buildEmptyCard(
                            isDark: isDark,
                            message: getTxt(lang, "natija_topilmadi"),
                            clearLabel: getTxt(lang, "filtrni_tozalash"),
                            showClearButton: true,
                            onClear: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                                _activeFilter = _WorkerFilter.all;
                              });
                            },
                          )
                        else
                          _buildWorkersGrid(
                            filteredIshchilar: filteredIshchilar,
                            lang: lang,
                            isDark: isDark,
                            getProductCount: getProductCountForWorker,
                            getSoldCount: getSoldCountForWorker,
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
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _WorkerColors.rose.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _WorkerColors.rose.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: _WorkerColors.rose,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              getFriendlyErrorMessage(error),
              style: const TextStyle(
                color: _WorkerColors.rose,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 1. KPI SUMMARY CARDS
  // ============================================================
  Widget _buildSummaryCards({
    required String lang,
    required bool isDark,
    required int totalWorkers,
    required int techCount,
    required int doctorCount,
    required int totalPreparedToday,
    required int totalSoldToday,
  }) {
    final String dona = getTxt(lang, "dona");
    final String ta = getTxt(lang, "ta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: getTxt(lang, "jami_ishchilar"),
            icon: Icons.groups_rounded,
            iconColor: _WorkerColors.primaryBlue,
            mainValue: "$totalWorkers $ta",
            subLabel1: "${getTxt(lang, "texnik_xodimlar")}:",
            subVal1: "$techCount $ta",
            subLabel2: "${getTxt(lang, "shifokorlar")}:",
            subVal2: "$doctorCount $ta",
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: getTxt(lang, "bugungi_natija"),
            icon: Icons.insights_rounded,
            iconColor: _WorkerColors.green,
            mainValue: "${totalPreparedToday + totalSoldToday} $dona",
            subLabel1: getTxt(lang, "tayyorlagan"),
            subVal1: "$totalPreparedToday $ta",
            subLabel2: getTxt(lang, "sotildi"),
            subVal2: "$totalSoldToday $ta",
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String mainValue,
    required String subLabel1,
    required String subVal1,
    required String subLabel2,
    required String subVal2,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? _WorkerColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 22),
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
                        color:
                        isDark ? Colors.white : const Color(0xFF0F172A),
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
                        color:
                        isDark ? Colors.white : const Color(0xFF0F172A),
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

  // ============================================================
  // 2. SEARCH + FILTER BAR
  // ============================================================
  Widget _buildSearchAndFilterBar({
    required String lang,
    required bool isDark,
    required double maxWidth,
    required int allCount,
    required int doctorCount,
    required int techCount,
  }) {
    final searchField = Container(
      decoration: BoxDecoration(
        color: isDark ? _WorkerColors.cardDark : Colors.white,
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
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: getTxt(lang, "qidirish"),
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
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterPill(
              label: "${getTxt(lang, "barchasi")} ($allCount)",
              selected: _activeFilter == _WorkerFilter.all,
              activeColor: _WorkerColors.primaryBlue,
              isDark: isDark,
              onTap: () => setState(() => _activeFilter = _WorkerFilter.all),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label: "${getTxt(lang, "shifokorlar")} ($doctorCount)",
              selected: _activeFilter == _WorkerFilter.doctors,
              activeColor: _WorkerColors.skyBlue,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _WorkerFilter.doctors),
            ),
          ),
          Expanded(
            child: _buildFilterPill(
              label: "${getTxt(lang, "texnik_xodimlar")} ($techCount)",
              selected: _activeFilter == _WorkerFilter.techStaff,
              activeColor: _WorkerColors.green,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activeFilter = _WorkerFilter.techStaff),
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
          borderRadius: BorderRadius.circular(25),
          boxShadow: selected
              ? [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.35),
              blurRadius: 6,
              offset: const Offset(0, 2),
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

  // ============================================================
  // 3. RESPONSIVE WORKERS GRID
  // ============================================================
  Widget _buildWorkersGrid({
    required List<IshchiModel> filteredIshchilar,
    required String lang,
    required bool isDark,
    required int Function(IshchiModel) getProductCount,
    required int Function(IshchiModel) getSoldCount,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32;
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
            final bool isSotuvchi =
                ishchi.kasb.trim().toLowerCase() == "sotuvchi" ||
                    ishchi.lavozim.trim().toLowerCase() == "sotuvchi";

            final int displayCount =
            isSotuvchi ? getSoldCount(ishchi) : getProductCount(ishchi);

            final String displayLabel = isSotuvchi
                ? getTxt(lang, "sotildi")
                : getTxt(lang, "tayyorlagan");

            final Color metricColor =
            isSotuvchi ? _WorkerColors.primaryBlue : _WorkerColors.green;

            final String displayName = "${ishchi.familya} ${ishchi.ism}"
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim();

            return SizedBox(
              width: itemWidth,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    final isAdmin = context.read<ProfileProvider>().role.trim().toLowerCase() == "admin";
                    if (!isAdmin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 10),
                              Text("Ushbu ma'lumot faqat Admin uchun mo'ljallangan"),
                            ],
                          ),
                          backgroundColor: const Color(0xFF1E293B),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IshchiDetail(
                          ishchi: ishchi,
                          initialTabIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? _WorkerColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.25)
                              : const Color(0xFF64748B).withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildWorkerAvatar(ishchi, metricColor, isDark),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: metricColor.withValues(alpha: 0.13),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "$displayLabel $displayCount ${getTxt(lang, "ta")}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: metricColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "${getTxt(lang, "tel")} ",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white60
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: ishchi.telefon.trim().isEmpty
                                          ? null
                                          : () => _makePhoneCall(ishchi.telefon),
                                      child: Text(
                                        _formatPhoneDisplay(ishchi.telefon),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: ishchi.telefon.trim().isEmpty
                                              ? (isDark
                                              ? Colors.white38
                                              : Colors.black38)
                                              : (isDark
                                              ? _WorkerColors.skyBlue
                                              : _WorkerColors.primaryBlue),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (ishchi.telefon.trim().isNotEmpty) ...[
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
                                  color: _WorkerColors.green
                                      .withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.phone_rounded,
                                  color: _WorkerColors.green,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildWorkerAvatar(
      IshchiModel ishchi,
      Color accentColor,
      bool isDark,
      ) {
    final String? rasm = ishchi.rasm?.trim();
    final String fam = ishchi.familya.trim();
    final String ism = ishchi.ism.trim();
    final String initial = fam.isNotEmpty
        ? fam[0].toUpperCase()
        : (ism.isNotEmpty ? ism[0].toUpperCase() : "");

    Widget fallback() {
      if (initial.isEmpty) {
        return Icon(
          Icons.person_rounded,
          color: isDark ? Colors.white54 : accentColor,
          size: 36,
        );
      }
      return Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : accentColor,
          ),
        ),
      );
    }

    Widget avatarContent = fallback();
    if (rasm != null && rasm.isNotEmpty) {
      if (rasm.startsWith('http://') || rasm.startsWith('https://')) {
        avatarContent = Image.network(
          rasm,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        );
      } else {
        final file = File(rasm);
        if (file.existsSync()) {
          avatarContent = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback(),
          );
        }
      }
    }

    return Container(
      width: 68,
      height: 68,
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
      child: ClipOval(child: avatarContent),
    );
  }

  Widget _buildEmptyCard({
    required bool isDark,
    required String message,
    required bool showClearButton,
    String? clearLabel,
    VoidCallback? onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: isDark ? _WorkerColors.cardDark : Colors.white,
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
              color: _WorkerColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              showClearButton
                  ? Icons.search_off_rounded
                  : Icons.people_outline_rounded,
              size: 32,
              color: _WorkerColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
          if (showClearButton && onClear != null && clearLabel != null) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                clearLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _WorkerColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}