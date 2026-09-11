import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/mijoz_modeli.dart';
import '../../provider/mijoz_provider/mijoz_provider.dart';
import '../../provider/profile_provider.dart';

class DraverKlentPages extends StatefulWidget {
  const DraverKlentPages({super.key});

  @override
  State<DraverKlentPages> createState() => _DraverKlentPagesState();
}

class _DraverKlentPagesState extends State<DraverKlentPages> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "mijozlar": "Mijozlar",
      "galereya": "Galereya",
      "kamera": "Kamera",
      "tel": "Tel:",
      "mijoz_qoshish": "Mijoz qo'shish",
      "mijozni_tahrirlash": "Mijozni tahrirlash",
      "f_i_sh": "F.I.Sh",
      "manzil": "Manzil",
      "jismoniy": "Jismoniy",
      "korporativ": "Korporativ",
      "status": "Status:",
      "faol": "Faol",
      "nofaol": "Nofaol",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "tahrirlash": "Tahrirlash",
      "ochirish": "O'chirish",
      "ism_telefon_majburiy": "Ism va telefon raqami majburiy",
      "ochirishni_tasdiqlang": "O'chirishni tasdiqlang",
      "mijozni_ochirish_savol":
      "Haqiqatan ham ushbu mijozni o'chirmoqchimisiz?",
      "yoq": "Yo'q",
      "ha": "Ha",
      "qidirish": "Qidirish...",
    },
    "Rus": {
      "mijozlar": "Клиенты",
      "galereya": "Галерея",
      "kamera": "Камера",
      "tel": "Тел:",
      "mijoz_qoshish": "Добавить клиента",
      "mijozni_tahrirlash": "Редактировать клиента",
      "f_i_sh": "Ф.И.О",
      "manzil": "Адрес",
      "jismoniy": "Физическое лицо",
      "korporativ": "Корпоративный",
      "status": "Статус:",
      "faol": "Активный",
      "nofaol": "Неактивный",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "tahrirlash": "Редактировать",
      "ochirish": "Удалить",
      "ism_telefon_majburiy": "Имя и номер телефона обязательны",
      "ochirishni_tasdiqlang": "Подтвердите удаление",
      "mijozni_ochirish_savol":
      "Вы действительно хотите удалить этого клиента?",
      "yoq": "Нет",
      "ha": "Да",
      "qidirish": "Поиск...",
    },
    "Kiril": {
      "mijozlar": "Мижозлар",
      "galereya": "Галерея",
      "kamera": "Камера",
      "tel": "Тел:",
      "mijoz_qoshish": "Мижоз қўшиш",
      "mijozni_tahrirlash": "Мижозни таҳрирлаш",
      "f_i_sh": "Ф.И.Ш",
      "manzil": "Манзил",
      "jismoniy": "Жисмоний",
      "korporativ": "Корпоратив",
      "status": "Статус:",
      "faol": "Фаол",
      "nofaol": "Нофаол",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "tahrirlash": "Таҳрирлаш",
      "ochirish": "Ўчириш",
      "ism_telefon_majburiy": "Исм ва телефон рақами мажбурий",
      "ochirishni_tasdiqlang": "Ўчиришни тасдиқланг",
      "mijozni_ochirish_savol":
      "Ҳақиқатан ҳам ушбу мижозни ўчирмоқчимисиз?",
      "yoq": "Йўқ",
      "ha": "Ҳа",
      "qidirish": "Қидириш...",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MijozProvider>().loadMijozlar();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang = context.read<ProfileProvider>().language;

    showModalBottomSheet(
      context: context,
      backgroundColor:
      isDark ? const Color(0xFF252836) : null,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: isDark ? Colors.white : Colors.black,
              ),
              title: Text(
                getTxt(lang, 'galereya'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                context
                    .read<MijozProvider>()
                    .rasmTanlash(
                  context,
                  ImageSource.gallery,
                );

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_camera,
                color: isDark ? Colors.white : Colors.black,
              ),
              title: Text(
                getTxt(lang, 'kamera'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                context
                    .read<MijozProvider>()
                    .rasmTanlash(
                  context,
                  ImageSource.camera,
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final profile = context.watch<ProfileProvider>();

    final lang = profile.language;

    final bool isAdmin =
        profile.role.trim().toLowerCase() == "admin";

    return Scaffold(
      floatingActionButton: isAdmin
          ? Padding(
        padding: const EdgeInsets.only(bottom: 20),
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
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                  Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withValues(
                      alpha: 0.25,
                    ),
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
                        .read<MijozProvider>()
                        .tozalash();

                    _showMijozDialog(context);
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
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.blue.shade100,
      appBar: AppBar(
        title: Text(
          getTxt(lang, "mijozlar"),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: isDark
            ? const Color(0xFF181A20)
            : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<MijozProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading &&
              provider.mijozlar.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final filteredMijozlar =
          provider.mijozlar.where((m) {
            final query = _searchQuery.toLowerCase();

            return m.ism
                .toLowerCase()
                .contains(query) ||
                m.familya
                    .toLowerCase()
                    .contains(query) ||
                m.telefon.contains(query) ||
                m.ishJoyi
                    .toLowerCase()
                    .contains(query);
          }).toList();

          if (provider.errorMessage != null &&
              provider.mijozlar.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        provider.loadMijozlar(),
                    child: const Text("Qayta urinish"),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  5,
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF252836)
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.1,
                        ),
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
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText:
                      getTxt(lang, "qidirish"),
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark
                            ? Colors.white54
                            : Colors.indigo,
                      ),
                      suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark
                              ? Colors.white54
                              : Colors.grey,
                        ),
                        onPressed: () {
                          _searchController
                              .clear();

                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      provider.loadMijozlar(),
                  child: filteredMijozlar.isEmpty
                      ? Center(
                    child: Text(
                      "Mijoz topilmadi",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : Colors.grey,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount:
                    filteredMijozlar.length,
                    itemBuilder:
                        (context, index) {
                      final mijoz =
                      filteredMijozlar[index];

                      return InkWell(
                        onTap: isAdmin
                            ? () {
                          _showMijozDialog(
                            context,
                            mijoz: mijoz,
                          );
                        }
                            : null,
                        child: Card(
                          elevation: 10,
                          margin:
                          const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          clipBehavior:
                          Clip.antiAlias,
                          surfaceTintColor:
                          Colors.transparent,
                          shadowColor: isDark
                              ? Colors.black26
                              : null,
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration:
                            BoxDecoration(
                              color: isDark
                                  ? const Color(
                                0xFF252836,
                              )
                                  : Colors.white,
                              border: isDark
                                  ? Border.all(
                                color:
                                const Color(
                                  0xFF3A3F4B,
                                ),
                              )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    left: 15,
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                    isDark
                                        ? const Color(
                                      0xFF181A20,
                                    )
                                        : Colors
                                        .grey
                                        .shade300,
                                    backgroundImage:
                                    mijoz.rasm !=
                                        null
                                        ? FileImage(
                                      File(
                                        mijoz.rasm!,
                                      ),
                                    )
                                        : null,
                                    child:
                                    mijoz.rasm ==
                                        null
                                        ? (mijoz.ism
                                        .isNotEmpty
                                        ? Text(
                                      mijoz.ism[
                                      0]
                                          .toUpperCase(),
                                      style:
                                      TextStyle(
                                        fontSize:
                                        32,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.indigo,
                                      ),
                                    )
                                        : Icon(
                                      Icons.person,
                                      size:
                                      32,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.indigo,
                                    ))
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets
                                        .only(
                                      top: 15,
                                      left: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          "${mijoz.ism} ${mijoz.familya}",
                                          style:
                                          TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            fontSize: 16,
                                            color: isDark
                                                ? Colors
                                                .white
                                                : Colors
                                                .black,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow
                                              .ellipsis,
                                        ),
                                        Text(
                                          mijoz.ishJoyi,
                                          style:
                                          const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color:
                                            Colors
                                                .green,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow
                                              .ellipsis,
                                        ),
                                        FittedBox(
                                          fit: BoxFit
                                              .scaleDown,
                                          alignment:
                                          Alignment
                                              .centerLeft,
                                          child: Text(
                                            mijoz.mijozTuri ==
                                                "Korporativ"
                                                ? getTxt(
                                              lang,
                                              "korporativ",
                                            )
                                                : getTxt(
                                              lang,
                                              "jismoniy",
                                            ),
                                            style:
                                            TextStyle(
                                              fontSize:
                                              12,
                                              color: mijoz.mijozTuri ==
                                                  "Korporativ"
                                                  ? Colors
                                                  .blue
                                                  : Colors
                                                  .orange,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit
                                              .scaleDown,
                                          alignment:
                                          Alignment
                                              .centerLeft,
                                          child: Text(
                                            "${getTxt(lang, "tel")} +${mijoz.telefon}",
                                            style:
                                            TextStyle(
                                              color: isDark
                                                  ? Colors
                                                  .white70
                                                  : Colors
                                                  .black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _makePhoneCall(
                                      "+${mijoz.telefon.replaceAll(' ', '')}",
                                    );
                                  },
                                  icon:
                                  const Icon(
                                    Icons.call,
                                    color:
                                    Colors.green,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMijozDialog(
      BuildContext context, {
        MijozModel? mijoz,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final provider =
    context.read<MijozProvider>();

    final lang =
        context.read<ProfileProvider>().language;

    if (mijoz != null) {
      provider.controllergaYuklash(mijoz);
    }

    final fullNameController =
    TextEditingController(
      text: mijoz != null
          ? "${mijoz.ism} ${mijoz.familya}".trim()
          : "",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          isDark ? const Color(0xFF252836) : null,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              mijoz == null
                  ? getTxt(
                lang,
                "mijoz_qoshish",
              )
                  : getTxt(
                lang,
                "mijozni_tahrirlash",
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.indigo,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImageSourceActionSheet(
                        context,
                      );
                    },
                    child:
                    Consumer<MijozProvider>(
                      builder:
                          (context, provider, child) {
                        return Card(
                          elevation: 0,
                          color: isDark
                              ? const Color(
                            0xFF2A2E38,
                          )
                              : Colors.blue.shade100,
                          surfaceTintColor:
                          Colors.transparent,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              60,
                            ),
                          ),
                          clipBehavior:
                          Clip.antiAlias,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration:
                            BoxDecoration(
                              color: isDark
                                  ? const Color(
                                0xFF2A2E38,
                              )
                                  : Colors.blue
                                  .shade100,
                              borderRadius:
                              BorderRadius.circular(
                                60,
                              ),
                              border: isDark
                                  ? Border.all(
                                color:
                                const Color(
                                  0xFF3A3F4B,
                                ),
                              )
                                  : null,
                              image: provider
                                  .tanlanganRasm !=
                                  null
                                  ? DecorationImage(
                                image: FileImage(
                                  File(
                                    provider
                                        .tanlanganRasm!,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: provider
                                .tanlanganRasm ==
                                null
                                ? Center(
                              child:
                              ValueListenableBuilder<
                                  TextEditingValue>(
                                valueListenable:
                                fullNameController,
                                builder:
                                    (
                                    context,
                                    value,
                                    child,
                                    ) {
                                  final String
                                  name =
                                  value.text
                                      .trim();

                                  if (name.isEmpty) {
                                    return Icon(
                                      Icons
                                          .add_a_photo,
                                      size: 40,
                                      color: isDark
                                          ? Colors
                                          .white54
                                          : Colors
                                          .indigo
                                          .withValues(
                                        alpha:
                                        0.5,
                                      ),
                                    );
                                  }

                                  return Text(
                                    name[0]
                                        .toUpperCase(),
                                    style:
                                    TextStyle(
                                      fontSize: 40,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color: isDark
                                          ? Colors
                                          .white
                                          : Colors
                                          .indigo,
                                    ),
                                  );
                                },
                              ),
                            )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: fullNameController,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText:
                      getTxt(lang, "f_i_sh"),
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),
                      enabledBorder: isDark
                          ? OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                        const BorderSide(
                          color:
                          Color(0xFF3A3F4B),
                        ),
                      )
                          : null,
                      focusedBorder: isDark
                          ? OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                        const BorderSide(
                          color:
                          Color(0xFF3C8DFF),
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RawAutocomplete<String>(
                    textEditingController:
                    provider.ishJoyiController,
                    focusNode: FocusNode(),
                    optionsBuilder:
                        (TextEditingValue
                    textEditingValue) {
                      if (textEditingValue
                          .text
                          .isEmpty) {
                        return const Iterable<
                            String>.empty();
                      }

                      const uzbCities = [
                        "Toshkent",
                        "Samarqand",
                        "Andijon",
                        "Buxoro",
                        "Farg'ona",
                        "Jizzax",
                        "Namangan",
                        "Navoiy",
                        "Qashqadaryo",
                        "Qoraqalpog'iston",
                        "Sirdaryo",
                        "Surxondaryo",
                        "Xorazm",
                      ];

                      return uzbCities.where(
                            (String option) {
                          return option
                              .toLowerCase()
                              .contains(
                            textEditingValue
                                .text
                                .toLowerCase(),
                          );
                        },
                      );
                    },
                    fieldViewBuilder: (
                        context,
                        controller,
                        focusNode,
                        onFieldSubmitted,
                        ) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration:
                        InputDecoration(
                          hintText:
                          getTxt(lang, "manzil"),
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey,
                          ),
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),
                          ),
                          enabledBorder: isDark
                              ? OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),
                            borderSide:
                            const BorderSide(
                              color: Color(
                                0xFF3A3F4B,
                              ),
                            ),
                          )
                              : null,
                          focusedBorder: isDark
                              ? OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),
                            borderSide:
                            const BorderSide(
                              color: Color(
                                0xFF3C8DFF,
                              ),
                            ),
                          )
                              : null,
                        ),
                      );
                    },
                    optionsViewBuilder: (
                        context,
                        onSelected,
                        options,
                        ) {
                      return Align(
                        alignment:
                        Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          color: isDark
                              ? const Color(
                            0xFF2A2E38,
                          )
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                          child: SizedBox(
                            width: 300,
                            child:
                            ListView.builder(
                              padding:
                              EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                              options.length,
                              itemBuilder:
                                  (
                                  BuildContext
                                  context,
                                  int index,
                                  ) {
                                final String option =
                                options.elementAt(
                                  index,
                                );

                                return ListTile(
                                  title: Text(
                                    option,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors
                                          .white
                                          : Colors
                                          .black,
                                    ),
                                  ),
                                  onTap: () =>
                                      onSelected(
                                        option,
                                      ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller:
                    provider.telefonController,
                    keyboardType:
                    TextInputType.phone,
                    inputFormatters: [
                      maskFormatter,
                    ],
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefixText: "+",
                      prefixStyle: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                      hintText: "90 123 45 67",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),
                      enabledBorder: isDark
                          ? OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                        const BorderSide(
                          color:
                          Color(0xFF3A3F4B),
                        ),
                      )
                          : null,
                      focusedBorder: isDark
                          ? OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                        const BorderSide(
                          color:
                          Color(0xFF3C8DFF),
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (
                        context,
                        setState,
                        ) {
                      return Container(
                        width: double.infinity,
                        height: 58,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(
                            0xFF2A2E38,
                          )
                              : Colors.transparent,
                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                          border: Border.all(
                            color: isDark
                                ? const Color(
                              0xFF3A3F4B,
                            )
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              provider.mijozTuri ==
                                  "Korporativ"
                                  ? getTxt(
                                lang,
                                "korporativ",
                              )
                                  : getTxt(
                                lang,
                                "jismoniy",
                              ),
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(
                                canvasColor: isDark
                                    ? const Color(
                                  0xFF252836,
                                )
                                    : Colors.white,
                              ),
                              child:
                              PopupMenuButton<
                                  String>(
                                icon: Icon(
                                  Icons
                                      .arrow_drop_down,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                onSelected: (val) {
                                  setState(() {
                                    provider
                                        .mijozTuri =
                                        val;
                                  });
                                },
                                itemBuilder:
                                    (context) => [
                                  "Korporativ",
                                  "Jismoniy",
                                ]
                                    .map(
                                      (
                                      e,
                                      ) =>
                                      PopupMenuItem(
                                        value: e,
                                        child: Text(
                                          e ==
                                              "Korporativ"
                                              ? getTxt(
                                            lang,
                                            "korporativ",
                                          )
                                              : getTxt(
                                            lang,
                                            "jismoniy",
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
                                      ),
                                )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (
                        context,
                        setState,
                        ) {
                      return Container(
                        width: double.infinity,
                        height: 58,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(
                            0xFF2A2E38,
                          )
                              : Colors.transparent,
                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                          border: Border.all(
                            color: isDark
                                ? const Color(
                              0xFF3A3F4B,
                            )
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              getTxt(
                                lang,
                                "status",
                              ),
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              provider.status == "Faol"
                                  ? getTxt(
                                lang,
                                "faol",
                              )
                                  : getTxt(
                                lang,
                                "nofaol",
                              ),
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(
                                canvasColor: isDark
                                    ? const Color(
                                  0xFF252836,
                                )
                                    : Colors.white,
                              ),
                              child:
                              PopupMenuButton<
                                  String>(
                                icon: Icon(
                                  Icons
                                      .arrow_drop_down,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                onSelected: (val) {
                                  setState(() {
                                    provider.status =
                                        val;
                                  });
                                },
                                itemBuilder:
                                    (context) => [
                                  "Faol",
                                  "Nofaol",
                                ]
                                    .map(
                                      (
                                      e,
                                      ) =>
                                      PopupMenuItem(
                                        value: e,
                                        child: Text(
                                          e == "Faol"
                                              ? getTxt(
                                            lang,
                                            "faol",
                                          )
                                              : getTxt(
                                            lang,
                                            "nofaol",
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
                                      ),
                                )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  mijoz == null
                      ? Row(
                    children: [
                      Expanded(
                        child:
                        ElevatedButton(
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            isDark
                                ? const Color(
                              0xFF3A3F4B,
                            )
                                : Colors.grey,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: FittedBox(
                            fit: BoxFit
                                .scaleDown,
                            child: Text(
                              getTxt(
                                lang,
                                "bekor_qilish",
                              ),
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                        ElevatedButton(
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            isDark
                                ? const Color(
                              0xFF3C8DFF,
                            )
                                : Colors.indigo,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            String full =
                            fullNameController
                                .text
                                .trim();

                            int firstSpace =
                            full.indexOf(
                              ' ',
                            );

                            if (firstSpace !=
                                -1) {
                              provider
                                  .ismController
                                  .text =
                                  full.substring(
                                    0,
                                    firstSpace,
                                  );

                              provider
                                  .familyaController
                                  .text =
                                  full
                                      .substring(
                                    firstSpace + 1,
                                  )
                                      .trim();
                            } else {
                              provider
                                  .ismController
                                  .text =
                                  full;

                              provider
                                  .familyaController
                                  .text =
                              "";
                            }

                            if (!provider.tekshir()) {
                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                  Colors.red,
                                  content: Text(
                                    getTxt(
                                      lang,
                                      "ism_telefon_majburiy",
                                    ),
                                  ),
                                ),
                              );

                              return;
                            }

                            await provider.qoshish();

                            if (provider
                                .errorMessage !=
                                null) {
                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider
                                        .errorMessage!,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pop(
                                context,
                              );
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit
                                .scaleDown,
                            child: Text(
                              getTxt(
                                lang,
                                "saqlash",
                              ),
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child:
                        ElevatedButton(
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            isDark
                                ? const Color(
                              0xFF3C8DFF,
                            )
                                : Colors.indigo,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            String full =
                            fullNameController
                                .text
                                .trim();

                            int firstSpace =
                            full.indexOf(
                              ' ',
                            );

                            if (firstSpace !=
                                -1) {
                              provider
                                  .ismController
                                  .text =
                                  full.substring(
                                    0,
                                    firstSpace,
                                  );

                              provider
                                  .familyaController
                                  .text =
                                  full
                                      .substring(
                                    firstSpace + 1,
                                  )
                                      .trim();
                            } else {
                              provider
                                  .ismController
                                  .text =
                                  full;

                              provider
                                  .familyaController
                                  .text =
                              "";
                            }

                            if (!provider.tekshir()) {
                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                  Colors.red,
                                  content: Text(
                                    getTxt(
                                      lang,
                                      "ism_telefon_majburiy",
                                    ),
                                  ),
                                ),
                              );

                              return;
                            }

                            await provider.tahrirlash(
                              mijoz.id!,
                            );

                            if (provider
                                .errorMessage !=
                                null) {
                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider
                                        .errorMessage!,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pop(
                                context,
                              );
                            }
                          },
                          child: Text(
                            getTxt(
                              lang,
                              "tahrirlash",
                            ),
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child:
                        ElevatedButton(
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            Colors.red,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );

                            _showDeleteConfirmDialog(
                              context,
                              mijoz.id!,
                            );
                          },
                          child: Text(
                            getTxt(
                              lang,
                              "ochirish",
                            ),
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(
                              context,
                            ),
                        child: Text(
                          getTxt(
                            lang,
                            "bekor_qilish",
                          ),
                          style: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : null,
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

  void _showDeleteConfirmDialog(
      BuildContext context,
      int id,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang =
        context.read<ProfileProvider>().language;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          isDark ? const Color(0xFF252836) : null,
          surfaceTintColor: Colors.transparent,
          title: Text(
            getTxt(
              lang,
              "ochirishni_tasdiqlang",
            ),
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          content: Text(
            getTxt(
              lang,
              "mijozni_ochirish_savol",
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
                getTxt(lang, "yoq"),
                style: TextStyle(
                  color: isDark
                      ? Colors.white70
                      : null,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final provider =
                context.read<MijozProvider>();

                await provider.ochirish(id);

                if (provider.errorMessage !=
                    null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.errorMessage!,
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                getTxt(lang, "ha"),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}