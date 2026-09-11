import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:afada/model/ishchi_modeli.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';

class KunlikDaromadPages extends StatefulWidget {
  const KunlikDaromadPages({super.key});

  @override
  State<KunlikDaromadPages> createState() =>
      _KunlikDaromadPagesState();
}

class _KunlikDaromadPagesState
    extends State<KunlikDaromadPages> {
  static final Map<String, Map<String, String>>
  _localizedTexts = {
    "Uzb": {
      "jami_ishchilar": "Jami ishchilar soni:",
      "dona": "dona",
      "texnik_xodimlar": "Texnik xodimlar:",
      "shifokorlar": "Shifokorlar:",
      "tayyorlagan": "Tayyorlagan:",
      "ta": "ta",
      "tel": "Tel:",
    },
    "Rus": {
      "jami_ishchilar": "Общее количество рабочих:",
      "dona": "шт",
      "texnik_xodimlar": "Технический персонал:",
      "shifokorlar": "Врачи:",
      "tayyorlagan": "Подготовил:",
      "ta": "шт",
      "tel": "Тел:",
    },
    "Kiril": {
      "jami_ishchilar": "Жами ишчилар сони:",
      "dona": "дона",
      "texnik_xodимlar": "Техник ходимлар:",
      "shifokorlar": "Шифокорлар:",
      "tayyorlagan": "Тайёрлаган:",
      "ta": "та",
      "tel": "Тел:",
    },
  };

  static String getTxt(
      String lang,
      String key,
      ) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<FinishedProductProvider>()
          .fetchFinishedProducts();
    });
  }

  Future<void> _makePhoneCall(
      String phoneNumber,
      ) async {
    final cleanNumber =
    phoneNumber.replaceAll(' ', '');

    if (cleanNumber.isEmpty) return;

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanNumber.startsWith('+')
          ? cleanNumber
          : '+$cleanNumber',
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  /*
   * Ismni solishtirish uchun normalizatsiya.
   *
   * Masalan:
   * "Ubaydulloh Tursunboyev"
   * "UbaydullohTursunboyev"
   *
   * ikkalasi ham bir xil hisoblanadi.
   */
  String _normalizeName(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
  }

  /*
   * Worker nomi bilan createdBy fullName mosligini tekshiradi.
   *
   * "Tursunboyev Ubaydulloh"
   * yoki
   * "Ubaydulloh Tursunboyev"
   *
   * ikkala variantni ham tekshiradi.
   */
  bool _isSameWorker(
      IshchiModel ishchi,
      String? createdByName,
      ) {
    if (createdByName == null ||
        createdByName.trim().isEmpty) {
      return false;
    }

    final workerFamilya =
    _normalizeName(ishchi.familya);

    final workerIsm =
    _normalizeName(ishchi.ism);

    final creator =
    _normalizeName(createdByName);

    final familyaIsm =
        '$workerFamilya$workerIsm';

    final ismFamilya =
        '$workerIsm$workerFamilya';

    return creator == familyaIsm ||
        creator == ismFamilya;
  }

  @override
  Widget build(BuildContext context) {
    final profile =
    context.watch<ProfileProvider>();

    final finishedProvider =
    context.watch<FinishedProductProvider>();

    final lang = profile.language;

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    /*
     * Ishchilar ro'yxati
     */
    final List<IshchiModel> ishchilar =
    List<IshchiModel>.from(
      IshchiDatabase.ishchilar,
    );

    /*
     * Hozir login qilgan account
     */
    final currentFullName =
    "${profile.surname} ${profile.name}".trim();

    final isAlreadyInList = ishchilar.any(
          (i) =>
      _normalizeName(
        "${i.familya} ${i.ism}",
      ) ==
          _normalizeName(currentFullName),
    );

    if (!isAlreadyInList &&
        currentFullName.isNotEmpty) {
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

    /*
     * Texnik xodimlar
     */
    final techCount = ishchilar.where((i) {
      return i.kasb.trim().toLowerCase() ==
          "texnik xodim";
    }).length;

    /*
     * Shifokorlar
     */
    final doctorCount = ishchilar.where((i) {
      return i.kasb.trim().toLowerCase() ==
          "shifokor";
    }).length;

    final now = DateTime.now();

    /*
     * FAQAT BUGUNGI MAHSULOTLAR
     */
    final todayFinishedProducts =
    finishedProvider.finishedProducts
        .where((item) {
      final date = item.createdAt;

      if (date == null) return false;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();

    /*
     * ADMIN UCHUN:
     *
     * Har bir FinishedProduct'dagi createdByName
     * orqali aynan qaysi worker qo'shganini topamiz.
     *
     * NON-ADMIN UCHUN:
     *
     * Backend faqat shu token egasining
     * finished-productslarini qaytaradi.
     */
    int getProductCountForWorker(
        IshchiModel ishchi,
        ) {
      /*
       * Agar API createdBy yuborgan bo'lsa,
       * worker bo'yicha ajratamiz.
       */
      final hasCreatorData =
      todayFinishedProducts.any(
            (item) =>
        item.createdByName != null &&
            item.createdByName!.trim().isNotEmpty,
      );

      if (hasCreatorData) {
        return todayFinishedProducts
            .where(
              (item) => _isSameWorker(
            ishchi,
            item.createdByName,
          ),
        )
            .fold<int>(
          0,
              (sum, item) => sum + item.quantity,
        );
      }

      /*
       * Non-admin API javobida createdBy yo'q.
       * Lekin API shu token egasining yozuvlarini
       * qaytaradi.
       *
       * Shuning uchun faqat login qilgan accountga
       * jami quantity beramiz.
       */
      final currentWorker =
      _normalizeName(
        "${profile.surname} ${profile.name}",
      );

      final thisWorker =
      _normalizeName(
        "${ishchi.familya} ${ishchi.ism}",
      );

      if (currentWorker == thisWorker) {
        return todayFinishedProducts
            .fold<int>(
          0,
              (sum, item) => sum + item.quantity,
        );
      }

      return 0;
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await finishedProvider
              .fetchFinishedProducts();
        },
        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 10,
            ),
            child: Column(
              children: [
                /*
                 * SUMMARY CARD
                 */
                Card(
                  elevation: 10,
                  shadowColor:
                  isDark ? Colors.black26 : null,
                  clipBehavior:
                  Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    constraints:
                    const BoxConstraints(
                      minHeight: 145,
                    ),
                    decoration:
                    BoxDecoration(
                      color: isDark
                          ? const Color(
                        0xFF252836,
                      )
                          : Colors.white,
                      border: isDark
                          ? Border.all(
                        color: const Color(
                          0xFF3A3F4B,
                        ),
                      )
                          : null,
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  getTxt(
                                    lang,
                                    "jami_ishchilar",
                                  ),
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 20,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${ishchilar.length} ${getTxt(lang, "dona")}",
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 20,
                                  color:
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  getTxt(
                                    lang,
                                    "texnik_xodimlar",
                                  ),
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "$techCount ${getTxt(lang, "dona")}",
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  getTxt(
                                    lang,
                                    "shifokorlar",
                                  ),
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "$doctorCount ${getTxt(lang, "dona")}",
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /*
                 * ISHCHILAR
                 */
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: ishchilar.length,
                  itemBuilder:
                      (context, index) {
                    final ishchi =
                    ishchilar[index];

                    /*
                     * AYNAN SHU ISHCHI BUGUN
                     * NECHTA MAHSULOT QO'SHGAN?
                     */
                    final productCount =
                    getProductCountForWorker(
                      ishchi,
                    );

                    return Card(
                      elevation: 4,
                      shadowColor: isDark
                          ? Colors.black26
                          : null,
                      clipBehavior:
                      Clip.antiAlias,
                      child: Container(
                        width: double.infinity,
                        constraints:
                        const BoxConstraints(
                          minHeight: 125,
                        ),
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
                        child: Padding(
                          padding:
                          const EdgeInsets.all(
                            10,
                          ),
                          child: Row(
                            children: [
                              /*
                               * RASM
                               */
                              Container(
                                width: 70,
                                height: 70,
                                decoration:
                                BoxDecoration(
                                  color: isDark
                                      ? const Color(
                                    0xFF2A2E38,
                                  )
                                      : Colors.grey,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    35,
                                  ),
                                  image: ishchi.rasm !=
                                      null &&
                                      ishchi
                                          .rasm!
                                          .isNotEmpty
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
                                child: ishchi.rasm ==
                                    null ||
                                    ishchi.rasm!
                                        .isEmpty
                                    ? const Icon(
                                  Icons.person,
                                  color:
                                  Colors.white,
                                  size: 40,
                                )
                                    : null,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              /*
                               * MA'LUMOT
                               */
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    /*
                                     * ISM
                                     */
                                    Text(
                                      "${ishchi.familya} ${ishchi.ism}",
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: isDark
                                            ? Colors
                                            .white
                                            : Colors
                                            .black,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 7,
                                    ),

                                    /*
                                     * TAYYORLAGAN
                                     */
                                    Row(
                                      children: [
                                        Text(
                                          getTxt(
                                            lang,
                                            "tayyorlagan",
                                          ),
                                          style:
                                          TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            fontSize: 13,
                                            color: isDark
                                                ? Colors
                                                .white70
                                                : Colors
                                                .black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child:
                                          Text(
                                            "$productCount ${getTxt(lang, "ta")}",
                                            overflow:
                                            TextOverflow
                                                .ellipsis,
                                            style:
                                            const TextStyle(
                                              color:
                                              Colors
                                                  .green,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              fontSize:
                                              13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    /*
                                     * TELEFON
                                     */
                                    Row(
                                      children: [
                                        Text(
                                          getTxt(
                                            lang,
                                            "tel",
                                          ),
                                          style:
                                          TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color: isDark
                                                ? Colors
                                                .white70
                                                : Colors
                                                .black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child:
                                          TextButton(
                                            onPressed:
                                            ishchi
                                                .telefon
                                                .trim()
                                                .isEmpty
                                                ? null
                                                : () =>
                                                _makePhoneCall(
                                                  ishchi
                                                      .telefon,
                                                ),
                                            style:
                                            TextButton
                                                .styleFrom(
                                              padding:
                                              EdgeInsets
                                                  .zero,
                                              minimumSize:
                                              Size
                                                  .zero,
                                              tapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap,
                                              alignment:
                                              Alignment
                                                  .centerLeft,
                                            ),
                                            child:
                                            Text(
                                              ishchi
                                                  .telefon
                                                  .trim()
                                                  .isEmpty
                                                  ? "-"
                                                  : ishchi
                                                  .telefon,
                                              maxLines:
                                              1,
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              style:
                                              TextStyle(
                                                color: isDark
                                                    ? const Color(
                                                  0xFF3C8DFF,
                                                )
                                                    : Colors
                                                    .indigo,
                                                fontSize:
                                                15,
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                /*
                 * LOADING
                 */
                if (finishedProvider.isLoading)
                  const Padding(
                    padding:
                    EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child:
                    CircularProgressIndicator(),
                  ),

                /*
                 * ERROR
                 */
                if (finishedProvider.error != null)
                  Padding(
                    padding:
                    const EdgeInsets.all(15),
                    child: Text(
                      finishedProvider.error!,
                      textAlign:
                      TextAlign.center,
                      style:
                      const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}