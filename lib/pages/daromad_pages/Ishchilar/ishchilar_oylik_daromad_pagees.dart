import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:afada/model/ishchi_modeli.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/order_provider.dart';

class IshchilarOylikDaromadPagees extends StatefulWidget {
  const IshchilarOylikDaromadPagees({super.key});

  @override
  State<IshchilarOylikDaromadPagees> createState() =>
      _IshchilarOylikDaromadPageesState();
}

class _IshchilarOylikDaromadPageesState
    extends State<IshchilarOylikDaromadPagees> {
  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "jami_mahsulotlar": "Jami mahsulotlar soni:",
      "dona": "dona",
      "texnik_xodimlar": "Texnik xodimlar:",
      "shifokorlar": "Shifokorlar:",
      "tayyorlagan": "Tayyorlagan:",
      "sotildi": "Sotildi:",
      "ta": "ta",
      "tel": "Tel:",
    },
    "Rus": {
      "jami_mahsulotlar": "Общее количество товаров:",
      "dona": "шт",
      "texnik_xodimlar": "Технический персонал:",
      "shifokorlar": "Врачи:",
      "tayyorlagan": "Подготовил:",
      "sotildi": "Продано:",
      "ta": "шт",
      "tel": "Тел:",
    },
    "Kiril": {
      "jami_mahsulotlar": "Жами маҳсулотлар сони:",
      "dona": "дона",
      "texnik_xodimlar": "Техник ходимлар:",
      "shifokorlar": "Шифокорлар:",
      "tayyorlagan": "Тайёрлаган:",
      "sotildi": "Сотилди:",
      "ta": "та",
      "tel": "Тел:",
    },
  };

  static String getTxt(String lang, String key) {
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

      context
          .read<OrderProvider>()
          .fetchSalesFromApi();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(' ', '');

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

  String _normalizeName(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
  }

  bool _isSameWorker(
      IshchiModel ishchi,
      String? createdByName,
      ) {
    if (createdByName == null ||
        createdByName.trim().isEmpty) {
      return false;
    }

    final familya = _normalizeName(ishchi.familya);
    final ism = _normalizeName(ishchi.ism);
    final creator = _normalizeName(createdByName);

    final familyaIsm = '$familya$ism';
    final ismFamilya = '$ism$familya';

    return creator == familyaIsm ||
        creator == ismFamilya;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    final finishedProvider =
    context.watch<FinishedProductProvider>();

    final orderProvider = context.watch<OrderProvider>();

    final lang = profile.language;

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    /*
     * ISHCHILAR RO'YXATI
     */
    final List<IshchiModel> ishchilar =
    List<IshchiModel>.from(
      IshchiDatabase.ishchilar,
    );

    /*
     * HOZIR LOGIN QILGAN ACCOUNT
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
     * TEXNIK XODIMLAR
     */
    final techCount = ishchilar.where((i) {
      return i.kasb.trim().toLowerCase() ==
          "texnik xodim";
    }).length;

    /*
     * SHIFOKORLAR
     */
    final doctorCount = ishchilar.where((i) {
      return i.kasb.trim().toLowerCase() ==
          "shifokor";
    }).length;

    final now = DateTime.now();

    /*
     * FAQAT SHU OYDA QO'SHILGAN MAHSULOTLAR
     */
    final monthlyFinishedProducts =
    finishedProvider.finishedProducts.where((item) {
      final date = item.createdAt;

      if (date == null) return false;

      return date.year == now.year &&
          date.month == now.month;
    }).toList();

    /*
     * FAQAT SHU OYDA SOTILGAN MAHSULOTLAR
     */
    final monthlySales = orderProvider.orders.where((o) {
      return o.date.year == now.year && o.date.month == now.month;
    }).toList();

    /*
     * SHU OYDA BARCHA ISHCHILAR QO'SHGAN
     * MAHSULOTLARNING UMUMIY SONI
     */
    final totalProducts =
    monthlyFinishedProducts.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );

    /*
     * HAR BIR ISHCHI UCHUN OYLIK MAHSULOT SONI
     */
    int getProductCountForWorker(
        IshchiModel ishchi,
        ) {
      /*
       * API createdBy ma'lumotini qaytaryaptimi?
       */
      final hasCreatorData =
      monthlyFinishedProducts.any(
            (item) =>
        item.createdByName != null &&
            item.createdByName!.trim().isNotEmpty,
      );

      /*
       * ADMIN:
       * createdBy orqali aynan qaysi ishchi
       * nechta mahsulot qo'shganini hisoblaymiz.
       */
      if (hasCreatorData) {
        return monthlyFinishedProducts
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
       * NON-ADMIN:
       * Backend token egasining mahsulotlarini
       * qaytaradi.
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
        return monthlyFinishedProducts
            .fold<int>(
          0,
              (sum, item) => sum + item.quantity,
        );
      }

      return 0;
    }

    int getSoldCountForWorker(IshchiModel ishchi) {
      return monthlySales.where((o) {
        final String? createdByName = o.createdBy != null
            ? (o.createdBy!["fullName"] ?? o.createdBy!["full_name"] ?? "").toString()
            : null;
        return _isSameWorker(ishchi, createdByName);
      }).fold<int>(0, (sum, item) => sum + item.quantity);
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF181A20)
          : Colors.blue.shade100,
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
              bottom: 5,
            ),
            child: Column(
              children: [
                /*
                 * SUMMARY CARD
                 */
                Card(
                  clipBehavior:
                  Clip.antiAlias,
                  surfaceTintColor:
                  Colors.transparent,
                  elevation:
                  isDark ? 0 : 10,
                  shadowColor:
                  isDark ? Colors.black26 : null,
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
                          /*
                           * JAMI MAHSULOT
                           */
                          Row(
                            children: [
                              Expanded(
                                child:
                                FittedBox(
                                  alignment:
                                  Alignment
                                      .centerLeft,
                                  fit: BoxFit
                                      .scaleDown,
                                  child: Text(
                                    getTxt(
                                      lang,
                                      "jami_mahsulotlar",
                                    ),
                                    softWrap: false,
                                    style:
                                    TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      fontSize: 20,
                                      color: isDark
                                          ? Colors
                                          .white
                                          : Colors
                                          .black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FittedBox(
                                fit: BoxFit
                                    .scaleDown,
                                child: Text(
                                  "$totalProducts ${getTxt(lang, "dona")}",
                                  softWrap:
                                  false,
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize: 20,
                                    color:
                                    Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 9,
                          ),

                          /*
                           * TEXNIK XODIMLAR
                           */
                          Row(
                            children: [
                              Expanded(
                                child:
                                FittedBox(
                                  alignment:
                                  Alignment
                                      .centerLeft,
                                  fit: BoxFit
                                      .scaleDown,
                                  child: Text(
                                    getTxt(
                                      lang,
                                      "texnik_xodimlar",
                                    ),
                                    softWrap: false,
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
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FittedBox(
                                fit: BoxFit
                                    .scaleDown,
                                child: Text(
                                  "$techCount ${getTxt(lang, "dona")}",
                                  softWrap:
                                  false,
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize: 16,
                                    color:
                                    Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 9,
                          ),

                          /*
                           * SHIFOKORLAR
                           */
                          Row(
                            children: [
                              Expanded(
                                child:
                                FittedBox(
                                  alignment:
                                  Alignment
                                      .centerLeft,
                                  fit: BoxFit
                                      .scaleDown,
                                  child: Text(
                                    getTxt(
                                      lang,
                                      "shifokorlar",
                                    ),
                                    softWrap: false,
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
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FittedBox(
                                fit: BoxFit
                                    .scaleDown,
                                child: Text(
                                  "$doctorCount ${getTxt(lang, "dona")}",
                                  softWrap:
                                  false,
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize: 16,
                                    color:
                                    Colors.green,
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

                const SizedBox(
                  height: 10,
                ),

                /*
                 * ISHCHILAR
                 */
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount:
                  ishchilar.length,
                  itemBuilder:
                      (context, index) {
                    final ishchi =
                    ishchilar[index];

                    /*
                     * SHU ISHCHI SHU OYDA
                     * QANCHA MAHSULOT QO'SHGAN yoki SOTGAN
                     */
                    final bool isSeller =
                        ishchi.kasb.trim().toLowerCase() == "sotuvchi" ||
                        ishchi.lavozim.trim().toLowerCase() == "sotuvchi" ||
                        ishchi.kasb.trim().toLowerCase() == "seller";

                    final countValue = isSeller
                        ? getSoldCountForWorker(ishchi)
                        : getProductCountForWorker(ishchi);

                    final titleKey = isSeller ? "sotildi" : "tayyorlagan";

                    return Card(
                      clipBehavior:
                      Clip.antiAlias,
                      surfaceTintColor:
                      Colors.transparent,
                      elevation:
                      isDark ? 0 : 10,
                      shadowColor: isDark
                          ? Colors.black26
                          : null,
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
                                      : Colors
                                      .grey,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    35,
                                  ),
                                  image: ishchi
                                      .rasm !=
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
                                child: ishchi
                                    .rasm ==
                                    null ||
                                    ishchi.rasm!
                                        .isEmpty
                                    ? const Icon(
                                  Icons.person,
                                  color:
                                  Colors
                                      .white,
                                  size: 40,
                                )
                                    : null,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              /*
                               * ISM VA MA'LUMOT
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
                                      style:
                                      TextStyle(
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
                                     * TAYYORLAGAN VA SOTILDI
                                     */
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                          FittedBox(
                                            alignment:
                                            Alignment
                                                .centerLeft,
                                            fit: BoxFit
                                                .scaleDown,
                                            child:
                                            Text(
                                              getTxt(
                                                lang,
                                                titleKey,
                                              ),
                                              softWrap:
                                              false,
                                              style:
                                              TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                fontSize:
                                                13,
                                                color: isDark
                                                    ? Colors
                                                    .white
                                                    : Colors
                                                    .black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        FittedBox(
                                          fit: BoxFit
                                              .scaleDown,
                                          child:
                                          Text(
                                            "$countValue ${getTxt(lang, "ta")}",
                                            softWrap:
                                            false,
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
                                        Expanded(
                                          child:
                                          FittedBox(
                                            alignment:
                                            Alignment
                                                .centerLeft,
                                            fit: BoxFit
                                                .scaleDown,
                                            child:
                                            Text(
                                              getTxt(
                                                lang,
                                                "tel",
                                              ),
                                              softWrap:
                                              false,
                                              style:
                                              TextStyle(
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
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        FittedBox(
                                          fit: BoxFit
                                              .scaleDown,
                                          child:
                                          TextButton(
                                            style:
                                            TextButton
                                                .styleFrom(
                                              padding:
                                              EdgeInsets
                                                  .zero,
                                              minimumSize:
                                              const Size(
                                                0,
                                                0,
                                              ),
                                              tapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap,
                                            ),
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
                                            child:
                                            Text(
                                              ishchi
                                                  .telefon
                                                  .trim()
                                                  .isEmpty
                                                  ? "-"
                                                  : ishchi
                                                  .telefon,
                                              softWrap:
                                              false,
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