import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:afada/model/ishchi_modeli.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/order_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/utils/error_utils.dart';

// ============================================================
// AFADA MEDICAL CLINICAL COLORS
// ============================================================
class _DetailColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color indigo = Color(0xFF6366F1);
  static const Color rose = Color(0xFFF43F5E);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF8FAFC);
}

// ============================================================
// HAR BIR QO'SHILGAN MAHSULOTNI ANIQ SANA VA SOATI BILAN SAQLASH
// (Backend bir xil mahsulotni qo'shib yuborgan holatda ham har bir
// qo'shish alohida saqlanib qolishi uchun)
// ============================================================
class WorkerProductionLogEntry {
  final String productName;
  final int quantity;
  final DateTime dateTime;
  final String workerName;
  final String workerLogin;

  const WorkerProductionLogEntry({
    required this.productName,
    required this.quantity,
    required this.dateTime,
    required this.workerName,
    required this.workerLogin,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'quantity': quantity,
    'dateTime': dateTime.toIso8601String(),
    'workerName': workerName,
    'workerLogin': workerLogin,
  };

  factory WorkerProductionLogEntry.fromJson(Map<String, dynamic> json) {
    return WorkerProductionLogEntry(
      productName: (json['productName'] ?? '').toString(),
      quantity: int.tryParse((json['quantity'] ?? '0').toString()) ?? 0,
      dateTime: DateTime.tryParse((json['dateTime'] ?? '').toString()) ??
          DateTime.now(),
      workerName: (json['workerName'] ?? '').toString(),
      workerLogin: (json['workerLogin'] ?? '').toString(),
    );
  }
}

class WorkerProductionLog {
  static const String _storageKey = 'afada_worker_production_log_v1';

  static Future<void> record({
    required String productName,
    required int quantity,
    required DateTime dateTime,
    required String workerName,
    String workerLogin = '',
  }) async {
    if (productName.trim().isEmpty || quantity <= 0) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getAll();
      existing.insert(
        0,
        WorkerProductionLogEntry(
          productName: productName.trim(),
          quantity: quantity,
          dateTime: dateTime,
          workerName: workerName.trim(),
          workerLogin: workerLogin.trim(),
        ),
      );
      final encoded = jsonEncode(existing.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('WorkerProductionLog record error: $e');
    }
  }

  static Future<List<WorkerProductionLogEntry>> getAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.trim().isEmpty) return [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(WorkerProductionLogEntry.fromJson)
          .where((e) => e.quantity > 0 && e.productName.trim().isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('WorkerProductionLog getAll error: $e');
      return [];
    }
  }
}

enum _ActivityType { produced, sold }

enum _ActivityFilter { all, produced, sold }

class _WorkerActivityRecord {
  final String productName;
  final int quantity;
  final DateTime dateTime;
  final _ActivityType type;
  final String? customerName;

  const _WorkerActivityRecord({
    required this.productName,
    required this.quantity,
    required this.dateTime,
    required this.type,
    this.customerName,
  });
}

class _DayBucket {
  final DateTime dayDate;
  final List<_WorkerActivityRecord> items;

  _DayBucket({
    required this.dayDate,
    required this.items,
  });

  int get totalQuantity => items.fold<int>(0, (sum, e) => sum + e.quantity);
}

class IshchiDetail extends StatefulWidget {
  final IshchiModel ishchi;
  final int initialTabIndex;

  const IshchiDetail({
    super.key,
    required this.ishchi,
    this.initialTabIndex = 0,
  });

  @override
  State<IshchiDetail> createState() => _IshchiDetailState();
}

class _IshchiDetailState extends State<IshchiDetail>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearchOpen = false;
  String _searchQuery = "";
  _ActivityFilter _activityFilter = _ActivityFilter.all;
  List<WorkerProductionLogEntry> _localLogs = [];

  static const Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "kunlik": "Kunlik",
      "oylik": "Oylik",
      "umumiy": "Umumiy",
      "ishlab_chiqardi": "Ishlab chiqardi",
      "sotildi": "Sotildi",
      "amallar": "Qo'shishlar:",
      "qoshishlar_soni": "Qo'shishlar soni",
      "dona": "dona",
      "ta": "ta",
      "marta": "marta",
      "barchasi": "Barchasi",
      "batafsil_tarix": "Ishlab chiqarish tarixi",
      "sotuv_tarixi": "Faoliyat tarixi",
      "qidirish": "Mahsulot, sana yoki soat bo'yicha qidirish...",
      "malumot_yoq_kunlik": "Bugun hali mahsulot ishlab chiqarilmagan",
      "malumot_yoq_oylik": "Ushbu oyda hali ma'lumot mavjud emas",
      "malumot_yoq_umumiy": "Hozircha hech qanday ma'lumot topilmadi",
      "qidiruv_topilmadi": "Qidiruv bo'yicha natija topilmadi",
      "bugun": "Bugun",
      "kecha": "Kecha",
      "oxirgi_vaqt": "Oxirgi vaqt:",
      "nomsiz_mahsulot": "Mahsulot",
      "tayyorlandi": "Tayyorlandi",
      "mijoz": "Mijoz:",
      "shifokor": "Shifokor",
      "texnik_xodim": "Texnik xodim",
      "admin": "Admin",
      "sotuvchi": "Sotuvchi",
      "ishchi": "Ishchi",
      "tel_yoq": "Raqam kiritilmagan",
      "kunlar": "Faol kunlar:",
    },
    "Rus": {
      "kunlik": "Дневной",
      "oylik": "Месячный",
      "umumiy": "Общий",
      "ishlab_chiqardi": "Произведено",
      "sotildi": "Продано",
      "amallar": "Добавлений:",
      "qoshishlar_soni": "Кол-во записей",
      "dona": "шт",
      "ta": "шт",
      "marta": "раз",
      "barchasi": "Все",
      "batafsil_tarix": "История производства",
      "sotuv_tarixi": "История активности",
      "qidirish": "Поиск по товару, дате или времени...",
      "malumot_yoq_kunlik": "За сегодня произведённых товаров нет",
      "malumot_yoq_oylik": "За этот месяц данных пока нет",
      "malumot_yoq_umumiy": "Записи пока отсутствуют",
      "qidiruv_topilmadi": "По вашему запросу ничего не найдено",
      "bugun": "Сегодня",
      "kecha": "Вчера",
      "oxirgi_vaqt": "Последнее:",
      "nomsiz_mahsulot": "Товар",
      "tayyorlandi": "Произведено",
      "mijoz": "Клиент:",
      "shifokor": "Врач",
      "texnik_xodim": "Технический персонал",
      "admin": "Админ",
      "sotuvchi": "Продавец",
      "ishchi": "Сотрудник",
      "tel_yoq": "Номер не указан",
      "kunlar": "Активных дней:",
    },
    "Kiril": {
      "kunlik": "Кунлик",
      "oylik": "Ойлик",
      "umumiy": "Умумий",
      "ishlab_chiqardi": "Ишлаб чиқарди",
      "sotildi": "Сотилди",
      "amallar": "Қўшишлар:",
      "qoshishlar_soni": "Қўшишлар сони",
      "dona": "дона",
      "ta": "та",
      "marta": "марта",
      "barchasi": "Барчаси",
      "batafsil_tarix": "Ишлаб чиқариш тарихи",
      "sotuv_tarixi": "Фаолият тарихи",
      "qidirish": "Маҳсулот, сана ёки соат бўйича қидириш...",
      "malumot_yoq_kunlik": "Бугун ҳали маҳсулот ишлаб чиқарилмаган",
      "malumot_yoq_oylik": "Ушбу ойда ҳали маълумот мавжуд эмас",
      "malumot_yoq_umumiy": "Ҳозирча ҳеч қандай маълумот топилмади",
      "qidiruv_topilmadi": "Қидирув бўйича натижа топилмади",
      "bugun": "Бугун",
      "kecha": "Кеча",
      "oxirgi_vaqt": "Охирги вақт:",
      "nomsiz_mahsulot": "Маҳсулот",
      "tayyorlandi": "Тайёрланди",
      "mijoz": "Мижоз:",
      "shifokor": "Шифокор",
      "texnik_xodim": "Техник ходим",
      "admin": "Админ",
      "sotuvchi": "Сотувчи",
      "ishchi": "Ишчи",
      "tel_yoq": "Рақам киритилмаган",
      "kunlar": "Фаол кунлар:",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? _localizedTexts["Uzb"]?[key] ?? key;
  }

  String _localizeRoleOrKasb(String lang, String raw) {
    final lower = raw.trim().toLowerCase();
    if (lower == "shifokor") return getTxt(lang, "shifokor");
    if (lower == "texnik xodim") return getTxt(lang, "texnik_xodim");
    if (lower == "admin") return getTxt(lang, "admin");
    if (lower == "sotuvchi") return getTxt(lang, "sotuvchi");
    if (lower == "ishchi") return getTxt(lang, "ishchi");
    return raw.trim();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 2),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    final logsFuture = WorkerProductionLog.getAll();
    await Future.wait([
      context.read<FinishedProductProvider>().fetchFinishedProducts(),
      context.read<OrderProvider>().fetchSalesFromApi(),
      logsFuture,
    ]);
    final loadedLogs = await logsFuture;
    if (mounted) {
      setState(() {
        _localLogs = loadedLogs;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    HapticFeedback.selectionClick();
    setState(() => _isSearchOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    HapticFeedback.selectionClick();
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _isSearchOpen = false;
      _searchQuery = "";
    });
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

  String _extractFinishedProductName(dynamic item, String fallback) {
    try {
      final v = item.productName;
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString().trim();
      }
    } catch (_) {}
    try {
      final v = item.mahsulotNomi;
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString().trim();
      }
    } catch (_) {}
    try {
      final v = item.product?.nomi;
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString().trim();
      }
    } catch (_) {}
    try {
      final v = item.product?.name;
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString().trim();
      }
    } catch (_) {}
    try {
      final v = item.name;
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString().trim();
      }
    } catch (_) {}
    try {
      final v = item.title;
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString().trim();
      }
    } catch (_) {}
    return fallback;
  }

  String _formatPhoneDisplay(String phone, String emptyFallback) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (digits.isEmpty) return emptyFallback;

    if (digits.startsWith('998') && digits.length == 12) {
      return '+${digits.substring(0, 3)} ${digits.substring(3, 5)} ${digits.substring(5, 8)} ${digits.substring(8, 10)} ${digits.substring(10, 12)}';
    }
    if (digits.length == 9) {
      return '+998 ${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 7)} ${digits.substring(7, 9)}';
    }
    final trimmed = phone.trim();
    return trimmed.startsWith('+') ? trimmed : '+$digits';
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

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    return '$d.$m.${local.year}';
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$h:$min';
  }

  String _formatRelativeDate(DateTime dt, String lang) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(local.year, local.month, local.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return "${getTxt(lang, "bugun")}, ${_formatDate(local)}";
    if (diff == 1) return "${getTxt(lang, "kecha")}, ${_formatDate(local)}";
    return _formatDate(local);
  }

  String _productInitial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "M";
    return trimmed[0].toUpperCase();
  }

  // Har bir qo'shilgan mahsulotni ALOHIDA yozuv sifatida yig'ish (hech qachon qo'shib yubormaydi)
  List<_WorkerActivityRecord> _collectAllWorkerRecords({
    required ProfileProvider profile,
    required FinishedProductProvider finishedProvider,
    required OrderProvider orderProvider,
    required String lang,
  }) {
    final ishchi = widget.ishchi;
    final currentUserName = "${profile.surname} ${profile.name}".trim();
    final isCurrentLoggedUser = _isSameWorker(ishchi, currentUserName) ||
        _normalizeName("${ishchi.familya} ${ishchi.ism}") ==
            _normalizeName(currentUserName);

    // 1. API dan kelgan ishlab chiqarilgan mahsulotlar
    final Map<String, List<_WorkerActivityRecord>> apiByProduct = {};
    for (final item in finishedProvider.finishedProducts) {
      final createdAt = item.createdAt;
      if (createdAt == null) continue;

      final bool belongsToWorker =
      (item.createdByName != null && item.createdByName!.trim().isNotEmpty)
          ? _isSameWorker(ishchi, item.createdByName)
          : isCurrentLoggedUser;

      if (!belongsToWorker) continue;

      final productName = _extractFinishedProductName(
        item,
        getTxt(lang, "nomsiz_mahsulot"),
      );
      final key = productName.toLowerCase();

      apiByProduct.putIfAbsent(key, () => []).add(
        _WorkerActivityRecord(
          productName: productName,
          quantity: item.quantity,
          dateTime: createdAt.toLocal(),
          type: _ActivityType.produced,
        ),
      );
    }

    // 2. OmborPages orqali har bir alohida qo'shishda yozib borilgan tarix
    final Map<String, List<_WorkerActivityRecord>> localByProduct = {};
    for (final log in _localLogs) {
      final bool belongsToWorker = _isSameWorker(ishchi, log.workerName) ||
          (log.workerLogin.isNotEmpty &&
              _isSameWorker(ishchi, log.workerLogin));

      if (!belongsToWorker) continue;

      final key = log.productName.trim().toLowerCase();
      localByProduct.putIfAbsent(key, () => []).add(
        _WorkerActivityRecord(
          productName: log.productName.trim(),
          quantity: log.quantity,
          dateTime: log.dateTime.toLocal(),
          type: _ActivityType.produced,
        ),
      );
    }

    final List<_WorkerActivityRecord> records = [];

    // 3. API va alohida qo'shish tarixini dublikatsiz uyg'unlashtirish
    final Set<String> allProductKeys = {
      ...apiByProduct.keys,
      ...localByProduct.keys,
    };

    for (final key in allProductKeys) {
      final apiItems = apiByProduct[key] ?? [];
      final localItems = localByProduct[key] ?? [];

      if (localItems.isEmpty) {
        records.addAll(apiItems);
        continue;
      }

      if (apiItems.isEmpty) {
        // Agar API hali javob bermagan yoki offline bo'lsa
        records.addAll(localItems);
        continue;
      }

      // Agar backend har bir qo'shishni alohida qator qilib qaytargan bo'lsa
      if (apiItems.length >= localItems.length && apiItems.length > 1) {
        records.addAll(apiItems);
        continue;
      }

      // Backend bir xil nomli mahsulotni bitta qatorga qo'shib yuborgan bo'lsa:
      // har bir qo'shish alohida o'z sanasi va soati bilan ko'rsatiladi
      final int apiTotal =
      apiItems.fold<int>(0, (sum, item) => sum + item.quantity);
      final int localTotal =
      localItems.fold<int>(0, (sum, item) => sum + item.quantity);

      records.addAll(localItems);

      // Agar bazada oldinroq qo'shilgan qoldiq miqdor ham bo'lsa, uni yo'qotmaslik
      if (apiTotal > localTotal) {
        apiItems.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        records.add(
          _WorkerActivityRecord(
            productName: apiItems.first.productName,
            quantity: apiTotal - localTotal,
            dateTime: apiItems.first.dateTime,
            type: _ActivityType.produced,
          ),
        );
      }
    }

    // 4. Sotilgan mahsulotlar (API: OrderProvider)
    for (final order in orderProvider.orders) {
      String? createdByName;
      if (order.createdBy != null) {
        final m = order.createdBy!;
        final raw = m["fullName"] ??
            m["full_name"] ??
            m["name"] ??
            m["username"] ??
            m["login"] ??
            m["displayName"];
        if (raw != null) createdByName = raw.toString();
      }

      final bool belongsToWorker =
      (createdByName != null && createdByName.trim().isNotEmpty)
          ? _isSameWorker(ishchi, createdByName)
          : isCurrentLoggedUser;

      if (!belongsToWorker) continue;

      final String productName = order.productName.trim().isNotEmpty
          ? order.productName.trim()
          : getTxt(lang, "nomsiz_mahsulot");

      records.add(
        _WorkerActivityRecord(
          productName: productName,
          quantity: order.quantity,
          dateTime: order.date.toLocal(),
          type: _ActivityType.sold,
          customerName: order.customerName.trim().isNotEmpty
              ? order.customerName.trim()
              : null,
        ),
      );
    }

    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return records;
  }

  List<_WorkerActivityRecord> _filterByPeriod(
      List<_WorkerActivityRecord> all,
      int tabIndex,
      ) {
    final now = DateTime.now();
    if (tabIndex == 0) {
      return all
          .where((r) =>
      r.dateTime.year == now.year &&
          r.dateTime.month == now.month &&
          r.dateTime.day == now.day)
          .toList();
    }
    if (tabIndex == 1) {
      return all
          .where((r) =>
      r.dateTime.year == now.year && r.dateTime.month == now.month)
          .toList();
    }
    return all;
  }

  // Faqat sanalar bo'yicha vizual bo'limlarga ajratish (mahsulotlarni qo'shib yubormasdan!)
  List<_DayBucket> _groupByDayOnly(List<_WorkerActivityRecord> records) {
    final Map<String, _DayBucket> map = {};
    for (final r in records) {
      final d = DateTime(r.dateTime.year, r.dateTime.month, r.dateTime.day);
      final key = '${d.year}-${d.month}-${d.day}';
      if (map.containsKey(key)) {
        map[key]!.items.add(r);
      } else {
        map[key] = _DayBucket(dayDate: d, items: [r]);
      }
    }
    final list = map.values.toList()
      ..sort((a, b) => b.dayDate.compareTo(a.dayDate));
    for (final bucket in list) {
      bucket.items.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final finishedProvider = context.watch<FinishedProductProvider>();
    final orderProvider = context.watch<OrderProvider>();

    final String lang = profile.language;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final bool isAdmin = profile.role.trim().toLowerCase() == "admin";

    if (!isAdmin) {
      return Scaffold(
        backgroundColor: isDark ? _DetailColors.slateDark : _DetailColors.lightBg,
        appBar: AppBar(
          backgroundColor: isDark ? _DetailColors.slateDark : _DetailColors.lightBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            getTxt(lang, "batafsil_tarix"),
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 48,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Faqat Admin uchun",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ushbu sahifa faqat Admin uchun mo'ljallangan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final String workerFullName =
    "${widget.ishchi.familya} ${widget.ishchi.ism}"
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final allRecords = _collectAllWorkerRecords(
      profile: profile,
      finishedProvider: finishedProvider,
      orderProvider: orderProvider,
      lang: lang,
    );

    final dailyRecords = _filterByPeriod(allRecords, 0);
    final monthlyRecords = _filterByPeriod(allRecords, 1);

    return Scaffold(
      backgroundColor: isDark ? _DetailColors.slateDark : _DetailColors.lightBg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle:
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleSpacing: 12,
        title: SizedBox(
          height: 46,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double totalWidth = constraints.maxWidth;
              return Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: _isSearchOpen ? 0.0 : 1.0,
                    child: IgnorePointer(
                      ignoring: _isSearchOpen,
                      child: Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? _DetailColors.cardDark
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 19,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              workerFullName.isEmpty
                                  ? getTxt(lang, "ishchi")
                                  : workerFullName,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.4,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),

                  // O'ngdan chapga silliq surilib ochiladigan qidiruv maydoni
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: _isSearchOpen ? totalWidth : 44,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: OverflowBox(
                        alignment: Alignment.centerRight,
                        minWidth: 44,
                        maxWidth: totalWidth,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          width: _isSearchOpen ? totalWidth : 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? _DetailColors.cardDark
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isSearchOpen
                                  ? _DetailColors.primaryBlue
                                  : (isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0)),
                              width: _isSearchOpen ? 1.5 : 1.0,
                            ),
                          ),
                          child: _isSearchOpen
                              ? Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.search_rounded,
                                size: 21,
                                color: _DetailColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  onChanged: (val) =>
                                      setState(() => _searchQuery = val),
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
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                onPressed: _closeSearch,
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 21,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          )
                              : InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _openSearch,
                            child: Center(
                              child: Icon(
                                Icons.search_rounded,
                                size: 22,
                                color: isDark
                                    ? _DetailColors.skyBlue
                                    : _DetailColors.primaryBlue,
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
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(62),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? _DetailColors.cardDark
                        : const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          _DetailColors.skyBlue,
                          _DetailColors.primaryBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: _DetailColors.primaryBlue
                              .withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                    isDark ? Colors.white60 : const Color(0xFF475569),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: [
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(getTxt(lang, "kunlik")),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(getTxt(lang, "oylik")),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(getTxt(lang, "umumiy")),
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
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildPeriodTab(
            records: dailyRecords,
            tabIndex: 0,
            lang: lang,
            isDark: isDark,
            isLoading: finishedProvider.isLoading,
            errorText: finishedProvider.error,
          ),
          _buildPeriodTab(
            records: monthlyRecords,
            tabIndex: 1,
            lang: lang,
            isDark: isDark,
            isLoading: finishedProvider.isLoading,
            errorText: finishedProvider.error,
          ),
          _buildPeriodTab(
            records: allRecords,
            tabIndex: 2,
            lang: lang,
            isDark: isDark,
            isLoading: finishedProvider.isLoading,
            errorText: finishedProvider.error,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTab({
    required List<_WorkerActivityRecord> records,
    required int tabIndex,
    required String lang,
    required bool isDark,
    required bool isLoading,
    String? errorText,
  }) {
    final bool hasProduced =
    records.any((r) => r.type == _ActivityType.produced);
    final bool hasSold = records.any((r) => r.type == _ActivityType.sold);
    final bool hasBothTypes = hasProduced && hasSold;

    final String query = _searchQuery.trim().toLowerCase();

    final List<_WorkerActivityRecord> visibleRecords = records.where((r) {
      if (hasBothTypes) {
        if (_activityFilter == _ActivityFilter.produced &&
            r.type != _ActivityType.produced) {
          return false;
        }
        if (_activityFilter == _ActivityFilter.sold &&
            r.type != _ActivityType.sold) {
          return false;
        }
      }
      if (query.isEmpty) return true;
      final dateStr = _formatDate(r.dateTime).toLowerCase();
      final timeStr = _formatTime(r.dateTime).toLowerCase();
      return r.productName.toLowerCase().contains(query) ||
          dateStr.contains(query) ||
          timeStr.contains(query) ||
          (r.customerName?.toLowerCase().contains(query) ?? false);
    }).toList();

    final int producedQty = records
        .where((r) => r.type == _ActivityType.produced)
        .fold<int>(0, (sum, r) => sum + r.quantity);
    final int producedOps =
        records.where((r) => r.type == _ActivityType.produced).length;

    final int soldQty = records
        .where((r) => r.type == _ActivityType.sold)
        .fold<int>(0, (sum, r) => sum + r.quantity);
    final int soldOps =
        records.where((r) => r.type == _ActivityType.sold).length;

    final List<_DayBucket> dayBuckets = _groupByDayOnly(visibleRecords);

    final String emptyMessage = query.isNotEmpty
        ? getTxt(lang, "qidiruv_topilmadi")
        : tabIndex == 0
        ? getTxt(lang, "malumot_yoq_kunlik")
        : tabIndex == 1
        ? getTxt(lang, "malumot_yoq_oylik")
        : getTxt(lang, "malumot_yoq_umumiy");

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: _DetailColors.primaryBlue,
      backgroundColor: isDark ? _DetailColors.cardDark : Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double contentMaxWidth =
          constraints.maxWidth > 1080 ? 1080 : constraints.maxWidth;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(
                          color: _DetailColors.primaryBlue,
                          minHeight: 3,
                        ),
                      ),

                    if (errorText != null) _buildErrorBanner(errorText),

                    // 1. XODIM PROFIL KARTASI
                    _buildWorkerHeaderCard(lang: lang, isDark: isDark),
                    const SizedBox(height: 14),

                    // 2. KPI STATISTIKA KARTALARI
                    _buildKpiCards(
                      lang: lang,
                      isDark: isDark,
                      producedQty: producedQty,
                      producedOps: producedOps,
                      soldQty: soldQty,
                      soldOps: soldOps,
                      activeDaysCount: dayBuckets.length,
                      lastRecordTime: visibleRecords.isNotEmpty
                          ? visibleRecords.first.dateTime
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // Agar ham ishlab chiqarish, ham sotuv bo'lsa ixcham filtr
                    if (hasBothTypes) ...[
                      _buildTypeFilterCapsule(
                        lang: lang,
                        isDark: isDark,
                        totalOps: records.length,
                        producedOps: producedOps,
                        soldOps: soldOps,
                      ),
                      const SizedBox(height: 14),
                    ],

                    // 3. HAR BIR QO'SHILGAN MAHSULOT ALOHIDA (KUNI VA SOATI BILAN)
                    _buildSectionTitle(
                      icon: Icons.history_rounded,
                      iconColor: _DetailColors.primaryBlue,
                      title: hasBothTypes
                          ? getTxt(lang, "sotuv_tarixi")
                          : getTxt(lang, "batafsil_tarix"),
                      countText:
                      "${visibleRecords.length} ${getTxt(lang, "marta")}",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    if (visibleRecords.isEmpty)
                      _buildEmptyCard(isDark: isDark, message: emptyMessage)
                    else
                      ...dayBuckets.map((bucket) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sana sarlavhasi (har kunning barcha alohida qo'shishlari ostida chiqadi)
                              _buildDayHeader(
                                bucket: bucket,
                                lang: lang,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 10),
                              _buildHistoryGrid(
                                records: bucket.items,
                                lang: lang,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayHeader({
    required _DayBucket bucket,
    required String lang,
    required bool isDark,
  }) {
    final String dona = getTxt(lang, "dona");
    final String marta = getTxt(lang, "marta");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isDark
            ? _DetailColors.primaryBlue.withValues(alpha: 0.14)
            : _DetailColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _DetailColors.primaryBlue.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            size: 18,
            color: _DetailColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _formatRelativeDate(bucket.dayDate, lang),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${bucket.items.length} $marta • ${bucket.totalQuantity} $dona",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? _DetailColors.skyBlue
                  : _DetailColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _DetailColors.rose.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _DetailColors.rose.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: _DetailColors.rose,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              getFriendlyErrorMessage(error),
              style: const TextStyle(
                color: _DetailColors.rose,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerHeaderCard({
    required String lang,
    required bool isDark,
  }) {
    final ishchi = widget.ishchi;
    final String fullName = "${ishchi.familya} ${ishchi.ism}"
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final Color accentColor = ishchi.kasb.trim().toLowerCase() == "shifokor"
        ? _DetailColors.primaryBlue
        : _DetailColors.green;
    final bool hasPhone = ishchi.telefon.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? _DetailColors.cardDark : Colors.white,
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
      child: Row(
        children: [
          _buildWorkerAvatar(ishchi, accentColor, isDark),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isEmpty ? getTxt(lang, "ishchi") : fullName,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (ishchi.kasb.trim().isNotEmpty)
                      _roleChip(
                        _localizeRoleOrKasb(lang, ishchi.kasb),
                        accentColor,
                      ),
                    if (ishchi.lavozim.trim().isNotEmpty &&
                        ishchi.lavozim.trim().toLowerCase() !=
                            ishchi.kasb.trim().toLowerCase())
                      _roleChip(
                        _localizeRoleOrKasb(lang, ishchi.lavozim),
                        _DetailColors.indigo,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _formatPhoneDisplay(
                    ishchi.telefon,
                    getTxt(lang, "tel_yoq"),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? _DetailColors.skyBlue
                        : _DetailColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          if (hasPhone) ...[
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _makePhoneCall(ishchi.telefon);
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _DetailColors.green.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: _DetailColors.green,
                    size: 23,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _roleChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
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
        : (ism.isNotEmpty ? ism[0].toUpperCase() : "?");

    Widget fallback() {
      return Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : accentColor,
          ),
        ),
      );
    }

    Widget content = fallback();
    if (rasm != null && rasm.isNotEmpty) {
      if (rasm.startsWith('http://') || rasm.startsWith('https://')) {
        content = Image.network(
          rasm,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        );
      } else {
        final file = File(rasm);
        if (file.existsSync()) {
          content = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback(),
          );
        }
      }
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? const Color(0xFF0F172A)
            : accentColor.withValues(alpha: 0.12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.5),
          width: 2.2,
        ),
      ),
      child: ClipOval(child: content),
    );
  }

  Widget _buildKpiCards({
    required String lang,
    required bool isDark,
    required int producedQty,
    required int producedOps,
    required int soldQty,
    required int soldOps,
    required int activeDaysCount,
    required DateTime? lastRecordTime,
  }) {
    final bool isSotuvchi =
        widget.ishchi.kasb.trim().toLowerCase() == "sotuvchi" ||
            widget.ishchi.lavozim.trim().toLowerCase() == "sotuvchi";

    final String dona = getTxt(lang, "dona");
    final String ta = getTxt(lang, "ta");
    final String marta = getTxt(lang, "marta");

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: isSotuvchi && producedQty == 0
                ? getTxt(lang, "sotildi")
                : getTxt(lang, "ishlab_chiqardi"),
            icon: isSotuvchi && producedQty == 0
                ? Icons.point_of_sale_rounded
                : Icons.precision_manufacturing_rounded,
            iconColor: isSotuvchi && producedQty == 0
                ? _DetailColors.primaryBlue
                : _DetailColors.green,
            mainValue: isSotuvchi && producedQty == 0
                ? "$soldQty $dona"
                : "$producedQty $dona",
            subLabel1: getTxt(lang, "amallar"),
            subVal1: isSotuvchi && producedQty == 0
                ? "$soldOps $marta"
                : "$producedOps $marta",
            subLabel2: isSotuvchi && producedQty == 0
                ? "${getTxt(lang, "ishlab_chiqardi")}:"
                : "${getTxt(lang, "sotildi")}:",
            subVal2: isSotuvchi && producedQty == 0
                ? "$producedQty $ta"
                : "$soldQty $ta",
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            title: getTxt(lang, "qoshishlar_soni"),
            icon: Icons.event_note_rounded,
            iconColor: _DetailColors.primaryBlue,
            mainValue: "${producedOps + soldOps} $marta",
            subLabel1: getTxt(lang, "oxirgi_vaqt"),
            subVal1: lastRecordTime != null ? _formatTime(lastRecordTime) : "—",
            subLabel2: getTxt(lang, "kunlar"),
            subVal2: "$activeDaysCount $ta",
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
        color: isDark ? _DetailColors.cardDark : Colors.white,
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
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.5,
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
                fontSize: 23,
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
                          fontSize: 12.5,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                          fontSize: 12.5,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
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

  Widget _buildTypeFilterCapsule({
    required String lang,
    required bool isDark,
    required int totalOps,
    required int producedOps,
    required int soldOps,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _filterPill(
              label: "${getTxt(lang, "barchasi")} ($totalOps)",
              selected: _activityFilter == _ActivityFilter.all,
              activeColor: _DetailColors.primaryBlue,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activityFilter = _ActivityFilter.all),
            ),
          ),
          Expanded(
            child: _filterPill(
              label: "${getTxt(lang, "tayyorlandi")} ($producedOps)",
              selected: _activityFilter == _ActivityFilter.produced,
              activeColor: _DetailColors.green,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activityFilter = _ActivityFilter.produced),
            ),
          ),
          Expanded(
            child: _filterPill(
              label: "${getTxt(lang, "sotildi")} ($soldOps)",
              selected: _activityFilter == _ActivityFilter.sold,
              activeColor: _DetailColors.skyBlue,
              isDark: isDark,
              onTap: () =>
                  setState(() => _activityFilter = _ActivityFilter.sold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterPill({
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
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String countText,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            countText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryGrid({
    required List<_WorkerActivityRecord> records,
    required String lang,
    required bool isDark,
  }) {
    final String dona = getTxt(lang, "dona");

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
          children: records.map((record) {
            final bool isProduced = record.type == _ActivityType.produced;
            final Color accent =
            isProduced ? _DetailColors.green : _DetailColors.primaryBlue;
            final String typeLabel = isProduced
                ? getTxt(lang, "tayyorlandi")
                : getTxt(lang, "sotildi");

            return SizedBox(
              width: itemWidth,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? _DetailColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.22)
                          : const Color(0xFF64748B).withValues(alpha: 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: accent.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            _productInitial(record.productName),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.productName,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.13),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  typeLabel,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            "+${record.quantity} $dona",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (record.customerName != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 15,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "${getTxt(lang, "mijoz")} ${record.customerName!}",
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
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 15,
                            color: _DetailColors.primaryBlue,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _formatDate(record.dateTime),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color:
                              _DetailColors.amber.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: _DetailColors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(record.dateTime),
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w900,
                                    color: _DetailColors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyCard({
    required bool isDark,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      decoration: BoxDecoration(
        color: isDark ? _DetailColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: _DetailColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 30,
              color: _DetailColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}