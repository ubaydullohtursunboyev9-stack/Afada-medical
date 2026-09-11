import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/model_provider.dart';

import '../../provider/profile_provider.dart';

class DraverOmborPages extends StatefulWidget {
  const DraverOmborPages({super.key});

  @override
  State<DraverOmborPages> createState() => _DraverOmborPagesState();
}

class _DraverOmborPagesState extends State<DraverOmborPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'warehouse': 'Ombor',
      'in_stock': 'Zaxirada:',
      'pcs': 'dona',
      'price': 'Narxi:',
      'search': 'Qidirish...',
      'no_product': 'Mahsulot topilmadi',
    },
    'Rus': {
      'warehouse': 'Склад',
      'in_stock': 'В наличии:',
      'pcs': 'шт',
      'price': 'Цена:',
      'search': 'Поиск...',
      'no_product': 'Товар не найден',
    },
    'Kiril': {
      'warehouse': 'Омбор',
      'in_stock': 'Захирада:',
      'pcs': 'дона',
      'price': 'Нархи:',
      'search': 'Қидириш...',
      'no_product': 'Маҳсулот топилмади',
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? _localizedTexts['Uzb']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String language = context.watch<ProfileProvider>().language;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF181A20) : Colors.indigo,
        foregroundColor: Colors.white,
        title: Text(getTxt(language, 'warehouse'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp)),
      ),
      body: Consumer<MahsulotProvider>(
        builder: (context, mahsulotProv, child) {
          final filteredMahsulotlar = mahsulotProv.mahsulotlar.where((m) {
            final query = _searchQuery.toLowerCase();
            return m.nomi.toLowerCase().contains(query);
          }).toList();
          
          filteredMahsulotlar.sort((a, b) {
            int aZaxira = mahsulotProv.getZaxira(a);
            int bZaxira = mahsulotProv.getZaxira(b);
            if (aZaxira == 0 && bZaxira != 0) return 1;
            if (aZaxira != 0 && bZaxira == 0) return -1;
            return 0;
          });

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 5.h),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF252836) : Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: isDark ? null : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: getTxt(language, 'search'),
                      hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey,
                          fontSize: 16.sp),
                      prefixIcon: Icon(Icons.search,
                          color: isDark ? Colors.white54 : Colors.indigo),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  color: isDark ? Colors.white54 : Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredMahsulotlar.isEmpty
                    ? Center(
                        child: Text(
                          getTxt(language, 'no_product'),
                          style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredMahsulotlar.length,
                        itemBuilder: (context, index) {
                          final m = filteredMahsulotlar[index];
                          final zaxira = mahsulotProv.getZaxira(m);
                          final narxFormat = NumberFormat('#,###').format(
                              int.tryParse(m.bemorNarxi.replaceAll(
                                      RegExp(r'[^0-9]'), '')) ??
                                  0);

                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF252836) : Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              border: zaxira == 0
                                  ? Border.all(color: Colors.red, width: 2.w)
                                  : (isDark
                                      ? Border.all(
                                          color: const Color(0xFF3A3F4B),
                                          width: 1.w)
                                      : null),
                              boxShadow: isDark
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 70.w,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: isDark
                                        ? const Color(0xFF2A2E38)
                                        : Colors.grey.shade200,
                                    image: m.rasm != null
                                        ? DecorationImage(
                                            image: FileImage(File(m.rasm!)),
                                            fit: BoxFit.cover)
                                        : null,
                                  ),
                                  child: m.rasm == null
                                      ? Icon(Icons.image,
                                          size: 30.r,
                                          color: isDark
                                              ? Colors.white24
                                              : Colors.grey)
                                      : null,
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(m.nomi,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black)),
                                      Text(
                                          "${getTxt(language, 'in_stock')} $zaxira ${getTxt(language, 'pcs')}",
                                          style: TextStyle(
                                              color: zaxira == 0
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp)),
                                      Text(
                                          "${getTxt(language, 'price')} $narxFormat UZS",
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              fontSize: 13.sp)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

