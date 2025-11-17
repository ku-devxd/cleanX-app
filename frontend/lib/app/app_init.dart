import 'package:frontend/core/services/auth_service.dart';

class AppInit {
  static Future<void> init() async {
    // инициализация сервиса аутентификации (SharedPreferences и т.д.)
    await AuthService.instance.init();
  }
}
