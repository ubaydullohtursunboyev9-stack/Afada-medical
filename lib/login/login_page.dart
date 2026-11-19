import 'dart:async';
import 'dart:ui';

import 'package:afada/pages/home_Pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/profile_provider.dart';
import '../service/api_service.dart';

// ── Afada Medical dizayn ranglari ──
const Color _slateDark = Color(0xFF0B132B);
const Color _cardDark = Color(0xFF1C2541);
const Color _primaryBlue = Color(0xFF0284C7);
const Color _skyBlue = Color(0xFF38BDF8);
const Color _emerald = Color(0xFF10B981);
const Color _rose = Color(0xFFF43F5E);

const Map<String, Map<String, String>> _loginLocalizedTexts = {
  'Uzb': {
    'subtitle': 'Tasdiqlash kodi Telegram orqali yuboriladi',
    'phone_label': 'Telefon raqami',
    'enter_full_phone': 'Telefon raqamini to‘liq kiriting',
    'login_btn': 'Kirish',
    'sending': 'Yuborilmoqda...',
    'error_title': 'Xatolik',
    'login_error_desc': 'Tizimga kirishda muammo yuz berdi.',
    'user_not_found_title': 'Foydalanuvchi topilmadi',
    'user_not_found_desc':
    'Ushbu telefon raqami tizimda ro‘yxatdan o‘tmagan yoki aktiv emas.',
    'network_error_desc':
    'Internet aloqasini tekshiring yoki keyinroq urinib ko‘ring.',
    'understood': 'Tushunarli',
    'verify_title': 'Tasdiqlash',
    'verify_subtitle_prefix': 'Telegram orqali yuborilgan 6 xonali kodni kiriting',
    'enter_6_digit': '6 xonali kodni to‘liq kiriting',
    'verify_btn': 'Tasdiqlash',
    'verifying': 'Tekshirilmoqda...',
    'resend_code': 'Kodni qayta yuborish',
    'resend_in': 'Qayta yuborish:',
    'code_resent': 'Yangi kod Telegram orqali yuborildi',
    'invalid_code_desc': 'Tasdiqlash kodi noto‘g‘ri yoki muddati o‘tgan.',
    'server_error_title': 'Serverda xatolik',
    'server_error_desc':
    'Kodni tekshirishda serverda xatolik yuz berdi (500).',
    'unexpected_error_desc':
    'Kutilmagan xatolik yuz berdi. Iltimos, qaytadan urinib ko‘ring.',
    'retry': 'Qayta urinish',
    'step_phone': '1 / 2 • Kirish',
    'step_otp': '2 / 2 • Tasdiqlash',
  },
  'Rus': {
    'subtitle': 'Код подтверждения будет отправлен через Telegram',
    'phone_label': 'Номер телефона',
    'enter_full_phone': 'Введите номер телефона полностью',
    'login_btn': 'Войти',
    'sending': 'Отправка...',
    'error_title': 'Ошибка',
    'login_error_desc': 'Возникла проблема при входе в систему.',
    'user_not_found_title': 'Пользователь не найден',
    'user_not_found_desc':
    'Этот номер телефона не зарегистрирован в системе или неактивен.',
    'network_error_desc':
    'Проверьте подключение к интернету или повторите попытку позже.',
    'understood': 'Понятно',
    'verify_title': 'Подтверждение',
    'verify_subtitle_prefix': 'Введите 6-значный код, отправленный в Telegram',
    'enter_6_digit': 'Введите 6-значный код полностью',
    'verify_btn': 'Подтвердить',
    'verifying': 'Проверка...',
    'resend_code': 'Отправить код повторно',
    'resend_in': 'Повторить через:',
    'code_resent': 'Новый код отправлен через Telegram',
    'invalid_code_desc': 'Код подтверждения неверный или срок его действия истёк.',
    'server_error_title': 'Ошибка сервера',
    'server_error_desc':
    'Произошла ошибка сервера при проверке кода (500).',
    'unexpected_error_desc':
    'Произошла непредвиденная ошибка. Пожалуйста, попробуйте снова.',
    'retry': 'Повторить',
    'step_phone': '1 / 2 • Вход',
    'step_otp': '2 / 2 • Код',
  },
  'Kiril': {
    'subtitle': 'Тасдиқлаш коди Telegram орқали юборилади',
    'phone_label': 'Телефон рақами',
    'enter_full_phone': 'Телефон рақамини тўлиқ киритинг',
    'login_btn': 'Кириш',
    'sending': 'Юборилмоқда...',
    'error_title': 'Хатолик',
    'login_error_desc': 'Тизимга киришда муаммо юз берди.',
    'user_not_found_title': 'Фойдаланувчи топилмади',
    'user_not_found_desc':
    'Ушбу телефон рақами тизимда рўйхатдан ўтмаган ёки актив эмас.',
    'network_error_desc':
    'Интернет алоқасини текширинг ёки кейинроқ уриниб кўринг.',
    'understood': 'Тушунарли',
    'verify_title': 'Тасдиқлаш',
    'verify_subtitle_prefix': 'Telegram орқали юборилган 6 хонали кодни киритинг',
    'enter_6_digit': '6 хонали кодни тўлиқ киритинг',
    'verify_btn': 'Тасдиқлаш',
    'verifying': 'Текширилмоқда...',
    'resend_code': 'Кодни қайта юбориш',
    'resend_in': 'Қайта юбориш:',
    'code_resent': 'Янги код Telegram орқали юборилди',
    'invalid_code_desc': 'Тасдиқлаш коди нотўғри ёки муддати ўтган.',
    'server_error_title': 'Серверда хатолик',
    'server_error_desc':
    'Кодни текширишда серверда хатолик юз берди (500).',
    'unexpected_error_desc':
    'Кутилмаган хатолик юз берди. Илтимос, қайтадан уриниб кўринг.',
    'retry': 'Қайта уриниш',
    'step_phone': '1 / 2 • Кириш',
    'step_otp': '2 / 2 • Тасдиқлаш',
  },
};

String _tr(String lang, String key) {
  return _loginLocalizedTexts[lang]?[key] ??
      _loginLocalizedTexts['Uzb']?[key] ??
      key;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  bool _isSendingCode = false;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _loginFade;
  late Animation<Offset> _loginSlide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    const curve = Curves.easeOutCubic;

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: curve),
    );
    _logoScale = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: curve),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.5, curve: curve),
    );
    _titleSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.5, curve: curve),
          ),
        );

    _subtitleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.6, curve: curve),
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.25, 0.6, curve: curve),
          ),
        );

    _cardFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.72, curve: curve),
    );
    _cardSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 0.72, curve: curve),
          ),
        );

    _loginFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.85, curve: curve),
    );
    _loginSlide =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 0.85, curve: curve),
          ),
        );

    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: curve),
    );
    _buttonSlide =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.65, 1.0, curve: curve),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode(String lang) async {
    if (_isSendingCode) return;

    final phoneInput = _phoneController.text.trim();
    final cleanPhone = phoneInput.replaceAll(RegExp(r'\D'), '');

    if (cleanPhone.length != 9) {
      HapticFeedback.lightImpact();
      _showSnackBar(
        context,
        message: _tr(lang, 'enter_full_phone'),
        isError: true,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSendingCode = true);

    final fullPhone = '998$cleanPhone';

    debugPrint('==============================');
    debugPrint('LOGIN PHONE: $fullPhone');
    debugPrint('==============================');

    try {
      final api = ApiService();
      await api.sendCode(fullPhone);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _OtpVerificationPage(
            phoneNumber: '+998 $phoneInput',
            rawPhone: fullPhone,
          ),
        ),
      );
    } on ApiException catch (e) {
      debugPrint('SEND CODE API ERROR: $e');
      if (!mounted) return;

      String title = _tr(lang, 'error_title');
      String description = _tr(lang, 'login_error_desc');

      if (e.statusCode == 404 || e.statusCode == 500) {
        title = _tr(lang, 'user_not_found_title');
        description = _tr(lang, 'user_not_found_desc');
      }

      _showPremiumDialog(
        context,
        title: title,
        description: description,
        buttonText: _tr(lang, 'understood'),
      );
    } catch (e) {
      debugPrint('SEND CODE ERROR: $e');
      if (!mounted) return;

      _showPremiumDialog(
        context,
        title: _tr(lang, 'error_title'),
        description: _tr(lang, 'network_error_desc'),
        buttonText: _tr(lang, 'understood'),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingCode = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String lang = context.watch<ProfileProvider>().language;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _slateDark,
        body: Stack(
          children: [
            // 1. Orqa fon rasmi + klinik tungi gradient qatlam
            const _ClinicalBackdrop(),

            // 2. Asosiy kontent
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCompact = constraints.maxWidth < 360;
                  final double horizontalPadding =
                  constraints.maxWidth >= 600 ? 32 : (isCompact ? 18 : 24);
                  final double logoSize = isCompact ? 68 : 82;

                  return Column(
                    children: [
                      // Yuqori qator: bosqich belgisi va til tanlash
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StepBadge(label: _tr(lang, 'step_phone')),
                            _LanguageSwitcher(
                              currentLang: lang,
                              onChanged: (newLang) {
                                context
                                    .read<ProfileProvider>()
                                    .updateLanguage(newLang);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Markaziy scroll qilinadigan qism
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 24,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 440),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Logo konteyneri (asl rasm saqlangan)
                                  FadeTransition(
                                    opacity: _logoFade,
                                    child: ScaleTransition(
                                      scale: _logoScale,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _skyBlue.withValues(
                                              alpha: 0.55,
                                            ),
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _primaryBlue.withValues(
                                                alpha: 0.42,
                                              ),
                                              blurRadius: 28,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          'assets/image/img_1.png',
                                          height: logoSize,
                                          width: logoSize,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.medical_services_rounded,
                                            size: logoSize * 0.65,
                                            color: _primaryBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 22),

                                  // Sarlavha: Afada Medical
                                  FadeTransition(
                                    opacity: _titleFade,
                                    child: SlideTransition(
                                      position: _titleSlide,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Afada Medical',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isCompact ? 28 : 34,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Izoh matni
                                  FadeTransition(
                                    opacity: _subtitleFade,
                                    child: SlideTransition(
                                      position: _subtitleSlide,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.send_rounded,
                                            color: _skyBlue,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              _tr(lang, 'subtitle'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.8),
                                                fontSize: isCompact ? 14 : 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isCompact ? 28 : 38),

                                  // Glassmorphism karta
                                  FadeTransition(
                                    opacity: _cardFade,
                                    child: SlideTransition(
                                      position: _cardSlide,
                                      child: _GlassCard(
                                        padding: EdgeInsets.all(
                                          isCompact ? 20 : 26,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _tr(lang, 'phone_label'),
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.85),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 10),

                                            // Telefon raqami maydoni
                                            FadeTransition(
                                              opacity: _loginFade,
                                              child: SlideTransition(
                                                position: _loginSlide,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: _slateDark
                                                        .withValues(alpha: 0.58),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      16,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withValues(
                                                        alpha: 0.16,
                                                      ),
                                                    ),
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                    _phoneController,
                                                    focusNode: _phoneFocusNode,
                                                    enabled: !_isSendingCode,
                                                    keyboardType:
                                                    TextInputType.phone,
                                                    textInputAction:
                                                    TextInputAction.done,
                                                    inputFormatters: [
                                                      maskFormatter,
                                                    ],
                                                    onSubmitted: (_) =>
                                                        _handleSendCode(lang),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      letterSpacing: 0.8,
                                                    ),
                                                    cursorColor: _skyBlue,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 17,
                                                      ),
                                                      hintText: '90 123 45 67',
                                                      hintStyle: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                          alpha: 0.35,
                                                        ),
                                                        fontSize: 17,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        letterSpacing: 0.6,
                                                      ),
                                                      prefixIcon: Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                          left: 14,
                                                          right: 10,
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .phone_android_rounded,
                                                              color: _skyBlue,
                                                              size: 21,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            const Text(
                                                              '+998',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              height: 22,
                                                              width: 1.2,
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      prefixIconConstraints:
                                                      const BoxConstraints(
                                                        minWidth: 0,
                                                        minHeight: 0,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 22),

                                            // Kirish tugmasi
                                            FadeTransition(
                                              opacity: _buttonFade,
                                              child: SlideTransition(
                                                position: _buttonSlide,
                                                child: _GradientActionButton(
                                                  label: _isSendingCode
                                                      ? _tr(lang, 'sending')
                                                      : _tr(lang, 'login_btn'),
                                                  isLoading: _isSendingCode,
                                                  onPressed: () =>
                                                      _handleSendCode(lang),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// OTP TASDIQLASH SAHIFASI (Yagona TextField — klaviatura miltillashisiz!)
// ═══════════════════════════════════════════════════════════════════════════════
class _OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String rawPhone;

  const _OtpVerificationPage({
    required this.phoneNumber,
    required this.rawPhone,
  });

  @override
  State<_OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<_OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Bitta controller va bitta FocusNode — klaviatura hech qachon yopilib-ochilmaydi!
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  int _counter = 120;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        );

    _otpFocusNode.addListener(_onFocusChanged);

    _controller.forward();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _otpFocusNode.requestFocus();
      }
    });
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _counter = 120;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_counter <= 1) {
        timer.cancel();
        setState(() {
          _counter = 0;
          _canResend = true;
        });
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  String _formatCountdown(int seconds) {
    final int min = seconds ~/ 60;
    final int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _otpFocusNode.removeListener(_onFocusChanged);
    _otpFocusNode.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    final String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    final String trimmed =
    digitsOnly.length > 6 ? digitsOnly.substring(0, 6) : digitsOnly;

    if (trimmed != _otpController.text) {
      _otpController.value = TextEditingValue(
        text: trimmed,
        selection: TextSelection.collapsed(offset: trimmed.length),
      );
    }

    setState(() {});

    // 6-raqam kiritilishi bilan avtomatik tekshirish
    if (trimmed.length == 6 && !_isVerifying) {
      HapticFeedback.selectionClick();
      _handleVerification();
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isResending) return;

    final String lang = context.read<ProfileProvider>().language;
    setState(() => _isResending = true);

    try {
      final api = ApiService();
      debugPrint('QAYTA OTP YUBORILMOQDA: ${widget.rawPhone}');
      await api.sendCode(widget.rawPhone);

      if (!mounted) return;

      _otpController.clear();
      _startTimer();
      _otpFocusNode.requestFocus();

      _showSnackBar(
        context,
        message: _tr(lang, 'code_resent'),
        isError: false,
      );
    } catch (e) {
      debugPrint('RESEND ERROR: $e');
      if (!mounted) return;

      _showSnackBar(
        context,
        message: e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _handleVerification() async {
    if (_isVerifying) return;

    final String lang = context.read<ProfileProvider>().language;
    final String code = _otpController.text.replaceAll(RegExp(r'\D'), '');

    if (code.length != 6) {
      HapticFeedback.lightImpact();
      _showSnackBar(
        context,
        message: _tr(lang, 'enter_6_digit'),
        isError: true,
      );
      _otpFocusNode.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isVerifying = true);

    try {
      final api = ApiService();

      debugPrint('================================');
      debugPrint('VERIFY PHONE: ${widget.rawPhone}');
      debugPrint('VERIFY CODE: $code');
      debugPrint('================================');

      final result = await api.verifyCode(
        phone: widget.rawPhone,
        code: code,
      );

      debugPrint('LOGIN RESULT: $result');

      final token = result['access_token'];
      if (token == null || token.toString().isEmpty) {
        throw Exception('Server access_token qaytarmadi');
      }

      final accessToken = token.toString();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);

      final user = result['user'] as Map<String, dynamic>?;
      if (user == null) {
        throw Exception("Server user ma'lumotlarini qaytarmadi");
      }

      final userName = user['fullName']?.toString() ?? 'User';
      final userRole = user['role']?.toString() ?? 'User';
      final userPhone = user['phone_number']?.toString() ?? '';

      await prefs.setString('user_name', userName);
      await prefs.setString('user_role', userRole);
      await prefs.setString('user_phone', userPhone);

      debugPrint('================================');
      debugPrint('PROFILE DATA SAVED');
      debugPrint('NAME: $userName');
      debugPrint('PHONE: $userPhone');
      debugPrint('ROLE: $userRole');
      debugPrint('================================');

      if (!mounted) return;

      await context.read<ProfileProvider>().setSession(
        userRole,
        userName,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
            (route) => false,
      );
    } on ApiException catch (e) {
      debugPrint('VERIFY CODE API ERROR: $e');
      if (!mounted) return;

      String title = _tr(lang, 'error_title');
      String description = _tr(lang, 'invalid_code_desc');

      if (e.statusCode == 500) {
        title = _tr(lang, 'server_error_title');
        description = _tr(lang, 'server_error_desc');
      }

      _showPremiumDialog(
        context,
        title: title,
        description: description,
        buttonText: _tr(lang, 'retry'),
        onDismiss: () {
          if (!mounted) return;
          _otpController.clear();
          setState(() {});
          _otpFocusNode.requestFocus();
        },
      );
    } catch (e) {
      debugPrint('================================');
      debugPrint('LOGIN ERROR: $e');
      debugPrint('================================');

      if (!mounted) return;

      _showPremiumDialog(
        context,
        title: _tr(lang, 'error_title'),
        description: _tr(lang, 'unexpected_error_desc'),
        buttonText: _tr(lang, 'retry'),
        onDismiss: () {
          if (!mounted) return;
          _otpFocusNode.requestFocus();
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String lang = context.watch<ProfileProvider>().language;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _slateDark,
        body: Stack(
          children: [
            const _ClinicalBackdrop(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCompact = constraints.maxWidth < 360;
                  final double horizontalPadding =
                  constraints.maxWidth >= 600 ? 32 : (isCompact ? 16 : 24);

                  return Column(
                    children: [
                      // Yuqori qator: Orqaga + Bosqich
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          10,
                          horizontalPadding,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _isVerifying
                                  ? null
                                  : () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.16),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            _StepBadge(label: _tr(lang, 'step_otp')),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 20,
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 440),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Ixcham logo nishoni
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _skyBlue.withValues(
                                              alpha: 0.55,
                                            ),
                                            width: 2.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _primaryBlue.withValues(
                                                alpha: 0.35,
                                              ),
                                              blurRadius: 22,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          'assets/image/img_1.png',
                                          height: isCompact ? 50 : 60,
                                          width: isCompact ? 50 : 60,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.verified_user_rounded,
                                            size: isCompact ? 34 : 40,
                                            color: _primaryBlue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      Text(
                                        _tr(lang, 'verify_title'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isCompact ? 26 : 30,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      Text(
                                        _tr(lang, 'verify_subtitle_prefix'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.78),
                                          fontSize: isCompact ? 14 : 15,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Telefon raqam kapsulasi
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                          _skyBlue.withValues(alpha: 0.14),
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          border: Border.all(
                                            color: _skyBlue.withValues(
                                              alpha: 0.35,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.send_rounded,
                                              color: _skyBlue,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.phoneNumber,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 28),

                                      // OTP Glass karta
                                      _GlassCard(
                                        padding: EdgeInsets.all(
                                          isCompact ? 18 : 24,
                                        ),
                                        child: Column(
                                          children: [
                                            // Yagona TextField asosidagi 6 katakchali OTP
                                            _SingleFieldOtpInput(
                                              controller: _otpController,
                                              focusNode: _otpFocusNode,
                                              readOnly: _isVerifying,
                                              onChanged: _onOtpChanged,
                                              onSubmitted: (_) =>
                                                  _handleVerification(),
                                            ),
                                            const SizedBox(height: 26),

                                            // Tasdiqlash tugmasi
                                            _GradientActionButton(
                                              label: _isVerifying
                                                  ? _tr(lang, 'verifying')
                                                  : _tr(lang, 'verify_btn'),
                                              isLoading: _isVerifying,
                                              onPressed: _handleVerification,
                                            ),
                                            const SizedBox(height: 18),

                                            // Qayta yuborish taymeri / tugmasi
                                            SizedBox(
                                              height: 40,
                                              child: _isResending
                                                  ? const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2.2,
                                                    color: _skyBlue,
                                                  ),
                                                ),
                                              )
                                                  : TextButton.icon(
                                                onPressed: _canResend
                                                    ? _resendCode
                                                    : null,
                                                icon: Icon(
                                                  _canResend
                                                      ? Icons
                                                      .refresh_rounded
                                                      : Icons
                                                      .timer_outlined,
                                                  size: 18,
                                                  color: _canResend
                                                      ? _skyBlue
                                                      : Colors.white
                                                      .withValues(
                                                    alpha: 0.5,
                                                  ),
                                                ),
                                                label: Text(
                                                  _canResend
                                                      ? _tr(
                                                    lang,
                                                    'resend_code',
                                                  )
                                                      : '${_tr(lang, 'resend_in')} ${_formatCountdown(_counter)}',
                                                  style: TextStyle(
                                                    color: _canResend
                                                        ? _skyBlue
                                                        : Colors.white
                                                        .withValues(
                                                      alpha: 0.65,
                                                    ),
                                                    fontSize: 14.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// YAGONA TEXTFIELD ASOSIDAGI OTP VIDJETI (Klaviatura miltillashisiz)
// ═══════════════════════════════════════════════════════════════════════════════
class _SingleFieldOtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _SingleFieldOtpInput({
    required this.controller,
    required this.focusNode,
    required this.readOnly,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final String code = controller.text;
    final bool hasFocus = focusNode.hasFocus;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double gap = maxWidth < 300 ? 6 : 10;
        final double boxWidth = ((maxWidth - gap * 5) / 6).clamp(36.0, 58.0);
        final double boxHeight = (boxWidth * 1.18).clamp(50.0, 66.0);
        final double fontSize = boxWidth < 44 ? 21 : 25;

        return SizedBox(
          height: boxHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. 6 ta chiroyli vizual katakcha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final bool isFilled = index < code.length;
                  final bool isActive = hasFocus &&
                      !readOnly &&
                      (index == code.length ||
                          (code.length == 6 && index == 5));

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    width: boxWidth,
                    height: boxHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? _primaryBlue.withValues(alpha: 0.22)
                          : isFilled
                          ? _slateDark.withValues(alpha: 0.72)
                          : _slateDark.withValues(alpha: 0.48),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? _skyBlue
                            : isFilled
                            ? _skyBlue.withValues(alpha: 0.55)
                            : Colors.white.withValues(alpha: 0.18),
                        width: isActive ? 2.0 : 1.2,
                      ),
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: _skyBlue.withValues(alpha: 0.28),
                          blurRadius: 12,
                          spreadRadius: 0.5,
                        ),
                      ]
                          : null,
                    ),
                    child: isFilled
                        ? Text(
                      code[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                        : isActive
                        ? const _BlinkingCursor()
                        : Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),

              // 2. Ustiga yotqizilgan yagona ko‘rinmas TextField
              //    (har qanday katakcha bosilsa ham aynan shu maydon fokusda qoladi)
              Positioned.fill(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  showCursor: false,
                  cursorColor: Colors.transparent,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 1,
                    height: 1,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                  onTap: () {
                    controller.selection = TextSelection.collapsed(
                      offset: controller.text.length,
                    );
                  },
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _blinkController,
      child: Container(
        width: 2.2,
        height: 24,
        decoration: BoxDecoration(
          color: _skyBlue,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// UMUMIY UI KOMPONENTLAR
// ═══════════════════════════════════════════════════════════════════════════════
class _ClinicalBackdrop extends StatelessWidget {
  const _ClinicalBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/image/img_2.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(color: _slateDark),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _slateDark.withValues(alpha: 0.72),
                  const Color(0xFF0F172A).withValues(alpha: 0.80),
                  _slateDark.withValues(alpha: 0.90),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _cardDark.withValues(alpha: 0.56),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _GradientActionButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [
              _skyBlue.withValues(alpha: 0.65),
              _primaryBlue.withValues(alpha: 0.65),
            ]
                : const [_skyBlue, _primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withValues(alpha: 0.42),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  final String label;

  const _StepBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  final String currentLang;
  final ValueChanged<String> onChanged;

  const _LanguageSwitcher({
    required this.currentLang,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Uzb', 'UZ'),
      ('Rus', 'RU'),
      ('Kiril', 'ЎЗ'),
    ];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final bool selected = currentLang == item.$1;
          return GestureDetector(
            onTap: () => onChanged(item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: selected ? _primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.$2,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

void _showSnackBar(
    BuildContext context, {
      required String message,
      required bool isError,
    }) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        backgroundColor: isError ? _rose : _emerald,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

void _showPremiumDialog(
    BuildContext context, {
      required String title,
      required String description,
      required String buttonText,
      VoidCallback? onDismiss,
    }) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'dialog',
    barrierColor: Colors.black.withValues(alpha: 0.65),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (dialogContext, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (dialogContext, anim1, anim2, child) {
      final double curved = Curves.easeOutBack.transform(anim1.value);
      return Transform.scale(
        scale: 0.9 + (0.1 * curved),
        child: Opacity(
          opacity: anim1.value.clamp(0.0, 1.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _cardDark.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _rose.withValues(alpha: 0.16),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _rose.withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Icon(
                                Icons.error_outline_rounded,
                                color: _rose,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _GradientActionButton(
                              label: buttonText,
                              isLoading: false,
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                onDismiss?.call();
                              },
                            ),
                          ],
                        ),
                      ),
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