import 'package:afada/login/login_page.dart';
import 'package:afada/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home_Pages.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(
      "assets/image/video/splash_video.mp4",
    );

    controller.initialize().then((_) {
      if (!mounted) return;

      setState(() {});
      controller.play();

      Future.delayed(controller.value.duration, () {
        if (!mounted) return;

        _checkLogin();
      });
    });
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    // Token umuman yo'q
    if (token == null || token.isEmpty) {
      _goToLogin();
      return;
    }

    try {
      // API tokenni tekshiradi.
      // Token 7 kunlik muddati tugamagan bo'lsa -> muvaffaqiyatli qaytadi.
      await ApiService().getMe(token);

      if (!mounted) return;

      // Token hali amal qiladi -> Zoom-out transition bilan HomePage ga o'tamiz
      _goToHome();
    } catch (e) {
      if (!mounted) return;

      final error = e.toString();

      // API 401 qaytarsa token muddati tugagan yoki yaroqsiz
      if (error.contains('401')) {
        await prefs.remove('access_token');
        await prefs.remove('user_role');
        await prefs.remove('user_name');
        await prefs.remove('user_phone');
        await prefs.remove('user_login');
        await prefs.remove('user_password');

        _goToLogin();
      } else {
        // Internet/server muammosi bo'lsa,
        // foydalanuvchini bekorga logout qilmaymiz.
        _goToHome();
      }
    }
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return ScaleTransition(
            scale: Tween<double>(begin: 1.15, end: 1.0).animate(curvedAnimation),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.value.isInitialized
          ? SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}