import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/model_provider.dart';
import '../model/mahsulot_modeli.dart';
import '../model/finished_product_model.dart';

class OmborPages extends StatefulWidget {
  const OmborPages({super.key});

  @override
  State<OmborPages> createState() => _OmborPagesState();

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "Ombor": "Ombor",
      "Ma'lumot kiritilmagan": "Ma'lumot kiritilmagan",
      "Tugagan mahsulotlar": "Tugagan mahsulotlar",
      "1-Bo'lim": "1-Bo'lim",
      "2-Bo'lim": "2-Bo'lim",
      "Mahsulot qo'shish": "Mahsulot qo'shish",
      "Mahsulot nomi": "Mahsulot nomi",
      "Sanani kiriting": "Sanani kiriting",
      "Mahsulot soni": "Mahsulot soni",
      "Bekor qilish": "Bekor qilish",
      "Saqlash": "Saqlash",
      "Soni": "Soni",
      "Narxi": "Narxi",
      "so'm": "so'm",
      "Miqdor 0 dan katta bo'lishi kerak": "Miqdor 0 dan katta bo'lishi kerak",
      "Bunday mahsulot bazada mavjud emas": "Bunday mahsulot bazada mavjud emas",
      "Iltimos, barcha maydonlarni to'ldiring": "Iltimos, barcha maydonlarni to'ldiring",
    },
    "Rus": {
      "Ombor": "Склад",
      "Ma'lumot kiritilmagan": "Данные не введены",
      "Tugagan mahsulotlar": "Закончившиеся товары",
      "1-Bo'lim": "1-Отдел",
      "2-Bo'lim": "2-Отдел",
      "Mahsulot qo'shish": "Добавить продукт",
      "Mahsulot nomi": "Название продукта",
      "Sanani kiriting": "Введите дату",
      "Mahsulot soni": "Количество продукта",
      "Bekor qilish": "Отмена",
      "Saqlash": "Сохранить",
      "Soni": "Кол-во",
      "Narxi": "Цена",
      "so'm": "сум",
      "Miqdor 0 dan katta bo'lishi kerak": "Количество должно быть больше 0",
      "Bunday mahsulot bazada mavjud emas": "Такого продукта нет в базе",
      "Iltimos, barcha maydonlarni to'ldiring": "Пожалуйста, заполните все поля",
    },
    "Kiril": {
      "Ombor": "Омбор",
      "Ma'lumot kiritilmagan": "Маълумот киритилмаган",
      "Tugagan mahsulotlar": "Тугаган маҳсулотлар",
      "1-Bo'lim": "1-Бўлим",
      "2-Bo'lim": "2-Бўлим",
      "Mahsulot qo'shish": "Маҳсулот қўшиш",
      "Mahsulot nomi": "Маҳсулот номи",
      "Sanani kiriting": "Санани киритинг",
      "Mahsulot soni": "Маҳсулот сони",
      "Bekor qilish": "Бекор қилиш",
      "Saqlash": "Сақлаш",
      "Soni": "Сони",
      "Narxi": "Нархи",
      "so'm": "сўм",
      "Miqdor 0 дан катта бўлиши керак": "Миқдор 0 дан катта бўлиши керак",
      "Бундай маҳсулот базада мавжуд эмас": "Бундай маҳсулот базада мавжуд эмас",
      "Iltimos, barcha maydonlarni to'ldiring": "Илтимос, барча майдонларни тўлдиринг",
    },
  };

  static String getTxt(BuildContext context, String key) {
    return _localizedTexts[Provider.of<ProfileProvider>(context, listen: false).language]?[key] ?? key;
  }
}

class _OmborPagesState extends State<OmborPages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MahsulotProvider>().loadProducts();
      context.read<FinishedProductProvider>().fetchFinishedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mahsulotProvider = context.watch<MahsulotProvider>();
    final finishedProductProvider = context.watch<FinishedProductProvider>();
    
    // API'dan kelgan tayyor mahsulotlarni catalog mahsulotlari bilan moslashtiramiz
    final allProducts = mahsulotProvider.mahsulotlar;
    final finishedProducts = finishedProductProvider.finishedProducts;

    // Tugagan mahsulotlar: Catalog mahsulotlari orasidan stock (zaxira) 0 bo'lganlarini olamiz
    final tugaganMahsulotlar = allProducts.where((p) => p.zaxira <= 0).toList();
    
    // Tayyor mahsulotlar: Catalog mahsulotlari orasidan stock (zaxira) > 0 bo'lganlarini olamiz
    final tayyorMahsulotlar = allProducts.where((p) => p.zaxira > 0).toList();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.07,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
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
                  onTap: () {
                    _showAddProductDialog(context, mahsulotProvider, finishedProductProvider, isDark);
                  },
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
      body: SafeArea(
        child: (mahsulotProvider.isLoading || finishedProductProvider.isLoading)
            ? const Center(child: CircularProgressIndicator())
            : allProducts.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 80.r,
                            color: isDark ? Colors.white24 : Colors.grey.shade400,
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            OmborPages.getTxt(context, "Ma'lumot kiritilmagan"),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white54 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await mahsulotProvider.loadProducts();
                          await finishedProductProvider.fetchFinishedProducts();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth > 800 ? 800 : constraints.maxWidth,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      OmborPages.getTxt(context, "Tugagan mahsulotlar"),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red
                                      ),
                                    ),
                                    Card(
                                      elevation: 10,
                                      shadowColor: isDark ? Colors.black26 : null,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Container(
                                        height: 155.h,
                                        padding: EdgeInsets.all(10.r),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF252836) : Colors.white,
                                          border: isDark ? Border.all(color: const Color(0xFF3A3F4B)) : null,
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: tugaganMahsulotlar.isEmpty
                                            ? Center(child: Text(OmborPages.getTxt(context, "Ma'lumot kiritilmagan")))
                                            : ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: tugaganMahsulotlar.length,
                                                itemBuilder: (context, index) {
                                                  final m = tugaganMahsulotlar[index];
                                                  return Padding(
                                                    padding: EdgeInsets.only(right: 10.w),
                                                    child: SizedBox(
                                                      width: 80.w,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 80.w,
                                                            height: 80.h,
                                                            decoration: BoxDecoration(
                                                              color: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade300,
                                                              borderRadius: BorderRadius.circular(20.r),
                                                              image: m.rasm != null ? DecorationImage(image: NetworkImage(m.rasm!), fit: BoxFit.cover) : null,
                                                            ),
                                                            child: m.rasm == null
                                                                ? Center(
                                                                    child: Text(
                                                                      m.nomi.isNotEmpty ? m.nomi[0].toUpperCase() : "?",
                                                                      style: TextStyle(
                                                                        fontSize: 30.sp,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: isDark ? Colors.white54 : Colors.grey,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : null,
                                                          ),
                                                          SizedBox(height: 5.h),
                                                          Text(
                                                            m.nomi,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: isDark ? Colors.white : Colors.black,
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildTayyorMahsulotlarCard(context, OmborPages.getTxt(context, "Tayyor mahsulotlar"), tayyorMahsulotlar, isDark),
                                    SizedBox(height: 130.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, MahsulotProvider mahsulotProvider, FinishedProductProvider finishedProductProvider, bool isDark) {
    MahsulotModel? selectedProduct;
    final soniController = TextEditingController();
    final dateController = TextEditingController(text: DateFormat('dd.MM.yyyy').format(DateTime.now()));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF252836) : Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: isDark ? BorderSide(color: const Color(0xFF3A3F4B)) : BorderSide.none,
          ),
          title: Center(
            child: Text(
              OmborPages.getTxt(context, "Mahsulot qo'shish"),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Autocomplete<MahsulotModel>(
                    displayStringForOption: (m) => m.nomi,
                    optionsBuilder: (textValue) {
                      if (textValue.text.isEmpty) return const Iterable<MahsulotModel>.empty();
                      return mahsulotProvider.mahsulotlar.where((m) => m.nomi.toLowerCase().contains(textValue.text.toLowerCase()));
                    },
                    onSelected: (m) => selectedProduct = m,
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return _buildTextField(
                        controller: controller,
                        hint: OmborPages.getTxt(context, "Mahsulot nomi"),
                        isDark: isDark,
                        focusNode: focusNode,
                      );
                    },
                  ),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    controller: dateController,
                    hint: OmborPages.getTxt(context, "Sanani kiriting"),
                    isDark: isDark,
                    readOnly: true,
                  ),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    controller: soniController,
                    hint: OmborPages.getTxt(context, "Mahsulot soni"),
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF3A3F4B) : Colors.grey,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      OmborPages.getTxt(context, "Bekor qilish"),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final soni = int.tryParse(soniController.text) ?? 0;

                      if (selectedProduct != null && soni > 0) {
                        try {
                          await finishedProductProvider.addFinishedProduct(
                            productId: selectedProduct!.id!,
                            quantity: soni,
                          );
                          if (context.mounted) {
                            await context.read<MahsulotProvider>().loadProducts();
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                            );
                          }
                        }
                      } else {
                        String error = "";
                        if (soni <= 0) {
                          error = OmborPages.getTxt(context, "Miqdor 0 dan katta bo'lishi kerak");
                        } else if (selectedProduct == null) {
                          error = OmborPages.getTxt(context, "Bunday mahsulot bazada mavjud emas");
                        } else {
                          error = OmborPages.getTxt(context, "Iltimos, barcha maydonlarni to'ldiring");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error), backgroundColor: Colors.red),
                        );
                      }
                    },
                    child: Text(
                      OmborPages.getTxt(context, "Saqlash"),
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
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo),
        ),
      ),
    );
  }

  Widget _buildTayyorMahsulotlarCard(BuildContext context, String title, List<MahsulotModel> products, bool isDark) {
    return Card(
      elevation: 10,
      shadowColor: isDark ? Colors.black26 : null,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252836) : Colors.white,
          border: isDark ? Border.all(color: const Color(0xFF3A3F4B)) : null,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: isDark ? Colors.white : Colors.black,
                )
              ),
            ),
            Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.indigo),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final m = products[index];
                
                final zaxira = m.zaxira;
                final narxFormat = NumberFormat('#,###').format(int.tryParse(m.bemorNarxi.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Row(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade200,
                              image: m.rasm != null ? DecorationImage(image: NetworkImage(m.rasm!), fit: BoxFit.cover) : null,
                            ),
                            child: m.rasm == null
                                ? Center(
                                    child: Text(
                                      m.nomi.isNotEmpty ? m.nomi[0].toUpperCase() : "?",
                                      style: TextStyle(
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white24 : Colors.grey,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.nomi,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.sp,
                                    color: isDark ? Colors.white : Colors.indigo
                                  )
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "${OmborPages.getTxt(context, "Soni")}: $zaxira",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: isDark ? Colors.white70 : Colors.black,
                                  )
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "${OmborPages.getTxt(context, "Narxi")}: $narxFormat ${OmborPages.getTxt(context, "so'm")}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index != products.length - 1)
                      Divider(color: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade300),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
