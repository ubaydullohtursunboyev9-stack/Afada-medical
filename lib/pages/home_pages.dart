import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/login/login_page.dart';
import 'package:afada/pages/daromad_pages/ishchilar_ishhaqqi_pages.dart';
import 'package:afada/pages/Drawer/draver_profil_pages.dart';
import 'package:afada/pages/Drawer/draver_buyurtmalar_pages.dart';
import 'package:afada/pages/Drawer/draver_ishchilar_pages.dart';
import 'package:afada/pages/Drawer/draver_klent_pages.dart';
import 'package:afada/pages/daromad_pages/kunlik_daromad_pages.dart';
import 'package:afada/pages/daromad_pages/oylik_daromad_pages.dart';
import 'package:afada/pages/daromad_pages/qarzdorlik_pages.dart';
import 'package:afada/pages/Drawer/draver_mahsulotlar_pages.dart';
import 'package:afada/pages/Drawer/draver_ombor_pages.dart';
import 'package:afada/pages/Drawer/draver_sotuv_bolimi.dart';
import 'package:afada/pages/Drawer/draver_sozlamalar_pages.dart';
import 'package:afada/pages/ishchilar_pages.dart';
import 'package:afada/pages/ombor_pages.dart';
import 'package:afada/pages/mahsulotlar_pages.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/mijoz_provider/mijoz_provider.dart';
import '../model/ishchi_modeli.dart';
import '../model/model_provider.dart';
import '../model/mahsulot_modeli.dart';
import '../model/mijoz_modeli.dart';
import '../model/order_model.dart';
import '../provider/order_provider.dart';
import '../provider/qarz_provider.dart';
import 'package:afada/services/notification_service.dart';
import 'package:afada/services/connectivity_service.dart';

// ============================================================
// GLOBAL TRANSLATIONS HELPER
// ============================================================
class AppTranslations {
  static const Map<String, Map<String, String>> texts = {
    "Uzb": {
      "Afada Medical": "Afada Medical",
      "Kunlik daromad": "Kunlik daromad",
      "Kunlik ish haqqi": "Kunlik ish haqqi",
      "Sotildi:": "Sotildi:",
      "Tayyorlandi:": "Tayyorlandi:",
      "Buyurtmalar:": "Buyurtmalar:",
      "Ishlar:": "Ishlar:",
      "Oylik daromad": "Oylik daromad",
      "Oylik ish haqqi": "Oylik ish haqqi",
      "Ishchilar": "Xodimlar",
      "Ishchilar soni:": "Xodimlar:",
      "Ish haqqi": "Ish haqqi",
      "Qarzdorlik": "Qarzdorlik",
      "Qarzdorlar:": "Qarzdorlar:",
      "Jami qarzdorlik": "Jami qarzdorlik",
      "Kunlik daromad statistikasi": "Kunlik ko'rsatkichlar",
      "Oylik daromad statistikasi": "Oylik tahlil",
      "Haftalik daromad statistikasi": "Haftalik monitoring",
      "Yillik daromad statistikasi": "Yillik hisobot",
      "Yangi buyurtma": "Yangi buyurtma",
      "Buyurtmani tahrirlash": "Buyurtmani tahrirlash",
      "Mahsulot nomi": "Mahsulot nomi",
      "Mahsulotni tanlang": "Mahsulotni tanlang",
      "Bunday mahsulot mavjud emas": "Bunday mahsulot topilmadi",
      "Mijoz turi": "Mijoz turi",
      "Doimiy mijoz": "Doimiy mijoz",
      "Bemor": "Bemor",
      "Mijoz ismi": "Mijoz F.I.SH",
      "Mijoz ismini kiriting": "Ismni kiriting",
      "Bunday doimiy mijoz mavjud emas.": "Bunday mijoz mavjud emas",
      "Telefon (90 123 45 67)": "Telefon (90 123 45 67)",
      "Telefon raqamini kiriting": "Telefon raqamini kiriting",
      "Soni": "Miqdori",
      "Sonini kiriting": "Miqdorini kiriting",
      "Musbat son kiriting": "Musbat son kiriting",
      "Omborda faqat": "Omborda faqat",
      "ta mahsulot mavjud.": "dona qoldi",
      "Sana": "Qabul sanasi",
      "Sanani tanlang": "Sanani tanlang",
      "Izoh (ixtiyoriy)": "Izoh (ixtiyoriy)",
      "To'lov holati": "To'lov holati",
      "To'langan": "To'langan",
      "To'lanmagan": "Nasiya (Qarz)",
      "To'langan summa": "To'langan summa",
      "Bekor qilish": "Bekor qilish",
      "Saqlash": "Saqlash",
      "Yangi buyurtma qo'shildi": "Yangi buyurtma qabul qilindi",
      "UZS": "UZS",
      "ta": "ta",
      "Profil": "Profil",
      "Sotuv bo'limi": "Sotuv bo'limi",
      "Doimiy mijozlar": "Doimiy mijozlar",
      "Ombor": "Tibbiy ombor",
      "Mahsulotlar": "Katalog",
      "Buyurtmalar": "Buyurtmalar",
      "Sozlamalar": "Sozlamalar",
      "Chiqish": "Chiqish",
      "Hisobdan chiqmoqchimisiz?": "Tizimdan chiqmoqchimisiz?",
      "Yo'q": "Yo'q",
      "Ha": "Ha, chiqish",
      "Home": "Asosiy",
      "Mahsulot": "Mahsulot",
      "Jami summa:": "Jami:",
      "Tez orada": "Tez orada",
      "Oylik": "Oylik",
      "Yillik": "Yillik",
      "Admin va sotuvchi uchun": "Faqat shifokor va admin uchun",
      "Foydalanuvchi": "Foydalanuvchi",
      "Menyu": "Menyu",
      "Bildirishnomalar": "Bildirishnomalar",
      "Xatolik yuz berdi": "Xatolik yuz berdi",
    },
    "Rus": {
      "Afada Medical": "Afada Medical",
      "Kunlik daromad": "Дневной доход",
      "Kunlik ish haqqi": "Дневная зарплата",
      "Sotildi:": "Продано:",
      "Tayyorlandi:": "Готово:",
      "Buyurtmalar:": "Заказы:",
      "Ishlar:": "Работы:",
      "Oylik daromad": "Месячный доход",
      "Oylik ish haqqi": "Месячная зарплата",
      "Ishchilar": "Персонал",
      "Ishchilar soni:": "Сотрудники:",
      "Ish haqqi": "Оплата труда",
      "Qarzdorlik": "Задолженность",
      "Qarzdorlar:": "Должники:",
      "Jami qarzdorlik": "Общий долг",
      "Kunlik daromad statistikasi": "Дневные показатели",
      "Oylik daromad statistikasi": "Месячный анализ",
      "Haftalik daromad statistikasi": "Недельный мониторинг",
      "Yillik daromad statistikasi": "Годовой отчет",
      "Yangi buyurtma": "Новый заказ",
      "Buyurtmani tahrirlash": "Редактировать заказ",
      "Mahsulot nomi": "Название товара",
      "Mahsulotni tanlang": "Выберите позицию",
      "Bunday mahsulot mavjud emas": "Позиция не найдена",
      "Mijoz turi": "Тип клиента",
      "Doimiy mijoz": "Постоянный",
      "Bemor": "Пациент",
      "Mijoz ismi": "Ф.И.О. Клиента",
      "Mijoz ismini kiriting": "Введите Ф.И.О.",
      "Bunday doimiy mijoz mavjud emas.": "Клиент не найден",
      "Telefon (90 123 45 67)": "Телефон (90 123 45 67)",
      "Telefon raqamini kiriting": "Введите номер",
      "Soni": "Количество",
      "Sonini kiriting": "Введите количество",
      "Musbat son kiriting": "Введите положительное число",
      "Omborda faqat": "На складе осталось",
      "ta mahsulot mavjud.": "ед.",
      "Sana": "Дата приема",
      "Sanani tanlang": "Выберите дату",
      "Izoh (ixtiyoriy)": "Примечание",
      "To'lov holati": "Статус оплаты",
      "To'langan": "Оплачено",
      "To'lanmagan": "В долг",
      "To'langan summa": "Внесенная сумма",
      "Bekor qilish": "Отмена",
      "Saqlash": "Сохранить",
      "Yangi buyurtma qo'shildi": "Заказ оформлен",
      "UZS": "UZS",
      "ta": "шт",
      "Profil": "Профиль",
      "Sotuv bo'limi": "Отдел продаж",
      "Doimiy mijozlar": "База клиентов",
      "Ombor": "Мед. склад",
      "Mahsulotlar": "Каталог",
      "Buyurtmalar": "Заказы",
      "Sozlamalar": "Настройки",
      "Chiqish": "Выход",
      "Hisobdan chiqmoqchimisiz?": "Выйти из системы?",
      "Yo'q": "Отмена",
      "Ha": "Выйти",
      "Home": "Главная",
      "Mahsulot": "Каталог",
      "Jami summa:": "Итого:",
      "Tez orada": "Скоро",
      "Oylik": "Месяц",
      "Yillik": "Год",
      "Admin va sotuvchi uchun": "Доступно администраторам",
      "Foydalanuvchi": "Пользователь",
      "Menyu": "Меню",
      "Bildirishnomalar": "Уведомления",
      "Xatolik yuz berdi": "Произошла ошибка",
    },
    "Kiril": {
      "Afada Medical": "Afada Medical",
      "Kunlik daromad": "Кунлик даромад",
      "Kunlik ish haqqi": "Кунлик иш ҳақи",
      "Sotildi:": "Сотилди:",
      "Tayyorlandi:": "Тайёрланди:",
      "Buyurtmalar:": "Буюртмалар:",
      "Ishlar:": "Ишлар:",
      "Oylik daromad": "Ойлик даромад",
      "Oylik ish haqqi": "Ойлик иш ҳақи",
      "Ishchilar": "Ходимлар",
      "Ishchilar soni:": "Ходимлар:",
      "Ish haqqi": "Иш ҳақи",
      "Qarzdorlik": "Қарздорлик",
      "Qarzdorlar:": "Қарздорлар:",
      "Jami qarzdorlik": "Жами қарздорлик",
      "Kunlik daromad statistikasi": "Кунлик кўрсаткичлар",
      "Oylik daromad statistikasi": "Ойлик таҳлил",
      "Haftalik daromad statistikasi": "Ҳафталик мониторинг",
      "Yillik daromad statistikasi": "Йиллик ҳисобот",
      "Yangi buyurtma": "Янги буюртма",
      "Buyurtmani tahrirlash": "Буюртмани таҳрирлаш",
      "Mahsulot nomi": "Маҳсулот номи",
      "Mahsulotni tanlang": "Маҳсулотни танланг",
      "Bunday mahsulot mavjud emas": "Маҳсулот топилмади",
      "Mijoz turi": "Мижоз тоифаси",
      "Doimiy mijoz": "Доимий мижоз",
      "Bemor": "Бемор",
      "Mijoz ismi": "Бемор Ф.И.Ш",
      "Mijoz ismini kiriting": "Исмни киритинг",
      "Bunday doimiy mijoz mavjud emas.": "Мижоз топилмади",
      "Telefon (90 123 45 67)": "Телефон (90 123 45 67)",
      "Telefon raqamini kiriting": "Телефон киритинг",
      "Soni": "Миқдори",
      "Sonini kiriting": "Миқдор киритинг",
      "Musbat son kiriting": "Мусбат сон киритинг",
      "Omborda faqat": "Омборда фақат",
      "ta mahsulot mavjud.": "дона қолди",
      "Sana": "Сана",
      "Sanani tanlang": "Санани танланг",
      "Izoh (ixtiyoriy)": "Изоҳ (ихтиёрий)",
      "To'lov holati": "Тўлов ҳолати",
      "To'langan": "Тўланган",
      "To'lanmagan": "Қарздорлик",
      "To'langan summa": "Тўланган сумма",
      "Bekor qilish": "Бекор қилиш",
      "Saqlash": "Сақлаш",
      "Yangi buyurtma qo'shildi": "Янги буюртма қабул қилинди",
      "UZS": "UZS",
      "ta": "та",
      "Profil": "Профиль",
      "Sotuv bo'limi": "Сотув бўлими",
      "Doimiy mijozlar": "Беморлар базаси",
      "Ombor": "Тиббий омбор",
      "Mahsulotlar": "Каталог",
      "Buyurtmalar": "Буюртмалар",
      "Sozlamalar": "Созламалар",
      "Chiqish": "Чиқиш",
      "Hisobdan chiqmoqchimisiz?": "Тизимдан чиқмоқчимисиз?",
      "Yo'q": "Йўқ",
      "Ha": "Ҳа, чиқиш",
      "Home": "Асосий",
      "Mahsulot": "Каталог",
      "Jami summa:": "Жами:",
      "Tez orada": "Тез орада",
      "Oylik": "Ойлик",
      "Yillik": "Йиллик",
      "Admin va sotuvchi uchun": "Фақат шифокор ва админ учун",
      "Foydalanuvchi": "Фойдаланувчи",
      "Menyu": "Меню",
      "Bildirishnomalar": "Билдиришномалар",
      "Xatolik yuz berdi": "Хатолик юз берди",
    },
  };

  static String get(BuildContext context, String key) {
    try {
      final lang = context.read<ProfileProvider>().language;
      return texts[lang]?[key] ?? texts["Uzb"]?[key] ?? key;
    } catch (_) {
      return texts["Uzb"]?[key] ?? key;
    }
  }
}

// ============================================================
// CLINICAL COLORS
// ============================================================
class MedColors {
  static const Color primaryBlue = Color(0xFF0284C7);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF10B981);
  static const Color rose = Color(0xFFF43F5E);
  static const Color slateDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color lightBg = Color(0xFFF1F5F9);
}

// ============================================================
// MAIN SHELL (HOME PAGE)
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageController;
  late final List<Widget> _pages;
  late final AnimationController _entryController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _refreshAllData();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 1.06, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _entryController.forward();

    _pageController = PageController(initialPage: 0);
    _pages = [
      HomePages(onRefresh: _refreshAllData),
      const OmborPages(),
      const IshchilarPages(),
      const MahsulotlarPages(),
    ];
  }

  Future<void> _refreshAllData() async {
    if (!mounted) return;
    if (!context.read<ConnectivityService>().isConnected) return;
    try {
      await Future.wait([
        context.read<OrderProvider>().fetchSalesFromApi(),
        context.read<MahsulotProvider>().loadProducts(),
        context.read<FinishedProductProvider>().fetchFinishedProducts(),
        context.read<IshchiProvider>().fetchIshchilar(),
        context.read<MijozProvider>().loadMijozlar(),
      ]);
    } catch (e) {
      debugPrint("Data refresh error: $e");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    if (index < 0 || index >= _pages.length) return;
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showLogoutDialog(BuildContext pageContext) {
    final isDark = Theme.of(pageContext).brightness == Brightness.dark;
    final profileProvider = pageContext.read<ProfileProvider>();
    final navigator = Navigator.of(pageContext);

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'logout',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (dialogContext, anim1, anim2) => const SizedBox(),
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: AlertDialog(
            backgroundColor: isDark ? MedColors.cardDark : Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
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
                    color: MedColors.rose.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, size: 28, color: MedColors.rose),
                ),
                const SizedBox(height: 16),
                Text(
                  AppTranslations.get(pageContext, "Hisobdan chiqmoqchimisiz?"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          foregroundColor: isDark ? Colors.white70 : const Color(0xFF334155),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                        child: Text(
                          AppTranslations.get(pageContext, "Yo'q"),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await profileProvider.logout();
                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MedColors.rose,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          AppTranslations.get(pageContext, "Ha"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBarButton({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.14)
                    : const Color(0xFFCBD5E1),
                width: 1,
              ),
              boxShadow: isDark
                  ? null
                  : [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Til o'zgarganda AppBar, Drawer va BottomNavigationBar darhol yangilanishi uchun
    context.watch<ProfileProvider>();

    final Color appBarTextColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: isDark ? MedColors.slateDark : MedColors.lightBg,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: appBarTextColor,
        iconTheme: IconThemeData(color: appBarTextColor),
        actionsIconTheme: IconThemeData(color: appBarTextColor),
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        leadingWidth: 66,
        titleSpacing: 6,
        leading: Builder(
          builder: (scaffoldContext) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildAppBarButton(
                  isDark: isDark,
                  icon: Icons.menu_rounded,
                  iconColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  tooltip: AppTranslations.get(context, "Menyu"),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Scaffold.of(scaffoldContext).openDrawer();
                  },
                ),
              ),
            );
          },
        ),
        title: Text(
          AppTranslations.get(context, "Afada Medical"),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            color: appBarTextColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  final count = orderProvider.orders.where((o) => o.status != "Sotildi").length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildAppBarButton(
                        isDark: isDark,
                        icon: Icons.notifications_none_rounded,
                        iconColor: isDark ? Colors.white : MedColors.primaryBlue,
                        tooltip: AppTranslations.get(context, "Bildirishnomalar"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DraverBuyurtmalarPages()),
                          );
                        },
                      ),
                      if (count > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: MedColors.rose,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? MedColors.slateDark : MedColors.lightBg,
                                width: 2,
                              ),
                            ),
                            constraints: const BoxConstraints(minWidth: 19, minHeight: 19),
                            child: Text(
                              count > 9 ? "9+" : count.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              HapticFeedback.selectionClick();
              setState(() => _currentIndex = index);
            },
            children: _pages,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(isDark),
      drawer: _buildPremiumDrawer(context, isDark),
    );
  }

  // ============================================================
  // FROSTED GLASS CAPSULE BOTTOM BAR
  // ============================================================
  Widget _buildBottomNavigation(bool isDark) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final double horizontalPadding = width < 360 ? 6 : width < 430 ? 8 : 12;

              final Color navBg = isDark
                  ? const Color(0xFF1C2541).withValues(alpha: 0.90)
                  : Colors.white.withValues(alpha: 0.95);

              final Color navBorder = isDark
                  ? const Color(0xFF3A506B).withValues(alpha: 0.55)
                  : const Color(0xFFCBD5E1);

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.42)
                          : const Color(0xFF0F172A).withValues(alpha: 0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(38),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6),
                      decoration: BoxDecoration(
                        color: navBg,
                        borderRadius: BorderRadius.circular(38),
                        border: Border.all(color: navBorder, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildNavItem(
                              index: 0,
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home_rounded,
                              labelKey: "Home",
                              isDark: isDark,
                            ),
                          ),
                          Expanded(
                            child: _buildNavItem(
                              index: 1,
                              icon: Icons.assignment_turned_in_outlined,
                              activeIcon: Icons.assignment_turned_in_rounded,
                              labelKey: "Ombor",
                              isDark: isDark,
                            ),
                          ),
                          Expanded(
                            child: _buildNavItem(
                              index: 2,
                              icon: Icons.people_outline_rounded,
                              activeIcon: Icons.people_rounded,
                              labelKey: "Ishchilar",
                              isDark: isDark,
                            ),
                          ),
                          Expanded(
                            child: _buildNavItem(
                              index: 3,
                              icon: Icons.medication_outlined,
                              activeIcon: Icons.medication_rounded,
                              labelKey: "Mahsulot",
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String labelKey,
    required bool isDark,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color activeColor = isDark ? MedColors.skyBlue : MedColors.primaryBlue;
    final Color inactiveColor = isDark ? Colors.white60 : const Color(0xFF475569);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              width: isSelected ? 52 : 44,
              height: isSelected ? 36 : 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: isDark ? 0.20 : 0.13)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: isSelected
                    ? Border.all(color: activeColor.withValues(alpha: isDark ? 0.35 : 0.24))
                    : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey<bool>(isSelected),
                    size: isSelected ? 23 : 21,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                height: 1.05,
              ),
              child: Text(
                AppTranslations.get(context, labelKey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerAvatar(ProfileProvider profile, bool isDark) {
    final String? path = profile.imagePath?.trim();
    Widget fallback = Icon(
      Icons.person_rounded,
      size: 30,
      color: isDark ? Colors.white70 : const Color(0xFF475569),
    );

    Widget imageWidget = fallback;
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        imageWidget = Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          imageWidget = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback,
          );
        }
      }
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: (isDark ? MedColors.skyBlue : MedColors.primaryBlue).withValues(alpha: 0.65),
          width: 2,
        ),
        color: isDark ? const Color(0xFF3A506B) : const Color(0xFFE2E8F0),
      ),
      child: ClipOval(child: imageWidget),
    );
  }

  Widget _buildPremiumDrawer(BuildContext context, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? MedColors.cardDark : Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          final isWorker = profile.role.trim().toLowerCase() == "ishchi";
          final fullName = "${profile.displayName} ${profile.displaySurname}".trim();

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
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
                      children: [
                        _buildDrawerAvatar(profile, isDark),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName.isEmpty
                                    ? AppTranslations.get(context, "Foydalanuvchi")
                                    : fullName,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                decoration: BoxDecoration(
                                  color: (isDark ? MedColors.skyBlue : MedColors.primaryBlue)
                                      .withValues(alpha: isDark ? 0.18 : 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  profile.role.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? MedColors.skyBlue : MedColors.primaryBlue,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: isDark
                      ? const Color(0xFF3A506B).withValues(alpha: 0.45)
                      : const Color(0xFFE2E8F0),
                  height: 1,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    children: [
                      _drawerTile(Icons.account_circle_outlined, "Profil", const DraverProfilPages(), isDark),
                      if (isWorker)
                        _buildDrawerLockedItem(
                          context,
                          icon: Icons.point_of_sale_rounded,
                          title: AppTranslations.get(context, "Sotuv bo'limi"),
                          message: AppTranslations.get(context, "Admin va sotuvchi uchun"),
                        )
                      else
                        _drawerTile(Icons.point_of_sale_rounded, "Sotuv bo'limi", const DraverSotuvBolimi(), isDark),
                      _drawerTile(Icons.badge_outlined, "Doimiy mijozlar", DraverKlentPages(), isDark),
                      _drawerTile(Icons.all_inbox_rounded, "Ombor", const DraverOmborPages(), isDark),
                      _drawerTile(Icons.inventory_2_outlined, "Mahsulotlar", const DraverMahsulotlarPages(), isDark),
                      _drawerTile(Icons.people_alt_outlined, "Ishchilar", DraverIshchilarPages(), isDark),
                      _drawerTile(Icons.shopping_bag_outlined, "Buyurtmalar", const DraverBuyurtmalarPages(), isDark),
                      _drawerTile(Icons.tune_rounded, "Sozlamalar", const DraverSozlamalarPages(), isDark),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
                  child: Material(
                    color: MedColors.rose.withValues(alpha: isDark ? 0.14 : 0.09),
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _showLogoutDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: MedColors.rose.withValues(alpha: isDark ? 0.30 : 0.24),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded, color: MedColors.rose, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              AppTranslations.get(context, "Chiqish"),
                              style: const TextStyle(
                                color: MedColors.rose,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawerTile(IconData icon, String titleKey, Widget page, bool isDark) {
    final Color accent = isDark ? MedColors.skyBlue : MedColors.primaryBlue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        hoverColor: accent.withValues(alpha: 0.08),
        leading: Container(
          padding: const EdgeInsets.all(8.5),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.14 : 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: accent),
        ),
        title: Text(
          AppTranslations.get(context, titleKey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: isDark ? Colors.white24 : const Color(0xFF94A3B8),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }

  Widget _buildDrawerLockedItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
      }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(8.5),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white38 : const Color(0xFF64748B),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_rounded,
            size: 14,
            color: isDark ? Colors.white38 : const Color(0xFF64748B),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                backgroundColor: const Color(0xFF0F172A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            );
        },
      ),
    );
  }
}

// ============================================================
// DASHBOARD HOMEPAGES BODY (RESPONSIVE + LIGHT/DARK BALANCED)
// ============================================================
class HomePages extends StatelessWidget {
  final RefreshCallback? onRefresh;
  HomePages({super.key, this.onRefresh});

  final TextEditingController sanaController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##');

  String _formatMoney(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
    );
  }

  void _showComingSoonSnackBar(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                AppTranslations.get(context, "Tez orada"),
                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0F172A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ishchiProvider = context.watch<IshchiProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      // QARZDORLIK KARTASIDEK TO'LIQ BLUR + QULF FLOATING BUTTON
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 102),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.45)
                    : const Color(0xFF0F172A).withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                    ),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 5.5),
                    child: Material(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.58)
                          : const Color(0xFF0F172A).withValues(alpha: 0.46),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => _showComingSoonSnackBar(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.20),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        color: MedColors.primaryBlue,
        backgroundColor: isDark ? MedColors.cardDark : Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.only(bottom: 112),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                children: [
                  _buildDateHeader(context, isDark),
                  Consumer5<OrderProvider, ProfileProvider, MahsulotProvider, QarzProvider, FinishedProductProvider>(
                    builder: (
                        context,
                        orderProvider,
                        profileProvider,
                        mahsulotProvider,
                        qarzProvider,
                        finishedProductProvider,
                        child,
                        ) {
                      final now = DateTime.now();
                      final bool isAdmin = profileProvider.role.trim().toLowerCase() == "admin";
                      final bool isWorker = profileProvider.role.trim().toLowerCase() == "ishchi";
                      final String currentUserName =
                      "${profileProvider.displayName} ${profileProvider.displaySurname}".trim().toLowerCase();
                      final String unitTa = AppTranslations.get(context, "ta");
                      final String unitUzs = AppTranslations.get(context, "UZS");

                      bool isMySale(OrderModel order) {
                        if (isAdmin) return true;
                        final createdBy = order.createdBy;
                        if (createdBy == null) return false;
                        final createdByName =
                        (createdBy["fullName"] ?? createdBy["full_name"] ?? "").toString().trim().toLowerCase();
                        return createdByName == currentUserName;
                      }

                      final myFinishedProducts = isAdmin
                          ? finishedProductProvider.finishedProducts
                          : finishedProductProvider.finishedProducts.where((item) {
                        return (item.createdByName ?? "").trim().toLowerCase() == currentUserName;
                      }).toList();

                      final int myFinishedProductCount =
                      myFinishedProducts.fold(0, (sum, item) => sum + item.quantity);

                      final todayOrders = orderProvider.orders.where((o) {
                        final localDate = o.date.toLocal();
                        return isMySale(o) &&
                            (o.status == "Sotildi" || o.paymentStatus == "To'langan") &&
                            localDate.year == now.year &&
                            localDate.month == now.month &&
                            localDate.day == now.day;
                      }).toList();

                      double todayRevenue = 0;
                      if (isWorker) {
                        todayRevenue = finishedProductProvider.finishedProducts.where((item) {
                          final createdAt = item.createdAt?.toLocal();
                          if (createdAt == null) return false;
                          return (item.createdByName ?? "").trim().toLowerCase() == currentUserName &&
                              createdAt.year == now.year &&
                              createdAt.month == now.month &&
                              createdAt.day == now.day;
                        }).fold<double>(0, (sum, item) => sum + item.quantity);
                      } else {
                        todayRevenue = todayOrders.fold(
                          0.0,
                              (sum, o) => sum + (o.status == "Sotildi" ? (o.price * o.quantity) : o.amountPaid),
                        );
                      }

                      final int todayProductsCount = todayOrders.fold(0, (sum, o) => sum + o.quantity);
                      final int todayTasksCount = todayOrders.length;

                      final monthlyOrders = orderProvider.orders.where((o) {
                        final localDate = o.date.toLocal();
                        return isMySale(o) &&
                            (o.status == "Sotildi" || o.paymentStatus == "To'langan") &&
                            localDate.year == now.year &&
                            localDate.month == now.month;
                      }).toList();

                      double monthlyRevenue = 0;
                      if (isWorker) {
                        monthlyRevenue = finishedProductProvider.finishedProducts.where((item) {
                          final createdAt = item.createdAt?.toLocal();
                          if (createdAt == null) return false;
                          return (item.createdByName ?? "").trim().toLowerCase() == currentUserName &&
                              createdAt.year == now.year &&
                              createdAt.month == now.month;
                        }).fold<double>(0, (sum, item) => sum + item.quantity);
                      } else {
                        monthlyRevenue = monthlyOrders.fold(
                          0.0,
                              (sum, o) => sum + (o.status == "Sotildi" ? (o.price * o.quantity) : o.amountPaid),
                        );
                      }

                      final int monthlyProductsCount = monthlyOrders.fold(0, (sum, o) => sum + o.quantity);
                      final int monthlyTasksCount = monthlyOrders.length;

                      final int workersCount = ishchiProvider.ishchilar.isNotEmpty
                          ? ishchiProvider.ishchilar.length
                          : IshchiDatabase.ishchilar.length;

                      final Widget dailyCard = _buildStatCard(
                        context,
                        titleKey: "Kunlik daromad",
                        icon: Icons.insights_rounded,
                        iconColor: MedColors.green,
                        mainValue: isWorker
                            ? "${todayRevenue.toInt()} $unitTa"
                            : "${_formatMoney(todayRevenue)} $unitUzs",
                        subLabel1: isWorker ? "Tayyorlandi:" : "Sotildi:",
                        subVal1: isWorker ? "${todayRevenue.toInt()}" : "$todayProductsCount",
                        subLabel2: "Buyurtmalar:",
                        subVal2: "$todayTasksCount",
                        page: KunlikDaromadPages(),
                        isDark: isDark,
                      );

                      final Widget workersCard = _buildStatCard(
                        context,
                        titleKey: "Ishchilar",
                        icon: Icons.badge_outlined,
                        iconColor: MedColors.primaryBlue,
                        mainValue: "$myFinishedProductCount $unitTa",
                        subLabel1: "Ishchilar soni:",
                        subVal1: "$workersCount",
                        subLabel2: "Tayyorlandi:",
                        subVal2: "$myFinishedProductCount",
                        page: IshchilarIshhaqqiPages(),
                        isDark: isDark,
                      );

                      final Widget monthlyCard = _buildStatCard(
                        context,
                        titleKey: "Oylik daromad",
                        icon: Icons.show_chart_rounded,
                        iconColor: MedColors.skyBlue,
                        mainValue: isWorker
                            ? "${monthlyRevenue.toInt()} $unitTa"
                            : "${_formatMoney(monthlyRevenue)} $unitUzs",
                        subLabel1: isWorker ? "Tayyorlandi:" : "Sotildi:",
                        subVal1: isWorker ? "${monthlyRevenue.toInt()}" : "$monthlyProductsCount",
                        subLabel2: "Buyurtmalar:",
                        subVal2: "$monthlyTasksCount",
                        page: OylikDaromadPages(),
                        isDark: isDark,
                      );

                      final Widget debtCard = _buildLockedOverlay(
                        context,
                        borderRadius: 24,
                        child: _buildStatCard(
                          context,
                          titleKey: "Qarzdorlik",
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: MedColors.rose,
                          mainValue: "${_formatMoney(qarzProvider.jamiQarz)} $unitUzs",
                          subLabel1: "Qarzdorlar:",
                          subVal1: "${qarzProvider.qarzdorlarSoni}",
                          subLabel2: "Jami qarzdorlik",
                          subVal2: "",
                          isDebt: true,
                          page: const QarzdorlikPages(),
                          isDark: isDark,
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final bool isWide = constraints.maxWidth >= 720;

                            return Column(
                              children: [
                                if (isWide)
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: dailyCard),
                                        const SizedBox(width: 12),
                                        Expanded(child: workersCard),
                                        const SizedBox(width: 12),
                                        Expanded(child: monthlyCard),
                                        const SizedBox(width: 12),
                                        Expanded(child: debtCard),
                                      ],
                                    ),
                                  )
                                else ...[
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: dailyCard),
                                        const SizedBox(width: 10),
                                        Expanded(child: workersCard),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(child: monthlyCard),
                                        const SizedBox(width: 10),
                                        Expanded(child: debtCard),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                // WEEKLY WAVE CHART
                                _buildWeeklyRevenueChart(
                                  context,
                                  orderProvider,
                                  profileProvider,
                                  mahsulotProvider,
                                  finishedProductProvider,
                                  isDark,
                                ),
                                const SizedBox(height: 16),
                                // MONTHLY / YEARLY WAVE CHARTS
                                _buildChartTabBarSection(
                                  context,
                                  orderProvider,
                                  profileProvider,
                                  mahsulotProvider,
                                  finishedProductProvider,
                                  isDark,
                                ),
                              ],
                            );
                          },
                        ),
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

  Widget _buildDateHeader(BuildContext context, bool isDark) {
    final now = DateTime.now();
    final lang = context.watch<ProfileProvider>().language;
    const monthsMap = {
      "Uzb": [
        "Yanvar", "Fevral", "Mart", "Aprel", "May", "Iyun",
        "Iyul", "Avgust", "Sentabr", "Oktabr", "Noyabr", "Dekabr"
      ],
      "Rus": [
        "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
        "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"
      ],
      "Kiril": [
        "Январ", "Феврал", "Март", "Апрел", "Май", "Июн",
        "Июл", "Август", "Сентябр", "Октябр", "Ноябр", "Декабр"
      ],
    };
    final months = monthsMap[lang] ?? monthsMap["Uzb"]!;
    final formattedDate = "${now.day} ${months[now.month - 1]}, ${now.year}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? MedColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.24)
                  : const Color(0xFF0F172A).withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: MedColors.primaryBlue.withValues(alpha: isDark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                size: 19,
                color: isDark ? MedColors.skyBlue : MedColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                formattedDate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STAT KARTA
  // ============================================================
  Widget _buildStatCard(
      BuildContext context, {
        required String titleKey,
        required IconData icon,
        required Color iconColor,
        required String mainValue,
        required String subLabel1,
        required String subVal1,
        required String subLabel2,
        required String subVal2,
        required Widget page,
        required bool isDark,
        bool isDebt = false,
      }) {
    return Material(
      color: isDark ? MedColors.cardDark : Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: isDark ? 0.16 : 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppTranslations.get(context, titleKey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
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
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: isDebt
                            ? MedColors.rose
                            : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            AppTranslations.get(context, subLabel1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subVal1,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    if (subLabel2.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppTranslations.get(context, subLabel2),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          if (subVal2.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            Text(
                              subVal2,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WEEKLY WAVE CHART
  Widget _buildWeeklyRevenueChart(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      bool isDark,
      ) {
    final now = DateTime.now();
    final bool isAdmin = profileProvider.role.trim().toLowerCase() == "admin";
    final bool isWorker = !isAdmin && profileProvider.role.trim().toLowerCase() == "ishchi";
    final String currentUserName =
    "${profileProvider.displayName} ${profileProvider.displaySurname}".trim().toLowerCase();

    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    final data = List.generate(7, (i) {
      final date = DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day)
          .add(Duration(days: i));

      if (isWorker) {
        return finishedProductProvider.finishedProducts.where((item) {
          final createdAt = item.createdAt?.toLocal();
          if (createdAt == null) return false;
          return (item.createdByName ?? "").trim().toLowerCase() == currentUserName &&
              createdAt.year == date.year &&
              createdAt.month == date.month &&
              createdAt.day == date.day;
        }).fold<double>(0, (sum, item) => sum + item.quantity);
      }

      return orderProvider.orders.where((o) {
        final localDate = o.date.toLocal();
        if (localDate.year != date.year ||
            localDate.month != date.month ||
            localDate.day != date.day) {
          return false;
        }
        if (o.paymentStatus != "To'langan" && o.status != "Sotildi") return false;
        if (isAdmin) return true;
        final createdBy = o.createdBy;
        if (createdBy == null) return false;
        return (createdBy["fullName"] ?? createdBy["full_name"] ?? "")
            .toString()
            .trim()
            .toLowerCase() ==
            currentUserName;
      }).fold<double>(
        0,
            (sum, o) => sum + (o.status == "Sotildi" ? (o.price * o.quantity) : o.amountPaid),
      );
    });

    const weekdayMap = {
      "Uzb": ['Du', 'Se', 'Cho', 'Pa', 'Ju', 'Sha', 'Yak'],
      "Rus": ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
      "Kiril": ['Ду', 'Се', 'Чо', 'Па', 'Жу', 'Ша', 'Як'],
    };
    final labels = weekdayMap[profileProvider.language] ?? weekdayMap["Uzb"]!;

    return _buildChartCard(
      context,
      title: AppTranslations.get(context, "Haftalik daromad statistikasi"),
      chart: _buildSmoothWaveChart(
        context,
        data,
        labels,
        isDark ? MedColors.skyBlue : MedColors.primaryBlue,
        isDark,
        unit: isWorker
            ? AppTranslations.get(context, "ta")
            : AppTranslations.get(context, "UZS"),
      ),
      isDark: isDark,
    );
  }

  // TABBAR SECTION (OVAL)
  Widget _buildChartTabBarSection(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      bool isDark,
      ) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? MedColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
              boxShadow: isDark
                  ? null
                  : [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: MedColors.primaryBlue,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: MedColors.primaryBlue.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.white60 : const Color(0xFF475569),
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              tabs: [
                Tab(text: AppTranslations.get(context, "Oylik")),
                Tab(text: AppTranslations.get(context, "Yillik")),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 316,
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildMonthlyRevenueChart(
                  context,
                  orderProvider,
                  profileProvider,
                  mahsulotProvider,
                  finishedProductProvider,
                  isDark,
                ),
                _buildYearlyRevenueChart(
                  context,
                  orderProvider,
                  profileProvider,
                  mahsulotProvider,
                  finishedProductProvider,
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueChart(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      bool isDark,
      ) {
    final now = DateTime.now();
    final bool isAdmin = profileProvider.role.trim().toLowerCase() == "admin";
    final bool isWorker = profileProvider.role.trim().toLowerCase() == "ishchi";
    final String currentUserName =
    "${profileProvider.displayName} ${profileProvider.displaySurname}".trim().toLowerCase();

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final data = List.generate(daysInMonth, (i) {
      final date = DateTime(now.year, now.month, i + 1);

      if (isWorker) {
        return finishedProductProvider.finishedProducts.where((item) {
          final createdAt = item.createdAt?.toLocal();
          if (createdAt == null) return false;
          return (item.createdByName ?? "").trim().toLowerCase() == currentUserName &&
              createdAt.year == date.year &&
              createdAt.month == date.month &&
              createdAt.day == date.day;
        }).fold<double>(0, (sum, item) => sum + item.quantity);
      }

      return orderProvider.orders.where((o) {
        final localDate = o.date.toLocal();
        if (localDate.year != date.year ||
            localDate.month != date.month ||
            localDate.day != date.day) {
          return false;
        }
        if (o.paymentStatus != "To'langan" && o.status != "Sotildi") return false;
        if (isAdmin) return true;
        final createdBy = o.createdBy;
        if (createdBy == null) return false;
        return (createdBy["fullName"] ?? createdBy["full_name"] ?? "")
            .toString()
            .trim()
            .toLowerCase() ==
            currentUserName;
      }).fold<double>(
        0,
            (sum, o) => sum + (o.status == "Sotildi" ? (o.price * o.quantity) : o.amountPaid),
      );
    });

    final labels = List.generate(daysInMonth, (i) => (i + 1).toString());

    return _buildChartCard(
      context,
      title: AppTranslations.get(context, "Oylik daromad statistikasi"),
      chart: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: daysInMonth * 40.0,
          child: _buildSmoothWaveChart(
            context,
            data,
            labels,
            MedColors.green,
            isDark,
            unit: isWorker
                ? AppTranslations.get(context, "ta")
                : AppTranslations.get(context, "UZS"),
          ),
        ),
      ),
      isDark: isDark,
    );
  }

  Widget _buildYearlyRevenueChart(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      bool isDark,
      ) {
    final now = DateTime.now();
    final bool isAdmin = profileProvider.role.trim().toLowerCase() == "admin";
    final bool isWorker = profileProvider.role.trim().toLowerCase() == "ishchi";
    final String currentUserName =
    "${profileProvider.displayName} ${profileProvider.displaySurname}".trim().toLowerCase();

    final data = List.generate(12, (index) {
      final targetMonth = index + 1;

      if (isWorker) {
        return finishedProductProvider.finishedProducts.where((item) {
          final createdAt = item.createdAt?.toLocal();
          if (createdAt == null) return false;
          return (item.createdByName ?? "").trim().toLowerCase() == currentUserName &&
              createdAt.year == now.year &&
              createdAt.month == targetMonth;
        }).fold<double>(0, (sum, item) => sum + item.quantity);
      }

      return orderProvider.orders.where((o) {
        final localDate = o.date.toLocal();
        if (localDate.year != now.year || localDate.month != targetMonth) return false;
        if (o.paymentStatus != "To'langan" && o.status != "Sotildi") return false;
        if (isAdmin) return true;
        final createdBy = o.createdBy;
        if (createdBy == null) return false;
        return (createdBy["fullName"] ?? createdBy["full_name"] ?? "")
            .toString()
            .trim()
            .toLowerCase() ==
            currentUserName;
      }).fold<double>(
        0,
            (sum, o) => sum + (o.status == "Sotildi" ? (o.price * o.quantity) : o.amountPaid),
      );
    });

    const shortMonthsMap = {
      "Uzb": ["Yan", "Fev", "Mar", "Apr", "May", "Iyn", "Iyl", "Avg", "Sen", "Okt", "Noy", "Dek"],
      "Rus": ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"],
      "Kiril": ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"],
    };
    final labels = shortMonthsMap[profileProvider.language] ?? shortMonthsMap["Uzb"]!;

    return _buildChartCard(
      context,
      title: AppTranslations.get(context, "Yillik daromad statistikasi"),
      chart: _buildSmoothWaveChart(
        context,
        data,
        labels,
        isDark ? MedColors.skyBlue : MedColors.primaryBlue,
        isDark,
        unit: isWorker
            ? AppTranslations.get(context, "ta")
            : AppTranslations.get(context, "UZS"),
      ),
      isDark: isDark,
    );
  }

  Widget _buildChartCard(
      BuildContext context, {
        required String title,
        required Widget chart,
        required bool isDark,
      }) {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? MedColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Icon(
                Icons.auto_graph_rounded,
                size: 20,
                color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: chart),
        ],
      ),
    );
  }

  // ============================================================
  // SMOOTH WAVE LINE CHART
  // ============================================================
  Widget _buildSmoothWaveChart(
      BuildContext context,
      List<double> data,
      List<String> labels,
      Color baseColor,
      bool isDark, {
        String unit = "UZS",
      }) {
    double maxVal = data.fold(0.0, (prev, element) => element > prev ? element : prev);
    if (maxVal <= 0) maxVal = 1000;

    String formatY(double val) {
      if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}M';
      if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}k';
      return val.toStringAsFixed(0);
    }

    final spots = List.generate(
      data.length,
          (i) => FlSpot(i.toDouble(), data[i]),
    );

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxVal * 1.25,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF0F172A),
            tooltipRoundedRadius: 12,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            tooltipMargin: 10,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  "${_formatMoney(spot.y)} $unit",
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          horizontalInterval: maxVal / 3,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
            strokeWidth: 1.0,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxVal / 3,
              getTitlesWidget: (value, meta) {
                if (value < 0) return const SizedBox();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    formatY(value),
                    style: TextStyle(
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx >= 0 && idx < labels.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 6,
                    child: Text(
                      labels[idx],
                      style: TextStyle(
                        color: isDark ? Colors.white60 : const Color(0xFF475569),
                        fontWeight: FontWeight.w700,
                        fontSize: labels.length > 7 ? 10 : 11.5,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.35,
            preventCurveOverShooting: true,
            spots: spots,
            color: baseColor,
            barWidth: 3.2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4.5,
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  strokeWidth: 2.5,
                  strokeColor: baseColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  baseColor.withValues(alpha: isDark ? 0.34 : 0.22),
                  baseColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedOverlay(
      BuildContext context, {
        required Widget child,
        double borderRadius = 26,
        double fontSize = 11.5,
      }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
              child: Material(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.62)
                    : const Color(0xFF0F172A).withValues(alpha: 0.48),
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: () => _showComingSoonSnackBar(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.28),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.lock_rounded, color: Colors.white, size: 19),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppTranslations.get(context, "Tez orada"),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: fontSize,
                              letterSpacing: 0.3,
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
      ],
    );
  }

  // ============================================================
  // DIALOG
  // ============================================================
  void showBuyurtmaDialog(BuildContext context, {OrderModel? order}) {
    final mahsulotProvider = context.read<MahsulotProvider>();
    final mijozProvider = context.read<MijozProvider>();

    final customerController = TextEditingController(text: order?.customerName ?? "");
    final phoneController = TextEditingController(text: order?.phone ?? "");
    final quantityController = TextEditingController(text: order?.quantity.toString() ?? "");
    final commentController = TextEditingController(text: order?.comment ?? "");
    final servicePriceController = TextEditingController(text: order?.servicePrice.toString() ?? "0");
    final amountPaidController = TextEditingController(text: order?.amountPaid.toString() ?? "0");

    String paymentStatus = order?.paymentStatus ?? "To'lanmagan";
    final TextEditingController localSanaController = TextEditingController(
      text: order != null ? "${order.date.day}.${order.date.month}.${order.date.year}" : "",
    );

    String mijozTuri = (order != null &&
        mijozProvider.mijozlar.any((m) => "${m.ism} ${m.familya}" == order.customerName))
        ? "Doimiy mijoz"
        : "Bemor";

    final formKey = GlobalKey<FormState>();
    TextEditingController? productController;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final Color inputTextColor = isDark ? Colors.white : const Color(0xFF0F172A);

        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              backgroundColor: isDark ? MedColors.cardDark : Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
                side: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              title: Center(
                child: Text(
                  order == null
                      ? AppTranslations.get(dialogContext, "Yangi buyurtma")
                      : AppTranslations.get(dialogContext, "Buyurtmani tahrirlash"),
                  style: TextStyle(
                    color: inputTextColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Autocomplete<MahsulotModel>(
                        initialValue: TextEditingValue(text: order?.productName ?? ""),
                        displayStringForOption: (m) => m.nomi,
                        optionsBuilder: (textValue) {
                          final options = mahsulotProvider.mahsulotlar.where((m) => m.zaxira > 0);
                          if (textValue.text.isEmpty) return options;
                          return options.where(
                                (m) => m.nomi.toLowerCase().contains(textValue.text.toLowerCase()),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 6.0,
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final MahsulotModel option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(
                                        option.nomi,
                                        style: TextStyle(color: inputTextColor),
                                      ),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          productController = controller;
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(color: inputTextColor),
                            decoration: _inputDecoration(
                              AppTranslations.get(context, "Mahsulot nomi"),
                              isDark,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppTranslations.get(context, "Mahsulotni tanlang");
                              }
                              if (!mahsulotProvider.mahsulotlar
                                  .any((m) => m.nomi.toLowerCase() == value.toLowerCase())) {
                                return AppTranslations.get(context, "Bunday mahsulot mavjud emas");
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: mijozTuri,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "Mijoz turi"),
                          isDark,
                        ),
                        items: ["Doimiy mijoz", "Bemor"]
                            .map(
                              (s) => DropdownMenuItem(
                            value: s,
                            child: Text(AppTranslations.get(dialogContext, s)),
                          ),
                        )
                            .toList(),
                        onChanged: (val) => setState(() => mijozTuri = val!),
                      ),
                      const SizedBox(height: 10),
                      mijozTuri == "Doimiy mijoz"
                          ? Autocomplete<MijozModel>(
                        initialValue: TextEditingValue(text: customerController.text),
                        displayStringForOption: (m) => "${m.ism} ${m.familya}",
                        optionsBuilder: (textValue) {
                          if (textValue.text.isEmpty) {
                            return const Iterable<MijozModel>.empty();
                          }
                          return mijozProvider.mijozlar.where(
                                (m) => "${m.ism} ${m.familya}"
                                .toLowerCase()
                                .contains(textValue.text.toLowerCase()),
                          );
                        },
                        onSelected: (MijozModel selection) {
                          customerController.text = "${selection.ism} ${selection.familya}";
                          phoneController.text = selection.telefon;
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(color: inputTextColor),
                            decoration: _inputDecoration(
                              AppTranslations.get(context, "Mijoz ismi"),
                              isDark,
                            ),
                            onChanged: (val) => customerController.text = val,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppTranslations.get(context, "Mijoz ismini kiriting");
                              }
                              if (!mijozProvider.mijozlar.any(
                                    (m) =>
                                "${m.ism} ${m.familya}".toLowerCase() ==
                                    value.toLowerCase(),
                              )) {
                                return AppTranslations.get(
                                  context,
                                  "Bunday doimiy mijoz mavjud emas.",
                                );
                              }
                              return null;
                            },
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 6.0,
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final MijozModel option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(
                                        "${option.ism} ${option.familya}",
                                        style: TextStyle(color: inputTextColor),
                                      ),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      )
                          : TextFormField(
                        controller: customerController,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "Mijoz ismi"),
                          isDark,
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? AppTranslations.get(dialogContext, "Mijoz ismini kiriting")
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "Telefon (90 123 45 67)"),
                          isDark,
                        ),
                        inputFormatters: [maskFormatter],
                        keyboardType: TextInputType.phone,
                        validator: (value) => (value == null || value.isEmpty)
                            ? AppTranslations.get(dialogContext, "Telefon raqamini kiriting")
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: quantityController,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "Soni"),
                          isDark,
                        ),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppTranslations.get(dialogContext, "Sonini kiriting");
                          }
                          final count = int.tryParse(value);
                          if (count == null || count <= 0) {
                            return AppTranslations.get(dialogContext, "Musbat son kiriting");
                          }

                          final selectedProduct = productController?.text;
                          if (selectedProduct != null && selectedProduct.isNotEmpty) {
                            final product = mahsulotProvider.mahsulotlar.firstWhere(
                                  (m) => m.nomi.toLowerCase() == selectedProduct.toLowerCase(),
                              orElse: () => MahsulotModel(
                                nomi: "",
                                bemorNarxi: "0",
                                shifokorNarxi: "0",
                                kategoriya: "Umumiy",
                                keshbek: "0",
                                status: "Faol",
                                zaxira: -1,
                              ),
                            );

                            if (product.zaxira != -1 && count > product.zaxira) {
                              return "${AppTranslations.get(dialogContext, "Omborda faqat")} ${product.zaxira} ${AppTranslations.get(dialogContext, "ta mahsulot mavjud.")}";
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: localSanaController,
                        readOnly: true,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "Sana"),
                          isDark,
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: order?.date ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (pickerContext, child) {
                              return Theme(
                                data: isDark
                                    ? ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: MedColors.skyBlue,
                                    surface: MedColors.cardDark,
                                  ),
                                )
                                    : ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: MedColors.primaryBlue,
                                    surface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            localSanaController.text = "${picked.day}.${picked.month}.${picked.year}";
                          }
                        },
                        validator: (value) => (value == null || value.isEmpty)
                            ? AppTranslations.get(dialogContext, "Sanani tanlang")
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: commentController,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "Izoh (ixtiyoriy)"),
                          isDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: paymentStatus,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: TextStyle(color: inputTextColor),
                        decoration: _inputDecoration(
                          AppTranslations.get(dialogContext, "To'lov holati"),
                          isDark,
                        ),
                        items: ["To'langan", "To'lanmagan"]
                            .map(
                              (s) => DropdownMenuItem(
                            value: s,
                            child: Text(AppTranslations.get(dialogContext, s)),
                          ),
                        )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            paymentStatus = val!;
                            if (paymentStatus == "To'lanmagan") {
                              amountPaidController.text = "0";
                            }
                          });
                        },
                      ),
                      if (paymentStatus == "To'langan") ...[
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: amountPaidController,
                          style: TextStyle(color: inputTextColor),
                          decoration: _inputDecoration(
                            AppTranslations.get(dialogContext, "To'langan summa"),
                            isDark,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          foregroundColor: isDark ? Colors.white70 : const Color(0xFF334155),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(AppTranslations.get(dialogContext, "Bekor qilish")),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MedColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final orderProvider = dialogContext.read<OrderProvider>();
                            final productName = productController?.text ?? "";
                            final quantity = int.tryParse(quantityController.text) ?? 0;
                            final servicePrice = double.tryParse(servicePriceController.text) ?? 0.0;
                            final amountPaid = paymentStatus == "To'langan"
                                ? (double.tryParse(amountPaidController.text) ?? 0.0)
                                : 0.0;

                            final product = mahsulotProvider.mahsulotlar.firstWhere(
                                  (m) => m.nomi.toLowerCase() == productName.toLowerCase(),
                              orElse: () => MahsulotModel(
                                nomi: "",
                                bemorNarxi: "0",
                                shifokorNarxi: "0",
                                kategoriya: "Umumiy",
                                keshbek: "0",
                                status: "Faol",
                              ),
                            );

                            final price =
                                double.tryParse(product.bemorNarxi.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                            final finalServicePrice = order == null
                                ? (double.tryParse(product.shifokorNarxi.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0)
                                : servicePrice;

                            DateTime orderDate = order?.date ?? DateTime.now();
                            if (localSanaController.text.isNotEmpty) {
                              try {
                                final parts = localSanaController.text.split('.');
                                if (parts.length == 3) {
                                  orderDate = DateTime(
                                    int.parse(parts[2]),
                                    int.parse(parts[1]),
                                    int.parse(parts[0]),
                                  );
                                }
                              } catch (_) {}
                            }

                            final updatedOrder = OrderModel(
                              id: order?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                              productName: productName,
                              quantity: quantity,
                              price: price,
                              date: orderDate,
                              customerName: customerController.text,
                              phone: phoneController.text,
                              comment: commentController.text,
                              referrer: order?.referrer ?? "",
                              status: order?.status ?? "Tayyorlash",
                              paymentStatus: paymentStatus,
                              amountPaid: amountPaid,
                              servicePrice: finalServicePrice,
                            );

                            if (order == null) {
                              orderProvider.addOrder(updatedOrder);
                              mahsulotProvider.zaxiraYangilash(
                                productName,
                                -quantity,
                                ishchi: customerController.text,
                              );
                              NotificationService.showNotification(
                                dialogContext,
                                title: AppTranslations.get(dialogContext, "Afada Medical"),
                                body: AppTranslations.get(dialogContext, "Yangi buyurtma qo'shildi"),
                              );
                            } else {
                              final matchedProduct = mahsulotProvider.mahsulotlar.firstWhere(
                                    (m) => m.nomi.toLowerCase() == productName.toLowerCase(),
                                orElse: () => product,
                              );
                              final matchedClient = mijozProvider.mijozlar.firstWhere(
                                    (m) => "${m.ism} ${m.familya}".toLowerCase() == customerController.text.toLowerCase(),
                                orElse: () => MijozModel(ism: "", telefon: "", ishJoyi: ""),
                              );

                              final messenger = ScaffoldMessenger.of(context);
                              final errorPrefix = AppTranslations.get(dialogContext, "Xatolik yuz berdi");
                              showDialog(
                                context: dialogContext,
                                barrierDismissible: false,
                                builder: (_) => const Center(child: CircularProgressIndicator()),
                              );

                              orderProvider
                                  .updateOrder(
                                updatedOrder,
                                productId: matchedProduct.id,
                                customerId: matchedClient.id,
                                saleType: matchedClient.mijozTuri == "Korporativ" ? "shifokor" : "patient",
                              )
                                  .then((_) {
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                  Navigator.pop(dialogContext);
                                }
                              }).catchError((error) {
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                }
                                messenger.showSnackBar(
                                  SnackBar(content: Text("$errorPrefix: $error")),
                                );
                              });
                              return;
                            }

                            Navigator.pop(dialogContext);
                          }
                        },
                        child: Text(
                          AppTranslations.get(dialogContext, "Saqlash"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF475569)),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MedColors.primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MedColors.rose),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MedColors.rose, width: 1.5),
      ),
    );
  }
}