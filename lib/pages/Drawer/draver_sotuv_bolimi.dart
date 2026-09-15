import 'dart:ui';
import 'package:afada/provider/sale_provider.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/mahsulot_modeli.dart';
import '../../model/mijoz_modeli.dart';
import '../../model/model_provider.dart';
import '../../provider/mijoz_provider/mijoz_provider.dart';
import '../../provider/order_provider.dart';
import '../../provider/profile_provider.dart';

class DraverSotuvBolimi extends StatefulWidget {
  const DraverSotuvBolimi({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    "Uzb": {
      "sotuv_bolimi": "Sotuv bo'limi",
      "restricted_msg": "Bu bo'lim faqat Administrator uchun mavjud.",
      "umumiy_tushum": "Umumiy Tushum",
      "sotilganlar_yoq": "Sotilgan mahsulotlar yo'q",
      "mijoz": "Mijoz:",
      "tel": "Tel:",
      "yuboruvchi": "Yuboruvchi:",
      "mahsulot": "Mahsulot:",
      "soni": "Soni:",
      "sana": "Sana:",
      "jami_summa": "Jami summa:",
      "tolangan": "To'langan:",
      "tolov_holati": "To'lov holati:",
      "tolangan_status": "To'langan",
      "tolanmagan_status": "To'lanmagan",
      "mahsulot_sotish": "Mahsulot sotish",
      "savdo_turi": "Savdo turi",
      "bir_martalik": "Bir martalik mijoz",
      "doimiy_mijoz": "Doimiy mijoz",
      "mijoz_tanlang": "Mijoz tanlang",
      "mijoz_telefoni": "Mijoz telefoni",
      "mijoz_ismi": "Mijoz ismi",
      "telefon_raqami": "Telefon raqami",
      "mahsulot_tanlang": "Mahsulot tanlang",
      "sotish_narxi": "Sotish narxi",
      "chegirma": "Chegirma",
      "yuboruvchi_ixtiyoriy": "Yuboruvchi (Ixtiyoriy)",
      "bekor_qilish": "Bekor qilish",
      "saqlash": "Saqlash",
      "muvaffaqiyat": "Sotuv muvaffaqiyatli amalga oshirildi!",
      "o'chirildi": "Muvaffaqiyatli o'chirildi",
      "xatolik": "Xatolik yuz berdi",
      "barcha_maydonlar": "Barcha maydonlarni to'ldiring!",
      "dona": "dona",
      "mavjud": "Mavjud",
      "valyuta": "UZS",
    },
    "Rus": {
      "sotuv_bolimi": "Отдел продаж",
      "restricted_msg": "Этот раздел доступен только администратору.",
      "umumiy_tushum": "Общая выручка",
      "sotilganlar_yoq": "Проданных товаров нет",
      "mijoz": "Клиент:",
      "tel": "Тел:",
      "yuboruvchi": "Отправитель:",
      "mahsulot": "Товар:",
      "soni": "Количество:",
      "sana": "Дата:",
      "jami_summa": "Общая сумма:",
      "tolangan": "Оплачено:",
      "tolov_holati": "Статус оплаты:",
      "tolangan_status": "Оплачено",
      "tolanmagan_status": "Не оплачено",
      "mahsulot_sotish": "Продажа товара",
      "savdo_turi": "Тип продажи",
      "bir_martalik": "Разовый клиент",
      "doimiy_mijoz": "Постоянный клиент",
      "mijoz_tanlang": "Выберите клиента",
      "mijoz_telefoni": "Телефон клиента",
      "mijoz_ismi": "Имя клиента",
      "telefon_raqami": "Номер телефона",
      "mahsulot_tanlang": "Выберите товар",
      "sotish_narxi": "Цена продажи",
      "chegirma": "Скидка",
      "yuboruvchi_ixtiyoriy": "Отправитель (необязательно)",
      "bekor_qilish": "Отмена",
      "saqlash": "Сохранить",
      "muvaffaqiyat": "Продажа успешно завершена!",
      "o'chirildi": "Успешно удалено",
      "xatolik": "Произошла ошибка",
      "barcha_maydonlar": "Заполните все поля!",
      "dona": "шт",
      "mavjud": "В наличии",
      "valyuta": "сум",
    },
    "Kiril": {
      "sotuv_bolimi": "Сотув бўлими",
      "restricted_msg": "Бу бўлим фақат Администратор учун мавжуд.",
      "umumiy_tushum": "Умумий Тушум",
      "sotilganlar_yoq": "Сотилган маҳсулотлар йўқ",
      "mijoz": "Мижоз:",
      "tel": "Тел:",
      "yuboruvchi": "Юборувчи:",
      "mahsulot": "Маҳсулот:",
      "soni": "Сони:",
      "sana": "Сана:",
      "jami_summa": "Жами сумма:",
      "tolangan": "Тўланган:",
      "tolov_holati": "Тўлов ҳолати:",
      "tolangan_status": "Тўланган",
      "tolanmagan_status": "Тўланмаган",
      "mahsulot_sotish": "Маҳсулот сотиш",
      "savdo_turi": "Савдо тури",
      "bir_martalik": "Бир марталик мижоз",
      "doimiy_mijoz": "Доимий мижоз",
      "mijoz_tanlang": "Мижоз танланг",
      "mijoz_telefoni": "Мижоз телефони",
      "mijoz_ismi": "Мижоз исми",
      "telefon_raqami": "Телефон рақами",
      "mahsulot_tanlang": "Маҳсулот танланг",
      "sotish_narxi": "Сотиш нархи",
      "chegirma": "Чегирма",
      "yuboruvchi_ixtiyoriy": "Юборувчи (Ихтиёрий)",
      "bekor_qilish": "Бекор қилиш",
      "saqlash": "Сақлаш",
      "muvaffaqiyat": "Сотув муваффақиятли амалга оширилди!",
      "o'chirildi": "Муваффақиятли ўчирилди",
      "xatolik": "Хатолик юз берди",
      "barcha_maydonlar": "Барча майдонларни тўлдиринг!",
      "dona": "дона",
      "mavjud": "Мавжуд",
      "valyuta": "сўм",
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? key;
  }

  @override
  State<DraverSotuvBolimi> createState() => _DraverSotuvBolimiState();
}

class _DraverSotuvBolimiState extends State<DraverSotuvBolimi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaleProvider>().fetchSales();
      context.read<OrderProvider>().fetchSalesFromApi(); // Also update OrderProvider for global consistency
      context.read<MahsulotProvider>().loadProducts();
      context.read<MijozProvider>().loadMijozlar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<ProfileProvider>().language;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(DraverSotuvBolimi.getTxt(lang, "sotuv_bolimi"), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      floatingActionButton: Padding(
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
                  onTap: () => _showSotishDialog(context),
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
      ),
      body: Consumer2<SaleProvider, MahsulotProvider>(
        builder: (context, saleProvider, mahsulotProvider, child) {
          final sotilganlar = saleProvider.sales;

          double jamiTushum = saleProvider.totalRevenue;

          if (saleProvider.isLoading && sotilganlar.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)
                  ]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    Text(DraverSotuvBolimi.getTxt(lang, "umumiy_tushum"), style: const TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      "${NumberFormat('#,###', 'en_US').format(jamiTushum).replaceAll(',', ' ')} ${DraverSotuvBolimi.getTxt(lang, "valyuta")}",
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<SaleProvider>().fetchSales();
                    if (mounted) {
                      await context.read<OrderProvider>().fetchSalesFromApi();
                    }
                  },
                  child: sotilganlar.isEmpty
                      ? Center(child: Text(DraverSotuvBolimi.getTxt(lang, "sotilganlar_yoq"), style: const TextStyle(fontSize: 18, color: Colors.grey)))
                      : ListView.builder(
                          itemCount: sotilganlar.length,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            final o = sotilganlar[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "mijoz"), o.customerName),
                                    if (o.customer?.telefon != null || o.phoneNumber != null)
                                      _buildRow(
                                        context,
                                        DraverSotuvBolimi.getTxt(lang, "tel"),
                                        ((o.customer?.telefon ?? o.phoneNumber!)
                                                .startsWith('+')
                                            ? (o.customer?.telefon ??
                                                o.phoneNumber!)
                                            : '+${o.customer?.telefon ?? o.phoneNumber!}'),
                                        isLink: true,
                                      ),
                                    if (o.referrer != null)
                                      _buildRow(context, DraverSotuvBolimi.getTxt(lang, "yuboruvchi"), o.referrerName, color: Colors.blueGrey),
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "mahsulot"), o.productName),
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "soni"), "${o.quantity} ${DraverSotuvBolimi.getTxt(lang, "dona")}"),
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "sana"), DateFormat('dd.MM.yyyy HH:mm').format(o.date), color: Colors.green),
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "jami_summa"), "${NumberFormat('#,###', 'en_US').format(o.jamiSumma).replaceAll(',', ' ')} ${DraverSotuvBolimi.getTxt(lang, "valyuta")}"),
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "tolangan"), "${NumberFormat('#,###', 'en_US').format(o.amountPaid).replaceAll(',', ' ')} ${DraverSotuvBolimi.getTxt(lang, "valyuta")}", color: Colors.green),
                                    _buildRow(context, DraverSotuvBolimi.getTxt(lang, "tolov_holati"), o.debt <= 0 ? DraverSotuvBolimi.getTxt(lang, "tolangan_status") : DraverSotuvBolimi.getTxt(lang, "tolanmagan_status"), color: o.debt <= 0 ? Colors.green : Colors.orange),
                                    const Divider(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => _confirmDelete(context, o.id!),
                                      ),
                                    ),
                                  ],
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

  Widget _buildRow(BuildContext context, String label, String value, {Color? color, bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color ?? (isLink ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    final lang = context.read<ProfileProvider>().language;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sotuvni o'chirish"),
        content: const Text("Haqiqatan ham ushbu sotuvni o'chirmoqchimisiz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Bekor qilish")),
          TextButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              nav.pop();
              try {
                // Avval sotuvni o'chiramiz
                await context.read<SaleProvider>().deleteSale(id);
                
                // Muvaffaqiyatli o'chgan bo'lsa, darhol xabarni ko'rsatamiz
                messenger.showSnackBar(SnackBar(
                  content: Text(DraverSotuvBolimi.getTxt(lang, "o'chirildi")),
                  backgroundColor: Colors.green
                ));

                // Keyin ma'lumotlarni fonda yangilaymiz (xato bo'lsa ham foydalanuvchiga xunuk ko'rinmaydi)
                try {
                  await context.read<OrderProvider>().fetchSalesFromApi();
                  if (context.mounted) {
                    await context.read<MahsulotProvider>().loadProducts();
                    await context.read<FinishedProductProvider>().fetchFinishedProducts();
                  }
                } catch (e) {
                  debugPrint("Refresh error: $e");
                }
              } catch (e) {
                messenger.showSnackBar(SnackBar(
                  content: Text(DraverSotuvBolimi.getTxt(lang, "xatolik")), 
                  backgroundColor: Colors.red
                ));
              }
            },
            child: const Text("O'chirish", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSotishDialog(BuildContext context) {
    final mahsulotProvider = context.read<MahsulotProvider>();
    final saleProvider = context.read<SaleProvider>();
    final mijozProvider = context.read<MijozProvider>();
    final finishedProductProvider = context.read<FinishedProductProvider>();
    final lang = context.read<ProfileProvider>().language;

    MahsulotModel? selectedMahsulot;
    MijozModel? selectedMijoz;
    MijozModel? selectedReferrer;

    String savdoTuri = "Bir martalik mijoz";

    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController =
    TextEditingController(text: "+998 ");
    final TextEditingController soniController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController chegirmaController =
    TextEditingController(text: "0");
    final TextEditingController jamiSummaController =
    TextEditingController();

    String tolovHolati = "To'landi";

    final TextEditingController tolanganSummaController =
    TextEditingController();

    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            // =========================================================
            // JAMI SUMMANI HISOBLASH
            // =========================================================

            if (selectedMahsulot != null) {
              final double p = double.tryParse(
                selectedMahsulot!.bemorNarxi
                    .replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
                  0.0;

              final int q = int.tryParse(
                soniController.text
                    .replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
                  0;

              final double d = double.tryParse(
                chegirmaController.text
                    .replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
                  0.0;

              final double total = (p * q) - d;

              final String formattedTotal =
              NumberFormat('#,###', 'en_US')
                  .format(total < 0 ? 0 : total)
                  .replaceAll(',', ' ');

              if (jamiSummaController.text != formattedTotal) {
                jamiSummaController.text = formattedTotal;
              }
            }

            // =========================================================
            // EKRAN O'LCHAMLARI
            // =========================================================

            final media = MediaQuery.of(context);

            final double screenWidth = media.size.width;
            final double screenHeight = media.size.height;
            final double keyboardHeight = media.viewInsets.bottom;

            // Kichik ekranlarda kenglik deyarli to'liq,
            // katta ekranlarda esa 500 px dan oshmaydi.
            final double dialogWidth = screenWidth >= 600 ? 500.w : 340.w;

            // Keyboard chiqqanda dialog balandligini kamaytiramiz.
            final double availableHeight = screenHeight - keyboardHeight - 100.h;
            final double dialogHeight = availableHeight.clamp(280.0, 580.h);

            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),

              // =======================================================
              // DIALOG STYLE
              // =======================================================

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),

              titlePadding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 8.h),
              contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              actionsPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),

              // =======================================================
              // TITLE
              // =======================================================

              title: Text(
                DraverSotuvBolimi.getTxt(lang, "mahsulot_sotish"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // =======================================================
              // CONTENT
              // =======================================================

              content: SizedBox(
                width: dialogWidth,
                height: dialogHeight,

                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                    children: [

                      // =================================================
                      // SAVDO TURI
                      // =================================================

                      DropdownButtonFormField<String>(
                        initialValue: savdoTuri,

                        isExpanded: true,

                        decoration: InputDecoration(
                          labelText: DraverSotuvBolimi.getTxt(lang, "savdo_turi"),
                          prefixIcon: const Icon(Icons.swap_horizontal_circle_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                        ),

                        items: [
                          "Bir martalik mijoz",
                          "Doimiy mijoz",
                        ]
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              DraverSotuvBolimi.getTxt(
                                lang,
                                e ==
                                    "Bir martalik mijoz"
                                    ? "bir_martalik"
                                    : "doimiy_mijoz",
                              ),
                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),

                        onChanged: (val) {
                          if (val == null) return;

                          setState(() {
                            savdoTuri = val;
                            selectedMijoz = null;
                            nameController.clear();
                            phoneController.text =
                            "+998 ";
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      // =================================================
                      // DOIMIY MIJOZ
                      // =================================================

                      if (savdoTuri == "Doimiy mijoz") ...[
                        Autocomplete<MijozModel>(
                          displayStringForOption: (m) => "${m.ism} ${m.familya}",
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return mijozProvider.mijozlar;
                            }
                            final query = textEditingValue.text.toLowerCase();
                            final rawQuery = query.replaceAll(RegExp(r'\D'), '');
                            return mijozProvider.mijozlar.where((m) {
                              final fullName = "${m.ism} ${m.familya}".toLowerCase();
                              final phone = m.telefon.replaceAll(' ', '');
                              return m.ism.toLowerCase().contains(query) ||
                                  m.familya.toLowerCase().contains(query) ||
                                  fullName.contains(query) ||
                                  (rawQuery.isNotEmpty && phone.contains(rawQuery));
                            });
                          },
                          onSelected: (MijozModel val) {
                            setState(() {
                              selectedMijoz = val;
                              String phone = val.telefon;
                              if (!phone.startsWith('+')) {
                                phone = '+998 $phone';
                              }
                              phoneController.text = phone;
                            });
                          },
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: DraverSotuvBolimi.getTxt(lang, "mijoz_tanlang"),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                              ),
                              onSubmitted: (value) => onFieldSubmitted(),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            final bool isDark = Theme.of(context).brightness == Brightness.dark;
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                color: isDark ? const Color(0xFF2A2E38) : Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                child: SizedBox(
                                  width: dialogWidth,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(
                                          "${option.ism} ${option.familya}",
                                          style: TextStyle(
                                            color: isDark ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "+998 ${option.telefon}",
                                          style: TextStyle(
                                            color: isDark ? Colors.white70 : Colors.black54,
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
                        ),
                        if (selectedMijoz != null) ...[
                          const SizedBox(height: 15),
                          TextField(
                            controller: phoneController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: DraverSotuvBolimi.getTxt(lang, "mijoz_telefoni"),
                              prefixIcon: const Icon(Icons.phone_android_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white10
                                  : Colors.grey.shade100,
                            ),
                          ),
                        ],
                      ]

                      // =================================================
                      // BIR MARTALIK MIJOZ
                      // =================================================

                      else ...[
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: DraverSotuvBolimi.getTxt(lang, "mijoz_ismi"),
                            prefixIcon: const Icon(Icons.person_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_UzPhoneInputFormatter()],
                          decoration: InputDecoration(
                            labelText: DraverSotuvBolimi.getTxt(lang, "telefon_raqami"),
                            prefixIcon: const Icon(Icons.phone_android_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 15),

                      // =================================================
                      // MAHSULOT
                      // =================================================

                      Autocomplete<MahsulotModel>(
                        displayStringForOption: (m) => m.nomi,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          final options = mahsulotProvider.mahsulotlar.where((m) => m.zaxira > 0);
                          if (textEditingValue.text.isEmpty) {
                            return options;
                          }
                          return options.where((m) => m.nomi.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (MahsulotModel val) {
                          setState(() {
                            selectedMahsulot = val;

                            final double p = double.tryParse(val.bemorNarxi.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

                            priceController.text = NumberFormat('#,###', 'en_US').format(p).replaceAll(',', ' ');

                            if (soniController.text.isEmpty) {
                              soniController.text = "1";
                            }

                            final int q = int.tryParse(soniController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
                            final double d = double.tryParse(chegirmaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

                            if (tolovHolati == "To'landi") {
                              final double total = (p * q) - d;
                              tolanganSummaController.text = NumberFormat('#,###', 'en_US').format(total < 0 ? 0 : total).replaceAll(',', ' ');
                            }
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: DraverSotuvBolimi.getTxt(lang, "mahsulot_tanlang"),
                              prefixIcon: const Icon(Icons.inventory_2_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                            ),
                            onSubmitted: (value) => onFieldSubmitted(),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          final bool isDark = Theme.of(context).brightness == Brightness.dark;
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              color: isDark ? const Color(0xFF2A2E38) : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              child: SizedBox(
                                width: dialogWidth,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(
                                        "${option.nomi} (${option.zaxira} ${DraverSotuvBolimi.getTxt(lang, "dona")})",
                                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                      ),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // =================================================
                      // MAHSULOT TANLANGANDAN KEYIN
                      // =================================================

                      if (selectedMahsulot != null) ...[
                        const SizedBox(height: 15),

                        // MIQDOR + NARX
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller:
                                soniController,

                                keyboardType:
                                TextInputType.number,

                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                ],

                                onChanged: (val) {
                                  setState(() {
                                    if (tolovHolati ==
                                        "To'landi") {
                                      final double p =
                                          double.tryParse(
                                            selectedMahsulot
                                                ?.bemorNarxi
                                                .replaceAll(
                                              RegExp(
                                                  r'[^0-9]'),
                                              '',
                                            ) ??
                                                '0',
                                          ) ??
                                              0.0;

                                      final int q =
                                          int.tryParse(
                                            val.replaceAll(
                                              RegExp(
                                                  r'[^0-9]'),
                                              '',
                                            ),
                                          ) ??
                                              0;

                                      final double d =
                                          double.tryParse(
                                            chegirmaController
                                                .text
                                                .replaceAll(
                                              RegExp(
                                                  r'[^0-9]'),
                                              '',
                                            ),
                                          ) ??
                                              0.0;

                                      final double total =
                                          (p * q) - d;

                                      tolanganSummaController
                                          .text =
                                          NumberFormat(
                                            '#,###',
                                            'en_US',
                                          )
                                              .format(
                                            total < 0
                                                ? 0
                                                : total,
                                          )
                                              .replaceAll(
                                            ',',
                                            ' ',
                                          );
                                    }
                                  });
                                },

                                decoration: InputDecoration(
                                  labelText: DraverSotuvBolimi.getTxt(lang, "soni"),
                                  prefixIcon: const Icon(Icons.shopping_cart_outlined),
                                  helperText: "${DraverSotuvBolimi.getTxt(lang, "mavjud")}: ${selectedMahsulot!.zaxira}",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller:
                                priceController,

                                readOnly: true,

                                decoration: InputDecoration(
                                  labelText: DraverSotuvBolimi.getTxt(lang, "sotish_narxi"),
                                  prefixIcon: const Icon(Icons.paid_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white10
                                      : Colors.grey.shade100,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // CHEGIRMA + JAMI
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                chegirmaController,

                                keyboardType:
                                TextInputType.number,

                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                  _CurrencyInputFormatter(),
                                ],

                                onChanged: (val) {
                                  setState(() {
                                    if (tolovHolati ==
                                        "To'landi") {
                                      final double p =
                                          double.tryParse(
                                            selectedMahsulot
                                                ?.bemorNarxi
                                                .replaceAll(
                                              RegExp(
                                                  r'[^0-9]'),
                                              '',
                                            ) ??
                                                '0',
                                          ) ??
                                              0.0;

                                      final int q =
                                          int.tryParse(
                                            soniController
                                                .text
                                                .replaceAll(
                                              RegExp(
                                                  r'[^0-9]'),
                                              '',
                                            ),
                                          ) ??
                                              0;

                                      final double d =
                                          double.tryParse(
                                            val.replaceAll(
                                              RegExp(
                                                  r'[^0-9]'),
                                              '',
                                            ),
                                          ) ??
                                              0.0;

                                      final double total =
                                          (p * q) - d;

                                      tolanganSummaController
                                          .text =
                                          NumberFormat(
                                            '#,###',
                                            'en_US',
                                          )
                                              .format(
                                            total < 0
                                                ? 0
                                                : total,
                                          )
                                              .replaceAll(
                                            ',',
                                            ' ',
                                          );
                                    }
                                  });
                                },

                                decoration: InputDecoration(
                                  labelText: DraverSotuvBolimi.getTxt(lang, "chegirma"),
                                  prefixIcon: const Icon(Icons.discount_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: TextField(
                                controller:
                                jamiSummaController,

                                readOnly: true,

                                decoration: InputDecoration(
                                  labelText: DraverSotuvBolimi.getTxt(lang, "jami_summa"),
                                  prefixIcon: const Icon(Icons.receipt_long_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white10
                                      : Colors.grey.shade100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 15),

                      // =================================================
                      // TO'LOV HOLATI
                      // =================================================

                      DropdownButtonFormField<String>(
                        initialValue: tolovHolati,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: DraverSotuvBolimi.getTxt(lang, "tolov_holati"),
                          prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                        ),

                        items: [
                          "To'landi",
                          "To'lanmadi",
                        ]
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              DraverSotuvBolimi.getTxt(
                                lang,
                                e == "To'landi"
                                    ? "tolangan_status"
                                    : "tolanmagan_status",
                              ),
                            ),
                          ),
                        )
                            .toList(),

                        onChanged: (val) {
                          if (val == null) return;

                          setState(() {
                            tolovHolati = val;

                            if (tolovHolati ==
                                "To'landi") {
                              final double p =
                                  double.tryParse(
                                    selectedMahsulot
                                        ?.bemorNarxi
                                        .replaceAll(
                                      RegExp(
                                          r'[^0-9]'),
                                      '',
                                    ) ??
                                        '0',
                                  ) ??
                                      0.0;

                              final int q =
                                  int.tryParse(
                                    soniController
                                        .text
                                        .replaceAll(
                                      RegExp(
                                          r'[^0-9]'),
                                      '',
                                    ),
                                  ) ??
                                      0;

                              final double d =
                                  double.tryParse(
                                    chegirmaController
                                        .text
                                        .replaceAll(
                                      RegExp(
                                          r'[^0-9]'),
                                      '',
                                    ),
                                  ) ??
                                      0.0;

                              final double total =
                                  (p * q) - d;

                              tolanganSummaController
                                  .text = NumberFormat(
                                '#,###',
                                'en_US',
                              )
                                  .format(
                                total < 0
                                    ? 0
                                    : total,
                              )
                                  .replaceAll(
                                ',',
                                ' ',
                              );
                            } else {
                              tolanganSummaController
                                  .clear();
                            }
                          });
                        },
                      ),

                      // =================================================
                      // TO'LANGAN SUMMA
                      // =================================================

                      if (tolovHolati ==
                          "To'landi") ...[
                        const SizedBox(height: 15),

                        TextField(
                          controller: tolanganSummaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _CurrencyInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: DraverSotuvBolimi.getTxt(lang, "tolangan"),
                            prefixIcon: const Icon(Icons.paid_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 15),

                      // =================================================
                      // YUBORUVCHI
                      // =================================================

                      DropdownButtonFormField<MijozModel>(
                        initialValue: selectedReferrer,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: DraverSotuvBolimi.getTxt(lang, "yuboruvchi_ixtiyoriy"),
                          prefixIcon: const Icon(Icons.send_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                        ),

                        items: mijozProvider.mijozlar
                            .map(
                              (m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              "${m.ism} ${m.familya}",
                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          ),
                        )
                            .toList(),

                        onChanged: (val) {
                          setState(() {
                            selectedReferrer = val;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),

              // =========================================================
              // ACTIONS
              // =========================================================

              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(context),

                  child: Text(
                    DraverSotuvBolimi.getTxt(
                      lang,
                      "bekor_qilish",
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  ),

                  onPressed: isSubmitting
                      ? null
                      : () async {
                    final bool isDoimiy =
                        savdoTuri ==
                            "Doimiy mijoz";

                    final bool mijozTanlangan =
                    isDoimiy
                        ? selectedMijoz != null
                        : phoneController
                        .text.length >=
                        5;

                    if (selectedMahsulot != null &&
                        mijozTanlangan &&
                        soniController
                            .text.isNotEmpty) {
                      final quantity =
                          int.tryParse(
                            soniController
                                .text
                                .replaceAll(
                              RegExp(
                                  r'[^0-9]'),
                              '',
                            ),
                          ) ??
                              1;

                      if (quantity >
                          selectedMahsulot!
                              .zaxira) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Zaxirada yetarli mahsulot yo'q!",
                            ),
                            backgroundColor:
                            Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(
                            () =>
                        isSubmitting = true,
                      );

                      try {
                        final paid =
                            double.tryParse(
                              tolanganSummaController
                                  .text
                                  .replaceAll(
                                RegExp(
                                    r'[^0-9]'),
                                '',
                              ),
                            ) ??
                                0.0;

                        final discount =
                            double.tryParse(
                              chegirmaController
                                  .text
                                  .replaceAll(
                                RegExp(
                                    r'[^0-9]'),
                                '',
                              ),
                            ) ??
                                0.0;

                        await saleProvider
                            .addSale(
                          productId:
                          selectedMahsulot!
                              .id!,
                          saleType: isDoimiy
                              ? 'client'
                              : 'patient',
                          quantity: quantity,
                          paid: paid,
                          customerId:
                          selectedMijoz?.id,
                          referrerId:
                          selectedReferrer?.id,
                          phoneNumber: isDoimiy
                              ? null
                              : phoneController
                              .text,
                          discount: discount,
                        );

                        await context
                            .read<OrderProvider>()
                            .fetchSalesFromApi();

                        await mahsulotProvider
                            .loadProducts();

                        await finishedProductProvider
                            .fetchFinishedProducts();

                        if (context.mounted) {
                          Navigator.pop(
                            context,
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                DraverSotuvBolimi
                                    .getTxt(
                                  lang,
                                  "muvaffaqiyat",
                                ),
                              ),
                              backgroundColor:
                              Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                DraverSotuvBolimi.getTxt(lang, "xatolik"),
                              ),
                              backgroundColor:
                              Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (context.mounted) {
                          setState(
                                () => isSubmitting =
                            false,
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            DraverSotuvBolimi.getTxt(
                              lang,
                              "barcha_maydonlar",
                            ),
                          ),
                          backgroundColor:
                          Colors.red,
                        ),
                      );
                    }
                  },

                  child: isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    DraverSotuvBolimi.getTxt(
                      lang,
                      "saqlash",
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.isEmpty) return newValue.copyWith(text: '');

    double value = double.parse(newText);
    String formattedText =
        NumberFormat('#,###', 'en_US').format(value).replaceAll(',', ' ');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _UzPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.length < 5) {
      return const TextEditingValue(
        text: '+998 ',
        selection: TextSelection.collapsed(offset: 5),
      );
    }

    if (!text.startsWith('+998 ')) {
      return oldValue;
    }

    String digits = text.substring(5).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    StringBuffer result = StringBuffer('+998 ');
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || i == 7) {
        result.write(' ');
      }
      result.write(digits[i]);
    }

    String formatted = result.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
