import 'dart:io';
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
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../provider/home_page_provider/provider_floating_bottom.dart';
import '../model/ishchi_modeli.dart';
import '../model/model_provider.dart';
import '../model/mahsulot_modeli.dart';
import '../model/mijoz_modeli.dart';
import '../model/order_model.dart';
import '../provider/order_provider.dart';
import '../provider/qarz_provider.dart';
import 'package:afada/services/notification_service.dart';
import 'dart:ui';

import 'daromad_pages/umumiy_daromad_pages.dart';
import 'package:afada/services/connectivity_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  late final List<Widget> pages;

  String _getTxt(BuildContext context, String key) {
    return HomePages()._getTxt(context, key);
  }

  @override
  void initState() {
    super.initState();
    _refreshAllData();
    pages = [
      HomePages(onRefresh: _refreshAllData),
      const OmborPages(),
      const IshchilarPages(),
      const MahsulotlarPages(),
    ];

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
  }

  Future<void> _refreshAllData() async {
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
      debugPrint("Error refreshing data: $e");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return Transform.scale(
          scale: anim1.value,
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color.fromRGBO(255, 255, 255, 0.1)
                          : const Color.fromRGBO(255, 255, 255, 0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? const Color.fromRGBO(255, 255, 255, 0.2)
                            : const Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 50,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _getTxt(context, "Hisobdan chiqmoqchimisiz?"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  _getTxt(context, "Yo'q"),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await context
                                      .read<ProfileProvider>()
                                      .logout();
                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  _getTxt(context, "Ha"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmall = MediaQuery.of(context).size.width < 600;
            return Row(
              children: [
                Expanded(
                  child: Text(
                    _getTxt(context, "Afada Medical"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: isSmall ? 22 : 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    final count = orderProvider.orders
                        .where((o) => o.status != "Sotildi")
                        .length;
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DraverBuyurtmalarPages(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.notifications_active,
                            size: isSmall ? 26 : 30,
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            top: 7,
                            right: 0,
                            child: Container(
                              width: isSmall ? 20 : 23,
                              height: isSmall ? 14 : 15,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  count > 9 ? "9+" : count.toString(),
                                  style: TextStyle(
                                    fontSize: isSmall ? 9 : 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
              ),
              child: pages[index],
            ),
          ),

          Positioned(left: 15, right: 15, bottom: 15, child: _bottomBar()),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width > 600 ? 350 : null,
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF181A20)
              : Colors.white,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 300;
              return Consumer<ProfileProvider>(
                builder: (context, profile, child) {
                  final bool isDark =
                      Theme.of(context).brightness == Brightness.dark;

                  final bool isWorker =
                      profile.role.trim().toLowerCase() == "ishchi";

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: isWide ? 80 : 60,
                              height: isWide ? 80 : 60,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF252836)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(40),
                                border: isDark
                                    ? Border.all(color: const Color(0xFF3A3F4B))
                                    : null,
                                image: profile.imagePath != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          File(profile.imagePath!),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              margin: EdgeInsets.only(
                                top: isWide ? 40 : 30,
                                left: 20,
                              ),
                              child: profile.imagePath == null
                                  ? Center(
                                      child: Icon(
                                        Icons.person,
                                        size: isWide ? 60 : 40,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: isWide ? 50 : 40),
                                  Text(
                                    "${profile.displayName} ${profile.displaySurname}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isWide ? 15 : 13,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          profile.role,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isWide ? 18 : 16,
                                            color: isDark
                                                ? const Color(0xFF3C8DFF)
                                                : Colors.blue,
                                          ),
                                        ),
                                      ),
                                      if (profile.role.trim().toLowerCase() ==
                                          "admin") ...[
                                        const SizedBox(width: 5),
                                        const Icon(
                                          Icons.verified,
                                          color: Color(0xFF3C8DFF),
                                          size: 15,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: isDark
                              ? const Color(0xFF3A3F4B)
                              : Colors.grey.shade300,
                        ),
                        _listTile(
                          Icons.person,
                          _getTxt(context, "Profil"),
                          const DraverProfilPages(),
                        ),

                        if (isWorker)
                          _buildDrawerLockedItem(
                            context,
                            icon: Icons.shopping_cart_outlined,
                            title: _getTxt(context, "Sotuv bo'limi"),
                            message: "Admin va sotuvchi uchun",
                          )
                        else
                          _listTile(
                            Icons.shopping_cart_outlined,
                            _getTxt(context, "Sotuv bo'limi"),
                            const DraverSotuvBolimi(),
                          ),

                        _listTile(
                          Icons.supervisor_account,
                          _getTxt(context, "Doimiy mijozlar"),
                          DraverKlentPages(),
                        ),
                        _listTile(
                          Icons.production_quantity_limits_outlined,
                          _getTxt(context, "Ombor"),
                          const DraverOmborPages(),
                        ),
                        _listTile(
                          Icons.inventory_outlined,
                          _getTxt(context, "Mahsulotlar"),
                          const DraverMahsulotlarPages(),
                        ),
                        _listTile(
                          Icons.group,
                          _getTxt(context, "Ishchilar"),
                          DraverIshchilarPages(),
                        ),
                        _listTile(
                          Icons.shopping_bag,
                          _getTxt(context, "Buyurtmalar"),
                          const DraverBuyurtmalarPages(),
                        ),
                        _listTile(
                          Icons.settings,
                          _getTxt(context, "Sozlamalar"),
                          const DraverSozlamalarPages(),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            size: 25,
                            color: Colors.red,
                          ),
                          title: Text(
                            _getTxt(context, "Chiqish"),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () => _showLogoutDialog(context),
                        ),

                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
  Widget _buildDrawerLockedItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ListTile(
              leading: Icon(
                icon,
                size: 25,
                color: isDark
                    ? Colors.white70
                    : Colors.black87,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),

            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  child: Container(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.72)
                        : Colors.white.withValues(alpha: 0.78),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),

                        const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 22,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
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
      ),
    );
  }

  Widget _listTile(
    IconData icon,
    String title,
    Widget page, {
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSmall = MediaQuery.of(context).size.width < 600;
    return ListTile(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
      leading: Icon(
        icon,
        size: isSmall ? 22 : 25,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isSmall ? 16 : 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth / 4;

        return ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.3),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: itemWidth * index,
                    top: 7,
                    child: Container(
                      width: itemWidth,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.18),
                            Colors.white.withValues(alpha: 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _navItem(
                          Icons.home,
                          _getTxt(context, "Home"),
                          0,
                        ),
                      ),
                      Expanded(
                        child: _navItem(
                          Icons.inventory_outlined,
                          _getTxt(context, "Ombor"),
                          1,
                        ),
                      ),
                      Expanded(
                        child: _navItem(
                          Icons.group,
                          _getTxt(context, "Ishchilar"),
                          2,
                        ),
                      ),
                      Expanded(
                        child: _navItem(
                          Icons.shopping_cart_outlined,
                          _getTxt(context, "Mahsulot"),
                          3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(
    IconData icon,
    String title,
    int itemIndex, {
    VoidCallback? onTap,
  }) {
    bool selected = index == itemIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap:
          onTap ??
          () {
            setState(() {
              index = itemIndex;
            });
          },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? Colors.blue : Colors.white,
            size: selected ? 28 : 20,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: selected ? 11 : 10,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePages extends StatelessWidget {
  final RefreshCallback? onRefresh;
  HomePages({super.key, this.onRefresh});

  final Map<String, Map<String, String>> _localizedTexts = {
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
      "Ishchilar": "Ishchilar",
      "Ishchilar soni:": "Ishchilar soni:",
      "Ish haqqi": "Ish haqqi",
      "Qarzdorlik": "Qarzdorlik",
      "Qarzdorlar:": "Qarzdorlar:",
      "Jami qarzdorlik": "Jami qarzdorlik",
      "Kunlik daromad statistikasi": "Kunlik daromad statistikasi",
      "Kunlik ish haqqi statistikasi": "Kunlik ish haqqi statistikasi",
      "Oylik daromad statistikasi": "Oylik daromad statistikasi",
      "Oylik ish haqqi statistikasi": "Oylik ish haqqi statistikasi",
      "Haftalik daromad statistikasi": "Haftalik daromad statistikasi",
      "Yillik daromad statistikasi": "Yillik daromad statistikasi",
      "Yangi buyurtma": "Yangi buyurtma",
      "Buyurtmani tahrirlash": "Buyurtmani tahrirlash",
      "Mahsulot nomi": "Mahsulot nomi",
      "Mahsulotni tanlang": "Mahsulotni tanlang",
      "Bunday mahsulot mavjud emas": "Bunday mahsulot mavjud emas",
      "Mijoz turi": "Mijoz turi",
      "Doimiy mijoz": "Doimiy mijoz",
      "Bemor": "Bemor",
      "Mijoz ismi": "Mijoz ismi",
      "Mijoz ismini kiriting": "Mijoz ismini kiriting",
      "Bunday doimiy mijoz mavjud emas.": "Bunday doimiy mijoz mavjud emas.",
      "Telefon (90 123 45 67)": "Telefon (90 123 45 67)",
      "Telefon raqamini kiriting": "Telefon raqamini kiriting",
      "Soni": "Soni",
      "Sonini kiriting": "Sonini kiriting",
      "Musbat son kiriting": "Musbat son kiriting",
      "Omborda faqat": "Omborda faqat",
      "ta mahsulot mavjud.": "ta mahsulot mavjud.",
      "Sana": "Sana",
      "Sanani tanlang": "Sanani tanlang",
      "Izoh (ixtiyoriy)": "Izoh (ixtiyoriy)",
      "To'lov holati": "To'lov holati",
      "To'langan": "To'langan",
      "To'lanmagan": "To'lanmagan",
      "To'langan summa": "To'langan summa",
      "Bekor qilish": "Bekor qilish",
      "Saqlash": "Saqlash",
      "Yangi buyurtma qo'shildi": "Yangi buyurtma qo'shildi",
      "Bu bo'lim faqat Administrator uchun mavjud.":
          "Bu bo'lim faqat Administrator uchun mavjud.",
      "UZS": "UZS",
      "Profil": "Profil",
      "Sotuv bo'limi": "Sotuv bo'limi",
      "Doimiy mijozlar": "Doimiy mijozlar",
      "Ombor": "Ombor",
      "Mahsulotlar": "Mahsulotlar",
      "Buyurtmalar": "Buyurtmalar",
      "Sozlamalar": "Sozlamalar",
      "Chiqish": "Chiqish",
      "Hisobdan chiqmoqchimisiz?": "Hisobdan chiqmoqchimisiz?",
      "Yo'q": "Yo'q",
      "Ha": "Ha",
      "Home": "Home",
      "Mahsulot": "Mahsulot",
      "Qarzdorlik:": "Qarzdorlik:",
      "Mon": "Du",
      "Tue": "Se",
      "Wed": "Cho",
      "Thu": "Pa",
      "Fri": "Ju",
      "Sat": "Sha",
      "Sun": "Yak",
      "Jan": "Yan",
      "Feb": "Fev",
      "Mar": "Mar",
      "Apr": "Apr",
      "May": "May",
      "Jun": "Iyun",
      "Jul": "Iyul",
      "Aug": "Avg",
      "Sep": "Sen",
      "Oct": "Okt",
      "Nov": "Noy",
      "Dec": "Dek",
      "Tez orada": "Tez orada",
      "Oylik": "Oylik",
      "Yillik": "Yillik",
    },
    "Rus": {
      "Afada Medical": "Афада Медикал",
      "Kunlik daromad": "Ежедневный доход",
      "Kunlik ish haqqi": "Ежедневная зарплата",
      "Sotildi:": "Продано:",
      "Tayyorlandi:": "Подготовлено:",
      "Buyurtmalar:": "Заказы:",
      "Ishlar:": "Работы:",
      "Oylik daromad": "Ежемесячный доход",
      "Oylik ish haqqi": "Ежемесячная зарплата",
      "Ishchilar": "Рабочие",
      "Ishchilar soni:": "Количество рабочих:",
      "Ish haqqi": "Зарплата",
      "Qarzdorlik": "Задолженность",
      "Qarzdorlar:": "Должники:",
      "Jami qarzdorlik": "Общая задолженность",
      "Kunlik daromad statistikasi": "Статистика ежедневного дохода",
      "Kunlik ish haqqi statistikasi": "Статистика ежедневной зарплаты",
      "Oylik daromad statistikasi": "Статистика ежемесячного дохода",
      "Oylik ish haqqi statistikasi": "Статистика ежемесячной зарплаты",
      "Haftalik daromad statistikasi": "Статистика еженедельного дохода",
      "Yillik daromad statistikasi": "Статистика годового дохода",
      "Yangi buyurtma": "Новый заказ",
      "Buyurtmani tahrirlash": "Редактировать заказ",
      "Mahsulot nomi": "Название продукта",
      "Mahsulotni tanlang": "Выберите продукт",
      "Bunday mahsulot mavjud emas": "Такого продукта не существует",
      "Mijoz turi": "Тип клиента",
      "Doimiy mijoz": "Постоянный клиент",
      "Bemor": "Пациент",
      "Mijoz ismi": "Имя клиента",
      "Mijoz ismini kiriting": "Введите имя клиента",
      "Bunday doimiy mijoz mavjud emas.":
          "Такого постоянного клиента не существует.",
      "Telefon (90 123 45 67)": "Телефон (90 123 45 67)",
      "Telefon raqamini kiriting": "Введите номер телефона",
      "Soni": "Количество",
      "Sonini kiriting": "Введите количество",
      "Musbat son kiriting": "Введите положительное число",
      "Omborda faqat": "В наличии только",
      "ta mahsulot mavjud.": "единиц товара.",
      "Sana": "Дата",
      "Sanani tanlang": "Выберите дату",
      "Izoh (ixtiyoriy)": "Примечание (необязательно)",
      "To'lov holati": "Статус платежа",
      "To'langan": "Оплачено",
      "To'lanmagan": "Не оплачено",
      "To'langan summa": "Оплаченная сумма",
      "Bekor qilish": "Отмена",
      "Saqlash": "Сохранить",
      "Yangi buyurtma qo'shildi": "Добавлен новый заказ",
      "Bu bo'lim faqat Administrator uchun mavjud.":
          "Этот раздел доступен только для Администратора.",
      "UZS": "сум",
      "Profil": "Профиль",
      "Sotuv bo'limi": "Отдел продаж",
      "Doimiy mijozlar": "Постоянные клиенты",
      "Ombor": "Склад",
      "Mahsulotlar": "Продукты",
      "Buyurtmalar": "Заказы",
      "Sozlamalar": "Настройки",
      "Chiqish": "Выход",
      "Hisobdan chiqmoqchimisiz?": "Вы хотите выйти из аккаунта?",
      "Yo'q": "Нет",
      "Ha": "Да",
      "Home": "Главная",
      "Mahsulot": "Продукты",
      "Qarzdorlik:": "Задолженность:",
      "Mon": "Пн",
      "Tue": "Вт",
      "Wed": "Ср",
      "Thu": "Чт",
      "Fri": "Пт",
      "Sat": "Сб",
      "Sun": "Вс",
      "Jan": "Янв",
      "Feb": "Фев",
      "Mar": "Мар",
      "Apr": "Апр",
      "May": "Май",
      "Jun": "Июн",
      "Jul": "Июл",
      "Aug": "Авг",
      "Sep": "Сен",
      "Oct": "Окт",
      "Nov": "Ноя",
      "Dec": "Дек",
      "Tez orada": "Тез орада",
      "Oylik": "Ежемесячно",
      "Yillik": "Ежегодно",
    },
    "Kiril": {
      "Afada Medical": "Афада медикал",
      "Kunlik daromad": "Кунлик даромад",
      "Kunlik ish haqqi": "Кунлик иш ҳаққи",
      "Sotildi:": "Сотилди:",
      "Tayyorlandi:": "Тайёрланди:",
      "Buyurtmalar:": "Буюртмалар:",
      "Ishlar:": "Ишлар:",
      "Oylik daromad": "Ойлик даромад",
      "Oylik ish haqqi": "Ойлик иш ҳаққи",
      "Ishchilar": "Ишчилар",
      "Ishchilar soni:": "Ишчилар сони:",
      "Ish haqqi": "Иш ҳаққи",
      "Qarzdorlik": "Қарздорлик",
      "Qarzdorlar:": "Қарздорлар:",
      "Jami qarzdorlik": "Жами қарздорлик",
      "Kunlik daromad statistikasi": "Кунlik даромад статистикаси",
      "Kunlik ish haqqi statistikasi": "Кунлик иш ҳаққи статистикаси",
      "Oylik daromad statistikasi": "Ойлик даромад статистикаси",
      "Oylik ish haqqi statistikasi": "Ойлик иш ҳаққи статистикаси",
      "Haftalik daromad statistikasi": "Ҳафталик даромад статистикаси",
      "Yillik daromad statistikasi": "Йиллик даромад статистикаси",
      "Yangi buyurtma": "Янги буюртма",
      "Buyurtmani tahrirlash": "Буюртмани таҳрирлаш",
      "Mahsulot nomi": "Маҳсулот номи",
      "Mahsulotni tanlang": "Маҳсулотни танланг",
      "Bunday mahsulot mavjud emas": "Бундай маҳсулот мавжуд эмас",
      "Mijoz turi": "Мижоз тури",
      "Doimiy mijoz": "Доимий мижоз",
      "Bemor": "Бемор",
      "Mijoz ismi": "Мижоз исми",
      "Mijoz ismini kiriting": "Мижоз исмини киритинг",
      "Bunday doimiy mijoz mavjud emas.": "Бундай доимий мижоз мавжуд эмас.",
      "Telefon (90 123 45 67)": "Телефон (90 123 45 67)",
      "Telefon raqamini kiriting": "Телефон рақамини киритинг",
      "Soni": "Сони",
      "Sonini kiriting": "Сонини киритинг",
      "Musbat son kiriting": "Мусбат сон киритинг",
      "Omborda faqat": "Омборда фақат",
      "ta mahsulot mavjud.": "та маҳсулот мавжуд.",
      "Sana": "Сана",
      "Sanani tanlang": "Санани танланг",
      "Izoh (ixtiyoriy)": "Изоҳ (ихтиёрий)",
      "To'lov holati": "Тўлов ҳолати",
      "To'langan": "Тўланган",
      "To'lanmagan": "Тўланмаган",
      "To'langan summa": "Тўланган сумма",
      "Bekor qilish": "Бекор қилиш",
      "Saqlash": "Сақлаш",
      "Yangi buyurtma qo'shildi": "Янги буюртма қўшилди",
      "Bu bo'lim faqat Administrator uchun mavjud.":
          "Бу бўлим фақат Администратор учун мавжуд.",
      "UZS": "сўм",
      "Profil": "Профиль",
      "Sotuv bo'limi": "Сотув бўлими",
      "Doimiy mijozlar": "Доимий мижозлар",
      "Ombor": "Омбор",
      "Mahsulotlar": "Маҳсулотлар",
      "Buyurtmalar": "Буюртмалар",
      "Sozlamalar": "Созламалар",
      "Chiqish": "Чиқиш",
      "Hisobdan chiqmoqchimisiz?": "Ҳисобдан чиқмоқчимисиз?",
      "Yo'q": "Йўқ",
      "Ha": "Ҳа",
      "Home": "Хоме",
      "Mahsulot": "Маҳсулот",
      "Qarzdorlik:": "Қарздорлик:",
      "Mon": "Ду",
      "Tue": "Се",
      "Wed": "Чо",
      "Thu": "Па",
      "Fri": "Жу",
      "Sat": "Ша",
      "Sun": "Як",
      "Jan": "Янв",
      "Feb": "Фев",
      "Mar": "Мар",
      "Apr": "Апр",
      "May": "Май",
      "Jun": "Июн",
      "Jul": "Июл",
      "Aug": "Авг",
      "Sep": "Сен",
      "Oct": "Окт",
      "Nov": "Ноя",
      "Dec": "Дек",
      "Tez orada": "Тез орада",
      "Oylik": "Ойлик",
      "Yillik": "Йиллик",
    },
  };

  String _getTxt(BuildContext context, String key) {
    final lang = context.read<ProfileProvider>().language;
    return _localizedTexts[lang]?[key] ?? key;
  }

  final TextEditingController sanaController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##');

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.07,
        ),
        child: _buildLockedOverlay(
          context,
          borderRadius: 25,
          fontSize: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {},
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.blue.shade100,
      body: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
                _buildDateHeader(context),
                Consumer5<
                  OrderProvider,
                  ProfileProvider,
                  MahsulotProvider,
                  QarzProvider,
                  FinishedProductProvider
                >(
                  builder:
                      (
                        context,
                        orderProvider,
                        profileProvider,
                        mahsulotProvider,
                        qarzProvider,
                        finishedProductProvider,
                        child,
                      ) {
                        context.watch<ProfileProvider>();
                        final now = DateTime.now();
                        // Unified Today's Stats (Admin view for all)
                        double todayRevenue = 0;
                        int todayProductsCount = 0;
                        int todayTasksCount = 0;

                        final bool isAdmin =
                            profileProvider.role.trim().toLowerCase() ==
                            "admin";

                        final String currentUserName =
                            "${profileProvider.displayName} ${profileProvider.displaySurname}"
                                .trim()
                                .toLowerCase();

                        bool isMySale(OrderModel order) {
                          if (isAdmin) return true;

                          final createdBy = order.createdBy;

                          if (createdBy == null) return false;

                          final createdByName =
                              (createdBy["fullName"] ??
                                      createdBy["full_name"] ??
                                      "")
                                  .toString()
                                  .trim()
                                  .toLowerCase();

                          return createdByName == currentUserName;
                        }

                        final myFinishedProducts = isAdmin
                            ? finishedProductProvider.finishedProducts
                            : finishedProductProvider.finishedProducts.where((
                                item,
                              ) {
                                final createdByName = (item.createdByName ?? "")
                                    .trim()
                                    .toLowerCase();

                                return createdByName == currentUserName;
                              }).toList();

                        final myFinishedProductCount = myFinishedProducts.fold(
                          0,
                          (sum, item) => sum + item.quantity,
                        );
                        final todayOrders = orderProvider.orders
                            .where(
                              (o) =>
                                  isMySale(o) &&
                                  (o.status == "Sotildi" ||
                                      o.paymentStatus == "To'langan") &&
                                  o.date.year == now.year &&
                                  o.date.month == now.month &&
                                  o.date.day == now.day,
                            )
                            .toList();

                        final bool isWorker =
                            profileProvider.role.trim().toLowerCase() == "ishchi";

                        if (isWorker) {
                          todayRevenue = finishedProductProvider.finishedProducts
                              .where((item) {
                            final createdAt = item.createdAt;

                            if (createdAt == null) return false;

                            return (item.createdByName ?? "").trim().toLowerCase() ==
                                currentUserName &&
                                createdAt.year == now.year &&
                                createdAt.month == now.month &&
                                createdAt.day == now.day;
                          })
                              .fold<double>(
                            0,
                                (sum, item) => sum + item.quantity,
                          );
                        } else {
                          todayRevenue = todayOrders.fold(
                            0.0,
                                (sum, o) =>
                            sum +
                                (o.status == "Sotildi"
                                    ? (o.price * o.quantity)
                                    : o.amountPaid),
                          );
                        }
                        todayProductsCount = todayOrders.fold(
                          0,
                          (sum, o) => sum + o.quantity,
                        );
                        todayTasksCount = todayOrders.length;

                        // Unified Monthly Stats (Admin view for all)
                        double monthlyRevenue = 0;
                        int monthlyProductsCount = 0;
                        int monthlyTasksCount = 0;

                        final monthlyOrders = orderProvider.orders
                            .where(
                              (o) =>
                                  isMySale(o) &&
                                  (o.status == "Sotildi" ||
                                      o.paymentStatus == "To'langan") &&
                                  o.date.year == now.year &&
                                  o.date.month == now.month,
                            )
                            .toList();

                        monthlyRevenue = monthlyOrders.fold(
                          0.0,
                          (sum, o) =>
                              sum +
                              (o.status == "Sotildi"
                                  ? (o.price * o.quantity)
                                  : o.amountPaid),
                        );
                        monthlyProductsCount = monthlyOrders.fold(
                          0,
                          (sum, o) => sum + o.quantity,
                        );
                        monthlyTasksCount = monthlyOrders.length;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      "Kunlik daromad",
                                      "Sotildi:",
                                      todayProductsCount.toString(),
                                      "Buyurtmalar:",
                                      todayTasksCount.toString(),
                                      isWorker
                                          ? "${todayRevenue.toInt()} ta"
                                          : _formatMoney(todayRevenue),
                                      KunlikDaromadPages(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      "Ishchilar",
                                      "Ishchilar soni:",
                                      IshchiDatabase.ishchilar.length.toString(),
                                      "Tayyorlandi:",
                                      myFinishedProductCount.toString(),
                                      myFinishedProductCount.toString(),
                                      IshchilarIshhaqqiPages(),
                                      isWorker: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      "Oylik daromad",
                                      "Sotildi:",
                                      monthlyProductsCount.toString(),
                                      "Buyurtmalar:",
                                      monthlyTasksCount.toString(),
                                      _formatMoney(monthlyRevenue),
                                      OylikDaromadPages(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildLockedOverlay(
                                      context,
                                      child: _buildStatCard(
                                        context,
                                        "Qarzdorlik",
                                        "Qarzdorlar:",
                                        qarzProvider.qarzdorlarSoni.toString(),
                                        "Qarzdorlik:",
                                        "",
                                        _formatMoney(qarzProvider.jamiQarz),
                                        const QarzdorlikPages(),
                                        isDebt: true,
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildWeeklyRevenueChart(
                              context,
                              orderProvider,
                              profileProvider,
                              mahsulotProvider,
                              finishedProductProvider,
                            ),
                            const SizedBox(height: 10),
                            DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  _buildChartTabBar(context),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 340,
                                    child: TabBarView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        _buildMonthlyRevenueChart(
                                          context,
                                          orderProvider,
                                          profileProvider,
                                          mahsulotProvider,
                                        ),
                                        _buildYearlyRevenueChart(
                                          context,
                                          orderProvider,
                                          profileProvider,
                                          mahsulotProvider,
                                          finishedProductProvider,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildLockedOverlay(
    BuildContext context, {
    required Widget child,
    double borderRadius = 24,
    double fontSize = 14,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: 0.4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: fontSize + 6),
                      const SizedBox(height: 4),
                      Text(
                        _getTxt(context, "Tez orada"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatMoney(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }

  Widget _buildDateHeader(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF252836).withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? const Color(0xFF3A3F4B).withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: isDark ? Colors.white : const Color(0xFF1F1F1F),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String label1,
    String val1,
    String label2,
    String val2,
    String amount,
    Widget page, {
    bool isWorker = false,
    bool isDebt = false,
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap:
          onTap ??
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF252836).withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getTxt(context, title),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: -0.5,
                            color: isDebt
                                ? (isDark
                                      ? const Color(0xFFFF5252)
                                      : const Color(0xFFD32F2F))
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF1F1F1F)),
                          ),
                        ),
                      ),
                      Icon(
                        isDebt
                            ? Icons.account_balance_wallet_rounded
                            : (isWorker
                                  ? Icons.people_alt_rounded
                                  : Icons.analytics_rounded),
                        size: 18,
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(context, label1, val1, isDark, Colors.green),
                  const SizedBox(height: 8),
                  _buildStatRow(context, label2, val2, isDark, Colors.red),
                  const Spacer(),
                  Divider(
                    color: isDark
                        ? Colors.white10
                        : Colors.black.withValues(alpha: 0.05),
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          isDebt
                              ? _getTxt(context, "Jami qarzdorlik")
                              : _getTxt(context, "Jami summa:"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        amount,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: isDebt
                              ? Colors.redAccent
                              : (isDark ? Colors.white : Colors.black),
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
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    bool isDark,
    Color labelColor,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            _getTxt(context, label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? labelColor.withValues(alpha: 0.8) : labelColor,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          flex: 2,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartTabBar(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2A2E38)
            : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A3F4B)
              : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TabBar(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: -25),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF3C8DFF).withValues(alpha: isDark ? 0.3 : 0.8),
          border: Border.all(
            color: isDark
                ? const Color(0xFF3C8DFF)
                : Colors.white.withValues(alpha: 0.4),
          ),
        ),
        tabs: [
          Tab(text: _getTxt(context, "Oylik")),
          Tab(text: _getTxt(context, "Yillik")),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueChart(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    final bool isAdmin =
        profileProvider.role.trim().toLowerCase() == "admin";

    final bool isWorker =
        profileProvider.role.trim().toLowerCase() == "ishchi";

    final String currentUserName =
    "${profileProvider.displayName} ${profileProvider.displaySurname}"
        .trim()
        .toLowerCase();

    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;

    final data = List.generate(daysInMonth, (i) {
      final date = DateTime(now.year, now.month, i + 1);

      // 👨‍🔧 ISHCHI — faqat o'zi tayyorlagan mahsulotlar
      if (isWorker) {
        final finishedProductProvider =
        context.read<FinishedProductProvider>();

        return finishedProductProvider.finishedProducts
            .where((item) {
          final createdAt = item.createdAt;

          if (createdAt == null) {
            return false;
          }

          final createdByName =
          (item.createdByName ?? "")
              .trim()
              .toLowerCase();

          return createdByName == currentUserName &&
              createdAt.year == date.year &&
              createdAt.month == date.month &&
              createdAt.day == date.day;
        })
            .fold<double>(
          0,
              (sum, item) => sum + item.quantity,
        );
      }

      // 👑 ADMIN + 🧑‍💼 SOTUVCHI — savdolar
      return orderProvider.orders
          .where((o) {
        if (o.date.year != date.year ||
            o.date.month != date.month ||
            o.date.day != date.day) {
          return false;
        }

        if (o.paymentStatus != "To'langan" &&
            o.status != "Sotildi") {
          return false;
        }

        // ADMIN — barcha savdolar
        if (isAdmin) {
          return true;
        }

        // SOTUVCHI — faqat o'z savdolari
        final createdBy = o.createdBy;

        if (createdBy == null) {
          return false;
        }

        final createdByName =
        (createdBy["fullName"] ??
            createdBy["full_name"] ??
            "")
            .toString()
            .trim()
            .toLowerCase();

        return createdByName == currentUserName;
      })
          .fold<double>(
        0,
            (sum, o) =>
        sum +
            (o.status == "Sotildi"
                ? (o.price * o.quantity)
                : o.amountPaid),
      );
    });

    final labels =
    List.generate(daysInMonth, (i) => (i + 1).toString());

    final String title =
    isWorker
        ? "Oylik tayyorlangan mahsulotlar"
        : "Oylik daromad statistikasi";

    return _buildChartContainer(
      context,
      title,
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: daysInMonth * 45.0,
          child: _buildBarChart(
            context,
            data,
            labels,
            const Color(0xFF3C8DFF),
            isDark,
            highlightIndex: now.day - 1,
            unit: isWorker ? "ta" : "UZS",
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyRevenueChart(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    final bool isAdmin =
        profileProvider.role.trim().toLowerCase() == "admin";

    final String currentUserName =
    "${profileProvider.displayName} ${profileProvider.displaySurname}"
        .trim()
        .toLowerCase();

    // ================================
    // HAFTALIK DATA
    // ================================
    final firstDayOfWeek =
    now.subtract(Duration(days: now.weekday - 1));

    final data = List.generate(7, (i) {
      final date = DateTime(
        firstDayOfWeek.year,
        firstDayOfWeek.month,
        firstDayOfWeek.day,
      ).add(Duration(days: i));

      // ================================
      // ISHCHI
      // ================================
      if (!isAdmin &&
          profileProvider.role.trim().toLowerCase() == "ishchi") {
        return finishedProductProvider.finishedProducts
            .where(
              (item) {
            final createdAt = item.createdAt;

            if (createdAt == null) {
              return false;
            }

            return (item.createdByName ?? "")
                .trim()
                .toLowerCase() ==
                currentUserName &&
                createdAt.year == date.year &&
                createdAt.month == date.month &&
                createdAt.day == date.day;
          },
        )
            .fold<double>(
          0,
              (sum, item) => sum + item.quantity,
        );
      }

      // ================================
      // ADMIN + SOTUVCHI
      // ================================
      return orderProvider.orders
          .where(
            (o) {
          if (o.date.year != date.year ||
              o.date.month != date.month ||
              o.date.day != date.day) {
            return false;
          }

          if (o.paymentStatus != "To'langan" &&
              o.status != "Sotildi") {
            return false;
          }

          // ADMIN — barcha sotuvlar
          if (isAdmin) {
            return true;
          }

          // SOTUVCHI — faqat o'z sotuvlari
          final createdBy = o.createdBy;

          if (createdBy == null) {
            return false;
          }

          final createdByName =
          (createdBy["fullName"] ??
              createdBy["full_name"] ??
              "")
              .toString()
              .trim()
              .toLowerCase();

          return createdByName == currentUserName;
        },
      )
          .fold<double>(
        0,
            (sum, o) =>
        sum +
            (o.status == "Sotildi"
                ? (o.price * o.quantity)
                : o.amountPaid),
      );
    });

    final labels = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final bool isWorker =
        !isAdmin &&
            profileProvider.role.trim().toLowerCase() == "ishchi";

    return _buildChartContainer(
      context,
      "Haftalik daromad statistikasi",
      _buildBarChart(
        context,
        data,
        labels,
        const Color(0xFF3C8DFF),
        isDark,
        highlightIndex: now.weekday - 1,
        unit: isWorker ? "ta" : "UZS",
      ),
    );
  }

  Widget _buildYearlyRevenueChart(
      BuildContext context,
      OrderProvider orderProvider,
      ProfileProvider profileProvider,
      MahsulotProvider mahsulotProvider,
      FinishedProductProvider finishedProductProvider,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();

    final bool isAdmin =
        profileProvider.role.trim().toLowerCase() == "admin";

    final bool isWorker =
        profileProvider.role.trim().toLowerCase() == "ishchi";

    final String currentUserName =
    "${profileProvider.displayName} ${profileProvider.displaySurname}"
        .trim()
        .toLowerCase();

    final data = List.generate(12, (index) {
      final targetMonth = index + 1;

      // 👨‍🔧 ISHCHI — o'zi tayyorlagan mahsulotlar
      if (isWorker) {
        return finishedProductProvider.finishedProducts
            .where((item) {
          final createdAt = item.createdAt;

          if (createdAt == null) {
            return false;
          }

          final createdByName =
          (item.createdByName ?? "")
              .trim()
              .toLowerCase();

          return createdByName == currentUserName &&
              createdAt.year == now.year &&
              createdAt.month == targetMonth;
        })
            .fold<double>(
          0,
              (sum, item) => sum + item.quantity,
        );
      }

      // 🧑‍💼 SOTUVCHI + 👑 ADMIN — savdolar
      return orderProvider.orders
          .where((o) {
        if (o.date.year != now.year ||
            o.date.month != targetMonth) {
          return false;
        }

        if (o.paymentStatus != "To'langan" &&
            o.status != "Sotildi") {
          return false;
        }

        // ADMIN — barcha savdolar
        if (isAdmin) {
          return true;
        }

        // SOTUVCHI — faqat o'z savdolari
        final createdBy = o.createdBy;

        if (createdBy == null) {
          return false;
        }

        final createdByName =
        (createdBy["fullName"] ??
            createdBy["full_name"] ??
            "")
            .toString()
            .trim()
            .toLowerCase();

        return createdByName == currentUserName;
      })
          .fold<double>(
        0,
            (sum, o) =>
        sum +
            (o.status == "Sotildi"
                ? (o.price * o.quantity)
                : o.amountPaid),
      );
    });

    const labels = [
      "Yan",
      "Fev",
      "Mar",
      "Apr",
      "May",
      "Iyun",
      "Iyul",
      "Avg",
      "Sen",
      "Okt",
      "Noy",
      "Dek",
    ];

    return _buildChartContainer(
      context,
      isWorker
          ? "Yillik tayyorlangan mahsulotlar"
          : "Yillik daromad statistikasi",
      _buildBarChart(
        context,
        data,
        labels,
        const Color(0xFF3C8DFF),
        isDark,
        highlightIndex: now.month - 1,
        unit: isWorker ? "ta" : "UZS",
      ),
    );
  }

  Widget _buildChartContainer(
    BuildContext context,
    String title,
    Widget chart,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 320,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252836) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? const Color(0xFF3A3F4B).withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getTxt(context, title),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                  ),
                ),
                Icon(
                  Icons.auto_graph_rounded,
                  size: 20,
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(
      BuildContext context,
      List<double> data,
      List<String> labels,
      Color baseColor,
      bool isDark, {
        int? highlightIndex,
        String unit = "UZS",
      }) {
    double maxVal = data.fold(
      0,
      (prev, element) => element > prev ? element : prev,
    );
    if (maxVal == 0) maxVal = 1000;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) =>
                isDark ? const Color(0xFF3A3F4B) : Colors.white,
            tooltipRoundedRadius: 12,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                _formatMoney(rod.toY),
                TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: " ${unit == "UZS" ? _getTxt(context, "UZS") : unit}",
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < labels.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Text(
                      _getTxt(context, labels[index]),
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontWeight: index == highlightIndex
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: labels.length > 7 ? 10 : 12,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxVal / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (i) {
          final isHighlighted = i == highlightIndex;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i],
                color: isHighlighted
                    ? baseColor
                    : baseColor.withValues(alpha: 0.15),
                width: data.length >= 12 ? 10 : 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxVal * 1.2,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.black.withValues(alpha: 0.01),
                ),
              ),
            ],
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.decelerate,
    );
  }

  void showBuyurtmaDialog(BuildContext context, {OrderModel? order}) {
    final mahsulotProvider = context.read<MahsulotProvider>();
    final customerController = TextEditingController(
      text: order?.customerName ?? "",
    );
    final phoneController = TextEditingController(text: order?.phone ?? "");
    final quantityController = TextEditingController(
      text: order?.quantity.toString() ?? "",
    );
    final commentController = TextEditingController(text: order?.comment ?? "");
    final servicePriceController = TextEditingController(
      text: order?.servicePrice.toString() ?? "0",
    );
    final amountPaidController = TextEditingController(
      text: order?.amountPaid.toString() ?? "0",
    );
    String paymentStatus = order?.paymentStatus ?? "To'lanmagan";
    final TextEditingController localSanaController = TextEditingController(
      text: order != null
          ? "${order.date.day}.${order.date.month}.${order.date.year}"
          : "",
    );

    final mijozProvider = context.read<MijozProvider>();
    String mijozTuri =
        (order != null &&
            mijozProvider.mijozlar.any(
              (m) => "${m.ism} ${m.familya}" == order.customerName,
            ))
        ? "Doimiy mijoz"
        : "Bemor";

    final formKey = GlobalKey<FormState>();
    TextEditingController? productController;

    showDialog(
      context: context,
      builder: (context) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF252836) : Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: isDark
                    ? const BorderSide(color: Color(0xFF3A3F4B))
                    : BorderSide.none,
              ),
              title: Center(
                child: Text(
                  order == null
                      ? _getTxt(context, "Yangi buyurtma")
                      : _getTxt(context, "Buyurtmani tahrirlash"),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.indigo,
                    fontWeight: FontWeight.bold,
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
                        initialValue: TextEditingValue(
                          text: order?.productName ?? "",
                        ),
                        displayStringForOption: (m) => m.nomi,
                        optionsBuilder: (textValue) {
                          final options = mahsulotProvider.mahsulotlar.where(
                            (m) => m.zaxira > 0,
                          );
                          if (textValue.text.isEmpty) {
                            return options;
                          }
                          return options.where(
                            (m) => m.nomi.toLowerCase().contains(
                              textValue.text.toLowerCase(),
                            ),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              color: isDark
                                  ? const Color(0xFF2A2E38)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 250,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        final MahsulotModel option = options
                                            .elementAt(index);
                                        return ListTile(
                                          title: Text(
                                            option.nomi,
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
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
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                              productController = controller;
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: _inputDecoration(
                                  _getTxt(context, "Mahsulot nomi"),
                                  isDark,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return _getTxt(
                                      context,
                                      "Mahsulotni tanlang",
                                    );
                                  }
                                  if (!mahsulotProvider.mahsulotlar.any(
                                    (m) =>
                                        m.nomi.toLowerCase() ==
                                        value.toLowerCase(),
                                  )) {
                                    return _getTxt(
                                      context,
                                      "Bunday mahsulot mavjud emas",
                                    );
                                  }
                                  return null;
                                },
                              );
                            },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: mijozTuri,
                        dropdownColor: isDark
                            ? const Color(0xFF2A2E38)
                            : Colors.white,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          _getTxt(context, "Mijoz turi"),
                          isDark,
                        ),
                        items: ["Doimiy mijoz", "Bemor"]
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(_getTxt(context, s)),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            mijozTuri = val!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      mijozTuri == "Doimiy mijoz"
                          ? Autocomplete<MijozModel>(
                              initialValue: TextEditingValue(
                                text: customerController.text,
                              ),
                              displayStringForOption: (m) =>
                                  "${m.ism} ${m.familya}",
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
                                customerController.text =
                                    "${selection.ism} ${selection.familya}";
                                phoneController.text = selection.telefon;
                              },
                              fieldViewBuilder:
                                  (
                                    context,
                                    controller,
                                    focusNode,
                                    onFieldSubmitted,
                                  ) {
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      decoration: _inputDecoration(
                                        _getTxt(context, "Mijoz ismi"),
                                        isDark,
                                      ),
                                      onChanged: (val) =>
                                          customerController.text = val,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return _getTxt(
                                            context,
                                            "Mijoz ismini kiriting",
                                          );
                                        }
                                        if (!mijozProvider.mijozlar.any(
                                          (m) =>
                                              "${m.ism} ${m.familya}"
                                                  .toLowerCase() ==
                                              value.toLowerCase(),
                                        )) {
                                          return _getTxt(
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
                                    elevation: 4.0,
                                    color: isDark
                                        ? const Color(0xFF2A2E38)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 250,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              final MijozModel option = options
                                                  .elementAt(index);
                                              return ListTile(
                                                title: Text(
                                                  "${option.ism} ${option.familya}",
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
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
                            )
                          : TextFormField(
                              controller: customerController,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: _inputDecoration(
                                _getTxt(context, "Mijoz ismi"),
                                isDark,
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? _getTxt(context, "Mijoz ismini kiriting")
                                  : null,
                            ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          _getTxt(context, "Telefon (90 123 45 67)"),
                          isDark,
                        ),
                        inputFormatters: [maskFormatter],
                        keyboardType: TextInputType.phone,
                        validator: (value) => (value == null || value.isEmpty)
                            ? _getTxt(context, "Telefon raqamini kiriting")
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: quantityController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          _getTxt(context, "Soni"),
                          isDark,
                        ),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _getTxt(context, "Sonini kiriting");
                          }
                          final count = int.tryParse(value);
                          if (count == null || count <= 0) {
                            return _getTxt(context, "Musbat son kiriting");
                          }

                          final selectedProduct = productController?.text;
                          if (selectedProduct != null &&
                              selectedProduct.isNotEmpty) {
                            final product = mahsulotProvider.mahsulotlar
                                .firstWhere(
                                  (m) =>
                                      m.nomi.toLowerCase() ==
                                      selectedProduct.toLowerCase(),
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

                            if (product.zaxira != -1 &&
                                count > product.zaxira) {
                              return "${_getTxt(context, "Omborda faqat")} ${product.zaxira} ${_getTxt(context, "ta mahsulot mavjud.")}";
                            }
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: localSanaController,
                        readOnly: true,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          _getTxt(context, "Sana"),
                          isDark,
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: order?.date ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            localSanaController.text =
                                "${picked.day}.${picked.month}.${picked.year}";
                          }
                        },
                        validator: (value) => (value == null || value.isEmpty)
                            ? _getTxt(context, "Sanani tanlang")
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: commentController,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          _getTxt(context, "Izoh (ixtiyoriy)"),
                          isDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: paymentStatus,
                        dropdownColor: isDark
                            ? const Color(0xFF2A2E38)
                            : Colors.white,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          _getTxt(context, "To'lov holati"),
                          isDark,
                        ),
                        items: ["To'langan", "To'lanmagan"]
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(_getTxt(context, s)),
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
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: _inputDecoration(
                            _getTxt(context, "To'langan summa"),
                            isDark,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF3A3F4B)
                              : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          _getTxt(context, "Bekor qilish"),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF3C8DFF)
                              : Colors.indigo,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final orderProvider = context.read<OrderProvider>();
                            final productName = productController?.text ?? "";
                            final quantity =
                                int.tryParse(quantityController.text) ?? 0;
                            final servicePrice =
                                double.tryParse(servicePriceController.text) ??
                                0.0;
                            final amountPaid = paymentStatus == "To'langan"
                                ? (double.tryParse(amountPaidController.text) ??
                                      0.0)
                                : 0.0;

                            final product = mahsulotProvider.mahsulotlar
                                .firstWhere(
                                  (m) =>
                                      m.nomi.toLowerCase() ==
                                      productName.toLowerCase(),
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
                                double.tryParse(
                                  product.bemorNarxi.replaceAll(
                                    RegExp(r'[^0-9.]'),
                                    '',
                                  ),
                                ) ??
                                0.0;
                            final finalServicePrice = order == null
                                ? (double.tryParse(
                                        product.shifokorNarxi.replaceAll(
                                          RegExp(r'[^0-9.]'),
                                          '',
                                        ),
                                      ) ??
                                      0.0)
                                : servicePrice;

                            DateTime orderDate = order?.date ?? DateTime.now();
                            if (localSanaController.text.isNotEmpty) {
                              try {
                                final parts = localSanaController.text.split(
                                  '.',
                                );
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
                              id:
                                  order?.id ??
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
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
                                context,
                                title: _getTxt(context, "Afada Medical"),
                                body: _getTxt(
                                  context,
                                  "Yangi buyurtma qo'shildi",
                                ),
                              );
                            } else {
                              orderProvider.updateOrder(updatedOrder);
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          _getTxt(context, "Saqlash"),
                          style: const TextStyle(color: Colors.white),
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
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
        ),
      ),
    );
  }
}
