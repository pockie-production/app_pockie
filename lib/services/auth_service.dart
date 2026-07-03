import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _api = ApiService().dio;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _api.post('/api/v1/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        // The backend likely returns an accessToken based on web app logic
        final token = data['accessToken'] ?? data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }
}
