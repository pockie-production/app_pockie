import 'api_service.dart';

class VoucherService {
  final _api = ApiService().dio;

  Future<Map<String, dynamic>?> getVoucherStats() async {
    try {
      final response = await _api.get('/api/v1/vouchers/stats');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return null;
    } catch (e) {
      print('Voucher stats error: $e');
      return null;
    }
  }

  Future<List<dynamic>?> getVoucherList() async {
    try {
      final response = await _api.get('/api/v1/vouchers/list');
      if (response.statusCode == 200) {
        return List<dynamic>.from(response.data as List);
      }
      return null;
    } catch (e) {
      print('Voucher list error: $e');
      return null;
    }
  }
}
