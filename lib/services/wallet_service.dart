import 'api_service.dart';

class WalletService {
  final _api = ApiService().dio;

  Future<Map<String, dynamic>?> getWalletsOverview() async {
    try {
      final response = await _api.get('/api/v1/wallets/overview');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return null;
    } catch (e) {
      print('Wallet overview error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getWalletsAccounts() async {
    try {
      final response = await _api.get('/api/v1/wallets/accounts');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return null;
    } catch (e) {
      print('Wallet accounts error: $e');
      return null;
    }
  }
}
