import 'dart:io';
import 'dart:ui';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/model_provider.dart';
import '../../provider/profile_provider.dart';

class DraverMahsulotlarPages extends StatefulWidget {
  const DraverMahsulotlarPages({super.key});

  @override
  State<DraverMahsulotlarPages> createState() =>
      _DraverMahsulotlarPagesState();
}

class _DraverMahsulotlarPagesState extends State<DraverMahsulotlarPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MahsulotProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      "Ma'lumotlarni to'liq kiriting":
      "Ma'lumotlarni to'liq kiriting",
      "UZS": "so'm",
      "Mahsulotni o'chirish": "Mahsulotni o'chirish",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?",
      "Qidirish...": "Qidirish...",
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
      "Ma'lumotlarni to'liq kiriting":
      "Введите данные полностью",
      "UZS": "сум",
      "Mahsulotni o'chirish": "Удаление товара",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Вы действительно хотите удалить этот товар?",
      "Qidirish...": "Поиск...",
      "Mahsulot topilmadi": "Товар не найден",
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
      "Ma'lumotlarni to'liq kiriting":
      "Маълумотларни тўлиқ киритинг",
      "UZS": "Сўм",
      "Mahsulotni o'chirish": "Маҳсулотни ўчириш",
      "Haqiqatan ham ushbu mahsulotni o'chirmoqchimisiz?":
      "Ҳақиқатан ҳам ушбу маҳсулотни ўчирмоқчимисиз?",
      "Qidirish...": "Қидириш...",
      "Mahsulot topilmadi": "Маҳсулот топилмади",
    },
  };

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final profile = context.watch<ProfileProvider>();

    final bool isAdmin =
        profile.role.trim().toLowerCase() == "admin";

    final lang = profile.language;

    String getTxt(String key) =>
        _localizedTexts[lang]?[key] ?? key;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF1E2127) : Colors.white,

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          getTxt("Mahsulot"),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
        isDark ? const Color(0xFF1E2127) : Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              10.h,
              16.w,
              5.h,
            ),
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2A2E38)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: TextStyle(
                  color:
                  isDark ? Colors.white : Colors.black,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: getTxt("Qidirish..."),
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white54
                        : Colors.grey,
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark
                        ? Colors.white54
                        : Colors.indigo,
                    size: 22.r,
                  ),
                  suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: isDark
                          ? Colors.white54
                          : Colors.grey,
                      size: 20.r,
                    ),
                    onPressed: () {
                      _searchController.clear();

                      setState(() {
                        _searchQuery = "";
                      });
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),

          Expanded(
            child: _buildProductList(
              context,
              isAdmin: isAdmin,
            ),
          ),
        ],
      ),

      // FAQAT ADMIN UCHUN
      floatingActionButton: isAdmin
          ? Padding(
        padding: EdgeInsets.only(
          bottom:
          MediaQuery.of(context).size.height * 0.03,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color:
                Colors.white.withValues(alpha: 0.12),
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

                    _showProductDialog(context);
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
      )
          : null,
    );
  }

  Widget _buildProductList(
      BuildContext context, {
        required bool isAdmin,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang =
        context.watch<ProfileProvider>().language;

    String getTxt(String key) =>
        _localizedTexts[lang]?[key] ?? key;

    return Consumer<MahsulotProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final filteredMahsulotlar =
        provider.mahsulotlar.where((m) {
          final query =
          _searchQuery.toLowerCase();

          return m.nomi
              .toLowerCase()
              .contains(query) ||
              m.kategoriya
                  .toLowerCase()
                  .contains(query);
        }).toList();

        if (filteredMahsulotlar.isEmpty) {
          return Center(
            child: Text(
              getTxt("Mahsulot topilmadi"),
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.black,
              ),
            ),
          );
        }

        return ListView.builder(
          physics:
          const BouncingScrollPhysics(),
          itemCount:
          filteredMahsulotlar.length,
          itemBuilder:
              (context, index) {
            final mahsulot =
            filteredMahsulotlar[index];

            final originalIndex =
            provider.mahsulotlar
                .indexOf(mahsulot);

            return InkWell(
              onTap: () {
                _showProductDetailsDialog(
                  context,
                  originalIndex,
                  mahsulot,
                  isAdmin: isAdmin,
                );
              },
              child: Container(
                width: double.infinity,
                margin:
                const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          margin:
                          const EdgeInsets.only(
                            left: 10,
                            top: 5,
                          ),
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                              25,
                            ),
                            color: isDark
                                ? const Color(
                              0xFF2A2E38,
                            )
                                : Colors.grey.shade300,
                            image: mahsulot.rasm != null
                                ? DecorationImage(
                              image: FileImage(
                                File(
                                  mahsulot.rasm!,
                                ),
                              ),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: mahsulot.rasm ==
                              null
                              ? Center(
                            child: Text(
                              mahsulot.nomi
                                  .isNotEmpty
                                  ? mahsulot
                                  .nomi[0]
                                  .toUpperCase()
                                  : "?",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight:
                                FontWeight.bold,
                                color: isDark
                                    ? const Color(
                                  0xFF3C8DFF,
                                )
                                    : Colors.indigo,
                              ),
                            ),
                          )
                              : null,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(
                              right: 10,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child:
                                      FittedBox(
                                        fit: BoxFit
                                            .scaleDown,
                                        alignment:
                                        Alignment
                                            .centerLeft,
                                        child: Text(
                                          mahsulot.nomi,
                                          maxLines: 1,
                                          style:
                                          TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            fontSize: 18,
                                            color: isDark
                                                ? const Color(
                                              0xFF3C8DFF,
                                            )
                                                : Colors
                                                .indigo,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                _productPriceRow(
                                  getTxt("Bemor narxi"),
                                  "${mahsulot.bemorNarxi} ${getTxt("UZS")}",
                                  isDark,
                                ),

                                _productPriceRow(
                                  getTxt("Shifokor narxi"),
                                  "${mahsulot.shifokorNarxi} ${getTxt("UZS")}",
                                  isDark,
                                ),

                                _productPriceRow(
                                  getTxt("Keshbek"),
                                  "${mahsulot.keshbek} ${getTxt("UZS")}",
                                  isDark,
                                ),

                                _productPriceRow(
                                  getTxt("Kategoriya"),
                                  getTxt(
                                    mahsulot.kategoriya,
                                  ),
                                  isDark,
                                  valueColor: isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Divider(
                      color: isDark
                          ? const Color(0xFF3A3F4B)
                          : Colors.black26,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _productPriceRow(
      String label,
      String value,
      bool isDark, {
        Color? valueColor,
      }) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              "$label: ",
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.greenAccent
                    : Colors.green,
              ),
            ),
            Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ??
                    (isDark
                        ? Colors.white
                        : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetailsDialog(
      BuildContext context,
      int index,
      MahsulotModel mahsulot, {
        required bool isAdmin,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang =
        context.read<ProfileProvider>().language;

    String getTxt(String key) =>
        _localizedTexts[lang]?[key] ?? key;

    final provider =
    context.read<MahsulotProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          isDark
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
          contentPadding:
          const EdgeInsets.all(20),
          content: Container(
            width:
            MediaQuery.of(context).size.width *
                0.9,
            constraints:
            const BoxConstraints(
              maxWidth: 400,
            ),
            child:
            SingleChildScrollView(
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                      color: isDark
                          ? const Color(
                        0xFF2A2E38,
                      )
                          : Colors.indigo.shade50,
                      image:
                      mahsulot.rasm != null
                          ? DecorationImage(
                        image:
                        FileImage(
                          File(
                            mahsulot.rasm!,
                          ),
                        ),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child:
                    mahsulot.rasm == null
                        ? Center(
                      child: Text(
                        mahsulot.nomi
                            .isNotEmpty
                            ? mahsulot
                            .nomi[0]
                            .toUpperCase()
                            : "?",
                        style:
                        TextStyle(
                          fontSize: 45,
                          fontWeight:
                          FontWeight
                              .bold,
                          color: isDark
                              ? const Color(
                            0xFF3C8DFF,
                          )
                              : Colors
                              .indigo,
                        ),
                      ),
                    )
                        : null,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    mahsulot.nomi,
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Colors.indigo,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _detailRow(
                    getTxt("Bemor narxi"),
                    "${mahsulot.bemorNarxi} ${getTxt("UZS")}",
                    isDark,
                  ),

                  _detailRow(
                    getTxt("Shifokor narxi"),
                    "${mahsulot.shifokorNarxi} ${getTxt("UZS")}",
                    isDark,
                  ),

                  _detailRow(
                    getTxt("Kategoriya"),
                    getTxt(mahsulot.kategoriya),
                    isDark,
                  ),

                  _detailRow(
                    getTxt("Keshbek"),
                    "${mahsulot.keshbek} ${getTxt("UZS")}",
                    isDark,
                  ),

                  _detailRow(
                    getTxt("Status"),
                    getTxt(mahsulot.status),
                    isDark,
                    valueColor:
                    mahsulot.status == "Faol"
                        ? Colors.green
                        : Colors.red,
                  ),

                  // FAQAT ADMIN UCHUN
                  if (isAdmin) ...[
                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(
                          child:
                          OutlinedButton(
                            style:
                            OutlinedButton.styleFrom(
                              side:
                              const BorderSide(
                                color: Colors.red,
                              ),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  12,
                                ),
                              ),
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );

                              _showDeleteDialog(
                                context,
                                index,
                              );
                            },
                            child: Text(
                              getTxt(
                                "O'chirish",
                              ),
                              style:
                              const TextStyle(
                                color:
                                Colors.red,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child:
                          ElevatedButton(
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              isDark
                                  ? const Color(
                                0xFF3C8DFF,
                              )
                                  : Colors
                                  .indigo,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  12,
                                ),
                              ),
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 12,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );

                              provider
                                  .tahrirlashUchunYuklash(
                                index,
                              );

                              _showProductDialog(
                                context,
                                isEditing: true,
                              );
                            },
                            child: Text(
                              getTxt(
                                "Tahrirlash",
                              ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
      String label,
      String value,
      bool isDark, {
        Color? valueColor,
      }) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? Colors.white60
                  : Colors.black54,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign:
              TextAlign.end,
              style: TextStyle(
                color: valueColor ??
                    (isDark
                        ? Colors.white
                        : Colors.black87),
                fontWeight:
                FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(
      BuildContext context, {
        bool isEditing = false,
      }) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
        context.read<ProfileProvider>().language;

    String getTxt(String key) =>
        _localizedTexts[lang]?[key] ?? key;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<MahsulotProvider>(
          builder:
              (context, provider, child) {
            return AlertDialog(
              backgroundColor:
              isDark
                  ? const Color(0xFF252836)
                  : Colors.white,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
                side: isDark
                    ? const BorderSide(
                  color: Color(
                    0xFF3A3F4B,
                  ),
                )
                    : BorderSide.none,
              ),
              title: Center(
                child: Text(
                  isEditing
                      ? getTxt(
                    "Tahrirlash",
                  )
                      : getTxt(
                    "Mahsulot qo'shish",
                  ),
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
              content:
              SingleChildScrollView(
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
                              0xFF181A20,
                            )
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
                                    0xFF181A20,
                                  )
                                      : Colors.white,
                                ),
                                child:
                                Column(
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
                                      title:
                                      Text(
                                        getTxt(
                                          "Kamera",
                                        ),
                                        style:
                                        TextStyle(
                                          color: isDark
                                              ? Colors
                                              .white
                                              : Colors
                                              .black,
                                        ),
                                      ),
                                      onTap:
                                          () {
                                        provider
                                            .rasmTanlash(
                                          context,
                                          ImageSource
                                              .camera,
                                        );

                                        Navigator.pop(
                                          bottomContext,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading:
                                      Icon(
                                        Icons
                                            .photo,
                                        color: isDark
                                            ? Colors
                                            .white70
                                            : Colors
                                            .black,
                                      ),
                                      title:
                                      Text(
                                        getTxt(
                                          "Galereya",
                                        ),
                                        style:
                                        TextStyle(
                                          color: isDark
                                              ? Colors
                                              .white
                                              : Colors
                                              .black,
                                        ),
                                      ),
                                      onTap:
                                          () {
                                        provider
                                            .rasmTanlash(
                                          context,
                                          ImageSource
                                              .gallery,
                                        );

                                        Navigator.pop(
                                          bottomContext,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Card(
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
                          child:
                          Container(
                            width: 120,
                            height: 120,
                            color: isDark
                                ? const Color(
                              0xFF2A2E38,
                            )
                                : Colors.blue
                                .shade100,
                            child: Center(
                              child:
                              provider.imageFile !=
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
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _buildTextField(
                        context,
                        controller:
                        provider
                            .mahsulotController,
                        hintText:
                        getTxt(
                          "Mahsulot nomi",
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _buildTextField(
                        context,
                        controller:
                        provider
                            .bemorNarxController,
                        hintText:
                        getTxt(
                          "Bemor narxi",
                        ),
                        keyboardType:
                        TextInputType.number,
                        inputFormatters: [
                          CurrencyTextInputFormatter
                              .currency(
                            locale: 'uz',
                            decimalDigits: 0,
                            symbol: '',
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _buildTextField(
                        context,
                        controller:
                        provider
                            .shifokorNarxController,
                        hintText:
                        getTxt(
                          "Shifokor narxi",
                        ),
                        keyboardType:
                        TextInputType.number,
                        inputFormatters: [
                          CurrencyTextInputFormatter
                              .currency(
                            locale: 'uz',
                            decimalDigits: 0,
                            symbol: '',
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _buildDropdown(
                        context,
                        lang: lang,
                        value: provider
                            .selectedKategoriya,
                        items: [
                          "Umumiy"
                        ],
                        hintText:
                        getTxt(
                          "Kategoriya",
                        ),
                        onChanged:
                            (val) {
                          if (val != null) {
                            provider
                                .setKategoriya(
                              val,
                            );
                          }
                        },
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _buildTextField(
                        context,
                        controller:
                        provider
                            .keshbekController,
                        hintText:
                        getTxt(
                          "Keshbek",
                        ),
                        keyboardType:
                        TextInputType.number,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _buildDropdown(
                        context,
                        lang: lang,
                        value: provider
                            .selectedStatus,
                        items: [
                          "Faol",
                          "Nofaol"
                        ],
                        hintText:
                        getTxt(
                          "Status",
                        ),
                        onChanged:
                            (val) {
                          if (val != null) {
                            provider
                                .setStatus(
                              val,
                            );
                          }
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

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
                                  0xFF3A3F4B,
                                )
                                    : Colors
                                    .grey,
                                elevation: 0,
                              ),
                              onPressed:
                                  () {
                                provider
                                    .tozalash();

                                Navigator.pop(
                                  context,
                                );
                              },
                              child:
                              Text(
                                getTxt(
                                  "Bekor qilish",
                                ),
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child:
                            ElevatedButton(
                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                isDark
                                    ? const Color(
                                  0xFF3C8DFF,
                                )
                                    : Colors
                                    .indigo,
                                elevation: 0,
                              ),
                              onPressed:
                                  () async {
                                if (provider
                                    .tekshir()) {
                                  final mahsulot =
                                  MahsulotModel(
                                    id: isEditing
                                        ? provider
                                        .mahsulotlar[
                                    provider
                                        .tahrirlashIndex!
                                    ]
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
                                    kategoriya:
                                    provider
                                        .selectedKategoriya,
                                    keshbek: provider
                                        .keshbekController
                                        .text,
                                    status: provider
                                        .selectedStatus,
                                    rasm: provider
                                        .imageFile
                                        ?.path,
                                    zaxira: isEditing
                                        ? provider
                                        .mahsulotlar[
                                    provider
                                        .tahrirlashIndex!
                                    ]
                                        .zaxira
                                        : 0,
                                  );

                                  try {
                                    if (isEditing &&
                                        provider
                                            .tahrirlashIndex !=
                                            null) {
                                      await provider
                                          .tahrirlash(
                                        provider
                                            .tahrirlashIndex!,
                                        mahsulot,
                                      );
                                    } else {
                                      await provider
                                          .qoshish(
                                        mahsulot,
                                      );
                                    }

                                    provider
                                        .tozalash();

                                    if (context
                                        .mounted) {
                                      Navigator.pop(
                                        context,
                                      );
                                    }
                                  } catch (e) {
                                    if (context
                                        .mounted) {
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                          Colors.red,
                                          content:
                                          Text(
                                            e.toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } else {
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                      Colors.red,
                                      content:
                                      Text(
                                        getTxt(
                                          "Ma'lumotlarni to'liq kiriting",
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child:
                              Text(
                                isEditing
                                    ? getTxt(
                                  "Yangilash",
                                )
                                    : getTxt(
                                  "Saqlash",
                                ),
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
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      int index,
      ) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
        context.read<ProfileProvider>().language;

    String getTxt(String key) =>
        _localizedTexts[lang]?[key] ?? key;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
        isDark
            ? const Color(0xFF252836)
            : Colors.white,
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
          side: isDark
              ? const BorderSide(
            color: Color(0xFF3A3F4B),
          )
              : BorderSide.none,
        ),
        title: Text(
          getTxt(
            "Mahsulotni o'chirish",
          ),
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
            fontWeight:
            FontWeight.bold,
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
            onPressed: () =>
                Navigator.pop(context),
            child: Text(
              getTxt("Bekor qilish"),
              style:
              const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await context
                    .read<MahsulotProvider>()
                    .ochirish(index);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content:
                      Text(e.toString()),
                      backgroundColor:
                      Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              getTxt("O'chirish"),
              style:
              const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
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
      inputFormatters: inputFormatters,
      style: TextStyle(
        color:
        isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
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
            color: Color(0xFF3A3F4B),
          )
              : const BorderSide(),
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: isDark
              ? const BorderSide(
            color: Color(0xFF3A3F4B),
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
                ? const Color(0xFF3C8DFF)
                : Colors.indigo,
          ),
        ),
      ),
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
        _localizedTexts[lang]?[key] ?? key;

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration:
      BoxDecoration(
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
        child:
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor:
          isDark
              ? const Color(0xFF252836)
              : Colors.white,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
          ),
          items:
          items.map(
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
}