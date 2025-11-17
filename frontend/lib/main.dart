import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'app/app_theme.dart';
import 'app/route_transitions.dart';
import 'core/services/auth_service.dart';
import 'ui/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Устанавливаем минимальный размер окна на десктопе
  if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
    // Desktop window package optional; ignore if not used
    // await DesktopWindow.setMinWindowSize(const Size(600, 800));
  }

  await AuthService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DryClean',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) =>
          RouteTransitions.fade(const SplashRoutePlaceholder()),
      home: const SplashView(),
    );
  }
}

// tiny placeholder used only to satisfy onGenerateRoute above
class SplashRoutePlaceholder extends StatelessWidget {
  const SplashRoutePlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
