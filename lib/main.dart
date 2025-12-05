import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/subscription_service.dart';
import 'services/device_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar serviços
  await ThemeService().initTheme();
  await SubscriptionService().initialize();
  
  runApp(const PerformanceOptimizerApp());
}

class PerformanceOptimizerApp extends StatelessWidget {
  const PerformanceOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Performance Optimizer',
            debugShowCheckedModeBanner: false,
            theme: themeService.currentTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}