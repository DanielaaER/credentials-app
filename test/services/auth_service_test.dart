import 'package:flutter_school_app/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    final authService = AuthService();

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('save and retrieve token', () async {
      await authService.saveToken(";abc123");
      final token = await authService.getToken();
      expect(token, "abc123");
    });

    test('clear token on logout', () async {
      await authService.saveToken("abc123");
      await authService.logout();
      final token = await authService.getToken();
      expect(token, null);
    });
  });
}