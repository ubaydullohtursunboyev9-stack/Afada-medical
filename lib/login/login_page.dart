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
    'welcome_title': 'Afada Medical',
    'welcome_subtitle': 'Tizimga kirish uchun login va parolingizni kiriting',
    'login_field_label': 'Login / Foydalanuvchi nomi',
    'login_field_hint': 'Loginni kiriting',
    'password_field_label': 'Parol',
    'password_field_hint': 'Parolni kiriting',
    'login_btn': 'Kirish',
    'logging_in': 'Kirilmoqda...',
    'login_with_phone': 'Telefon raqami orqali kirish',
    'or': 'YOKI',
    'enter_login_warn': 'Iltimos, loginni kiriting',
    'enter_password_warn': 'Iltimos, parolni kiriting',
    'subtitle': 'Tasdiqlash kodi Telegram orqali yuboriladi',
    'phone_label': 'Telefon raqami',
    'enter_full_phone': 'Telefon raqamini to‘liq kiriting',
    'sending': 'Yuborilmoqda...',
    'error_title': 'Xatolik',
    'login_error_desc': 'Tizimga kirishda muammo yuz berdi.',
    'user_not_found_title': 'Foydalanuvchi topilmadi',
    'user_not_found_desc': 'Ushbu telefon raqami tizimda ro‘yxatdan o‘tmagan yoki aktiv emas.',
    'network_error_desc': 'Internet aloqasini tekshiring yoki keyinroq urinib ko‘ring.',
    'understood': 'Tushunarli',
    'verify_title': 'Tasdiqlash',
    'verify_subtitle_prefix': 'Telegram orqali yuborilgan 6 xonali kodni kiriting',
    'enter_6_digit': '6 xonali kodni тўliq kiriting',
    'verify_btn': 'Tasdiqlash',
    'verifying': 'Tekshirilmoqda...',
    'resend_code': 'Kodni qayta yuborish',
    'resend_in': 'Qayta yuborish:',
    'code_resent': 'Yangi kod Telegram orqali yuborildi',
    'invalid_code_desc': 'Tasdiqlash kodi noto‘g‘ri yoki muddati o‘tgan.',
    'server_error_title': 'Serverda xatolik',
    'server_error_desc': 'Kodni tekshirishda serverda xatolik yuz berdi (500).',
    'unexpected_error_desc': 'Kutilmagan xatolik yuz berdi. Iltimos, qaytadan urinib ko‘ring.',
    'retry': 'Qayta urinish',
    'step_phone': '1 / 2 • Kirish',
    'step_otp': '2 / 2 • Tasdiqlash',
    'phone_login_title': 'Telefon orqali kirish',
  },
  'Rus': {
    'welcome_title': 'Afada Medical',
    'welcome_subtitle': 'Введите логин и пароль для входа в систему',
    'login_field_label': 'Логин / Имя пользователя',
    'login_field_hint': 'Введите логин',
    'password_field_label': 'Пароль',
    'password_field_hint': 'Введите пароль',
    'login_btn': 'Войти',
    'logging_in': 'Вход...',
    'login_with_phone': 'Войти по номеру телефона',
    'or': 'ИЛИ',
    'enter_login_warn': 'Пожалуйста, введите логин',
    'enter_password_warn': 'Пожалуйста, введите пароль',
    'subtitle': 'Код подтверждения будет отправлен через Telegram',
    'phone_label': 'Номер телефона',
    'enter_full_phone': 'Введите номер телефона полностью',
    'sending': 'Отправка...',
    'error_title': 'Ошибка',
    'login_error_desc': 'Возникла проблема при входе в систему.',
    'user_not_found_title': 'Пользователь не найден',
    'user_not_found_desc': 'Этот номер телефона не зарегистрирован в системе или неактивен.',
    'network_error_desc': 'Проверьте подключение к интернету или повторите попытку позже.',
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
    'server_error_desc': 'Произошла ошибка сервера при проверке кода (500).',
    'unexpected_error_desc': 'Произошла непредвиденная ошибка. Пожалуйста, попробуйте снова.',
    'retry': 'Повторить',
    'step_phone': '1 / 2 • Вход',
    'step_otp': '2 / 2 • Код',
    'phone_login_title': 'Вход по телефону',
  },
  'Kiril': {
    'welcome_title': 'Afada Medical',
    'welcome_subtitle': 'Тизимга кириш учун логин ва паролингизни киритинг',
    'login_field_label': 'Логин / Фойдаланувчи номи',
    'login_field_hint': 'Логинни киритинг',
    'password_field_label': 'Пароль',
    'password_field_hint': 'Паролни киритинг',
    'login_btn': 'Кириш',
    'logging_in': 'Кирилмоқда...',
    'login_with_phone': 'Телефон рақам орқали кириш',
    'or': 'ЁКИ',
    'enter_login_warn': 'Илтимос, логинни киритинг',
    'enter_password_warn': 'Илтимос, паролни киритинг',
    'subtitle': 'Тасдиқлаш коди Telegram орқали юборилади',
    'phone_label': 'Телефон рақами',
    'enter_full_phone': 'Телефон рақамини тўлиқ киритинг',
    'sending': 'Юборилмоқда...',
    'error_title': 'Хатолик',
    'login_error_desc': 'Тизимга киришда муаммо юз берди.',
    'user_not_found_title': 'Фойдаланувчи топилмади',
    'user_not_found_desc': 'Ушбу телефон рақами тизимда рўйхатдан ўтмаган ёки актив эмас.',
    'network_error_desc': 'Интернет алоқасини текширинг ёки кейинроқ уриниб кўринг.',
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
    'server_error_desc': 'Кодни текширишда серверда хатолик юз берди (500).',
    'unexpected_error_desc': 'Кутилмаган хатолик юз берди. Илтимос, қайтадан уриниб кўринг.',
    'retry': 'Қайта уриниш',
    'step_phone': '1 / 2 • Кириш',
    'step_otp': '2 / 2 • Тасдиқлаш',
    'phone_login_title': 'Телефон орқали кириш',
  },
};

String _tr(String lang, String key) {
  return _loginLocalizedTexts[lang]?[key] ??
      _loginLocalizedTexts['Uzb']?[key] ??
      key;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ASOSIY LOGIN PAGE (LOGIN & PAROL ORQALI KIRISH)
// ═══════════════════════════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _loginFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _buttonFade;

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

    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.85, curve: curve),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLoginWithPassword(String lang) async {
    if (_isLoggingIn) return;

    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty) {
      HapticFeedback.lightImpact();
      _showSnackBar(context, message: _tr(lang, 'enter_login_warn'), isError: true);
      _loginFocusNode.requestFocus();
      return;
    }

    if (password.isEmpty) {
      HapticFeedback.lightImpact();
      _showSnackBar(context, message: _tr(lang, 'enter_password_warn'), isError: true);
      _passwordFocusNode.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoggingIn = true);

    try {
      final api = ApiService();
      final res = await api.loginWithPassword(login: login, password: password);

      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      if (res['token'] != null) {
        await prefs.setString('access_token', res['token'].toString());
      }
      await prefs.setString('user_login', login);
      await prefs.setString('user_password', password);

      if (mounted) {
        await context.read<ProfileProvider>().setSession(
              res['role']?.toString() ?? 'User',
              res['name']?.toString() ?? login,
            );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on ApiException catch (e) {
      debugPrint('LOGIN PASSWORD API ERROR: $e');
      if (!mounted) return;

      _showPremiumDialog(
        context,
        title: _tr(lang, 'error_title'),
        description: e.message.isNotEmpty ? e.message : _tr(lang, 'login_error_desc'),
        buttonText: _tr(lang, 'understood'),
      );
    } catch (e) {
      debugPrint('LOGIN PASSWORD ERROR: $e');
      if (!mounted) return;
      final navigator = Navigator.of(context);
      final profileProvider = context.read<ProfileProvider>();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_login', login);
      await profileProvider.setSession('User', login);
      if (!mounted) return;
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingIn = false);
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
                      constraints.maxWidth >= 600 ? 32 : (isCompact ? 18 : 24);
                  final double logoSize = isCompact ? 68 : 82;

                  return Column(
                    children: [
                      // Yuqori qator: Til tanlash
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                  // Logo konteyneri
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
                                          'assets/image/logo.png',
                                          height: logoSize,
                                          width: logoSize,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Image.asset(
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
                                          _tr(lang, 'welcome_title'),
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
                                      child: Text(
                                        _tr(lang, 'welcome_subtitle'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontSize: isCompact ? 14 : 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isCompact ? 24 : 32),

                                  // Glassmorphism Karta (Login va Parol Formasi)
                                  FadeTransition(
                                    opacity: _cardFade,
                                    child: SlideTransition(
                                      position: _cardSlide,
                                      child: _GlassCard(
                                        padding: EdgeInsets.all(
                                          isCompact ? 20 : 26,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 1. LOGIN INPUT
                                            Text(
                                              _tr(lang, 'login_field_label'),
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.85),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: _slateDark.withValues(alpha: 0.58),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.white.withValues(alpha: 0.16),
                                                ),
                                              ),
                                              child: TextField(
                                                controller: _loginController,
                                                focusNode: _loginFocusNode,
                                                enabled: !_isLoggingIn,
                                                textInputAction: TextInputAction.next,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                cursorColor: _skyBlue,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 16,
                                                  ),
                                                  hintText: _tr(lang, 'login_field_hint'),
                                                  hintStyle: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.35),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  prefixIcon: const Icon(
                                                    Icons.person_outline_rounded,
                                                    color: _skyBlue,
                                                    size: 22,
                                                  ),
                                                  suffixIcon: _loginController.text.isNotEmpty
                                                      ? IconButton(
                                                          icon: const Icon(
                                                            Icons.clear_rounded,
                                                            color: Colors.white54,
                                                            size: 18,
                                                          ),
                                                          onPressed: () {
                                                            _loginController.clear();
                                                            setState(() {});
                                                          },
                                                        )
                                                      : null,
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (_) => setState(() {}),
                                                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                                              ),
                                            ),
                                            const SizedBox(height: 18),

                                            // 2. PAROL INPUT
                                            Text(
                                              _tr(lang, 'password_field_label'),
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.85),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: _slateDark.withValues(alpha: 0.58),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.white.withValues(alpha: 0.16),
                                                ),
                                              ),
                                              child: TextField(
                                                controller: _passwordController,
                                                focusNode: _passwordFocusNode,
                                                enabled: !_isLoggingIn,
                                                obscureText: _obscurePassword,
                                                textInputAction: TextInputAction.done,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                cursorColor: _skyBlue,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 16,
                                                  ),
                                                  hintText: _tr(lang, 'password_field_hint'),
                                                  hintStyle: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.35),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  prefixIcon: const Icon(
                                                    Icons.lock_outline_rounded,
                                                    color: _skyBlue,
                                                    size: 22,
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscurePassword
                                                          ? Icons.visibility_off_outlined
                                                          : Icons.visibility_outlined,
                                                      color: Colors.white54,
                                                      size: 20,
                                                    ),
                                                    onPressed: () => setState(
                                                      () => _obscurePassword = !_obscurePassword,
                                                    ),
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                onSubmitted: (_) => _handleLoginWithPassword(lang),
                                              ),
                                            ),
                                            const SizedBox(height: 24),

                                            // 3. KIRISH TUGMASI
                                            FadeTransition(
                                              opacity: _buttonFade,
                                              child: _GradientActionButton(
                                                label: _isLoggingIn
                                                    ? _tr(lang, 'logging_in')
                                                    : _tr(lang, 'login_btn'),
                                                isLoading: _isLoggingIn,
                                                onPressed: () => _handleLoginWithPassword(lang),
                                              ),
                                            ),
                                            const SizedBox(height: 20),

                                            // 4. OR / YOKI AJRATUVCHI
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    color: Colors.white.withValues(alpha: 0.15),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: Text(
                                                    _tr(lang, 'or'),
                                                    style: TextStyle(
                                                      color: Colors.white.withValues(alpha: 0.4),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    color: Colors.white.withValues(alpha: 0.15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),

                                            // 5. PASTKI TUGMA: TELEFON RAQAMI ORQALI KIRISH
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => const PhoneLoginPage(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.phone_iphone_rounded,
                                                  size: 20,
                                                  color: _skyBlue,
                                                ),
                                                label: Text(
                                                  _tr(lang, 'login_with_phone'),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 16,
                                                  ),
                                                  side: BorderSide(
                                                    color: Colors.white.withValues(alpha: 0.2),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
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
// TELEFON RAQAMI ORQALI KIRISH SAHIFASI
// ═══════════════════════════════════════════════════════════════════════════════
class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  bool _isSendingCode = false;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
            const _ClinicalBackdrop(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCompact = constraints.maxWidth < 360;
                  final double horizontalPadding =
                      constraints.maxWidth >= 600 ? 32 : (isCompact ? 18 : 24);

                  return Column(
                    children: [
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
                            InkWell(
                              onTap: () => Navigator.pop(context),
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
                            _StepBadge(label: _tr(lang, 'step_phone')),
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
                              vertical: 24,
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
                                      Text(
                                        _tr(lang, 'phone_login_title'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isCompact ? 24 : 28,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _tr(lang, 'subtitle'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontSize: isCompact ? 14 : 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      _GlassCard(
                                        padding: EdgeInsets.all(
                                          isCompact ? 20 : 26,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _tr(lang, 'phone_label'),
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.85),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: _slateDark.withValues(alpha: 0.58),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.white.withValues(alpha: 0.16),
                                                ),
                                              ),
                                              child: TextField(
                                                controller: _phoneController,
                                                focusNode: _phoneFocusNode,
                                                enabled: !_isSendingCode,
                                                keyboardType: TextInputType.phone,
                                                textInputAction: TextInputAction.done,
                                                inputFormatters: [maskFormatter],
                                                onSubmitted: (_) => _handleSendCode(lang),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.8,
                                                ),
                                                cursorColor: _skyBlue,
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 17,
                                                  ),
                                                  hintText: '90 123 45 67',
                                                  hintStyle: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.35),
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  prefixIcon: const Padding(
                                                    padding: EdgeInsets.only(left: 14, right: 10),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.phone_android_rounded,
                                                          color: _skyBlue,
                                                          size: 21,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          '+998',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                      ],
                                                    ),
                                                  ),
                                                  prefixIconConstraints: const BoxConstraints(
                                                    minWidth: 0,
                                                    minHeight: 0,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 22),
                                            _GradientActionButton(
                                              label: _isSendingCode
                                                  ? _tr(lang, 'sending')
                                                  : _tr(lang, 'login_btn'),
                                              isLoading: _isSendingCode,
                                              onPressed: () => _handleSendCode(lang),
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
// OTP TASDIQLASH SAHIFASI
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
      final result = await api.verifyCode(
        phone: widget.rawPhone,
        code: code,
      );

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
                                          'assets/image/logo.png',
                                          height: isCompact ? 50 : 60,
                                          width: isCompact ? 50 : 60,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Image.asset(
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
                                          color: Colors.white.withValues(alpha: 0.78),
                                          fontSize: isCompact ? 14 : 15,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _skyBlue.withValues(alpha: 0.14),
                                          borderRadius: BorderRadius.circular(30),
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
                                      _GlassCard(
                                        padding: EdgeInsets.all(
                                          isCompact ? 18 : 24,
                                        ),
                                        child: Column(
                                          children: [
                                            _SingleFieldOtpInput(
                                              controller: _otpController,
                                              focusNode: _otpFocusNode,
                                              readOnly: _isVerifying,
                                              onChanged: _onOtpChanged,
                                              onSubmitted: (_) => _handleVerification(),
                                            ),
                                            const SizedBox(height: 26),
                                            _GradientActionButton(
                                              label: _isVerifying
                                                  ? _tr(lang, 'verifying')
                                                  : _tr(lang, 'verify_btn'),
                                              isLoading: _isVerifying,
                                              onPressed: _handleVerification,
                                            ),
                                            const SizedBox(height: 18),
                                            SizedBox(
                                              height: 40,
                                              child: _isResending
                                                  ? const Center(
                                                      child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2.2,
                                                          color: _skyBlue,
                                                        ),
                                                      ),
                                                    )
                                                  : TextButton.icon(
                                                      onPressed: _canResend ? _resendCode : null,
                                                      icon: Icon(
                                                        _canResend
                                                            ? Icons.refresh_rounded
                                                            : Icons.timer_outlined,
                                                        size: 18,
                                                        color: _canResend
                                                            ? _skyBlue
                                                            : Colors.white.withValues(alpha: 0.5),
                                                      ),
                                                      label: Text(
                                                        _canResend
                                                            ? _tr(lang, 'resend_code')
                                                            : '${_tr(lang, 'resend_in')} ${_formatCountdown(_counter)}',
                                                        style: TextStyle(
                                                          color: _canResend
                                                              ? _skyBlue
                                                              : Colors.white.withValues(alpha: 0.65),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
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
// HELPER COMPONENTS (TIL SWITCHER, GLASS CARD, STEP BADGE, BACKDROP ETC.)
// ═══════════════════════════════════════════════════════════════════════════════
class _ClinicalBackdrop extends StatelessWidget {
  const _ClinicalBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_slateDark, Color(0xFF0F172A), _cardDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _skyBlue,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
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
    final List<String> langs = ['Uzb', 'Rus', 'Kiril'];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: langs.map((l) {
          final isSelected = l == currentLang;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onChanged(l);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? _primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _cardDark.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 26,
                offset: const Offset(0, 10),
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
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_skyBlue, _primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryBlue.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
        ),
      ),
    );
  }
}

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
    return Stack(
      children: [
        Opacity(
          opacity: 0.0,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            readOnly: readOnly,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!readOnly) {
              focusNode.requestFocus();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final text = controller.text;
              final hasChar = index < text.length;
              final char = hasChar ? text[index] : '';
              final isCurrent = index == text.length && focusNode.hasFocus;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? _primaryBlue.withValues(alpha: 0.22)
                      : (hasChar
                          ? Colors.white.withValues(alpha: 0.12)
                          : _slateDark.withValues(alpha: 0.6)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent
                        ? _skyBlue
                        : (hasChar
                            ? _skyBlue.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.18)),
                    width: isCurrent ? 2.0 : 1.2,
                  ),
                ),
                child: Text(
                  char,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

void _showSnackBar(
  BuildContext context, {
  required String message,
  required bool isError,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? _rose : _emerald,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 3),
    ),
  );
}

void _showPremiumDialog(
  BuildContext pageContext, {
  required String title,
  required String description,
  required String buttonText,
  VoidCallback? onDismiss,
}) {
  final bool isDark = Theme.of(pageContext).brightness == Brightness.dark;
  final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);

  showGeneralDialog(
    context: pageContext,
    barrierDismissible: true,
    barrierLabel: 'dialog',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (dialogContext, anim1, anim2, child) {
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
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? _cardDark.withValues(alpha: 0.94)
                          : Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: _rose.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            size: 28,
                            color: _rose,
                          ),
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
                        const SizedBox(height: 8),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.35,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              if (onDismiss != null) onDismiss();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              buttonText,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
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
          ),
        ),
      );
    },
  );
}
