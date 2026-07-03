import 'api_service.dart';

class ReportService {
  final _api = ApiService().dio;

  Future<Map<String, dynamic>?> getReportsOverview() async {
    try {
      final response = await _api.get('/api/v1/wallets/overview');
      if (response.statusCode == 200) return Map<String, dynamic>.from(response.data as Map);
      return null;
    } catch (e) {
      print('Reports overview error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getReportsTrends() async {
    try {
      final response = await _api.get('/api/v1/reports/trends');
      if (response.statusCode == 200) return Map<String, dynamic>.from(response.data as Map);
      return null;
    } catch (e) {
      print('Report trends error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTransactionsCategories() async {
    try {
      final response = await _api.get('/api/v1/transactions/categories');
      if (response.statusCode == 200) return Map<String, dynamic>.from(response.data as Map);
      return null;
    } catch (e) {
      print('Categories error: $e');
      return null;
    }
  }
}
