import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/mahsulot_modeli.dart';
import '../model/model_provider.dart';
import '../provider/profile_provider.dart';
import 'dart:ui';
import 'dart:io';

class MahsulotlarPages extends StatefulWidget {
  const MahsulotlarPages({super.key});

  @override
  State<MahsulotlarPages> createState() => _MahsulotlarPagesState();

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Mahsulot": "Mahsulot",
      "Mahsulot qo'shish": "Mahsulot qo'shish",
      "Ma'lumot kiritilmagan": "Ma'lumot kiritilmagan",
      "Bekor qilish": "Bekor qilish",
      "Saqlash": "Saqlash",
      "Mahsulot nomi": "Mahsulot nomi",
      "Bemor narxi": "Bemor narxi",
      "Shifokor narxi": "Shifokor narxi",
      "Kategoriya": "Kategoriya",
      "Keshbek": "Keshbek",
      "Status": "Status",
      "Faol": "Faol",
      "Nofaol": "Nofaol",
      "Umumiy": "Umumiy",
      "Tahrirlash": "Tahrirlash",
      "O'chirish": "O'chirish",
      "Yangilash": "Yangilash",
      "Kamera": "Kamera",
      "Galereya": "Galereya",
      "Ma'lumotlarni to'liq kiriting": "Ma'lumotlarni to'liq kiriting",
      "UZS": "so'm",
      "Mahsulotni o'chirish": "Mahsulotni o'chirish",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
      "Mahsulot qidirish": "Mahsulot qidirish",
      "Mahsulot topilmadi": "Mahsulot topilmadi",
    },
    "Rus": {
      "Mahsulot": "Продукт",
      "Mahsulot qo'shish": "Добавить продукт",
      "Ma'lumot kiritilmagan": "Данные не введены",
      "Bekor qilish": "Отмена",
      "Saqlash": "Сохранить",
      "Mahsulot nomi": "Название продукта",
      "Bemor narxi": "Цена для пациента",
      "Shifokor narxi": "Цена для врача",
      "Kategoriya": "Категория",
      "Keshbek": "Кешбэк",
      "Status": "Статус",
      "Faol": "Активный",
      "Nofaol": "Неактивный",
      "Umumiy": "Общий",
      "Tahrirlash": "Изменить",
      "O'chirish": "Удалить",
      "Yangilash": "Обновить",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "Ma'lumotlarni to'liq kiriting": "Введите данные полностью",
      "UZS": "сум",
      "Mahsulotni o'chirish": "Удаление товара",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Вы действительно хотите удалить этот товар?",
      "Mahsulot qidirish": "Поиск продукта",
      "Mahsulot topilmadi": "Продукт не найден",
    },
    "Kiril": {
      "Mahsulot": "Маҳсулот",
      "Mahsulot qo'shish": "Маҳсулот қўшиш",
      "Ma'lumot kiritilmagan": "Маълумот киритилмаган",
      "Bekor qilish": "Бекор қилиш",
      "Saqlash": "Сақлаш",
      "Mahsulot nomi": "Маҳсулот номи",
      "Bemor narxi": "Бемор нархи",
      "Shifokor narxi": "Шифокор нархи",
      "Kategoriya": "Категория",
      "Keshbek": "Кешбек",
      "Status": "Статус",
      "Faol": "Фаол",
      "Nofaol": "Нофаол",
      "Umumiy": "Умумий",
      "Tahrirlash": "Таҳрирлаш",
      "O'chirish": "Ўчириш",
      "Yangilash": "Янгилаш",
      "Kamera": "Камера",
      "Galereya": "Галерея",
      "Ma'lumotlarni тўliq kiriting":
      "Маълумотларни тўлиқ киритинг",
      "UZS": "Сўм",
      "Mahsulotni o'chirish": "Маҳсулотни ўчириш",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Ҳақиқатан ҳам ушбу маҳсулотни ўчирмоқчимисиз?",
      "Mahsulot qidirish": "Маҳсулот қидириш",
      "Mahsulot topilmadi": "Маҳсулот топилмади",
    },
  };
}

class _MahsulotlarPagesState extends State<MahsulotlarPages> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog(
      BuildContext context,
      String lang,
      int index,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ?? key;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          isDark ? const Color(0xFF252836) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isDark
                ? const BorderSide(
              color: Color(0xFF3A3F4B),
            )
                : BorderSide.none,
          ),
          title: Text(
            getTxt("Mahsulotni o'chirish"),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            getTxt(
              "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
            ),
            style: TextStyle(
              color: isDark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                getTxt("Bekor qilish"),
                style: TextStyle(
                  color: isDark
                      ? Colors.white70
                      : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF3C8DFF)
                    : Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                context
                    .read<MahsulotProvider>()
                    .ochirish(index);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                getTxt("O'chirish"),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  String _formatPrice(String price) {
    final cleanPrice = price.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanPrice.isEmpty) return price;

    final number = int.tryParse(cleanPrice);
    if (number == null) return price;

    return number
        .toString()
        .replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
    );
  }


  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<MahsulotProvider>();

    final profileProvider =
    context.watch<ProfileProvider>();

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final String lang = profileProvider.language;

    // FAQAT ADMIN
    final bool isAdmin =
        profileProvider.role.trim().toLowerCase() == 'admin';

    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ?? key;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.mahsulotlar.isEmpty &&
          !provider.isLoading) {
        provider.loadProducts();
      }
    });

    final filteredMahsulotlar =
    provider.mahsulotlar.where((m) {
      return m.nomi
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.blue.shade100,

      // + TUGMA FAQAT ADMINDA
      floatingActionButton:
      isAdmin ? _buildAddButton(context, lang) : null,

      body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : provider.mahsulotlar.isEmpty
          ? Center(
        child: RefreshIndicator(
          onRefresh: provider.loadProducts,
          child: SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 80,
                  color: isDark
                      ? Colors.white38
                      : Colors.black26,
                ),
                const SizedBox(height: 10),
                Text(
                  getTxt(
                    "Ma'lumot kiritilmagan",
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? Colors.white38
                        : Colors.black26,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : LayoutBuilder(
        builder:
            (context, constraints) {
          final double width =
              constraints.maxWidth;

          int crossAxisCount = 2;
          double childAspectRatio = 0.75;

          if (width > 1200) {
            crossAxisCount = 6;
            childAspectRatio = 0.9;
          } else if (width > 900) {
            crossAxisCount = 4;
            childAspectRatio = 0.85;
          } else if (width > 600) {
            crossAxisCount = 3;
            childAspectRatio = 0.8;
          }

          return RefreshIndicator(
            onRefresh:
            provider.loadProducts,
            child:
            SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildSearchField(
                    context,
                    isDark,
                    lang,
                  ),

                  if (filteredMahsulotlar
                      .isEmpty &&
                      _searchQuery
                          .isNotEmpty)
                    _buildEmptySearchResults(
                      context,
                      isDark,
                      lang,
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      padding:
                      const EdgeInsets
                          .all(10),
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount:
                      filteredMahsulotlar
                          .length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                        crossAxisCount,
                        crossAxisSpacing:
                        10,
                        mainAxisSpacing:
                        10,
                        childAspectRatio:
                        childAspectRatio,
                      ),
                      itemBuilder:
                          (context, index) {
                        final mahsulot =
                        filteredMahsulotlar[
                        index];

                        final originalIndex =
                        provider.mahsulotlar
                            .indexOf(
                            mahsulot);

                        return GestureDetector(
                          onTap: () =>
                              _showDetailsDialog(
                                context,
                                mahsulot,
                                lang,
                                originalIndex,
                              ),
                          child:
                          ClipRRect(
                            borderRadius:
                            BorderRadius
                                .circular(
                              20,
                            ),
                            child:
                            BackdropFilter(
                              filter:
                              ImageFilter
                                  .blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child:
                              Container(
                                decoration:
                                BoxDecoration(
                                  color: isDark
                                      ? const Color(
                                      0xFF252836)
                                      .withValues(
                                    alpha:
                                    0.7,
                                  )
                                      : Colors
                                      .white
                                      .withValues(
                                    alpha:
                                    0.7,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                  border:
                                  Border.all(
                                    color: isDark
                                        ? const Color(
                                        0xFF3A3F4B)
                                        .withValues(
                                      alpha:
                                      0.5,
                                    )
                                        : Colors
                                        .white
                                        .withValues(
                                      alpha:
                                      0.5,
                                    ),
                                    width:
                                    1.5,
                                  ),
                                ),
                                child:
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Expanded(
                                      child:
                                      Container(
                                        width:
                                        double.infinity,
                                        decoration:
                                        BoxDecoration(
                                          color: isDark
                                              ? const Color(
                                              0xFF2A2E38)
                                              .withValues(
                                            alpha:
                                            0.5,
                                          )
                                              : Colors
                                              .grey
                                              .shade100
                                              .withValues(
                                            alpha:
                                            0.5,
                                          ),
                                          borderRadius:
                                          const BorderRadius
                                              .vertical(
                                            top:
                                            Radius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                        child:
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius
                                              .vertical(
                                            top:
                                            Radius.circular(
                                              18,
                                            ),
                                          ),
                                          child:
                                          mahsulot.rasm !=
                                              null
                                              ? (mahsulot.rasm!
                                              .startsWith(
                                            'http',
                                          )
                                              ? Image.network(
                                            mahsulot.rasm!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (c, e, s) =>
                                                Center(
                                                  child:
                                                  Text(
                                                    mahsulot.nomi.isNotEmpty
                                                        ? mahsulot.nomi[0].toUpperCase()
                                                        : "",
                                                    style:
                                                    TextStyle(
                                                      fontSize:
                                                      60,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: isDark
                                                          ? Colors.white24
                                                          : Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                          )
                                              : Image.file(
                                            File(
                                              mahsulot.rasm!,
                                            ),
                                            fit: BoxFit.cover,
                                          ))
                                              : Center(
                                            child:
                                            Text(
                                              mahsulot.nomi.isNotEmpty
                                                  ? mahsulot.nomi[0].toUpperCase()
                                                  : "",
                                              style:
                                              TextStyle(
                                                fontSize:
                                                60,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white24
                                                    : Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding:
                                      const EdgeInsets
                                          .fromLTRB(
                                        12,
                                        10,
                                        12,
                                        12,
                                      ),
                                      child:
                                      Column(
                                        mainAxisSize:
                                        MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mahsulot.nomi,
                                            maxLines:
                                            1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style:
                                            TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize:
                                              16,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                              4),
                                          Text(
                                            "${_formatPrice(mahsulot.bemorNarxi)} ${getTxt("UZS")}",
                                            style:
                                            TextStyle(
                                              color: isDark
                                                  ? const Color(
                                                  0xFFFF4D4F)
                                                  : Colors.redAccent,
                                              fontWeight:
                                              FontWeight.w800,
                                              fontSize:
                                              15,
                                            ),
                                          ),
                                        ],
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

                  const SizedBox(
                      height: 200),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(
      BuildContext context,
      bool isDark,
      String lang,
      ) {
    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ??
            key;

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF252836)
                  .withValues(alpha: 0.8)
                  : Colors.white
                  .withValues(alpha: 0.8),
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF3A3F4B)
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
              decoration: InputDecoration(
                hintText:
                getTxt("Mahsulot qidirish"),
                hintStyle: TextStyle(
                  color: isDark
                      ? Colors.white38
                      : Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark
                      ? Colors.white70
                      : Colors.black54,
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearchResults(
      BuildContext context,
      bool isDark,
      String lang,
      ) {
    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ??
            key;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: isDark
                ? Colors.white38
                : Colors.black26,
          ),
          const SizedBox(height: 10),
          Text(
            getTxt("Mahsulot topilmadi"),
            style: TextStyle(
              fontSize: 18,
              color: isDark
                  ? Colors.white38
                  : Colors.black26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
      BuildContext context,
      String lang,
      ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
        MediaQuery.of(context).size.height *
            0.07,
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.12),
              borderRadius:
              BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo
                      .withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius:
                BorderRadius.circular(25),
                onTap: () {
                  context
                      .read<MahsulotProvider>()
                      .tozalash();

                  _showProductDialog(
                    context,
                    lang,
                  );
                },
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(
      BuildContext context,
      MahsulotModel mahsulot,
      String lang,
      int index,
      ) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final profileProvider =
    context.read<ProfileProvider>();

    // FAQAT ADMIN
    final bool isAdmin =
        profileProvider.role.trim().toLowerCase() ==
            'admin';

    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ??
            key;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF252836)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
            side: isDark
                ? const BorderSide(
              color: Color(0xFF3A3F4B),
            )
                : BorderSide.none,
          ),
          title: Center(
            child: Text(
              getTxt("Mahsulot"),
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.indigo,
                fontWeight:
                FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                if (mahsulot.rasm != null)
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(12),
                    child: mahsulot.rasm!
                        .startsWith('http')
                        ? Image.network(
                      mahsulot.rasm!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (c, e, s) =>
                      const Icon(
                        Icons
                            .image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    )
                        : Image.file(
                      File(mahsulot.rasm!),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Text(
                    mahsulot.nomi.isNotEmpty
                        ? mahsulot.nomi[0]
                        .toUpperCase()
                        : "",
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight:
                      FontWeight.bold,
                      color: isDark
                          ? Colors.white24
                          : Colors.grey,
                    ),
                  ),

                const SizedBox(height: 20),

                _buildDetailItem(
                  getTxt("Mahsulot nomi"),
                  mahsulot.nomi,
                  isDark,
                ),

                _buildDetailItem(
                  getTxt("Bemor narxi"),
                  "${mahsulot.bemorNarxi} ${getTxt("UZS")}",
                  isDark,
                ),

                _buildDetailItem(
                  getTxt("Shifokor narxi"),
                  "${mahsulot.shifokorNarxi} ${getTxt("UZS")}",
                  isDark,
                ),

                _buildDetailItem(
                  getTxt("Kategoriya"),
                  getTxt(mahsulot.kategoriya),
                  isDark,
                ),

                _buildDetailItem(
                  getTxt("Keshbek"),
                  mahsulot.keshbek,
                  isDark,
                ),

                _buildDetailItem(
                  getTxt("Status"),
                  getTxt(mahsulot.status),
                  isDark,
                ),
              ],
            ),
          ),

          actions: [
            // O'CHIRISH VA TAHRIRLASH
            // FAQAT ADMIN UCHUN
            if (isAdmin)
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration:
                        BoxDecoration(
                          color: Colors.red
                              .withValues(
                            alpha: 0.1,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(15),
                          border: Border.all(
                            color: Colors.red
                                .withValues(
                              alpha: 0.5,
                            ),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius:
                          BorderRadius
                              .circular(15),
                          onTap: () {
                            _showDeleteConfirmationDialog(
                              context,
                              lang,
                              index,
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              Text(
                                getTxt(
                                    "O'chirish"),
                                style:
                                const TextStyle(
                                  color:
                                  Colors.red,
                                  fontWeight:
                                  FontWeight
                                      .w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        height: 45,
                        decoration:
                        BoxDecoration(
                          color: (isDark
                              ? const Color(
                              0xFF3C8DFF)
                              : Colors.indigo)
                              .withValues(
                            alpha: 0.1,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(15),
                          border: Border.all(
                            color: (isDark
                                ? const Color(
                                0xFF3C8DFF)
                                : Colors.indigo)
                                .withValues(
                              alpha: 0.5,
                            ),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius:
                          BorderRadius
                              .circular(15),
                          onTap: () {
                            Navigator.pop(
                                context);

                            final provider =
                            context.read<
                                MahsulotProvider>();

                            provider
                                .tahrirlashIndex =
                                index;

                            provider
                                .mahsulotController
                                .text =
                                mahsulot.nomi;

                            provider
                                .bemorNarxController
                                .text =
                                mahsulot.bemorNarxi;

                            provider
                                .shifokorNarxController
                                .text =
                                mahsulot.shifokorNarxi;

                            provider
                                .keshbekController
                                .text =
                                mahsulot.keshbek;

                            provider.setKategoriya(
                              mahsulot
                                  .kategoriya,
                            );

                            provider.setStatus(
                              mahsulot.status,
                            );

                            provider.imageFile =
                            mahsulot.rasm !=
                                null
                                ? File(
                              mahsulot
                                  .rasm!,
                            )
                                : null;

                            _showProductDialog(
                              context,
                              lang,
                              isEditing: true,
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              Text(
                                getTxt(
                                    "Tahrirlash"),
                                style:
                                TextStyle(
                                  color: isDark
                                      ? const Color(
                                      0xFF3C8DFF)
                                      : Colors
                                      .indigo,
                                  fontWeight:
                                  FontWeight
                                      .w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: Text(
                  getTxt("Bekor qilish"),
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(
      String label,
      String value,
      bool isDark,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight:
              FontWeight.bold,
              color: isDark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(
      BuildContext context,
      String lang, {
        bool isEditing = false,
      }) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ??
            key;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF252836)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
            side: isDark
                ? const BorderSide(
              color: Color(0xFF3A3F4B),
            )
                : BorderSide.none,
          ),
          title: Center(
            child: Text(
              isEditing
                  ? getTxt("Tahrirlash")
                  : getTxt("Mahsulot qo'shish"),
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.indigo,
                fontWeight:
                FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width:
              MediaQuery.of(context)
                  .size
                  .width *
                  0.9,
              constraints:
              const BoxConstraints(
                maxWidth: 400,
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor:
                        isDark
                            ? const Color(
                            0xFF181A20)
                            : Colors.white,
                        builder:
                            (bottomContext) {
                          return Container(
                            height: 150,
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              const BorderRadius
                                  .vertical(
                                top: Radius
                                    .circular(
                                  20,
                                ),
                              ),
                              color: isDark
                                  ? const Color(
                                  0xFF181A20)
                                  : Colors.white,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading:
                                  Icon(
                                    Icons
                                        .camera_alt,
                                    color: isDark
                                        ? Colors
                                        .white70
                                        : Colors
                                        .black,
                                  ),
                                  title: Text(
                                    getTxt(
                                        "Kamera"),
                                    style:
                                    TextStyle(
                                      color: isDark
                                          ? Colors
                                          .white
                                          : Colors
                                          .black,
                                    ),
                                  ),
                                  onTap: () {
                                    context
                                        .read<
                                        MahsulotProvider>()
                                        .rasmTanlash(
                                      context,
                                      ImageSource
                                          .camera,
                                    );

                                    Navigator.pop(
                                        bottomContext);
                                  },
                                ),
                                ListTile(
                                  leading:
                                  Icon(
                                    Icons.photo,
                                    color: isDark
                                        ? Colors
                                        .white70
                                        : Colors
                                        .black,
                                  ),
                                  title: Text(
                                    getTxt(
                                        "Galereya"),
                                    style:
                                    TextStyle(
                                      color: isDark
                                          ? Colors
                                          .white
                                          : Colors
                                          .black,
                                    ),
                                  ),
                                  onTap: () {
                                    context
                                        .read<
                                        MahsulotProvider>()
                                        .rasmTanlash(
                                      context,
                                      ImageSource
                                          .gallery,
                                    );

                                    Navigator.pop(
                                        bottomContext);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Consumer<
                        MahsulotProvider>(
                      builder: (
                          context,
                          provider,
                          child,
                          ) {
                        return Card(
                          elevation: 0,
                          clipBehavior:
                          Clip.antiAlias,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                          child: Container(
                            width: 120,
                            height: 120,
                            color: isDark
                                ? const Color(
                                0xFF2A2E38)
                                : Colors.blue
                                .shade100,
                            child: Center(
                              child: provider
                                  .imageFile !=
                                  null
                                  ? Image.file(
                                provider
                                    .imageFile!,
                                fit: BoxFit
                                    .cover,
                              )
                                  : Icon(
                                Icons
                                    .add_a_photo,
                                size: 40,
                                color: isDark
                                    ? Colors
                                    .white24
                                    : Colors
                                    .white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildTextField(
                    context,
                    controller: context
                        .read<
                        MahsulotProvider>()
                        .mahsulotController,
                    hintText:
                    getTxt("Mahsulot nomi"),
                  ),

                  const SizedBox(height: 10),

                  _buildTextField(
                    context,
                    controller: context
                        .read<
                        MahsulotProvider>()
                        .bemorNarxController,
                    hintText:
                    getTxt("Bemor narxi"),
                    keyboardType:
                    TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                        locale: 'uz',
                        decimalDigits: 0,
                        symbol: '',
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  _buildTextField(
                    context,
                    controller: context
                        .read<
                        MahsulotProvider>()
                        .shifokorNarxController,
                    hintText:
                    getTxt("Shifokor narxi"),
                    keyboardType:
                    TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                        locale: 'uz',
                        decimalDigits: 0,
                        symbol: '',
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  _buildDropdown(
                    context,
                    lang: lang,
                    value: context
                        .watch<
                        MahsulotProvider>()
                        .selectedKategoriya,
                    items: ["Umumiy"],
                    hintText:
                    getTxt("Kategoriya"),
                    onChanged: (val) {
                      if (val != null) {
                        context
                            .read<
                            MahsulotProvider>()
                            .setKategoriya(val);
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  _buildTextField(
                    context,
                    controller: context
                        .read<
                        MahsulotProvider>()
                        .keshbekController,
                    hintText:
                    getTxt("Keshbek"),
                    keyboardType:
                    TextInputType.number,
                  ),

                  const SizedBox(height: 10),

                  _buildDropdown(
                    context,
                    lang: lang,
                    value: context
                        .watch<
                        MahsulotProvider>()
                        .selectedStatus,
                    items: [
                      "Faol",
                      "Nofaol",
                    ],
                    hintText:
                    getTxt("Status"),
                    onChanged: (val) {
                      if (val != null) {
                        context
                            .read<
                            MahsulotProvider>()
                            .setStatus(val);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child:
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            isDark
                                ? const Color(
                                0xFF3A3F4B)
                                : Colors.grey,
                            elevation: 0,
                          ),
                          onPressed: () {
                            context
                                .read<
                                MahsulotProvider>()
                                .tozalash();

                            Navigator.pop(
                                context);
                          },
                          child: Text(
                            getTxt(
                                "Bekor qilish"),
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          width: 10),

                      Expanded(
                        child:
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            isDark
                                ? const Color(
                                0xFF3C8DFF)
                                : Colors.indigo,
                            elevation: 0,
                          ),
                          onPressed: () {
                            final provider =
                            context.read<
                                MahsulotProvider>();

                            if (provider
                                .tekshir()) {
                              final mahsulot =
                              MahsulotModel(
                                id: isEditing &&
                                    provider
                                        .tahrirlashIndex !=
                                        null
                                    ? provider
                                    .mahsulotlar[
                                provider
                                    .tahrirlashIndex!]
                                    .id
                                    : null,
                                nomi: provider
                                    .mahsulotController
                                    .text,
                                bemorNarxi: provider
                                    .bemorNarxController
                                    .text,
                                shifokorNarxi:
                                provider
                                    .shifokorNarxController
                                    .text,
                                kategoriya: provider
                                    .selectedKategoriya,
                                keshbek: provider
                                    .keshbekController
                                    .text,
                                status: provider
                                    .selectedStatus,
                                rasm: provider
                                    .imageFile
                                    ?.path,
                              );

                              if (isEditing &&
                                  provider
                                      .tahrirlashIndex !=
                                      null) {
                                provider
                                    .tahrirlash(
                                  provider
                                      .tahrirlashIndex!,
                                  mahsulot,
                                )
                                    .then(
                                      (_) {
                                    provider
                                        .tozalash();

                                    Navigator.pop(
                                        context);
                                  },
                                )
                                    .catchError(
                                      (e) {
                                    ScaffoldMessenger
                                        .of(
                                        context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                        Colors.red,
                                        content:
                                        Text(
                                          e
                                              .toString()
                                              .replaceAll(
                                            'Exception: ',
                                            '',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                provider
                                    .qoshish(
                                  mahsulot,
                                )
                                    .then(
                                      (_) {
                                    provider
                                        .tozalash();

                                    Navigator.pop(
                                        context);
                                  },
                                )
                                    .catchError(
                                      (e) {
                                    ScaffoldMessenger
                                        .of(
                                        context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                        Colors.red,
                                        content:
                                        Text(
                                          e
                                              .toString()
                                              .replaceAll(
                                            'Exception: ',
                                            '',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                  Colors.red,
                                  content: Text(
                                    getTxt(
                                      "Ma'lumotlarni to'liq kiriting",
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            isEditing
                                ? getTxt(
                                "Yangilash")
                                : getTxt(
                                "Saqlash"),
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
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
        );
      },
    );
  }

  Widget _buildDropdown(
      BuildContext context, {
        required String lang,
        required String value,
        required List<String> items,
        required String hintText,
        required ValueChanged<String?>
        onChanged,
      }) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    String getTxt(String key) =>
        MahsulotlarPages._localizedTexts[lang]?[key] ??
            key;

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2A2E38)
            : null,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A3F4B)
              : Colors.grey,
        ),
      ),
      child:
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: isDark
              ? const Color(0xFF252836)
              : Colors.white,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
          ),
          items: items.map(
                (String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  getTxt(item),
                ),
              );
            },
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController
        controller,
        required String hintText,
        TextInputType keyboardType =
            TextInputType.text,
        List<CurrencyTextInputFormatter>?
        inputFormatters,
      }) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters:
      inputFormatters,
      style: TextStyle(
        color: isDark
            ? Colors.white
            : Colors.black,
      ),
      decoration:
      InputDecoration(
        hintText: hintText,
        hintStyle:
        TextStyle(
          color: isDark
              ? Colors.white38
              : Colors.grey,
        ),
        filled: isDark,
        fillColor: isDark
            ? const Color(0xFF2A2E38)
            : null,
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: isDark
              ? const BorderSide(
            color:
            Color(0xFF3A3F4B),
          )
              : const BorderSide(),
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: isDark
              ? const BorderSide(
            color:
            Color(0xFF3A3F4B),
          )
              : const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide:
          BorderSide(
            color: isDark
                ? const Color(
              0xFF3C8DFF,
            )
                : Colors.indigo,
          ),
        ),
      ),
    );
  }
}