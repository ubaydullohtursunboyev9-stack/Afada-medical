import 'package:afada/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/order_provider.dart';
import '../../model/order_model.dart';
import 'package:intl/intl.dart';

class UmumiyDaromadPages extends StatelessWidget {
  const UmumiyDaromadPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "umumiy_daromad": "Umumiy daromad",
      "umumiy_buyurtmalar": "Umumiy buyurtmalar",
      "sotilganlar": "Sotilganlar:",
      "buyurtmalar": "Buyurtmalar:",
      "jami": "Jami:",
      "narxi": "Narxi:",
      "mijoz": "Mijoz:",
      "soni": "Soni:",
      "tolov": "To'lov:",
      "tolangan": "To'langan",
      "kutilmoqda": "Kutilmoqda",
      "nomer": "Nomer:",
      "tahrirlash": "Tahrirlash",
      "vaqt": "Vaqt:",
      "sana": "Sana:",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "buyurtmani_tahrirlash": "Buyurtmani tahrirlash",
      "buyurtma_holati": "Buyurtma holati",
      "sotildi": "Sotildi",
      "sotilgan_belgilash":
      "Bu buyurtmani sotilgan deb belgilamoqchimisiz?",
      "umumiy_hisobot": "Umumiy hisobot",
      "mening_hisobotim": "Mening hisobotim",
      "jami_sotildi": "Jami sotildi:",
      "jami_tayyorlandi": "Jami tayyorlandi:",
      "dona": "dona",
      "umumiy_summa": "Umumiy summa:",
      "valyuta": "UZS",
      "buyurtmalar_mavjud_emas": "Buyurtmalar mavjud emas",
      "ish_haqqi": "Ish haqqi:",
      "klent": "Klent",
      "holatni_ozgartirish": "Holatni o'zgartirish",
      "Yanvar": "Yanvar",
      "Fevral": "Fevral",
      "Mart": "Mart",
      "Aprel": "Aprel",
      "May": "May",
      "Iyun": "Iyun",
      "Iyul": "Iyul",
      "Avgust": "Avgust",
      "Sentabr": "Sentabr",
      "Oktabr": "Oktabr",
      "Noyabr": "Noyabr",
      "Dekabr": "Dekabr",
    },
    "Rus": {
      "umumiy_daromad": "Общий доход",
      "umumiy_buyurtmalar": "Общие заказы",
      "sotilganlar": "Продано:",
      "buyurtmalar": "Заказы:",
      "jami": "Итого:",
      "narxi": "Цена:",
      "mijoz": "Клиент:",
      "soni": "Количество:",
      "tolov": "Оплата:",
      "tolangan": "Оплачено",
      "kutilmoqda": "Ожидается",
      "nomer": "Номер:",
      "tahrirlash": "Редактировать",
      "vaqt": "Время:",
      "sana": "Дата:",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "buyurtmani_tahrirlash": "Редактировать заказ",
      "buyurtma_holati": "Статус заказа",
      "sotildi": "Продано",
      "sotilgan_belgilash":
      "Вы хотите отметить этот заказ как проданный?",
      "umumiy_hisobot": "Общий отчет",
      "mening_hisobotim": "Мой отчет",
      "jami_sotildi": "Всего продано:",
      "jami_tayyorlandi": "Всего подготовлено:",
      "dona": "шт",
      "umumiy_summa": "Общая сумма:",
      "valyuta": "сум",
      "buyurtmalar_mavjud_emas": "Заказов нет",
      "ish_haqqi": "Зарплата:",
      "klent": "Клиент",
      "holatni_ozgartirish": "Изменить статус",
      "Yanvar": "Январь",
      "Fevral": "Февраль",
      "Mart": "Март",
      "Aprel": "Апрель",
      "May": "Май",
      "Iyun": "Июнь",
      "Iyul": "Июль",
      "Avgust": "Август",
      "Sentabr": "Сентябрь",
      "Oktabr": "Октябрь",
      "Noyabr": "Ноябрь",
      "Dekabr": "Декабрь",
    },
    "Kiril": {
      "umumiy_daromad": "Умумий даромад",
      "umumiy_buyurtmalar": "Умумий буюртмалар",
      "sotilganlar": "Сотилганлар:",
      "buyurtmalar": "Буюртмалар:",
      "jami": "Жами:",
      "narxi": "Нархи:",
      "mijoz": "Мижоз:",
      "soni": "Сони:",
      "tolov": "Тўлов:",
      "tolangan": "Тўланган",
      "kutilmoqda": "Кутилмоқда",
      "nomer": "Номер:",
      "tahrirlash": "Таҳрирлаш",
      "vaqt": "Вақт:",
      "sana": "Сана:",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "buyurtmani_tahrirlash": "Буюртмани таҳрирлаш",
      "buyurtma_holati": "Буюртма ҳолати",
      "sotildi": "Сотилди",
      "sotilgan_belgilash":
      "Бу буюртмани сотилган деб белгиламоқчимисиз?",
      "umumiy_hisobot": "Умумий ҳисобот",
      "mening_hisobotim": "Менинг ҳисоботим",
      "jami_sotildi": "Жами сотилди:",
      "jami_tayyorlandi": "Жами тайёрланди:",
      "dona": "дона",
      "umumiy_summa": "Умумий сумма:",
      "valyuta": "сўм",
      "buyurtmalar_mavjud_emas":
      "Буюртмалар мавжуд эмас",
      "ish_haqqi": "Иш ҳаққи:",
      "klent": "Клент",
      "holatni_ozgartirish":
      "Ҳолатни ўзгартириш",
      "Yanvar": "Январ",
      "Fevral": "Феврал",
      "Mart": "Март",
      "Aprel": "Апрел",
      "May": "Май",
      "Iyun": "Июн",
      "Iyul": "Июл",
      "Avgust": "Август",
      "Sentabr": "Сентябр",
      "Oktabr": "Октабр",
      "Noyabr": "Ноябр",
      "Dekabr": "Декабр",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  final List<String> oylar = const [
    '',
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'Iyun',
    'Iyul',
    'Avgust',
    'Sentabr',
    'Oktabr',
    'Noyabr',
    'Dekabr',
  ];

  String _formatMoney(double amount) {
    return NumberFormat('#,###').format(amount).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Consumer2<OrderProvider, ProfileProvider>(
      builder: (
          context,
          orderProvider,
          profileProvider,
          child,
          ) {
        final String lang = profileProvider.language;

        final allOrders = orderProvider.orders;

        final paidOrders = allOrders.where(
              (o) =>
          o.paymentStatus == "To'langan" ||
              o.status == "Sotildi",
        );

        final double totalRevenue = paidOrders.fold(
          0.0,
              (sum, o) {
            if (o.status == "Sotildi") {
              return sum + (o.price * o.quantity);
            }

            return sum + o.amountPaid;
          },
        );

        final int totalProductsCount = paidOrders.fold(
          0,
              (sum, o) => sum + o.quantity,
        );

        final int totalTaskCount = allOrders.length;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                child: _buildSummaryCard(
                  context,
                  lang,
                  totalProductsCount,
                  totalTaskCount,
                  totalRevenue,
                ),
              ),

              if (allOrders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      getTxt(
                        lang,
                        "buyurtmalar_mavjud_emas",
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: isDark
                            ? Colors.white54
                            : Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: allOrders.length,
                  itemBuilder: (context, index) {
                    final order = allOrders[index];

                    return _buildOrderCard(
                      context,
                      order,
                      lang,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      BuildContext context,
      String lang,
      int totalProducts,
      int totalOrders,
      double totalRevenue,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final double screenWidth =
        MediaQuery.of(context).size.width;

    final double horizontalPadding =
    screenWidth < 360 ? 15 : 20;

    final double fontSize =
    screenWidth < 360 ? 15 : 16;

    return Card(
      elevation: isDark ? 0 : 10,
      surfaceTintColor: Colors.transparent,
      shadowColor: isDark ? Colors.black26 : null,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF252836)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isDark
              ? Border.all(
            color: const Color(0xFF3A3F4B),
          )
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    getTxt(
                      lang,
                      "umumiy_hisobot",
                    ),
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.analytics,
                  color: isDark
                      ? const Color(0xFF3C8DFF)
                      : Colors.indigo,
                ),
              ],
            ),

            const SizedBox(height: 5),

            _buildSummaryRow(
              context,
              getTxt(
                lang,
                "jami_sotildi",
              ),
              "$totalProducts ${getTxt(lang, "dona")}",
              Colors.green,
              fontSize,
            ),

            const SizedBox(height: 5),

            _buildSummaryRow(
              context,
              getTxt(
                lang,
                "buyurtmalar",
              ),
              "$totalOrders ${getTxt(lang, "ta")}",
              Colors.green,
              fontSize,
            ),

            const SizedBox(height: 5),

            _buildSummaryRow(
              context,
              getTxt(
                lang,
                "umumiy_summa",
              ),
              "${_formatMoney(totalRevenue)} ${getTxt(lang, "valyuta")}",
              Colors.red,
              fontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      BuildContext context,
      String label,
      String value,
      Color valueColor,
      double fontSize,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(
      BuildContext context,
      OrderModel order,
      String lang,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final double screenWidth =
        MediaQuery.of(context).size.width;

    final bool isSmallScreen =
        screenWidth < 380;

    final double imageWidth =
    isSmallScreen ? 82 : 100;

    final double imageHeight =
    isSmallScreen ? 108 : 130;

    final double titleSize =
    isSmallScreen ? 16 : 18;

    return Card(
      elevation: isDark ? 0 : 10,
      surfaceTintColor: Colors.transparent,
      shadowColor: isDark ? Colors.black26 : null,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 5,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF252836)
              : Colors.white,
          border: isDark
              ? Border.all(
            color: const Color(0xFF3A3F4B),
          )
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(15),
                        color: isDark
                            ? const Color(0xFF2A2E38)
                            : Colors.grey,
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size:
                        isSmallScreen ? 42 : 50,
                        color: isDark
                            ? Colors.white24
                            : Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productName,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: titleSize,
                              color: isDark
                                  ? const Color(
                                0xFF3C8DFF,
                              )
                                  : Colors.indigo,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            "${getTxt(lang, "sana")} ${order.date.day} ${getTxt(lang, oylar[order.date.month])} ${order.date.year}",
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize:
                              isSmallScreen
                                  ? 12
                                  : 14,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 3),

                          _buildInfoRow(
                            context,
                            getTxt(
                              lang,
                              "narxi",
                            ),
                            "${_formatMoney(order.price)} ${getTxt(lang, "valyuta")}",
                          ),

                          _buildInfoRow(
                            context,
                            getTxt(
                              lang,
                              "mijoz",
                            ),
                            order.customerName.isEmpty
                                ? getTxt(
                              lang,
                              "klent",
                            )
                                : order.customerName,
                          ),

                          _buildInfoRow(
                            context,
                            getTxt(
                              lang,
                              "soni",
                            ),
                            "${order.quantity} ${getTxt(lang, "dona")}",
                          ),

                          _buildInfoRow(
                            context,
                            getTxt(
                              lang,
                              "tolov",
                            ),
                            order.status ==
                                "Sotildi"
                                ? getTxt(
                              lang,
                              "tolangan",
                            )
                                : getTxt(
                              lang,
                              "kutilmoqda",
                            ),
                            valueColor:
                            order.status ==
                                "Sotildi"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      String label,
      String value, {
        Color? valueColor,
      }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final double screenWidth =
        MediaQuery.of(context).size.width;

    final double labelWidth =
    screenWidth < 360 ? 55 : 65;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 2,
      ),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                screenWidth < 360 ? 12 : 13,
                color: isDark
                    ? Colors.white70
                    : Colors.green,
              ),
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                screenWidth < 360 ? 12 : 13,
                color: valueColor ??
                    (isDark
                        ? Colors.white
                        : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(
      BuildContext context,
      OrderModel order,
      OrderProvider provider,
      ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) =>
          Consumer<ProfileProvider>(
            builder:
                (context, profileProvider, child) {
              final String lang =
                  profileProvider.language;

              return AlertDialog(
                backgroundColor: isDark
                    ? const Color(0xFF252836)
                    : null,
                surfaceTintColor:
                Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                title: Text(
                  getTxt(
                    lang,
                    "buyurtma_holati",
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
                    "sotilgan_belgilash",
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
                  TextButton(
                    onPressed: () {
                      provider.updateOrderStatus(
                        order.id,
                        "Sotildi",
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      getTxt(
                        lang,
                        "sotildi",
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}