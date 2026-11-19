import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/mahsulot_modeli.dart';
import '../../model/model_provider.dart';
import '../../model/order_model.dart';
import '../../provider/order_provider.dart';
import '../../provider/profile_provider.dart';

class DraverBuyurtmalarPages extends StatefulWidget {
  const DraverBuyurtmalarPages({super.key});

  static final Map<String, Map<String, String>> _localizedTexts = {
    'Uzb': {
      'title': 'Buyurtmalar',
      'all': 'Barchasi',
      'active_orders': 'Faol buyurtmalar',
      'total_sum': 'Umumiy summa',
      'total_paid': "To'langan summa",
      'search': 'Mahsulot, mijoz yoki telefon...',
      'no_orders': "Hozircha buyurtmalar yo'q",
      'not_found': 'Buyurtma topilmadi',
      'quantity': 'Soni:',
      'unit': 'dona',
      'count_unit': 'ta',
      'currency': 'UZS',
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
      'delete': "O'chirish",
      'delete_confirm': "Ushbu buyurtmani o'chirmoqchimisiz?",
      'cancel_confirm': 'Buyurtmani bekor qilmoqchimisiz?',
      'countdown_msg': "Buyurtma {} soniyadan so'ng arxivlanadi.",
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
      'product_required': 'Mahsulotni tanlang!',
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
      'all': 'Все',
      'active_orders': 'Активные заказы',
      'total_sum': 'Общая сумма',
      'total_paid': 'Оплачено всего',
      'search': 'Товар, клиент или телефон...',
      'no_orders': 'Пока нет заказов',
      'not_found': 'Заказы не найдены',
      'quantity': 'Кол-во:',
      'unit': 'шт',
      'count_unit': 'шт',
      'currency': 'UZS',
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
      'delete': 'Удалить',
      'delete_confirm': 'Удалить этот заказ?',
      'cancel_confirm': 'Отменить этот заказ?',
      'countdown_msg': 'Заказ будет архивирован через {} сек.',
      'no': 'Нет',
      'ha': 'Да',
      'preparing': 'Готовится',
      'ready': 'Готово',
      'selling': 'Продается',
      'sold': 'Продано',
      'cancelled': 'Отменено',
      'start_preparing': 'Начать подготовку?',
      'is_ready': 'Заказ готов?',
      'start_selling': 'Начать продажу?',
      'new_order': 'Новый заказ',
      'product': 'Продукт',
      'product_required': 'Выберите продукт!',
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
      'all': 'Барчаси',
      'active_orders': 'Фаол буюртмалар',
      'total_sum': 'Умумий сумма',
      'total_paid': 'Тўланган сумма',
      'search': 'Маҳсулот, мижоз ёки телефон...',
      'no_orders': 'Ҳозирча буюртмалар йўқ',
      'not_found': 'Буюртма топилмади',
      'quantity': 'Сони:',
      'unit': 'дона',
      'count_unit': 'та',
      'currency': 'UZS',
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
      'delete': 'Ўчириш',
      'delete_confirm': 'Ушбу буюртмани ўчирмоқчимисиз?',
      'cancel_confirm': 'Буюртмани бекор қилмоқчимисиз?',
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
      'product_required': 'Маҳсулотни танланг!',
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
    },
  };

  static String getTxt(String lang, String key) {
    return _localizedTexts[lang]?[key] ??
        _localizedTexts['Uzb']?[key] ??
        key;
  }

  static final maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  static void showBuyurtmaDialog(BuildContext context, {OrderModel? order}) {
    showCustomOrderDialog(context, order: order);
  }

  static void showCustomOrderDialog(BuildContext context, {OrderModel? order}) {
    final selectedLanguage =
        Provider.of<ProfileProvider>(context, listen: false).language;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CustomOrderFormDialog(
        lang: selectedLanguage,
        order: order,
      ),
    );
  }

  @override
  State<DraverBuyurtmalarPages> createState() => _DraverBuyurtmalarPagesState();
}

class _DraverBuyurtmalarPagesState extends State<DraverBuyurtmalarPages> {
  // Afada Medical Ranglar Palitrasi
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _amber = Color(0xFFF59E0B);
  static const Color _indigo = Color(0xFF6366F1);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);
  static const Color _lightBg = Color(0xFFF8FAFC);

  String? _archivingOrderId;
  int _countdown = 5;
  Timer? _timer;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchOpen = false;
  String _searchQuery = "";
  String _statusFilter = "all";

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _isSearchOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _searchQuery = "";
      _isSearchOpen = false;
    });
  }

  String _formatMoney(num value) {
    return NumberFormat('#,###', 'en_US')
        .format(value)
        .replaceAll(',', ' ');
  }

  String _formatPhoneDisplay(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (digits.isEmpty) return "";

    if (digits.startsWith('998') && digits.length == 12) {
      final cc = digits.substring(0, 3);
      final code = digits.substring(3, 5);
      final p1 = digits.substring(5, 8);
      final p2 = digits.substring(8, 10);
      final p3 = digits.substring(10, 12);
      return '+$cc $code $p1 $p2 $p3';
    }

    if (digits.length == 9) {
      final code = digits.substring(0, 2);
      final p1 = digits.substring(2, 5);
      final p2 = digits.substring(5, 7);
      final p3 = digits.substring(7, 9);
      return '+998 $code $p1 $p2 $p3';
    }

    final trimmed = raw.trim();
    if (trimmed.startsWith('+')) return trimmed;
    return '+$digits';
  }

  Future<void> _makePhoneCall(String rawPhone) async {
    final cleaned = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return;
    final String formatted = cleaned.startsWith('+')
        ? cleaned
        : (cleaned.startsWith('998') ? '+$cleaned' : '+998$cleaned');
    final Uri launchUri = Uri(scheme: 'tel', path: formatted);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
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
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        setState(() => _archivingOrderId = null);
      }
    });
  }

  void _cancelArchiving(String orderId) {
    _timer?.cancel();
    context.read<OrderProvider>().updateOrderStatus(orderId, "Sotilmoqda");
    setState(() => _archivingOrderId = null);
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

  String _translatePaymentStatus(String lang, String paymentStatus) {
    if (paymentStatus == "To'langan") {
      return DraverBuyurtmalarPages.getTxt(lang, 'paid_status');
    }
    return DraverBuyurtmalarPages.getTxt(lang, 'unpaid_status');
  }

  Color _getHolatColor(String holat) {
    switch (holat) {
      case 'Tayyorlanmoqda':
        return _amber;
      case 'Tayyor':
        return _primaryBlue;
      case 'Sotilmoqda':
        return _indigo;
      case 'Sotildi':
        return _emerald;
      case 'Bekor qilindi':
        return _rose;
      default:
        return _primaryBlue;
    }
  }

  void _handleHolatChange(BuildContext pageContext, OrderModel order) {
    final provider = pageContext.read<OrderProvider>();
    final selectedLanguage =
        Provider.of<ProfileProvider>(pageContext, listen: false).language;
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
      pageContext,
      title: savol,
      accentColor: _getHolatColor(yangiHolat),
      icon: Icons.task_alt_rounded,
      onConfirm: () => provider.updateOrderStatus(order.id, yangiHolat),
    );
  }

  void _showConfirmDialog(
      BuildContext pageContext, {
        required String title,
        required Color accentColor,
        required IconData icon,
        required VoidCallback onConfirm,
      }) {
    final selectedLanguage =
        Provider.of<ProfileProvider>(pageContext, listen: false).language;

    showGeneralDialog(
      context: pageContext,
      barrierDismissible: true,
      barrierLabel: 'order_confirm',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, anim1, anim2, child) {
        final bool isDark =
            Theme.of(dialogContext).brightness == Brightness.dark;
        final Color textPrimary =
        isDark ? Colors.white : const Color(0xFF0F172A);

        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              contentPadding: EdgeInsets.zero,
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? _cardDark.withValues(alpha: 0.94)
                            : Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: accentColor, size: 30),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    side: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    DraverBuyurtmalarPages.getTxt(
                                        selectedLanguage, 'no'),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    onConfirm();
                                    Navigator.pop(dialogContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    DraverBuyurtmalarPages.getTxt(
                                        selectedLanguage, 'ha'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // ANIMATSIYALI APPBAR: O'NGDAN CHAPGA SURILUVCHI QIDIRUV
  // =========================================================================

  Widget _buildAnimatedAppBarTitle({
    required String lang,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          const double buttonSize = 44;
          final double closedLeft =
          (maxWidth - buttonSize).clamp(0.0, double.infinity);

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _isSearchOpen ? 0.0 : 1.0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  offset: _isSearchOpen
                      ? const Offset(-0.18, 0)
                      : Offset.zero,
                  child: IgnorePointer(
                    ignoring: _isSearchOpen,
                    child: Padding(
                      padding: const EdgeInsets.only(right: buttonSize + 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _primaryBlue.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.assignment_rounded,
                              size: 21,
                              color: isDark ? _skyBlue : _primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              DraverBuyurtmalarPages.getTxt(lang, 'title'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                top: 1,
                bottom: 1,
                right: 0,
                left: _isSearchOpen ? 0 : closedLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isSearchOpen
                          ? cardBg
                          : _primaryBlue.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _isSearchOpen
                            ? _primaryBlue.withValues(alpha: 0.65)
                            : _primaryBlue.withValues(alpha: 0.22),
                        width: _isSearchOpen ? 1.4 : 1.0,
                      ),
                    ),
                    child: _isSearchOpen
                        ? OverflowBox(
                      alignment: Alignment.centerRight,
                      minWidth: maxWidth,
                      maxWidth: maxWidth,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(
                            Icons.search_rounded,
                            size: 21,
                            color: isDark ? _skyBlue : _primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val),
                              textInputAction: TextInputAction.search,
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: DraverBuyurtmalarPages.getTxt(
                                    lang, 'search'),
                                hintStyle: TextStyle(
                                  fontSize: 14.5,
                                  color: textSecondary,
                                ),
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: _closeSearch,
                            icon: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: _openSearch,
                        child: Center(
                          child: Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: isDark ? _skyBlue : _primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCountdownWidget(bool isDark, String selectedLanguage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? _cardDark.withValues(alpha: 0.92)
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _emerald.withValues(alpha: 0.45),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _emerald.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$_countdown",
                    style: const TextStyle(
                      color: _emerald,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  DraverBuyurtmalarPages.getTxt(
                      selectedLanguage, 'countdown_msg')
                      .replaceFirst('{}', _countdown.toString()),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _archivingOrderId == null
                    ? null
                    : () => _cancelArchiving(_archivingOrderId!),
                style: TextButton.styleFrom(
                  backgroundColor: _rose.withValues(alpha: 0.14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  DraverBuyurtmalarPages.getTxt(selectedLanguage, 'cancel'),
                  style: const TextStyle(
                    color: _rose,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String selectedLanguage =
        Provider.of<ProfileProvider>(context).language;

    final Color bgColor = isDark ? _slateDark : _lightBg;
    final Color cardBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final String currency =
    DraverBuyurtmalarPages.getTxt(selectedLanguage, 'currency');

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleSpacing: 12,
        title: _buildAnimatedAppBarTitle(
          lang: selectedLanguage,
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ),
      body: Stack(
        children: [
          Consumer2<OrderProvider, MahsulotProvider>(
            builder: (context, orderProvider, mahsulotProvider, child) {
              final List<OrderModel> activeOrders = orderProvider.orders.reversed
                  .where((o) =>
              o.status != "Sotildi" || o.id == _archivingOrderId)
                  .toList();

              final double totalSum = activeOrders.fold<double>(
                0.0,
                    (sum, o) => sum + (o.price * o.quantity),
              );
              final double totalPaid = activeOrders.fold<double>(
                0.0,
                    (sum, o) => sum + o.amountPaid,
              );

              final List<String> statuses = [
                "Tayyorlash",
                "Tayyorlanmoqda",
                "Tayyor",
                "Sotilmoqda",
                "Bekor qilindi",
              ];

              final List<OrderModel> filteredOrders = activeOrders.where((o) {
                if (_statusFilter != "all" && o.status != _statusFilter) {
                  return false;
                }
                if (_searchQuery.trim().isNotEmpty) {
                  final q = _searchQuery.trim().toLowerCase();
                  final digitsQ = q.replaceAll(RegExp(r'\D'), '');
                  final rawPhone = o.phone.replaceAll(RegExp(r'\D'), '');
                  if (!o.productName.toLowerCase().contains(q) &&
                      !o.customerName.toLowerCase().contains(q) &&
                      !o.comment.toLowerCase().contains(q) &&
                      !o.phone.toLowerCase().contains(q) &&
                      !(digitsQ.isNotEmpty && rawPhone.contains(digitsQ))) {
                    return false;
                  }
                }
                return true;
              }).toList();

              return LayoutBuilder(
                builder: (context, constraints) {
                  final double horizontalPad =
                  constraints.maxWidth >= 900 ? 24 : 16;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPad,
                      12,
                      horizontalPad,
                      115,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1260),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==============================================
                            // KPI KARTALAR (3 TA)
                            // ==============================================
                            LayoutBuilder(
                              builder: (context, kpiConstraints) {
                                final bool wide = kpiConstraints.maxWidth >= 640;
                                const double gap = 10;

                                if (wide) {
                                  final double itemW =
                                      (kpiConstraints.maxWidth - gap * 2) / 3;
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: itemW,
                                        child: _OrderKpiCard(
                                          title: DraverBuyurtmalarPages.getTxt(
                                              selectedLanguage,
                                              'active_orders'),
                                          value:
                                          "${activeOrders.length} ${DraverBuyurtmalarPages.getTxt(selectedLanguage, 'count_unit')}",
                                          icon: Icons.assignment_rounded,
                                          accentColor: _primaryBlue,
                                          isDark: isDark,
                                          cardBg: cardBg,
                                          borderColor: borderColor,
                                          textPrimary: textPrimary,
                                          textSecondary: textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: gap),
                                      SizedBox(
                                        width: itemW,
                                        child: _OrderKpiCard(
                                          title: DraverBuyurtmalarPages.getTxt(
                                              selectedLanguage, 'total_sum'),
                                          value:
                                          "${_formatMoney(totalSum)} $currency",
                                          icon: Icons.payments_rounded,
                                          accentColor: _indigo,
                                          isDark: isDark,
                                          cardBg: cardBg,
                                          borderColor: borderColor,
                                          textPrimary: textPrimary,
                                          textSecondary: textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: gap),
                                      SizedBox(
                                        width: itemW,
                                        child: _OrderKpiCard(
                                          title: DraverBuyurtmalarPages.getTxt(
                                              selectedLanguage, 'total_paid'),
                                          value:
                                          "${_formatMoney(totalPaid)} $currency",
                                          icon: Icons.verified_rounded,
                                          accentColor: _emerald,
                                          isDark: isDark,
                                          cardBg: cardBg,
                                          borderColor: borderColor,
                                          textPrimary: textPrimary,
                                          textSecondary: textSecondary,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                final double halfW =
                                    (kpiConstraints.maxWidth - gap) / 2;
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: halfW,
                                          child: _OrderKpiCard(
                                            title:
                                            DraverBuyurtmalarPages.getTxt(
                                                selectedLanguage,
                                                'active_orders'),
                                            value:
                                            "${activeOrders.length} ${DraverBuyurtmalarPages.getTxt(selectedLanguage, 'count_unit')}",
                                            icon: Icons.assignment_rounded,
                                            accentColor: _primaryBlue,
                                            isDark: isDark,
                                            cardBg: cardBg,
                                            borderColor: borderColor,
                                            textPrimary: textPrimary,
                                            textSecondary: textSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: gap),
                                        SizedBox(
                                          width: halfW,
                                          child: _OrderKpiCard(
                                            title:
                                            DraverBuyurtmalarPages.getTxt(
                                                selectedLanguage,
                                                'total_paid'),
                                            value:
                                            "${_formatMoney(totalPaid)} $currency",
                                            icon: Icons.verified_rounded,
                                            accentColor: _emerald,
                                            isDark: isDark,
                                            cardBg: cardBg,
                                            borderColor: borderColor,
                                            textPrimary: textPrimary,
                                            textSecondary: textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: gap),
                                    _OrderKpiCard(
                                      title: DraverBuyurtmalarPages.getTxt(
                                          selectedLanguage, 'total_sum'),
                                      value:
                                      "${_formatMoney(totalSum)} $currency",
                                      icon: Icons.payments_rounded,
                                      accentColor: _indigo,
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 14),

                            // ==============================================
                            // HOLAT FILTR KAPSULALARI
                            // ==============================================
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _OrderFilterPill(
                                    label:
                                    "${DraverBuyurtmalarPages.getTxt(selectedLanguage, 'all')} (${activeOrders.length})",
                                    selected: _statusFilter == "all",
                                    activeColor: _primaryBlue,
                                    isDark: isDark,
                                    onTap: () => setState(
                                            () => _statusFilter = "all"),
                                  ),
                                  ...statuses.map((st) {
                                    final count = activeOrders
                                        .where((o) => o.status == st)
                                        .length;
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: _OrderFilterPill(
                                        label:
                                        "${_translateStatus(selectedLanguage, st)} ($count)",
                                        selected: _statusFilter == st,
                                        activeColor: _getHolatColor(st),
                                        isDark: isDark,
                                        onTap: () => setState(
                                              () => _statusFilter = st,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ==============================================
                            // BUYURTMALAR RO'YXATI (1 / 2 / 3 USTUN)
                            // ==============================================
                            if (filteredOrders.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 56,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.assignment_outlined,
                                      size: 54,
                                      color:
                                      textSecondary.withValues(alpha: 0.55),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      activeOrders.isEmpty
                                          ? DraverBuyurtmalarPages.getTxt(
                                          selectedLanguage, 'no_orders')
                                          : DraverBuyurtmalarPages.getTxt(
                                          selectedLanguage, 'not_found'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              LayoutBuilder(
                                builder: (context, gridConstraints) {
                                  final double w = gridConstraints.maxWidth;
                                  final int columns =
                                  w >= 1160 ? 3 : (w >= 720 ? 2 : 1);
                                  const double gap = 14;
                                  final double cardWidth =
                                      (w - gap * (columns - 1)) / columns;

                                  return Wrap(
                                    spacing: gap,
                                    runSpacing: gap,
                                    children: filteredOrders.map((order) {
                                      final double jamiNarx =
                                          order.price * order.quantity;
                                      final MahsulotModel product =
                                      mahsulotProvider.mahsulotlar
                                          .firstWhere(
                                            (m) =>
                                        m.nomi.toLowerCase() ==
                                            order.productName.toLowerCase(),
                                        orElse: () => MahsulotModel(
                                          nomi: order.productName,
                                          bemorNarxi: "0",
                                          shifokorNarxi: "0",
                                          kategoriya: "Umumiy",
                                          keshbek: "0",
                                          status: "Faol",
                                        ),
                                      );

                                      final String formattedPhone =
                                      _formatPhoneDisplay(order.phone);
                                      final Color statusColor =
                                      _getHolatColor(order.status);
                                      final bool isPaid =
                                          order.paymentStatus == "To'langan";

                                      return SizedBox(
                                        width: cardWidth,
                                        child: _OrderItemCard(
                                          order: order,
                                          productImagePath: product.rasm,
                                          jamiNarxText:
                                          "${_formatMoney(jamiNarx)} $currency",
                                          paidText:
                                          "${_formatMoney(order.amountPaid)} $currency",
                                          paymentStatusText:
                                          _translatePaymentStatus(
                                            selectedLanguage,
                                            order.paymentStatus,
                                          ),
                                          statusText: _translateStatus(
                                            selectedLanguage,
                                            order.status,
                                          ),
                                          statusColor: statusColor,
                                          isPaid: isPaid,
                                          formattedPhone: formattedPhone,
                                          lang: selectedLanguage,
                                          isDark: isDark,
                                          cardBg: cardBg,
                                          borderColor: borderColor,
                                          textPrimary: textPrimary,
                                          textSecondary: textSecondary,
                                          onCallTap: formattedPhone.isEmpty
                                              ? null
                                              : () =>
                                              _makePhoneCall(order.phone),
                                          onStatusTap: () => _handleHolatChange(
                                              context, order),
                                          onEditTap: () =>
                                              DraverBuyurtmalarPages
                                                  .showCustomOrderDialog(
                                                context,
                                                order: order,
                                              ),
                                          onCancelTap: () => _showConfirmDialog(
                                            context,
                                            title:
                                            DraverBuyurtmalarPages.getTxt(
                                              selectedLanguage,
                                              'cancel_confirm',
                                            ),
                                            accentColor: _rose,
                                            icon: Icons.cancel_outlined,
                                            onConfirm: () => orderProvider
                                                .updateOrderStatus(
                                              order.id,
                                              "Bekor qilindi",
                                            ),
                                          ),
                                          onDeleteTap: () => _showConfirmDialog(
                                            context,
                                            title:
                                            DraverBuyurtmalarPages.getTxt(
                                              selectedLanguage,
                                              'delete_confirm',
                                            ),
                                            accentColor: _rose,
                                            icon: Icons.delete_outline_rounded,
                                            onConfirm: () => orderProvider
                                                .removeOrder(order.id),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // 5 SONIYALIK ARXIVLASH BANNERI
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            bottom: _archivingOrderId != null ? 18 : -140,
            left: 16,
            right: 16,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: _buildCountdownWidget(isDark, selectedLanguage),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// KPI KARTA & FILTR KAPSULASI
// ===========================================================================

class _OrderKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _OrderKpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderFilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color activeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _OrderFilterPill({
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? activeColor
                : (isDark ? const Color(0xFF1C2541) : Colors.white),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected
                  ? activeColor
                  : (isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0)),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF334155)),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// BUYURTMA KARTASI
// ===========================================================================

class _OrderItemCard extends StatelessWidget {
  final OrderModel order;
  final String? productImagePath;
  final String jamiNarxText;
  final String paidText;
  final String paymentStatusText;
  final String statusText;
  final Color statusColor;
  final bool isPaid;
  final String formattedPhone;
  final String lang;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback? onCallTap;
  final VoidCallback onStatusTap;
  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;
  final VoidCallback onDeleteTap;

  const _OrderItemCard({
    required this.order,
    required this.productImagePath,
    required this.jamiNarxText,
    required this.paidText,
    required this.paymentStatusText,
    required this.statusText,
    required this.statusColor,
    required this.isPaid,
    required this.formattedPhone,
    required this.lang,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onCallTap,
    required this.onStatusTap,
    required this.onEditTap,
    required this.onCancelTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color payColor =
    isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YUQORI QISM: RASM + NOM + SONI + O'CHIRISH
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderProductThumb(
                imagePath: productImagePath,
                productName: order.productName,
                isDark: isDark,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7)
                                .withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${order.quantity} ${DraverBuyurtmalarPages.getTxt(lang, 'unit')}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? const Color(0xFF38BDF8)
                                  : const Color(0xFF0284C7),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: payColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            paymentStatusText,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: payColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDeleteTap,
                tooltip: DraverBuyurtmalarPages.getTxt(lang, 'delete'),
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFF43F5E),
                    size: 19,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // MIJOZ, TELEFON, SANA, IZOH
          _OrderDetailLine(
            icon: Icons.person_rounded,
            label: DraverBuyurtmalarPages.getTxt(lang, 'customer'),
            value: order.customerName.trim().isEmpty
                ? DraverBuyurtmalarPages.getTxt(lang, 'no_info')
                : order.customerName,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Icon(Icons.phone_rounded, size: 17, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                DraverBuyurtmalarPages.getTxt(lang, 'tel'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const Spacer(),
              if (onCallTap != null)
                InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: onCallTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.call_rounded,
                          size: 14,
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formattedPhone,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFF38BDF8)
                                : const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  DraverBuyurtmalarPages.getTxt(lang, 'no_info'),
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          _OrderDetailLine(
            icon: Icons.calendar_today_rounded,
            label: DraverBuyurtmalarPages.getTxt(lang, 'date'),
            value: DateFormat('dd.MM.yyyy').format(order.date),
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          if (order.comment.trim().isNotEmpty) ...[
            const SizedBox(height: 7),
            _OrderDetailLine(
              icon: Icons.notes_rounded,
              label: DraverBuyurtmalarPages.getTxt(lang, 'comment'),
              value: order.comment,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ],

          const SizedBox(height: 13),

          // MOLIYAVIY BLOK
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0B132B).withValues(alpha: 0.55)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.75),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DraverBuyurtmalarPages.getTxt(lang, 'total'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          jamiNarxText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DraverBuyurtmalarPages.getTxt(lang, 'paid'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          paidText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 13),

          // AMAL TUGMALARI (OVERFLOW-PROOF)
          Row(
            children: [
              Expanded(
                flex: 5,
                child: ElevatedButton(
                  onPressed: onStatusTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: OutlinedButton(
                  onPressed: onEditTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? const Color(0xFF38BDF8)
                        : const Color(0xFF0284C7),
                    side: BorderSide(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.45),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      DraverBuyurtmalarPages.getTxt(lang, 'edit'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: DraverBuyurtmalarPages.getTxt(lang, 'cancel'),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onCancelTap,
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          const Color(0xFFF43F5E).withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.block_rounded,
                        color: Color(0xFFF43F5E),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderDetailLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;

  const _OrderDetailLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderProductThumb extends StatelessWidget {
  final String? imagePath;
  final String productName;
  final bool isDark;

  const _OrderProductThumb({
    required this.imagePath,
    required this.productName,
    required this.isDark,
  });

  String _initial() {
    final trimmed = productName.trim();
    return trimmed.isNotEmpty ? trimmed[0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    final String path = imagePath?.trim() ?? "";
    final bool isNetwork =
        path.startsWith('http://') || path.startsWith('https://');
    final Color letterColor =
    isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    Widget fallback() {
      return Center(
        child: Text(
          _initial(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: letterColor,
          ),
        ),
      );
    }

    Widget imageWidget = fallback();
    if (path.isNotEmpty) {
      if (isNetwork) {
        imageWidget = Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          imageWidget = Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback(),
          );
        }
      }
    }

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF0284C7).withValues(alpha: isDark ? 0.16 : 0.1),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFF0284C7).withValues(alpha: 0.25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }
}

// ===========================================================================
// BUYURTMA QO'SHISH / TAHRIRLASH DIALOGI (LEAK-FREE STATEFULWIDGET)
// ===========================================================================

class _CustomOrderFormDialog extends StatefulWidget {
  final String lang;
  final OrderModel? order;

  const _CustomOrderFormDialog({
    required this.lang,
    required this.order,
  });

  @override
  State<_CustomOrderFormDialog> createState() => _CustomOrderFormDialogState();
}

class _CustomOrderFormDialogState extends State<_CustomOrderFormDialog> {
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _rose = Color(0xFFF43F5E);
  static const Color _slateDark = Color(0xFF0B132B);
  static const Color _cardDark = Color(0xFF1C2541);

  late final TextEditingController _customerController;
  late final TextEditingController _phoneController;
  late final TextEditingController _quantityController;
  late final TextEditingController _commentController;
  late final TextEditingController _servicePriceController;
  late final TextEditingController _amountPaidController;
  late final TextEditingController _sanaController;

  final MaskTextInputFormatter _maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  late String _paymentStatus;
  MahsulotModel? _selectedMahsulot;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    final mahsulotProvider = context.read<MahsulotProvider>();

    _customerController =
        TextEditingController(text: order?.customerName ?? "");
    _phoneController = TextEditingController(text: order?.phone ?? "");
    _quantityController =
        TextEditingController(text: order?.quantity.toString() ?? "");
    _commentController = TextEditingController(text: order?.comment ?? "");
    _servicePriceController =
        TextEditingController(text: order?.servicePrice.toString() ?? "0");
    _amountPaidController =
        TextEditingController(text: order?.amountPaid.toString() ?? "0");
    _sanaController = TextEditingController(
      text: order != null ? DateFormat('dd.MM.yyyy').format(order.date) : "",
    );

    final rawPayStatus = order?.paymentStatus ?? "To'lanmagan";
    _paymentStatus =
    (rawPayStatus == "To'langan" || rawPayStatus == "To'lanmagan")
        ? rawPayStatus
        : "To'lanmagan";

    if (order != null) {
      _selectedMahsulot = mahsulotProvider.mahsulotlar.firstWhere(
            (m) => m.nomi.toLowerCase() == order.productName.toLowerCase(),
        orElse: () => MahsulotModel(
          nomi: order.productName,
          bemorNarxi: order.price.toString(),
          shifokorNarxi: order.servicePrice.toString(),
          kategoriya: "Umumiy",
          keshbek: "0",
          status: "Faol",
        ),
      );
    }
  }

  @override
  void dispose() {
    _customerController.dispose();
    _phoneController.dispose();
    _quantityController.dispose();
    _commentController.dispose();
    _servicePriceController.dispose();
    _amountPaidController.dispose();
    _sanaController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: isDark
          ? _slateDark.withValues(alpha: 0.65)
          : const Color(0xFFF8FAFC),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.6),
      ),
    );
  }

  void _saveOrder() {
    final lang = widget.lang;
    if (_selectedMahsulot == null) {
      setState(() {
        _inlineError = DraverBuyurtmalarPages.getTxt(lang, 'product_required');
      });
      return;
    }

    final orderProvider = context.read<OrderProvider>();
    final mahsulotProvider = context.read<MahsulotProvider>();
    final order = widget.order;

    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
    final double servicePrice =
        double.tryParse(_servicePriceController.text.trim()) ?? 0.0;
    final double amountPaid = _paymentStatus == "To'langan"
        ? (double.tryParse(_amountPaidController.text.trim()) ?? 0.0)
        : 0.0;
    final double price = double.tryParse(
      _selectedMahsulot!.bemorNarxi.replaceAll(RegExp(r'[^0-9.]'), ''),
    ) ??
        0.0;

    DateTime orderDate = order?.date ?? DateTime.now();
    try {
      if (_sanaController.text.trim().isNotEmpty) {
        orderDate = DateFormat('dd.MM.yyyy').parse(_sanaController.text.trim());
      }
    } catch (_) {}

    final updatedOrder = OrderModel(
      id: order?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      productName: _selectedMahsulot!.nomi,
      quantity: quantity,
      price: price,
      date: orderDate,
      customerName: _customerController.text,
      phone: _phoneController.text,
      comment: _commentController.text,
      referrer: order?.referrer ?? "",
      status: order?.status ?? "Tayyorlash",
      paymentStatus: _paymentStatus,
      amountPaid: amountPaid,
      servicePrice: servicePrice,
    );

    if (order == null) {
      orderProvider.addOrder(updatedOrder);
      mahsulotProvider.zaxiraYangilash(_selectedMahsulot!.nomi, -quantity);
    } else {
      orderProvider.updateOrder(updatedOrder);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final mahsulotProvider = context.watch<MahsulotProvider>();

    final Color dialogBg = isDark ? _cardDark : Colors.white;
    final Color borderColor =
    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color textPrimary =
    isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary =
    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final media = MediaQuery.of(context);
    final double dialogWidth =
    media.size.width >= 600 ? 480 : media.size.width - 28;
    final double maxHeight =
    (media.size.height - media.viewInsets.bottom - 150)
        .clamp(280.0, 560.0);

    return AlertDialog(
      backgroundColor: dialogBg,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 14, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _primaryBlue.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.order == null
                  ? Icons.add_shopping_cart_rounded
                  : Icons.edit_rounded,
              size: 21,
              color: isDark ? _skyBlue : _primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.order == null
                  ? DraverBuyurtmalarPages.getTxt(lang, 'new_order')
                  : DraverBuyurtmalarPages.getTxt(lang, 'edit'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, color: textSecondary),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_inlineError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: _rose.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _rose.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: _rose,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _inlineError!,
                            style: TextStyle(
                              color: isDark ? Colors.white : _rose,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                LayoutBuilder(
                  builder: (context, fieldConstraints) {
                    return Autocomplete<MahsulotModel>(
                      initialValue: TextEditingValue(
                        text: _selectedMahsulot?.nomi ?? "",
                      ),
                      displayStringForOption: (m) => m.nomi,
                      optionsBuilder: (textValue) {
                        final options = mahsulotProvider.mahsulotlar
                            .where((m) => m.zaxira > 0);
                        if (textValue.text.isEmpty) {
                          return options;
                        }
                        return options.where(
                              (m) => m.nomi
                              .toLowerCase()
                              .contains(textValue.text.toLowerCase()),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 6,
                            color: dialogBg,
                            borderRadius: BorderRadius.circular(14),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: fieldConstraints.maxWidth,
                                maxHeight: 200,
                              ),
                              child: ListView.separated(
                                padding:
                                const EdgeInsets.symmetric(vertical: 4),
                                shrinkWrap: true,
                                itemCount: options.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: borderColor,
                                ),
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    dense: true,
                                    title: Text(
                                      option.nomi,
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w600,
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
                          style: TextStyle(color: textPrimary, fontSize: 15.5),
                          decoration: _inputDecoration(
                            label: DraverBuyurtmalarPages.getTxt(
                                lang, 'product'),
                            icon: Icons.inventory_2_outlined,
                            isDark: isDark,
                          ),
                          onFieldSubmitted: (_) => onFieldSubmitted(),
                          onChanged: (value) {
                            final match =
                            mahsulotProvider.mahsulotlar.firstWhere(
                                  (m) =>
                              m.nomi.toLowerCase() == value.toLowerCase(),
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
                              setState(() {
                                _selectedMahsulot = match;
                                _inlineError = null;
                              });
                            }
                          },
                        );
                      },
                      onSelected: (selection) {
                        setState(() {
                          _selectedMahsulot = selection;
                          _inlineError = null;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _customerController,
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label:
                    DraverBuyurtmalarPages.getTxt(lang, 'customer_name'),
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _phoneController,
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  inputFormatters: [_maskFormatter],
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    label: DraverBuyurtmalarPages.getTxt(lang, 'phone_hint'),
                    icon: Icons.phone_android_rounded,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        style: TextStyle(color: textPrimary, fontSize: 15.5),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          label: DraverBuyurtmalarPages.getTxt(
                              lang, 'quantity_label'),
                          icon: Icons.numbers_rounded,
                          isDark: isDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _servicePriceController,
                        style: TextStyle(color: textPrimary, fontSize: 15.5),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          label: DraverBuyurtmalarPages.getTxt(
                              lang, 'service_price'),
                          icon: Icons.paid_outlined,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _sanaController,
                  readOnly: true,
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label: DraverBuyurtmalarPages.getTxt(lang, 'date_label'),
                    icon: Icons.calendar_today_rounded,
                    isDark: isDark,
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.order?.date ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        _sanaController.text =
                            DateFormat('dd.MM.yyyy').format(picked);
                      });
                    }
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _commentController,
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label:
                    DraverBuyurtmalarPages.getTxt(lang, 'comment_label'),
                    icon: Icons.notes_rounded,
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _paymentStatus,
                  isExpanded: true,
                  dropdownColor: dialogBg,
                  style: TextStyle(color: textPrimary, fontSize: 15.5),
                  decoration: _inputDecoration(
                    label: DraverBuyurtmalarPages.getTxt(
                        lang, 'payment_status_label'),
                    icon: Icons.account_balance_wallet_outlined,
                    isDark: isDark,
                  ),
                  items: const ["To'langan", "To'lanmagan"]
                      .map(
                        (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s == "To'langan"
                            ? DraverBuyurtmalarPages.getTxt(
                            lang, 'paid_status')
                            : DraverBuyurtmalarPages.getTxt(
                            lang, 'unpaid_status'),
                        style: TextStyle(color: textPrimary),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _paymentStatus = val;
                      if (_paymentStatus == "To'lanmagan") {
                        _amountPaidController.text = "0";
                      }
                    });
                  },
                ),

                if (_paymentStatus == "To'langan") ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountPaidController,
                    style: TextStyle(color: textPrimary, fontSize: 15.5),
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label:
                      DraverBuyurtmalarPages.getTxt(lang, 'paid_amount'),
                      icon: Icons.payments_outlined,
                      isDark: isDark,
                    ),
                  ),
                ],

                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    DraverBuyurtmalarPages.getTxt(lang, 'cancel'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.order == null
                        ? DraverBuyurtmalarPages.getTxt(lang, 'add')
                        : DraverBuyurtmalarPages.getTxt(lang, 'save'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}