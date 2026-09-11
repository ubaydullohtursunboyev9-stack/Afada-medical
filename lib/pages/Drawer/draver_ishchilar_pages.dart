import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/ishchi_modeli.dart';
import '../../provider/ishchilar_Provider/ishchilar_provider.dart';
import '../../provider/profile_provider.dart';
import '../Ishchilar_Pages.dart';

class DraverIshchilarPages extends StatelessWidget {
  const DraverIshchilarPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'worker_details': "Ishchi ma'lumotlari",
      'fish': 'F.I.SH:',
      'position': 'Lavozim:',
      'profession': 'Kasbi:',
      'phone': 'Telefon:',
      'login': 'Login:',
      'password': 'Password:',
      'close': 'Yopish',
      'edit': 'Tahrirlash',
      'delete': "O'chirish",
      'delete_confirm':
      "Haqiqatan ham ushbu ishchini o'chirmoqchimisiz?",
      'no': "Yo'q",
      'yes': 'Ha',
      'workers': 'Ishchilar',
      'no_workers': 'Ishchilar mavjud emas',
    },
    'Rus': {
      'worker_details': 'Данные сотрудника',
      'fish': 'Ф.И.О:',
      'position': 'Должность:',
      'profession': 'Профессия:',
      'phone': 'Телефон:',
      'login': 'Логин:',
      'password': 'Пароль:',
      'close': 'Закрыть',
      'edit': 'Редактировать',
      'delete': 'Удалить',
      'delete_confirm':
      'Вы действительно хотите удалить этого сотрудника?',
      'no': 'Нет',
      'yes': 'Да',
      'workers': 'Сотрудники',
      'no_workers': 'Нет доступных сотрудников',
    },
    'Kiril': {
      'worker_details': 'Ишчи маълумотлари',
      'fish': 'Ф.И.Ш:',
      'position': 'Лавозим:',
      'profession': 'Касби:',
      'phone': 'Телефон:',
      'login': 'Логин:',
      'password': 'Пароль:',
      'close': 'Ёпиш',
      'edit': 'Таҳрирлаш',
      'delete': 'Ўчириш',
      'delete_confirm':
      'Ҳақиқатан ҳам ушбу ишчини ўчирмоқчимисиз?',
      'no': 'Йўқ',
      'yes': 'Ҳа',
      'workers': 'Ишчилар',
      'no_workers': 'Ишчилар мавжуд эмас',
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts['Uzb']![key]!;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _showDetailDialog(
      BuildContext context,
      IshchiModel ishchi,
      int index, {
        required bool isAdmin,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final String language =
        context.read<ProfileProvider>().language;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
        isDark ? const Color(0xFF252836) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark
              ? const BorderSide(
            color: Color(0xFF3A3F4B),
          )
              : BorderSide.none,
        ),
        title: Text(
          getTxt(language, 'worker_details'),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              getTxt(language, 'fish'),
              "${ishchi.familya} ${ishchi.ism}",
              isDark,
            ),
            _buildDetailRow(
              getTxt(language, 'position'),
              ishchi.lavozim,
              isDark,
            ),
            _buildDetailRow(
              getTxt(language, 'profession'),
              ishchi.kasb,
              isDark,
            ),
            _buildDetailRow(
              getTxt(language, 'phone'),
              "+${ishchi.telefon}",
              isDark,
            ),

            if (ishchi.lavozim == "Ishchi") ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              _buildDetailRow(
                getTxt(language, 'login'),
                ishchi.login ?? "",
                isDark,
              ),
              _buildDetailRow(
                getTxt(language, 'password'),
                ishchi.parol ?? "",
                isDark,
              ),
            ],
          ],
        ),

        actions: [
          // FAQAT ADMIN
          if (isAdmin)
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                _showDeleteDialog(
                  context,
                  index,
                );
              },
              child: Text(
                getTxt(language, 'delete'),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

          // FAQAT ADMIN
          if (isAdmin)
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                context
                    .read<IshchiProvider>()
                    .tahrirlashUchunYuklash(index);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => IshchiQoshishDialog(
                    maskFormatter:
                    MaskTextInputFormatter(
                      mask: '## ### ## ##',
                    ),
                    isEditing: true,
                  ),
                );
              },
              child: Text(
                getTxt(language, 'edit'),
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF3C8DFF)
                      : Colors.indigo,
                ),
              ),
            ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              getTxt(language, 'close'),
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      String label,
      String value,
      bool isDark,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      int index,
      ) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final String language =
        context.read<ProfileProvider>().language;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
        isDark ? const Color(0xFF252836) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark
              ? const BorderSide(
            color: Color(0xFF3A3F4B),
          )
              : BorderSide.none,
        ),
        title: Text(
          getTxt(language, 'delete'),
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
          ),
        ),
        content: Text(
          getTxt(language, 'delete_confirm'),
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
              getTxt(language, 'no'),
              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<IshchiProvider>()
                  .ochirish(index);

              Navigator.pop(context);
            },
            child: Text(
              getTxt(language, 'yes'),
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<IshchiProvider>();

    final ishchilar =
        IshchiDatabase.ishchilar;

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final profile =
    context.watch<ProfileProvider>();

    // FAQAT HAQIQIY ADMIN
    final bool isAdmin =
        profile.role.trim().toLowerCase() ==
            "admin";

    final String language =
        profile.language;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.blue.shade100,

      // ==========================================
      // FAQAT ADMIN UCHUN FLOATING ACTION BUTTON
      // ==========================================
      floatingActionButton: isAdmin
          ? Padding(
        padding:
        const EdgeInsets.only(
          bottom: 20,
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
                        .withValues(
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
                        .read<IshchiProvider>()
                        .tozalash();

                    showDialog(
                      context: context,
                      barrierDismissible:
                      false,
                      builder: (context) =>
                          IshchiQoshishDialog(
                            maskFormatter:
                            MaskTextInputFormatter(
                              mask: '## ### ## ##',
                            ),
                          ),
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
      )
          : null,

      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF181A20)
            : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          getTxt(language, 'workers'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: ishchilar.isEmpty
          ? Center(
        child: Text(
          getTxt(
            language,
            'no_workers',
          ),
          style: TextStyle(
            color: isDark
                ? Colors.white70
                : Colors.black54,
          ),
        ),
      )
          : ListView.builder(
        physics:
        const BouncingScrollPhysics(),
        itemCount: ishchilar.length,
        itemBuilder:
            (context, index) {
          final ishchi =
          ishchilar[index];

          return Container(
            width: double.infinity,
            height: 100,
            margin:
            const EdgeInsets.only(
              top: 5,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _showDetailDialog(
                            context,
                            ishchi,
                            index,
                            isAdmin: isAdmin,
                          ),
                      child: Container(
                        width: 70,
                        height: 70,
                        margin:
                        const EdgeInsets.only(
                          left: 10,
                        ),
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(
                            35,
                          ),
                          color: isDark
                              ? const Color(
                            0xFF2A2E38,
                          )
                              : Colors.grey,
                          border: isDark
                              ? Border.all(
                            color:
                            const Color(
                              0xFF3A3F4B,
                            ),
                          )
                              : null,
                          image:
                          ishchi.rasm !=
                              null
                              ? DecorationImage(
                            image:
                            FileImage(
                              File(
                                ishchi
                                    .rasm!,
                              ),
                            ),
                            fit: BoxFit
                                .cover,
                          )
                              : null,
                        ),
                        child:
                        ishchi.rasm ==
                            null
                            ? Center(
                          child: ishchi
                              .ism
                              .isNotEmpty
                              ? Text(
                            ishchi
                                .ism[0]
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
                            Icons
                                .person,
                            color: isDark
                                ? Colors.white24
                                : Colors.white,
                            size: 45,
                          ),
                        )
                            : null,
                      ),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _showDetailDialog(
                              context,
                              ishchi,
                              index,
                              isAdmin:
                              isAdmin,
                            ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            FittedBox(
                              fit: BoxFit
                                  .scaleDown,
                              alignment:
                              Alignment
                                  .centerLeft,
                              child: Text(
                                "${ishchi.familya} ${ishchi.ism}",
                                style:
                                TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: isDark
                                      ? Colors
                                      .white
                                      : Colors
                                      .black,
                                ),
                                maxLines: 1,
                              ),
                            ),

                            Text(
                              ishchi.kasb,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? const Color(
                                  0xFF3C8DFF,
                                )
                                    : Colors
                                    .indigo,
                              ),
                            ),

                            FittedBox(
                              fit: BoxFit
                                  .scaleDown,
                              alignment:
                              Alignment
                                  .centerLeft,
                              child: Text(
                                "+${ishchi.telefon}",
                                style:
                                TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: isDark
                                      ? Colors
                                      .white70
                                      : Colors
                                      .black,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () =>
                              _makePhoneCall(
                                "+998${ishchi.telefon.replaceAll(' ', '')}",
                              ),
                          icon:
                          const Icon(
                            Icons.phone,
                            color:
                            Colors.green,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),

                Divider(
                  color: isDark
                      ? const Color(
                    0xFF3A3F4B,
                  )
                      : Colors.black26,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}