import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/order_model.dart';
import '../../provider/order_provider.dart';
import '../../model/model_provider.dart';
import '../../provider/profile_provider.dart';

class DraverBuyurtmalarPages extends StatefulWidget {
  const DraverBuyurtmalarPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'title': 'Buyurtmalar',
      'no_orders': "Hozircha buyurtmalar yo'q",
      'quantity': 'Soni:',
      'unit': 'Dona',
      'total': 'Summa:',
      'paid': "To'langan:",
      'payment_status': "To'lov holati:",
      'paid_status': "To'langan",
      'unpaid_status': "To'lanmagan",
      'date': 'Sanasi:',
      'comment': 'Izoh:',
      'customer': 'Mijoz:',
      'tel': 'Tel:',
      'no_info': "Ma'lumot yo'q",
      'cancel': 'Bekor qilish',
      'edit': 'Tahrirlash',
      'delete_confirm': "O'chirilsinmi?",
      'cancel_confirm': 'Bekor qilinsinmi?',
      'countdown_msg': 'Buyurtma {} soniyadan so\'ng arxivlanadi.',
      'no': "Yo'q",
      'ha': 'Ha',
      'preparing': 'Tayyorlanmoqda',
      'ready': 'Tayyor',
      'selling': 'Sotilmoqda',
      'sold': 'Sotildi',
      'cancelled': 'Bekor qilindi',
      'start_preparing': 'Tayyorlashni boshlaysizmi?',
      'is_ready': "Tayyor bo'ldimi?",
      'start_selling': 'Sotishni boshlaysizmi?',
      'new_order': 'Yangi buyurtma',
      'product': 'Mahsulot',
      'customer_name': 'Mijoz ismi',
      'phone_hint': 'Telefon (90 123 45 67)',
      'service_price': 'Xizmat haqqi',
      'date_label': 'Sana',
      'paid_amount': "To'langan summa",
      'add': "Qo'shish",
      'save': 'Saqlash',
      'prepare': 'Tayyorlash',
      'quantity_label': 'Soni',
      'comment_label': 'Izoh',
      'payment_status_label': "To'lov holati",
    },
    'Rus': {
      'title': 'Заказы',
      'no_orders': 'Пока нет заказов',
      'quantity': 'Кол-во:',
      'unit': 'Шт',
      'total': 'Сумма:',
      'paid': 'Оплачено:',
      'payment_status': 'Статус оплаты:',
      'paid_status': 'Оплачено',
      'unpaid_status': 'Не оплачено',
      'date': 'Дата:',
      'comment': 'Коммент:',
      'customer': 'Клиент:',
      'tel': 'Тел:',
      'no_info': 'Нет информации',
      'cancel': 'Отмена',
      'edit': 'Редактировать',
      'delete_confirm': 'Удалить?',
      'cancel_confirm': 'Отменить?',
      'countdown_msg': 'Заказ будет архивирован через {} сек.',
      'no': 'Нет',
      'ha': 'Да',
      'preparing': 'Готовится',
      'ready': 'Готово',
      'selling': 'Продается',
      'sold': 'Продано',
      'cancelled': 'Отменено',
      'start_preparing': 'Начать подготовку?',
      'is_ready': 'Готово?',
      'start_selling': 'Начать продажу?',
      'new_order': 'Новый заказ',
      'product': 'Продукт',
      'customer_name': 'Имя клиента',
      'phone_hint': 'Телефон (90 123 45 67)',
      'service_price': 'Цена услуги',
      'date_label': 'Дата',
      'paid_amount': 'Оплаченная сумма',
      'add': 'Добавить',
      'save': 'Сохранить',
      'prepare': 'Подготовить',
      'quantity_label': 'Кол-во',
      'comment_label': 'Коммент',
      'payment_status_label': 'Статус оплаты',
    },
    'Kiril': {
      'title': 'Буюртмалар',
      'no_orders': "Ҳозирча буюртмалар йўқ",
      'quantity': 'Сони:',
      'unit': 'Дона',
      'total': 'Сумма:',
      'paid': 'Тўланган:',
      'payment_status': 'Тўлов ҳолати:',
      'paid_status': 'Тўланган',
      'unpaid_status': 'Тўланмаган',
      'date': 'Санаси:',
      'comment': 'Изоҳ:',
      'customer': 'Мижоз:',
      'tel': 'Тел:',
      'no_info': 'Маълумот йўқ',
      'cancel': 'Бекор қилиш',
      'edit': 'Таҳрирлаш',
      'delete_confirm': 'Ўчирилсинми?',
      'cancel_confirm': 'Бекор қилинсинми?',
      'countdown_msg': 'Буюртма {} сониядан сўнг архивланади.',
      'no': 'Йўқ',
      'ha': 'Ҳа',
      'preparing': 'Тайёрланмоқда',
      'ready': 'Тайёр',
      'selling': 'Сотилмоқда',
      'sold': 'Сотилди',
      'cancelled': 'Бекор қилинди',
      'start_preparing': 'Тайёрлашни бошлайсизми?',
      'is_ready': 'Тайёр бўлдими?',
      'start_selling': 'Сотишни бошлайсизми?',
      'new_order': 'Янги буюртма',
      'product': 'Маҳсулот',
      'customer_name': 'Мижоз исми',
      'phone_hint': 'Телефон (90 123 45 67)',
      'service_price': 'Хизмат ҳаққи',
      'date_label': 'Сана',
      'paid_amount': 'Тўланган сумма',
      'add': 'Қўшиш',
      'save': 'Сақлаш',
      'prepare': 'Тайёрлаш',
      'quantity_label': 'Сони',
      'comment_label': 'Изоҳ',
      'payment_status_label': 'Тўлов ҳолати',
    }
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ?? _localizedTexts['Uzb']![key]!;
  }

  @override
  State<DraverBuyurtmalarPages> createState() => _DraverBuyurtmalarPagesState();
}

class _DraverBuyurtmalarPagesState extends State<DraverBuyurtmalarPages> {
  String? _archivingOrderId;
  int _countdown = 5;
  Timer? _timer;

  final maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _startArchiving(OrderModel order) {
    final provider = context.read<OrderProvider>();
    setState(() {
      _archivingOrderId = order.id;
      _countdown = 5;
    });
    provider.updateOrderStatus(order.id, "Sotildi");

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _archivingOrderId = null;
        });
      }
    });
  }

  void _cancelArchiving(String orderId) {
    _timer?.cancel();
    context.read<OrderProvider>().updateOrderStatus(orderId, "Sotilmoqda");
    setState(() {
      _archivingOrderId = null;
    });
  }

  String _translateStatus(String lang, String status) {
    switch (status) {
      case 'Tayyorlanmoqda':
        return DraverBuyurtmalarPages.getTxt(lang, 'preparing');
      case 'Tayyor':
        return DraverBuyurtmalarPages.getTxt(lang, 'ready');
      case 'Sotilmoqda':
        return DraverBuyurtmalarPages.getTxt(lang, 'selling');
      case 'Sotildi':
        return DraverBuyurtmalarPages.getTxt(lang, 'sold');
      case 'Bekor qilindi':
        return DraverBuyurtmalarPages.getTxt(lang, 'cancelled');
      case 'Tayyorlash':
        return DraverBuyurtmalarPages.getTxt(lang, 'prepare');
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedLanguage = Provider.of<ProfileProvider>(context).language;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF181A20) : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'title'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: Stack(
        children: [
          Consumer2<OrderProvider, MahsulotProvider>(
            builder: (context, orderProvider, mahsulotProvider, child) {
              final orders = orderProvider.orders.reversed
                  .where((o) => o.status != "Sotildi" || o.id == _archivingOrderId)
                  .toList();
              if (orders.isEmpty) {
                return Center(
                    child: Text(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'no_orders'),
                        style: TextStyle(
                            fontSize: 18,
                            color: isDark ? Colors.white70 : Colors.grey)));
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final jamiNarx = order.price * order.quantity;

                  // Mahsulotni topish (rasm uchun)
                  final product = mahsulotProvider.mahsulotlar.firstWhere(
                    (m) =>
                        m.nomi.toLowerCase() == order.productName.toLowerCase(),
                    orElse: () => MahsulotModel(
                        nomi: order.productName,
                        bemorNarxi: "0",
                        shifokorNarxi: "0",
                        kategoriya: "Umumiy",
                        keshbek: "0",
                        status: "Faol"),
                  );

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF252836) : Colors.white,
                        border: isDark
                            ? Border.all(color: const Color(0xFF3A3F4B))
                            : null,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black26
                                : Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: isDark
                                      ? const Color(0xFF2A2E38)
                                      : Colors.grey.shade300,
                                  image: product.rasm != null
                                      ? DecorationImage(
                                          image: FileImage(File(product.rasm!)),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                                child: product.rasm == null
                                    ? Icon(Icons.image,
                                        color: isDark
                                            ? Colors.white24
                                            : Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order.productName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: isDark
                                                ? const Color(0xFF3C8DFF)
                                                : Colors.indigo)),
                                    const SizedBox(height: 5),
                                    Text("${DraverBuyurtmalarPages.getTxt(selectedLanguage, 'quantity')} ${order.quantity} ${DraverBuyurtmalarPages.getTxt(selectedLanguage, 'unit')}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.indigo)),
                                    _infoRow(context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'total'),
                                        "${NumberFormat('#,###').format(jamiNarx)} UZS",
                                        valueColor: Colors.red),
                                    _infoRow(context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'paid'),
                                        "${NumberFormat('#,###').format(order.amountPaid)} UZS",
                                        valueColor: Colors.green),
                                    _infoRow(context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'payment_status'),
                                        order.paymentStatus,
                                        valueColor: order.paymentStatus ==
                                                "To'langan"
                                            ? Colors.green
                                            : Colors.orange),
                                    _infoRow(context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'date'),
                                        DateFormat('dd.MM.yyyy').format(order.date)),
                                    _infoRow(context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'comment'), order.comment,
                                        valueColor: order.comment.isEmpty
                                            ? (isDark
                                                ? Colors.white38
                                                : Colors.grey)
                                            : (isDark
                                                ? Colors.white70
                                                : Colors.indigo)),
                                    _infoRow(
                                        context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'customer'), order.customerName),
                                    Row(
                                      children: [
                                        Text(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'tel'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 13)),
                                        TextButton(
                                          onPressed: () => _makePhoneCall(
                                              "+998${order.phone.replaceAll(' ', '')}"),
                                          child: Text("+998 ${order.phone}",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _actionButton(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'cancel'), Colors.red, () {
                                _showConfirmDialog(context, DraverBuyurtmalarPages.getTxt(selectedLanguage, 'cancel_confirm'),
                                    () => orderProvider.updateOrderStatus(order.id, "Bekor qilindi"));
                              }),
                              _actionButton(
                                  _translateStatus(selectedLanguage, order.status),
                                  _getHolatColor(order.status),
                                  () => _handleHolatChange(context, order)),
                              _actionButton(
                                  DraverBuyurtmalarPages.getTxt(selectedLanguage, 'edit'),
                                  isDark
                                      ? const Color(0xFF3C8DFF)
                                      : Colors.indigo, () {
                                _showCustomOrderDialog(context, order: order);
                              }),
                              IconButton(
                                onPressed: () => _showConfirmDialog(
                                    context,
                                    DraverBuyurtmalarPages.getTxt(selectedLanguage, 'delete_confirm'),
                                    () => orderProvider.removeOrder(order.id)),
                                icon: Icon(Icons.delete,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: _archivingOrderId != null ? 20 : -130,
            left: 15,
            right: 15,
            child: _buildCountdownWidget(isDark, selectedLanguage),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownWidget(bool isDark, String selectedLanguage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.indigo.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DraverBuyurtmalarPages.getTxt(selectedLanguage, 'countdown_msg').replaceFirst('{}', _countdown.toString()),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: _archivingOrderId == null
                    ? null
                    : () => _cancelArchiving(_archivingOrderId!),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                child: Text(
                  DraverBuyurtmalarPages.getTxt(selectedLanguage, 'cancel'),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedLanguage = Provider.of<ProfileProvider>(context, listen: false).language;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value.isEmpty ? DraverBuyurtmalarPages.getTxt(selectedLanguage, 'no_info') : value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: valueColor ??
                          (isDark ? Colors.white70 : Colors.indigo)),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
      ),
    );
  }

  Color _getHolatColor(String holat) {
    switch (holat) {
      case 'Tayyorlanmoqda':
        return Colors.orange;
      case 'Tayyor':
        return Colors.blue;
      case 'Sotilmoqda':
        return Colors.purple;
      case 'Sotildi':
        return Colors.green;
      case 'Bekor qilindi':
        return Colors.black;
      default:
        return Colors.indigo;
    }
  }

  void _handleHolatChange(BuildContext context, OrderModel order) {
    final provider = context.read<OrderProvider>();
    final selectedLanguage = Provider.of<ProfileProvider>(context, listen: false).language;
    String savol = "";
    String yangiHolat = "";

    if (order.status == "Tayyorlash") {
      savol = DraverBuyurtmalarPages.getTxt(selectedLanguage, 'start_preparing');
      yangiHolat = "Tayyorlanmoqda";
    } else if (order.status == "Tayyorlanmoqda") {
      savol = DraverBuyurtmalarPages.getTxt(selectedLanguage, 'is_ready');
      yangiHolat = "Tayyor";
    } else if (order.status == "Tayyor") {
      savol = DraverBuyurtmalarPages.getTxt(selectedLanguage, 'start_selling');
      yangiHolat = "Sotilmoqda";
    } else if (order.status == "Sotilmoqda") {
      _startArchiving(order);
      return;
    } else {
      return;
    }

    _showConfirmDialog(
        context, savol, () => provider.updateOrderStatus(order.id, yangiHolat));
  }

  void _showConfirmDialog(
      BuildContext context, String title, VoidCallback onConfirm) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedLanguage = Provider.of<ProfileProvider>(context, listen: false).language;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF252836) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark
              ? const BorderSide(color: Color(0xFF3A3F4B))
              : BorderSide.none,
        ),
        title: Text(title,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.indigo,
                fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'no'),
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey))),
          TextButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context);
              },
              child: Text(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'ha'),
                  style: TextStyle(
                      color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo))),
        ],
      ),
    );
  }

  void _showCustomOrderDialog(BuildContext context, {OrderModel? order}) {
    final orderProvider = context.read<OrderProvider>();
    final mahsulotProvider = context.read<MahsulotProvider>();
    final selectedLanguage = Provider.of<ProfileProvider>(context, listen: false).language;

    final customerController =
        TextEditingController(text: order?.customerName ?? "");
    final phoneController = TextEditingController(text: order?.phone ?? "");
    final quantityController =
        TextEditingController(text: order?.quantity.toString() ?? "");
    final commentController =
        TextEditingController(text: order?.comment ?? "");
    final servicePriceController =
        TextEditingController(text: order?.servicePrice.toString() ?? "0");
    final amountPaidController =
        TextEditingController(text: order?.amountPaid.toString() ?? "0");
    String paymentStatus = order?.paymentStatus ?? "To'lanmagan";
    final sanaController = TextEditingController(
        text: order != null ? DateFormat('dd.MM.yyyy').format(order.date) : "");

    MahsulotModel? selectedMahsulot;
    if (order != null) {
      selectedMahsulot = mahsulotProvider.mahsulotlar.firstWhere(
        (m) => m.nomi.toLowerCase() == order.productName.toLowerCase(),
        orElse: () => MahsulotModel(
            nomi: order.productName,
            bemorNarxi: order.price.toString(),
            shifokorNarxi: order.servicePrice.toString(),
            kategoriya: "Umumiy",
            keshbek: "0",
            status: "Faol"),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF252836) : Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isDark
                  ? const BorderSide(color: Color(0xFF3A3F4B))
                  : BorderSide.none,
            ),
            title: Center(
              child: Text(
                order == null ? DraverBuyurtmalarPages.getTxt(selectedLanguage, 'new_order') : DraverBuyurtmalarPages.getTxt(selectedLanguage, 'edit'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Autocomplete<MahsulotModel>(
                    initialValue: TextEditingValue(
                      text: selectedMahsulot?.nomi ?? "",
                    ),
                    displayStringForOption: (m) => m.nomi,
                    optionsBuilder: (textValue) {
                      final options = mahsulotProvider.mahsulotlar
                          .where((m) => m.zaxira > 0);
                      if (textValue.text.isEmpty) {
                        return options;
                      }
                      return options.where(
                        (m) => m.nomi.toLowerCase().contains(
                              textValue.text.toLowerCase(),
                            ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          color: isDark ? const Color(0xFF2A2E38) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 250,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final MahsulotModel option =
                                    options.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    option.nomi,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
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
                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: _inputDecoration(
                          DraverBuyurtmalarPages.getTxt(
                              selectedLanguage, 'product'),
                          isDark,
                        ),
                        onFieldSubmitted: (value) {
                          onFieldSubmitted();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return DraverBuyurtmalarPages.getTxt(
                                selectedLanguage, 'product_required');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final match = mahsulotProvider.mahsulotlar.firstWhere(
                            (m) => m.nomi.toLowerCase() == value.toLowerCase(),
                            orElse: () => MahsulotModel(
                              nomi: "",
                              bemorNarxi: "0",
                              shifokorNarxi: "0",
                              kategoriya: "Umumiy",
                              keshbek: "0",
                              status: "Faol",
                            ),
                          );
                          if (match.nomi.isNotEmpty) {
                            setState(() => selectedMahsulot = match);
                          }
                        },
                      );
                    },
                    onSelected: (MahsulotModel selection) {
                      setState(() => selectedMahsulot = selection);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      controller: customerController,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'customer_name'), isDark)),
                  const SizedBox(height: 10),
                  TextField(
                      controller: phoneController,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.phone,
                      decoration:
                          _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'phone_hint'), isDark)),
                  const SizedBox(height: 10),
                  TextField(
                      controller: quantityController,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'quantity_label'), isDark),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  TextField(
                      controller: servicePriceController,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'service_price'), isDark),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  TextField(
                    controller: sanaController,
                    readOnly: true,
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'date_label'), isDark).copyWith(
                        prefixIcon: Icon(Icons.calendar_today,
                            color: isDark ? Colors.white70 : Colors.black54)),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: order?.date ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030));
                      if (picked != null) {
                        setState(() => sanaController.text =
                            DateFormat('dd.MM.yyyy').format(picked));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      controller: commentController,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'comment_label'), isDark)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: paymentStatus,
                    dropdownColor:
                        isDark ? const Color(0xFF2A2E38) : Colors.white,
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'payment_status_label'), isDark),
                    items: ["To'langan", "To'lanmagan"]
                        .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s == "To'langan" 
                                ? DraverBuyurtmalarPages.getTxt(selectedLanguage, 'paid_status') 
                                : DraverBuyurtmalarPages.getTxt(selectedLanguage, 'unpaid_status'),
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white : Colors.black))))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        paymentStatus = val!;
                        if (paymentStatus == "To'lanmagan") {
                          amountPaidController.text = "0";
                        }
                      });
                    },
                  ),
                  if (paymentStatus == "To'langan") ...[
                    const SizedBox(height: 10),
                    TextField(
                        controller: amountPaidController,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                        decoration: _inputDecoration(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'paid_amount'), isDark),
                        keyboardType: TextInputType.number),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(DraverBuyurtmalarPages.getTxt(selectedLanguage, 'cancel'),
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? const Color(0xFF3C8DFF) : Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (selectedMahsulot != null) {
                    final quantity = int.tryParse(quantityController.text) ?? 1;
                    final servicePrice =
                        double.tryParse(servicePriceController.text) ?? 0.0;
                    final amountPaid = paymentStatus == "To'langan"
                        ? (double.tryParse(amountPaidController.text) ?? 0.0)
                        : 0.0;
                    final price = double.tryParse(selectedMahsulot!.bemorNarxi
                            .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                        0.0;

                    DateTime orderDate = order?.date ?? DateTime.now();
                    try {
                      if (sanaController.text.isNotEmpty) {
                        orderDate = DateFormat('dd.MM.yyyy')
                            .parse(sanaController.text);
                      }
                    } catch (_) {}

                    final updatedOrder = OrderModel(
                      id: order?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      productName: selectedMahsulot!.nomi,
                      quantity: quantity,
                      price: price,
                      date: orderDate,
                      customerName: customerController.text,
                      phone: phoneController.text,
                      comment: commentController.text,
                      referrer: order?.referrer ?? "",
                      status: order?.status ?? "Tayyorlash",
                      paymentStatus: paymentStatus,
                      amountPaid: amountPaid,
                      servicePrice: servicePrice,
                    );

                    if (order == null) {
                      orderProvider.addOrder(updatedOrder);
                      mahsulotProvider.zaxiraYangilash(
                          selectedMahsulot!.nomi, -quantity);
                    } else {
                      orderProvider.updateOrder(updatedOrder);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(order == null ? DraverBuyurtmalarPages.getTxt(selectedLanguage, 'add') : DraverBuyurtmalarPages.getTxt(selectedLanguage, 'save')),
              ),
            ],
          );
        });
      },
    );
  }

  InputDecoration _inputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2E38) : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDark ? const Color(0xFF3A3F4B) : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDark ? const Color(0xFF3C8DFF) : Colors.indigo),
      ),
    );
  }

  double _scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double factor = width / 390; // 390 - standart o'rtacha telefon eni
    if (factor < 0.8) factor = 0.8; // juda kichik ekranlarda ham o'qilishi uchun
    if (factor > 1.15) factor = 1.15; // planshetlarda haddan tashqari kattalashmasin
    return factor;
  }
}
