import 'dart:async';
import 'dart:ui';
import 'package:afada/pages/home_Pages.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../provider/profile_provider.dart';
import '../service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _phoneController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##');

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
      duration: const Duration(milliseconds: 2500),
    );

    const curve = Curves.easeOutCubic;

    // 1. Logo fades in smoothly while slightly scaling from 0.8 -> 1.0
    _logoFade = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: curve));
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: curve)),
    );

    // 2. Title fades in with slight upward movement
    _titleFade = CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5, curve: curve));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5, curve: curve)),
    );

    // 3. Subtitle fades in with slight upward movement
    _subtitleFade = CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: curve));
    _subtitleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: curve)),
    );

    // 4. Card fades in with slight upward movement
    _cardFade = CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.7, curve: curve));
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.7, curve: curve)),
    );

    // 5. Login TextField slides and fades in
    _loginFade = CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.8, curve: curve));
    _loginSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.8, curve: curve)),
    );

    // 7. Button slides and fades in
    _buttonFade = CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: curve));
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: curve)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/image/img_2.png',
              fit: BoxFit.cover,
            ),
          ),
          // 2. Dark transparent overlay for readability
          Positioned.fill(
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.6),
            ),
          ),
          // 3. Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/image/img_1.png',
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title: Afada Medical
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: const Text(
                          'Afada Medical',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    FadeTransition(
                      opacity: _subtitleFade,
                      child: SlideTransition(
                        position: _subtitleSlide,
                        child: const Text(
                          'Tasdiqlash kodi Telegram orqali yuboriladi.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Glassmorphism Form Container
                    FadeTransition(
                      opacity: _cardFade,
                      child: SlideTransition(
                        position: _cardSlide,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 255, 255, 0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Telefon raqami TextField
                                  FadeTransition(
                                    opacity: _loginFade,
                                    child: SlideTransition(
                                      position: _loginSlide,
                                      child: TextField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [maskFormatter],
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          prefixText: '+998 ',
                                          prefixStyle: const TextStyle(color: Colors.white),
                                          hintText: '90 123 45 67',
                                          hintStyle:   TextStyle(color: Colors.white60),
                                          prefixIcon: const Icon(Icons.phone_android, color: Colors.white70),
                                          filled: true,
                                          fillColor: const Color.fromRGBO(255, 255, 255, 0.05),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Kirish Button
                                  FadeTransition(
                                    opacity: _buttonFade,
                                    child: SlideTransition(
                                      position: _buttonSlide,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final phoneInput = _phoneController.text.trim();

                                            final cleanPhone = phoneInput.replaceAll(RegExp(r'\D'), '');

                                            if (cleanPhone.length != 9) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Telefon raqamini to‘liq kiriting'),
                                                ),
                                              );
                                              return;
                                            }

                                            final fullPhone = '998$cleanPhone';

                                            print('==============================');
                                            print('LOGIN PHONE: $fullPhone');
                                            print('==============================');

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
                                              print('SEND CODE API ERROR: $e');
                                              if (!mounted) return;

                                              String title = 'Xatolik';
                                              String description = 'Tizimga kirishda muammo yuz berdi.';

                                              if (e.statusCode == 404 || e.statusCode == 500) {
                                                title = 'Foydalanuvchi topilmadi';
                                                description = 'Ushbu telefon raqami tizimda ro‘yxatdan o‘tmagan yoki aktiv emas.';
                                              }

                                              _showPremiumDialog(
                                                context,
                                                title: title,
                                                description: description,
                                                buttonText: 'Tushunarli',
                                              );
                                            } catch (e) {
                                              print('SEND CODE ERROR: $e');

                                              if (!mounted) return;

                                              _showPremiumDialog(
                                                context,
                                                title: 'Xatolik',
                                                description: 'Internet aloqasini tekshiring yoki keyinroq urinib ko‘ring.',
                                                buttonText: 'Tushunarli',
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            elevation: 2,
                                            shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                          ),
                                          child: const Text(
                                            'Kirish',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 0.2),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white70,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (onDismiss != null) onDismiss();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  buttonText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }
}

class _OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String rawPhone;

  const _OtpVerificationPage({super.key, required this.phoneNumber, required this.rawPhone});

  @override
  State<_OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<_OtpVerificationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _counter = 120;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    setState(() {
      _counter = 120;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }


  Future<void> _resendCode() async {
    try {
      final api = ApiService();

      print('QAYTA OTP YUBORILMOQDA: ${widget.rawPhone}');

      await api.sendCode(widget.rawPhone);

      if (!mounted) return;

      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yangi kod Telegram orqali yuborildi'),
        ),
      );
    } catch (e) {
      print('RESEND ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }



  Future<void> _handleVerification() async {
    final code = _otpControllers
        .map((controller) => controller.text)
        .join();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('6 xonali kodni kiriting'),
        ),
      );
      return;
    }

    // Bir necha marta bosib yubormaslik uchun
    FocusScope.of(context).unfocus();

    try {
      final api = ApiService();

      print('================================');
      print('VERIFY PHONE: ${widget.rawPhone}');
      print('VERIFY CODE: $code');
      print('================================');

      // OTP tekshirish
      final result = await api.verifyCode(
        phone: widget.rawPhone,
        code: code,
      );

      print('LOGIN RESULT: $result');

      // =====================================================
      // BACKEND:
      //
      // {
      //   "access_token": "...",
      //   "user": {
      //      "id": 1,
      //      "fullName": "Aliyev Vali",
      //      "phone_number": "+998901234567",
      //      "role": "admin",
      //      "telegram_chat_id": "123456789"
      //   }
      // }
      // =====================================================

      final token = result['access_token'];

      if (token == null || token.toString().isEmpty) {
        throw Exception(
          'Server access_token qaytarmadi',
        );
      }

      final accessToken = token.toString();

      print('ACCESS TOKEN OLINDI');

      // =====================================================
      // TOKENNI SAQLASH
      // =====================================================

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'access_token',
        accessToken,
      );

      print('TOKEN SAQLANDI');

      // =====================================================
      // USER MA'LUMOTLARI
      // =====================================================

      final user = result['user'] as Map<String, dynamic>?;

      if (user == null) {
        throw Exception('Server user ma\'lumotlarini qaytarmadi');
      }

      final userName = user['fullName']?.toString() ?? 'User';
      final userRole = user['role']?.toString() ?? 'User';

      print('================================');
      print('USER NAME: $userName');
      print('USER ROLE: $userRole');
      print('USER PHONE: ${user['phone_number']}');
      print('USER ID: ${user['id']}');
      print('================================');

      print('USER NAME: $userName');
      print('USER ROLE: $userRole');

      // =====================================================
      // USER MA'LUMOTLARINI SAQLASH
      // =====================================================

      // =====================================================
// USER MA'LUMOTLARINI SAQLASH
// =====================================================

      final userPhone =
          user['phone_number']?.toString() ?? '';

      await prefs.setString(
        'user_name',
        userName,
      );

      await prefs.setString(
        'user_role',
        userRole,
      );

      await prefs.setString(
        'user_phone',
        userPhone,
      );

      print('================================');
      print('PROFILE DATA SAVED');
      print('NAME: $userName');
      print('PHONE: $userPhone');
      print('ROLE: $userRole');
      print('================================');
      // =====================================================
      // PROFILE PROVIDER
      // =====================================================

      if (!mounted) return;

      await context.read<ProfileProvider>().setSession(
        userRole,
        userName,
      );

      if (!mounted) return;

      // =====================================================
      // HOME PAGE
      // =====================================================

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
            (route) => false,
      );
    } on ApiException catch (e) {
      print('VERIFY CODE API ERROR: $e');
      if (!mounted) return;

      String title = 'Xatolik';
      String description = 'Tasdiqlash kodi noto‘g‘ri yoki muddati o‘tgan.';

      if (e.statusCode == 500) {
        title = 'Serverda xatolik';
        description = 'Kodni tekshirishda serverda xatolik yuz berdi (500).';
      }

      _showPremiumDialog(
        context,
        title: title,
        description: description,
        buttonText: 'Qayta urinish',
        onDismiss: () {
          for (var controller in _otpControllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();
        },
      );
    } catch (e) {
      print('================================');
      print('LOGIN ERROR: $e');
      print('================================');

      if (!mounted) return;

      _showPremiumDialog(
        context,
        title: 'Xatolik',
        description: 'Kutilmagan xatolik yuz berdi. Iltimos, qaytadan urinib ko‘ring.',
        buttonText: 'Qayta urinish',
      );
    }
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
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 0.2),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white70,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (onDismiss != null) onDismiss();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  buttonText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/img_2.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.6)),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tasdiqlash',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Kodni kiriting, u ${widget.phoneNumber} raqamiga Telegram orqali yuborildi',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 40),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(6, (index) {
                                            return SizedBox(
                                              width: 40,
                                              child: TextField(
                                                controller: _otpControllers[index],
                                                focusNode: _focusNodes[index],
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                maxLength: 1,
                                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  if (value.isNotEmpty && index < 5) {
                                                    _focusNodes[index + 1].requestFocus();
                                                  } else if (value.isEmpty && index > 0) {
                                                    _focusNodes[index - 1].requestFocus();
                                                  }
                                                },
                                              ),
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 32),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: ElevatedButton(
                                            onPressed: _handleVerification,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.primary,
                                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            ),
                                            child: const Text('Tasdiqlash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: _canResend ? _resendCode : null,
                                          child: Text(
                                            _canResend
                                                ? "Kodni qayta yuborish"
                                                : "Kodni qayta yuborish (${_counter.toString().padLeft(2, '0')})",
                                            style: TextStyle(
                                              color: _canResend ? Colors.white : Colors.white54,
                                              fontWeight: FontWeight.w500,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

