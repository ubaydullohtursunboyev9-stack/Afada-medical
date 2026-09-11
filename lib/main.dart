import 'package:afada/model/ishchi_modeli.dart';
import 'package:afada/provider/finished_product_provider.dart';
import 'package:afada/provider/home_page_provider/provider_floating_bottom.dart';
import 'package:afada/provider/ishchilar_Provider/ishchilar_provider.dart';
import 'package:afada/provider/mahsulotlar_provider/mahsulot_qoshish_provider.dart';
import 'package:afada/provider/mijoz_provider/mijoz_provider.dart';
import 'package:afada/provider/notification_provider.dart';
import 'package:afada/provider/order_provider.dart';
import 'package:afada/provider/qarz_provider.dart';
import 'package:afada/provider/profile_provider.dart';
import 'package:afada/provider/sale_provider.dart';
import 'package:afada/provider/theme_provider.dart';
import 'package:afada/theme/app_theme.dart';
import 'package:afada/splash_screen/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:afada/services/notification_service.dart';

import 'package:afada/model/model_provider.dart';

import 'package:afada/services/connectivity_service.dart';
import 'package:afada/widgets/no_internet_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await IshchiDatabase.loadIshchilar();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderFlotingbottom()),
        ChangeNotifierProvider(create: (_) => BekorqilishProvider()),
        ChangeNotifierProvider(create: (_) => BuyurtmaHolatProvider()),
        ChangeNotifierProvider(create: (_) => IshchiProvider()),
        ChangeNotifierProvider(create: (_) => MahsulotProvider()),
        ChangeNotifierProvider(create: (_) => MijozProvider()),
        ChangeNotifierProvider(create: (_) => MijoztanlashProvider()),
        ChangeNotifierProvider(create: (_) => TolovProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => DavrProvider()),
        ChangeNotifierProvider(create: (_) => QarzProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => FinishedProductProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Afada App',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              builder: (context, child) {
                return NoInternetWrapper(child: child!);
              },
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }
}
