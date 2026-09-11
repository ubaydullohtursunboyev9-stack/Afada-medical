import 'dart:ui';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import 'package:afada/provider/mahsulotlar_provider/mahsulot_qoshish_provider.dart';
import 'package:afada/provider/mijoz_provider/mijoz_provider.dart';
import 'package:afada/provider/order_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/sale_provider.dart';
import 'package:afada/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/model_provider.dart';

class NoInternetWrapper extends StatefulWidget {
  final Widget child;
  const NoInternetWrapper({super.key, required this.child});

  @override
  State<NoInternetWrapper> createState() => _NoInternetWrapperState();
}

class _NoInternetWrapperState extends State<NoInternetWrapper> {
  bool _wasOffline = false;

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<ConnectivityService>().isConnected;

    if (!isConnected) {
      if (!_wasOffline) {
        _wasOffline = true;
      }
    } else {
      if (_wasOffline) {
        _wasOffline = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _refreshAllData(context);
        });
      }
    }

    return PopScope(
      canPop: isConnected,
      child: Stack(
        children: [
          // Main app content
          // We wrap the child in an AbsorbPointer when offline to block all interactions
          AbsorbPointer(
            absorbing: !isConnected,
            child: widget.child,
          ),
          
          // No internet overlay
          if (!isConnected)
            const Positioned.fill(
              child: NoInternetDialog(),
            ),
        ],
      ),
    );
  }

  Future<void> _refreshAllData(BuildContext context) async {
    try {
      // Fetch data from multiple providers to ensure the app is up-to-date
      await Future.wait([
        context.read<OrderProvider>().fetchSalesFromApi(),
        context.read<MahsulotProvider>().loadProducts(),
        context.read<FinishedProductProvider>().fetchFinishedProducts(),
        context.read<IshchiProvider>().fetchIshchilar(),
        context.read<MijozProvider>().loadMijozlar(),
        context.read<SaleProvider>().fetchSales(),
        // Profile might need to be re-synced if there are online parts, 
        // but it usually loads from prefs. Added just in case.
        // context.read<ProfileProvider>().loadProfile(), 
      ]);
      debugPrint("All data refreshed successfully after reconnection.");
    } catch (e) {
      debugPrint("Error refreshing data after reconnection: $e");
    }
  }
}

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.black.withOpacity(0.6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromRGBO(30, 30, 30, 0.8)
                    : const Color.fromRGBO(255, 255, 255, 0.9),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark
                      ? const Color.fromRGBO(255, 255, 255, 0.1)
                      : const Color.fromRGBO(0, 0, 0, 0.05),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Internet aloqasi yo'q",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Internetga ulanishingizni tekshiring. Ilovadan foydalanish uchun tarmoqqa ulanish zarur.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Qayta ulanish kutilmoqda...",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
