import 'api_service.dart';

class DashboardService {
  final _api = ApiService().dio;

  Future<Map<String, dynamic>?> getHomeDashboard() async {
    try {
      final response = await _api.get('/api/v1/dashboard/home', queryParameters: {
        'tzOffset': DateTime.now().timeZoneOffset.inMinutes,
      });
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return null;
    } catch (e) {
      print('Dashboard error: $e');
      return null;
    }
  }
}
